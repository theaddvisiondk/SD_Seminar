table 123456710 "Seminar Registration Header"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 6 - Lab 1-3 & Lab 1-4
    //     - Created new table


    fields
    {
        field(1;"No.";Code[20])
        {

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                  SeminarSetup.Get;
                  NoSeriesMgt.TestManual(SeminarSetup."Seminar Registration Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"Starting Date";Date)
        {

            trigger OnValidate();
            begin
                if "Starting Date" <> xRec."Starting Date" then
                  TestField(Status,Status::Planning);
            end;
        }
        field(3;"Seminar No.";Code[20])
        {
            TableRelation = Seminar;

            trigger OnValidate();
            begin
                if "Seminar No." <> xRec."Seminar No." then begin
                  SeminarRegLine.Reset;
                  SeminarRegLine.SetRange("Document No.","No.");
                  SeminarRegLine.SetRange(Registered,true);
                  if not SeminarRegLine.Isempty then
                    ERROR(
                      Text002,
                      FieldCaption("Seminar No."),
                      SeminarRegLine.TableCaption,
                      SeminarRegLine.FieldCaption(Registered),
                      true);

                  Seminar.Get("Seminar No.");
                  Seminar.TestField(Blocked,false);
                  Seminar.TestField("Gen. Prod. Posting Group");
                  Seminar.TestField("VAT Prod. Posting Group");
                  "Seminar Name" := Seminar.Name;
                  Duration := Seminar."Seminar Duration";
                  "Seminar Price" := Seminar."Seminar Price";
                  "Gen. Prod. Posting Group" := Seminar."Gen. Prod. Posting Group";
                  "VAT Prod. Posting Group" := Seminar."VAT Prod. Posting Group";
                  "Minimum Participants" := Seminar."Minimum Participants";
                  "Maximum Participants" := Seminar."Maximum Participants";
                end;
            end;
        }
        field(4;"Seminar Name";Text[50])
        {
        }
        field(5;"Instructor Resource no.";Code[10])
        {
            TableRelation = Resource where (Type=const(Person));

            trigger OnValidate();
            begin
                CalcFields("Instructor Name");
            end;
        }
        field(6;"Instructor Name";Text[50])
        {
            CalcFormula = Lookup(Resource.Name where ("No."=Field("Instructor Resource no."),
                                                      Type=const(Person)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;Status;Option)
        {
            OptionCaption = 'Planning,Registration,Closed,Canceled';
            OptionMembers = Planning,Registration,Closed,Canceled;
        }
        field(8;Duration;Decimal)
        {
            DecimalPlaces = 0:1;
        }
        field(9;"Maximum Participants";Integer)
        {
        }
        field(10;"Minimum Participants";Integer)
        {
        }
        field(11;"Room Resource no.";Code[10])
        {
            TableRelation = Resource where (Type=const(Machine));

            trigger OnValidate();
            begin
                if "Room Resource no." = '' then begin
                  "Room Name" := '';
                  "Room Address" := '';
                  "Room Address 2" := '';
                  "Room Post Code" := '';
                  "Room City" := '';
                  "Room County" := '';
                  "Room Country/Reg. Code" := '';
                end else begin
                  SeminarRoom.GET("Room Resource no.");
                  "Room Name" := SeminarRoom.Name;
                  "Room Address" := SeminarRoom.Address;
                  "Room Address 2" := SeminarRoom."Address 2";
                  "Room Post Code" := SeminarRoom."Post Code";
                  "Room City" := SeminarRoom.City;
                  "Room County" := SeminarRoom.County;
                  "Room Country/Reg. Code" := SeminarRoom."Country/Region Code";

                  if (CurrFieldNo <> 0) then begin
                    if (SeminarRoom."CSD_Maximum Participants" <> 0) and
                       (SeminarRoom."CSD_Maximum Participants" < "Maximum Participants")
                    then begin
                      if Confirm(Text004,true,
                           "Maximum Participants",
                           SeminarRoom."CSD_Maximum Participants",
                           FieldCaption("Maximum Participants"),
                           SeminarRoom."CSD_Maximum Participants",
                           SeminarRoom."CSD_Maximum Participants")
                           
                      then
                        "Maximum Participants" := SeminarRoom."CSD_Maximum Participants";
                    end;
                  end;
                end;
            end;
        }
        field(12;"Room Name";Text[30])
        {
        }
        field(13;"Room Address";Text[30])
        {
        }
        field(14;"Room Address 2";Text[30])
        {
        }
        field(15;"Room Post Code";Code[20])
        {
            TableRelation = "Post Code".Code;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidatePostCode("Room City","Room Post Code","Room County","Room Country/Reg. Code",(CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(16;"Room City";Text[30])
        {

            trigger OnValidate();
            begin
                PostCode.ValidateCity("Room City","Room Post Code","Room County","Room Country/Reg. Code",(CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(17;"Room Country/Reg. Code";Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(18;"Room County";Text[30])
        {
        }
        field(19;"Seminar Price";Decimal)
        {
            AutoFormatType = 1;

            trigger OnValidate();
            begin
                if ("Seminar Price" <> xRec."Seminar Price") and
                   (Status <> Status::Canceled)
                then begin
                  SeminarRegLine.Reset;
                  SeminarRegLine.SetRange("Document No.","No.");
                  SeminarRegLine.SetRange(Registered,false);
                  if SeminarRegLine.FindSet(false,false) then
                    if Confirm(Text005,false,
                         FieldCaption("Seminar Price"),
                         SeminarRegLine.TableCaption)
                    then begin
                      repeat
                        SeminarRegLine.VALIDATE("Seminar Price","Seminar Price");
                        SeminarRegLine.modify;
                      until SeminarRegLine.NEXT = 0;
                      modify;
                    end;
                end;
            end;
        }
        field(20;"Gen. Prod. Posting Group";Code[10])
        {
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(21;"VAT Prod. Posting Group";Code[10])
        {
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(22;Comment;Boolean)
        {
            CalcFormula = Exist("Seminar Comment Line" where ("Table Name"=const("Seminar Registration"),
                                                              "No."=Field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23;"Posting Date";Date)
        {
        }
        field(24;"Document Date";Date)
        {
        }
        field(25;"Reason Code";Code[10])
        {
            TableRelation = "Reason Code".Code;
        }
        field(26;"No. Series";Code[10])
        {
            Editable = false;
            TableRelation = "No. Series".Code;
        }
        field(27;"Posting No. Series";Code[10])
        {
            TableRelation = "No. Series".Code;

            trigger OnLookup();
            begin
                with SeminarRegHeader do begin
                  SeminarRegHeader := Rec;
                  SeminarSetup.GET;
                  SeminarSetup.TestField("Seminar Registration Nos.");
                  SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                  if NoSeriesMgt.LookupSeries(SeminarSetup."Posted Seminar Reg. Nos.","Posting No. Series")
                  then begin
                    VALIDATE("Posting No. Series");
                  end;
                  Rec := SeminarRegHeader;
                end;
            end;

            trigger OnValidate();
            begin
                if "Posting No. Series" <> '' then begin
                  SeminarSetup.GET;
                  SeminarSetup.TestField("Seminar Registration Nos.");
                  SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                  NoSeriesMgt.TestSeries(SeminarSetup."Posted Seminar Reg. Nos.","Posting No. Series");
                end;
                TestField("Posting No.",'');
            end;
        }
        field(28;"Posting No.";Code[20])
        {
        }

    }

    keys
    {
        key(PK;"No.")
        {
        }
        key(Key2;"Room Resource no.")
        {
            SumIndexFields = Duration;
        }
    }

    var
        PostCode : Record "Post Code";
        Seminar : Record Seminar;
        SeminarCommentLine : Record "Seminar Comment Line";
        SeminarCharge : Record "Seminar Charge";
        SeminarRegHeader : Record "Seminar Registration Header";
        SeminarRegLine : Record "Seminar Registration Line";
        SeminarRoom : Record Resource;
        SeminarSetup : Record "Seminar Setup";
        NoSeriesMgt : Codeunit NoSeriesManagement;
        Text001 : TextConst ENU = 'You cannot delete the Seminar Registration, because there is at least one %1 where %2=%3.';
        Text002 : TextConst ENU = 'You cannot change the %1, because there is at least one %2 with %3=%4.';
        Text004 : Label 'This Seminar is for %1 participants. \The selected Room has a maximum of %2 participants \Do you want to change %3 for the Seminar from %4 to %5?';
        Text005 : Label 'Should the new %1 be copied to all %2 that are not yet invoiced?';
        Text006 : Label 'You cannot delete the Seminar Registration, because there is at least one %1.';

    trigger OnDelete();
    begin
        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.","No.");
        SeminarRegLine.SETRANGE(Registered,true);
        if SeminarRegLine.FIND('-') then
          ERROR(
            Text001,
            SeminarRegLine.TableCaption,
            SeminarRegLine.FieldCaption(Registered),
            true);
        SeminarRegLine.SETRANGE(Registered);
        SeminarRegLine.deleteALL(true);

        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.","No.");
        if not SeminarCharge.ISEMPTY then
          ERROR(Text006,SeminarCharge.TableCaption);

        SeminarCommentLine.RESET;
        SeminarCommentLine.SETRANGE("Table Name",SeminarCommentLine."Table Name"::"Seminar Registration");
        SeminarCommentLine.SETRANGE("No.","No.");
        SeminarCommentLine.deleteALL;
    end;

    trigger OnInsert();
    begin
        if "No." = '' then begin
          SeminarSetup.GET;
          SeminarSetup.TestField("Seminar Registration Nos.");
          NoSeriesMgt.InitSeries(SeminarSetup."Seminar Registration Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;

        if "Posting Date" = 0D then
          "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        SeminarSetup.GET;
        NoSeriesMgt.SetDefaultSeries("Posting No. Series",SeminarSetup."Posted Seminar Reg. Nos.");
    end;

    procedure AssistEdit(OldSeminarRegHeader : Record "Seminar Registration Header") : Boolean;
    begin
        with SeminarRegHeader do begin
          SeminarRegHeader := Rec;
          SeminarSetup.GET;
          SeminarSetup.TestField("Seminar Registration Nos.");
          if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Registration Nos.",OldSeminarRegHeader."No. Series","No. Series") then begin
            SeminarSetup.GET;
            SeminarSetup.TestField("Seminar Registration Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := SeminarRegHeader;
            exit(true);
          end;
        end;
    end;
}

