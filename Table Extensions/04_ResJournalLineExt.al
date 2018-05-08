tableextension 123456704 CSD_ResJournalLineExt extends "Res. Journal Line"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 4-2
{
    fields
    {
        field(123456700;"CSD_Seminar No.";code[20])
        {
            Caption='Seminar No.';
            TableRelation=Seminar;
        }
        field(123456701;"CSD_Seminar Registration No.";code[20])
        {
            Caption='Seminar Registration No.';
            TableRelation="Seminar Registration Header";
        }        
    }
}