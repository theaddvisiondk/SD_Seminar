table 50101 "Cust Entry"
{
    Caption='Cust Entry';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption='Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2;"Customer No.";CODE[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK;"Entry No.")
        {
            Clustered = true;
        }
    }
    
    var
        myInt : Integer;

    trigger OnInsert();
    begin
    end;

    trigger OnModify();
    begin
    end;

    trigger OnDelete();
    begin
    end;

    trigger OnRename();
    begin
    end;

}