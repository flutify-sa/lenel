import 'package:flutter/material.dart';

class TempContractPage extends StatelessWidget {
  const TempContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contract of Employment - Temp Contract'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('CONTRACT OF EMPLOYMENT\n(LIMITED DURATION)'),
            _sectionContent('Entered between:'),
            _sectionContent(
                'SINCOT TRADING\n(Herein after referred to as "the Employer")\nCHURCH STREET 5b, HENNENMAN, 9445'),
            _sectionTitle('And'),
            _sectionContent(
                'Initials & Surname: #\nI.D. Number: #\n(Herein after referred to as "the Employee")'),
            _sectionTitle('JOB DESCRIPTION'),
            _sectionContent('#'),
            _sectionTitle('STATUTORY DEDUCTIONS PER MONTH'),
            _sectionContent(
                'This contract will commence on: # and will be terminated on completion of duties related to tasks for foundation works at # or a portion thereof, whichever being the first to materialise. \n'
                'The employee shall be remunerated at R# PER MONTH. Calculated from the first day clocked in on system. \n'
                'Other Allowances/Benefits:\n'
                'L/O ALLOWANCE @R179.00 p/d PAYABLE MONTHLY; SITE ALLOWANCE R500.00 p/m; ACCOMMODATION ALLOWANCE R2000.00 p/m.\n\n'
                'Pay Cycle will be from the 16th – 15th of each month. Depending on your starting date you might not qualify for a full month salary at the end of the 1st month. Salaries will be released on the last Friday of each month. R&R / Pay Weekend will be unpaid. No pay increases will be considered before 12 Months consecutive work has been completed. \n'
                'Disciplinary action will be taken against any employee that participates in an unprotected / illegal strike / deliberate go-slows / work stoppage / refusal to work / unauthorised absenteeism. This action can lead to immediate dismissal and the “No Work No Pay” rule will apply.\n'
                'Please note that no banking details will be changed after the acceptance of this agreement other than what is required by law or ordered by an appropriate court of South Africa.\n\n'
                'Address\n\n'
                'Hometown\n\n'
                'Banking Details\n\n'
                'Tax No\n\n'
                'Employee Contact No\n\n'
                'Emergency Contact No\n\n'
                'Any changes to the above must be communicated to the Employer in writing within 30 (Thirty) days of the change.'),
            _sectionTitle('LIMITED DURATION CONTRACT'),
            _sectionContent(
                'This is NOT a permanent employment contract and under NO circumstances may it be construed as such. This contract shall expire automatically on the date specified herein below.\n\n'
                'The contract will commence on: as specified on the contract cover page and will be terminated on: as specified on the contract cover page or once the specific work / project: as specified on the contract cover page, is completed in terms of the duration of the requirements or a specific section thereof or a portion thereof, whichever being the first to materialise it being agreed that this contract may be terminated earlier as and when the employer might be compelled to reduce the number of employees of the employer as portions or sections of the project are completed resulting in a lesser number of employees being required to complete the project.\n\n'
                'The termination of this contract after expiry of the period or completion of the project stipulated in sub-clause 1.1 shall not be construed as a dismissal or termination on grounds of operational requirements.\n\n'
                'The employee agrees and understands that this is not a permanent position and that no expectation of ongoing or permanent employment is created by signing of this contract.\n\n'
                'The employer reserves the right to terminate the contract prematurely in accordance with the statutory procedures in the case of conduct, capacity or the operational requirements of the employer.\n\n'
                'Should the employee for any reason not pass his/her entry medical examination or be unable to fulfil the primary responsibilities of the role for which he/she was appointed for, this contract will be deemed null and void and will be terminated with immediate effect.'),
            _sectionTitle('JOB DESCRIPTION'),
            _sectionContent(
                'The employee will be employed as specified on the contract cover page.\n\n'
                'The employee will perform any other reasonable and lawful task as and when instructed or requested from the employer/supervisor from time to time.'),
            _sectionTitle('PLACE OF WORK'),
            _sectionContent(
                'The employee will be required to perform some or all of his or her duties at the address / site given by the employer on the date of signing this contract, or at any other address / site, the employer may require the employee to perform duties.\n\n'
                'All disciplinary action or disputes must be referred to the administrative head office in Hennenman: 066 207 1306.\n\n'
                'All disputes will be handled at Hennenman (Administrative Head-Office) for the conciliation process within 30 days. If the matter could not be resolved, it must be referred to the CCMA Welkom (057) 910 8300.'),
            _sectionTitle('WORKING HOURS, OVERTIME AND PAY WEEKEND'),
            _sectionContent(
                'The employee will work 45 hours per week, Monday to Friday, 07:00 – 17:00 and/or on such days communicated by the Employer / Supervisor to the Employee’s.\n\n'
                'The employee shall be entitled to an unpaid meal interval of a maximum 60 minutes. This meal interval will be taken within 5 hours of starting the shift.\n\n'
                'The employee undertakes and agrees to work overtime from time to time. The rate of pay for overtime worked will be paid in terms of the Basic Conditions of Employment Act. (BCEA).\n\n'
                'Where an employee works less than required number of weekly hours, any overtime hours for that week will be used to make up the shortfall. This will not apply where an employee is on sick leave in terms of “Paid Sick Leave” or Sunday overtime.\n\n'
                'The employee must clock in and out every day. No clocking will result in being booked AWOP / Unpaid.\n\n'
                'Pay weekend will be at the end of each month when remuneration is released. Starting from the Thursday / Friday till Monday. Work will resume from Tuesday at 07:00. This weekend will be unpaid.\n\n'
                'The employee undertakes to work on Saturday / Sunday / Public Holiday, at the request of the employer. The employee will be remunerated for such work at a rate indicated on the cover page.'),
            _sectionTitle('REMUNERATION'),
            _sectionContent(
                'The employee shall be remunerated as agreed and as such deductions as per the cover page. Annual increases will be made in March each year, according to the client agreement. No pay increases will be considered before 12 months’ consecutive work has been completed.\n\n'
                'The payment of Bonus / Incentive / Allowance will not form part of the employee’s conditions of employment and shall solely be on the discretion of the employer.\n\n'
                'The employer will not pay the employee for any absenteeism and the rule “No Work No Pay” will be strictly adhered to.\n\n'
                'The employee hereby grants the employer permission to make deductions from his/her wages or leave bonus for any monies owed to the company (Advances/Loans/Training/Damages or losses). The company may recover the full balance of the amount owed to the company when the employee’s services are terminated or when the employee resigns.'),
            _sectionTitle('THRESHOLD EARNINGS'),
            _sectionContent(
                'This agreement is subject to The Basic Conditions of Employment Act 1997. The following is mutually agreed between the Employer and the Employee relating to driving time / overtime: If the Employee’s earnings are more than the Threshold Earnings as published by the Minister of Labour, the Employee shall not be entitled to be paid overtime or claim overtime.'),
            _sectionTitle('ANNUAL LEAVE (Leave Policy)'),
            _sectionContent(
                'The employee will accumulate 1 day’s paid leave for every 17 days worked.\n\n'
                'The employee must apply for leave 3 working days in advance. If not applied in advance/no annual leave is available (need ± 15 days for Annual Shutdown), this will be unpaid or set off against the employee’s overtime for that week.\n\n'
                'The company has an annual shutdown during the period of December – January and all employees will be compelled to take their annual leave during this time period. Should the employee not have adequate leave days due to him/her for the annual shutdown period this will be regarded as unpaid leave, subjected to the discretion of the Employer dependent inter alia upon the date during the year on which employment commenced.'),
            _sectionTitle('SICK LEAVE (Sick Leave Policy)'),
            _sectionContent(
                'A valid sick note (as per BCEA) and claim form must be submitted.\n\n'
                'A sick note will be compulsory when sick on a Monday / Friday / the day before or after a public holiday.\n\n'
                'The employee will accumulate sick leave as per the Labour Relation Act (LRA).\n\n'
                'During the first six months of employment, an employee is entitled to one day’s paid sick leave for every 26 days worked.'),
            _sectionTitle(
                'FAMILY RESPONSIBILITY LEAVE (Family Responsibility Leave Policy)'),
            _sectionContent(
                'Employees who have been employed by an employer for longer than four (4) months; will be entitled to 3 (three) days leave during each 12 months of employment which the employee is entitled to take:\n\n'
                'Take note that the accurate completion of the below list is very important. If you claim Family Responsibility leave for someone not indicated above the onus will be on you to provide sufficient proof that this person qualifies as close family.\n\n'
                'WHEN THE EMPLOYEE’S CHILD IS SICK:\nChildren:\n\n'
                'Adoptive Children\n\n'
                'Grand Children\n\n'
                'IN THE EVENT OF THE DEATH OF A MEMBER OF THE EMPLOYEE’S IMMEDIATE FAMILY:\n\n'
                'Immediate Family means:\n'
                '• The employee’s spouse, life partner or any other person who cohabits with the employee;\n'
                '• The employee’s parent, adoptive parent, grandparent, child, adopted child, grand children (as per above) or siblings.\n\n'
                'Spouse/Life Partner:\n\n'
                'Parents\n\n'
                'Adoptive Parents\n\n'
                'Grand Parents\n\n'
                'Brothers\n\n'
                'Sisters\n\n'
                'Before granting an employee leave in terms of this clause, an employer may require reasonable proof of an event for which the leave was required.'),
            _sectionTitle('PATERNITY LEAVE (Paternity Leave Policy)'),
            _sectionContent(
                'An employee will be entitled to 10 consecutive days leave. These days are calendar days and not working days. This leave will be unpaid. Employees that take this leave must claim from the Unemployment Insurance Fund.'),
            _sectionTitle('MATERNITY LEAVE (Maternity Leave Policy)'),
            _sectionContent(
                'Female employees shall be entitled to 4 (four) months unpaid maternity leave.'),
            _sectionTitle('ADOPTION LEAVE (Adoption Leave Policy)'),
            _sectionContent(
                'An employee shall be entitled to 10 (ten) consecutive weeks’ unpaid leave.'),
            _sectionTitle('DISCIPLINE'),
            _sectionContent(
                'The employee will be subjected to the disciplinary procedure and rules of the company.'),
            _sectionTitle('COMPANY POLICIES AND PROCEDURES'),
            _sectionContent(
                'The employee’s conditions of employment will be regulated by this contract and by the provision of the Labour Relations Act as well as with all policies and procedures of the Client which might be amended from time to time.\n\n'
                'Company Vehicle Drivers / LEGAL APPOINTMENTS ON SITE AS DRIVERS\n'
                '• The employee will take full responsibility for the company vehicle and undertake to pay any penalty or excess amount due to negligence.\n'
                '• The employee will take full responsibility for any traffic fines incurred while he/she was driving the vehicle.\n'
                '• Business vehicles may under no circumstances be used for private purposes, and under no circumstances may any private persons be transported in or on such vehicle. The company regards this as a serious offence and warrant to take serious disciplinary action in the event of contravention.\n'
                '• The employer is indemnified against any action due to an employee’s failure to comply with this provision.\n'
                '• Authorisation must be obtained from the Employer for any personal use and even then, the driver would still be liable for the cost at AA Rates.\n'
                '• All drivers of company vehicles must complete a daily vehicle inspection report and report all faults to management before departing from the workplace. Every driver must hand in his Vehicle Inspection list. Fleet receipts (including the garage receipts) + Private Km’s for the whole month before the 7th of the following month (if not in Hennenman via e-mail / post).\n'
                '• Should a driver lose his license due to it being temporarily suspended in terms of the AARTO ACT or for whatever reason, the employee agrees that for the duration of such suspension the employee will be placed on unpaid leave and upon the validity of the license being restored the employee may return to work to resume normal duties.\n'
                '• Alternatively, in the event of such temporary suspension the employer undertakes to seek alternative working positions where the employee may be accommodated for the time being. Should such alternative working position be available the employee agrees that his salary may be adjusted in accordance with the available position. Should there not be such alternative working position available or should the employee refuse to accept such alternative working position the employee will be placed on unpaid leave for such duration.\n'
                '• Should the driver’s license be permanently suspended for whatever reason the employee will be subjected to an incapacity inquiry/retrenchment which may lead to his services being terminated should there be no viable alternatives to be able to accommodate the employee.'),
            _sectionTitle('CLOTHING TOOLS AND ANY OTHER EQUIPMENT'),
            _sectionContent(
                '• All tools and equipment issued to the employee by the employer will remain the property of the employer. All tools, equipment and goods are to be returned to the employer upon termination of contract or the value thereof will be deducted from any amount due to the employee.\n'
                '• The employer will have the right to deduct from the employee’s wages any amount to replace tools or equipment that was lost or damaged by the employees.\n'
                '• If the employee resigns from the company within 3 months of the receipt of any PPE, the employee will be liable for the cost of all PPE issued to him/her within the three months.'),
            _sectionTitle('DESERTION / ABSCONDMENT'),
            _sectionContent(
                'Any employee shall be regarded as having deserted from their employer’s service after 4 (four) continuous working days of unauthorised absence / no notification. The contract will automatically expire due to breach of contract. All outstanding salaries / overtime / leave days will be paid out within 7 days of termination. No notice period will be paid out. The employee will have NO right to appeal against his/her expired contract.'),
            _sectionTitle('ZERO TOLERANCE – (SUBSTANCE ABUSE POLICY)'),
            _sectionContent(
                'Zero Tolerance means that should the employee be found guilty in any of the following rules, dismissal may be the appropriate sanction.\n\n'
                '• Any employee who appears to be under the influence of any alcohol / narcotics / Marijuana or THC (Dagga). Such an employee will not be allowed on the employer’s premises / work sites. The client can request that the worker will be terminated immediately, and a hearing will not be required.\n'
                '• Any employee who tested positive of having consumed alcoholic liquor or drugs will be required to undergo the breathalyser test or any other test the employer may require the employee to undergo. The company / client in its sole discretion can request random on-site control checks/testing. The client can request that the worker will be terminated immediately, and a hearing will not be required.\n'
                '• No employee will be allowed to smoke on the employer’s premises unless the employer has a designated smoking area. Employees may only smoke in such designated areas during tea times and or during their lunch time.\n'
                '• Any theft of company or client’s property shall be seen as a serious offence which will warrant dismissal. No company property or the property of a client, including material or cut-offs from sites, may be removed without prior permission from the employer.\n'
                '• Sexual Harassment\n'
                '• ESKOM LIFE SAVING RULES (“Non-Negotiable Rules”)\n'
                '• Be sober (Zero Tolerance)\n'
                '• Open, Isolate,\n'
                '• Test, Earth, Bond and/or Insulate before touch;\n'
                '• Hook up at heights;\n'
                '• Buckle Up;\n'
                '• Ensure that you have a Permit to work.'),
            _sectionTitle('TRAINING'),
            _sectionContent(
                'The employer may from time to time provide the employee with additional training or provide in-house training to the employee. The employee agrees that where the employee attends any training and the employee’s services are terminated within one year after the training was provided, the employee undertakes to refund the employer for all costs incurred by the employer for such training. All training certificates are the property of the employer. The employer is not obligated to give the original or copies of the training certificates to the employee.'),
            _sectionTitle(
                'UNPROTECTED / ILLEGAL STRIKE/ DELIBERATE GO-SLOWS / WORK STOPPAGE / REFUSAL TO WORK'),
            _sectionContent(
                'Disciplinary action will be taken against any employee that participates in an unprotected / illegal strike / deliberate go-slows / work stoppage / refusal to work. This action can lead to immediate dismissal. The “No Work No Pay” rule will apply.'),
            _sectionTitle('INCLEMENT WEATHER'),
            _sectionContent(
                'If, as a result of inclement weather condition, it is not possible to commence or continue with normal work, the Employer / Site Supervisor / Client may decide to discontinue work for that day. In the event of a decision being made to discontinue work on a normal working day (weekday) owing to inclement weather, an employee shall be paid according to the below or per Site Level Agreement.\n\n'
                '• If work has been stopped within 4 hrs of the start of a normal working day, he shall be paid a minimum of 4 hrs pay at his normal rate.\n'
                '• If more than 4 hrs were worked but less than 5 ½ hrs have elapsed since the normal starting time, the employee shall be paid for the full hours worked.\n'
                '• If more than 5 ½ hrs have elapsed since the normal starting time, the employee shall be paid the full day (9 hrs).'),
            _sectionTitle('INJURY ON DUTY (I.O.D)'),
            _sectionContent(
                'If you are injured on duty you must report to your supervisor immediately in order to receive the necessary treatment. It does not matter how small the injury is, you must report it. Any injuries must be reported on the same day before the end of shift. No late reports will be accepted.'),
            _sectionTitle('GENERAL'),
            _sectionContent(
                'The employee agrees and accepts employment in terms of this contract. The employee agrees and understands that this is not a permanent position and that no expectation of ongoing or permanent employment is created by signing of this contract.\n\n'
                'The employee also agrees that he is aware as to all company policies and procedures and acknowledges that it has been discussed with him and that he agrees to it. He furthermore acknowledges and agrees that all duties and responsibilities have been discussed with him and that he is fully aware as to what is required of him.\n\n'
                'In addition to any other services which it may render on this project, THE CLIENT will be supplying PPE with THE CLIENT’S branding, to any employees employed to complete works under the Client’s scope of work. All individuals working on this project will also have to adhere to all Sincot’s as well as the Client’s, Policies and Procedures.'),
            _sectionTitle('RESTRAINT OF TRADE'),
            _sectionContent(
                'The employee undertakes not to be engaged in the establishing of a business be it direct or indirect in competition or as a shareholder, partner, member of a Close Corporation, director of a company or in any other capacity within means the period during which the employee is employed by the company and a period of twelve (12) consecutive months from the termination date within a radius of 100 km of the employers’ or employer-clients’ premises.\n\n'
                'The employee undertakes not to accept employment from any of the Company’s employers/Clients or any other contractors on the project where the employee has been employed as this constitutes conflict of interest.'),
            _sectionTitle('SITE LEVEL AGREEMENT'),
            _sectionContent(
                'This contract sets out the terms and conditions of employment that apply to the limited duration contract of employment between the Employee and the Employer. This Agreement must be read in conjunction with the Site Level Agreement for the Project, a copy of which is available on request from the Site Supervisor. If there is any conflict between this Agreement and the Site Level Agreement, the latter prevails.\n\n'
                'Should the company have to embark on any short time and or lay off such will be done in accordance with the Labour Relations Act.\n\n'
                'Should the client temporarily stop work on the relevant site, due to circumstances beyond the employer’s control, the employee hereby agrees that the employer may consider and implement a lay-off to avoid dismissal based on operational requirements, after giving the employee two working days-notice. The employee also hereby agrees that the time-period the employee is placed on lay off will be considered “No Work No Pay.”'),
            _sectionTitle('NOTICE PERIOD AND TERMINATION OF EMPLOYMENT'),
            _sectionContent(
                'If the employer or the employee intends to terminate this contract of employment notice must be given to the other party as set out in terms of the Labour Relations Act as set out below.\n\n'
                '• One week if employed for six months or less\n'
                '• Two weeks if employed for more than six months\n'
                '• Four weeks if employed for more than 12 months\n\n'
                'Should the employee fail to give notice as set out above the employer may then withhold an amount equal to the notice period from the employee’s last wage/salary. If the employee resigns from the company within 3 months, the employee will be liable for the cost of the entry medical.\n\n'
                'Either party can terminate this agreement in written notice. In the case where an employee is illiterate verbal notice may be given.\n\n'
                'No notice period may run concurrently with any period of annual, sick, maternity or family responsibility leave.\n\n'
                'A notice period will not be applicable if the employee’s services are terminated due to misconduct.'),
            _sectionTitle('POPI ACT'),
            _sectionContent(
                'No personal information will be given out to any 3rd party except to a union that you are a member of, CCMA, SARS, and upon request from the client.'),
            _sectionTitle('INFORMATION FILE'),
            _sectionContent(
                'The employee agrees that a copy of the Company’s Policies / Procedures / Disciplinary Code, as amended from time to time, was explained to him/her and that a copy will be made available to him/her at the employer’s office / site.\n\n'
                'It is the responsibility of each employee to familiarise themselves with the company’s policies and procedures.\n\n'
                'Signed at ZIBULO on this 23/10/2024.\n\n'
                'Employee _____________    Witness ______________    Employer ______________'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
