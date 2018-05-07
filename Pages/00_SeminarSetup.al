page 123456700 "Seminar Setup"
{
    PageType = Card;
    SourceTable = "Seminar Setup";
    Caption = 'Seminar Setup';
    InsertAllowed = true;
    DeleteAllowed = false;
    UsageCategory = Administration;



    layout
    {
        area(content)
        {
            group(Numbering)
            {
                field("Seminar Nos.";"Seminar Nos.")
                {
                    
                }

                field("Seminar Registration Nos.";"Seminar Registration Nos.")
                {
                    
                }

                field("Posted Seminar Reg. Nos.";"Posted Seminar Reg. Nos.")
                {
                    
                }    
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionName)
            {
                trigger OnAction();
                begin
                end;
            }
        }
    }
    

    trigger OnOpenPage();
    begin
        if not rec.Get then
            rec.INSERT;

    end;
    var
        myInt : Integer;
}