pageextension 123456700 CSD_ResourceCardExt extends "Resource Card"
{
    layout
    {
        addlast(General)
        {
            field("Resource Type"; "CSD_Resource Type")
            {
            }
            field("Quantity Per Day"; "CSD_Quantity Per Day")
            {
            }
        }

        addafter("Personal Data")
        {

            group("Room")
            {
                Visible = ShowMaxField;
                field("Maximum Participants"; "CSD_Maximum Participants")
                {
                    
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        ShowMaxField := (Type = Type::Machine);
        CurrPage.Update(false);
    end;

    var
        [InDataSet]
        ShowMaxField: Boolean;
}