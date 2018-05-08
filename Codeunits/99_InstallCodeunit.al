codeunit 123456700 InstallCodeunit
{
    Subtype=Install;


    trigger OnInstallAppPerCompany();
    begin
        InitSetup;
        CreateResources;   
        CreateSeminars;     
    end;

        local procedure CreateResources();
    var
        Resource: Record Resource;
    begin
        Resource.init;
        Resource."No.":='INSTR';
        Resource.Name:='Mr. Instructor';
        Resource.validate("Gen. Prod. Posting Group",'MISC');
        Resource."Direct Unit Cost":=100;
        Resource."CSD_Quantity Per Day":=8;
        Resource.Type:=Resource.Type::Person;
        if Resource.Insert then;
        Resource."No.":='ROOM 01';
        Resource.Name:='Room 01';
        Resource.Type:=Resource.Type::Machine;
        if Resource.Insert then;
    end;
    local procedure CreateSeminars();
    var
        Course : Record Course;
        Seminar : Record Seminar;

    begin
        if Course.FindSet then repeat
          Seminar.init;
          Seminar."No.":=Course.Code;
          Seminar.Name:=Course.Name;
          Seminar."Seminar Price":=course.Price;
          Seminar."Seminar Duration":=Course.Duration;
          Seminar."Gen. Prod. Posting Group":='MISC';
          if Seminar.Insert then;
        until Course.Next=0;
    end;
    
    local procedure InitSetup();
    var
        NoSerie: Record "No. Series";
        NoSerieLine: Record "No. Series Line";
        SeminarSetup: Record "Seminar Setup";
        SourceCodeSetup: Record "Source Code Setup";
        SourceCode: Record "Source Code";
    begin
        SeminarSetup.init;
        if SeminarSetup.Insert then;

        NoSerie.Code := 'SEM';
        NoSerie.Description := 'Seminars';
        NoSerie."Default Nos.":=true;
        NoSerie."Manual Nos.":=true;

        if NoSerie.Insert then;

        NoSerieLine."Series Code" := NoSerie.Code;
        NoSerieLine."Starting No." := 'SEM0000';
        if NoSerieLine.Insert then;
        SeminarSetup."Seminar Nos." := NoSerie.code;

        NoSerie.Code := 'SEMREG';
        NoSerie.Description := 'Seminar Registrations';
        NoSerie."Default Nos.":=true;
        NoSerie."Manual Nos.":=false;
        if NoSerie.Insert then;

        NoSerieLine."Series Code" := NoSerie.Code;
        NoSerieLine."Starting No." := 'SEMREG0000';
        if NoSerieLine.Insert then;
        SeminarSetup."Seminar Registration Nos." := NoSerie.code;

        NoSerie.Code := 'SEMREGPOST';
        NoSerie.Description := 'Posted Seminar Registrations';
        NoSerie."Default Nos.":=true;
        NoSerie."Manual Nos.":=true;
        if NoSerie.Insert then;

        NoSerieLine."Series Code" := NoSerie.Code;
        NoSerieLine."Starting No." := 'SEMPREG0000';
        if NoSerieLine.Insert then;
        SeminarSetup."Posted Seminar Reg. Nos." := NoSerie.code;

        if SeminarSetup.Modify then;

        // SourceCode.Code := 'SEMINAR';
        // if SourceCode.Insert then;
        // SourceCodeSetup.get;
        // SourceCodeSetup.CSD_Seminar := 'SEMINAR';
        // SourceCodeSetup.modify;
     end;
}