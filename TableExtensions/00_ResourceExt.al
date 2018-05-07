tableextension 123456700 CSD_ResourceExt extends Resource
{
    fields
    {
        modify("Profit %")
        {
            trigger OnAfterValidate()
            
            begin
                Rec.TestField("Unit Cost");
            End;
            
        }

        field(123456701;"CSD_Resource Type";Option)
        {
            Caption = 'Resource Type';
            OptionMembers = "Internal","External";
            OptionCaption = 'Internal,External';
        }
        field(123456702;"CSD_Maximum Participants";Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(123456703;"CSD_Quantity Per Day";Integer)
        {
            Caption = 'Quantity Per Day';
        }        
    }
}