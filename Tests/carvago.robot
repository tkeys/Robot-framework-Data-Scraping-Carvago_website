*** Settings ***
Library    SeleniumLibrary
Library    RPA.Tables
Library    Collections
Library    RPA.Excel.Files





*** Variables ***
${SITE_URL} =    https://carvago.com/
${EXCEL_FILE} =  C:\\Users\\admin\\Documents\\robot_scrape_list.xlsx

# run code : robot -d results tests/carvago.robot


*** Keywords ***
#Open available browser
   # open browser    firefox
Create Excel Report
    create workbook    C:\\Users\\admin\\Documents\\robot_scrape_reportlist.xlsx
    save workbook
Read Excel
    open workbook    ${EXCEL_FILE}
    ${list}     read worksheet      header=True
    log to console    ${list}
    close workbook
    FOR    ${item}  IN  @{list}
        Search Cars     ${item}
    END

Search Cars
    [Arguments]    ${item}
    open browser    ${SITE_URL}     edge

    maximize browser window
    #accepting cookies

    #click element                xpath= /html/body/div[5]/div/div/div[2]/div[2]/div[2]/div[2]/button/span
    click element    css=#cookiefirst-root > div > div > div.cfAdwL.cf7ddU > div.cf2L3T.cfysV4.cf3l36 > div.cf3Tgk.cf2pAE.cf1IKf > div.cf1lHZ.cf2L3T.cf3fgI > button
    sleep                       3s
    #wait until location contains    You choose your car online. We inspect it and deliver it.

    click element    xpath=/html/body/div[1]/div/main/div[1]/div[1]/div[1]/div/div[1]/form/div[1]/div[1]/div/div/div/div/div[1]/div[2]
    press keys    NONE  ${item}[make]
    sleep    1s
    press keys    NONE  TAB
    press keys    NONE  TAB
    sleep    1s

    press keys    NONE  ${item}[model]
    #sleep    1s
    press keys    NONE  TAB
    press keys    NONE  TAB
    sleep    1s

    press keys    NONE  ${item}[max_km]
    sleep    3s
    #click element    xpath= /html/body/div[1]/div/main/div[1]/div[1]/div[1]/div/div[1]/form/div[1]/div[3]/div/div/div/div[1]/svg
    click element    css=#form-homepage-filter > div.css-9siekq > div:nth-child(3) > div > div > div > div.chakra-input__right-element.css-12nin32
    sleep    1s
    click element    xpath =/html/body/div[1]/div/main/div[1]/div[1]/div[1]/div/div[1]/form/div[2]/div[1]/button
    sleep    2s

    #sort bt lowest price
    click element    id = tabs-1--tab-4
    sleep    2s

    #data scraping from site

    ${name}         get text    css=#__next > div > main > div.css-cct8s7.e1mfd0dm2 > div.css-1tyg3qz.e1mfd0dm1 > section > div > div.css-1f3egm3.e1qmtrzl0 > div:nth-child(1) > div > a > div > div.css-1lcfenz.e1oahio82 > div.TitleSection.css-440tyw > h6
    sleep    1s
    ${total_km}  get text  css=#__next > div > main > div.css-cct8s7.e1mfd0dm2 > div.css-1tyg3qz.e1mfd0dm1 > section > div > div.css-1f3egm3.e1qmtrzl0 > div:nth-child(1) > div > a > div > div.css-1lcfenz.e1oahio82 > div.css-1pmpzjz.e181zu8w1 > div:nth-child(1) > span.css-1yrmnaj.e181zu8w0
    sleep    1s

    ${horse_power}  get text   css=#__next > div > main > div.css-cct8s7.e1mfd0dm2 > div.css-1tyg3qz.e1mfd0dm1 > section > div > div.css-1f3egm3.e1qmtrzl0 > div:nth-child(1) > div > a > div > div.css-1lcfenz.e1oahio82 > div.css-1pmpzjz.e181zu8w1 > div:nth-child(3) > span.css-1yrmnaj.e181zu8w0
    sleep    1s

    ${country}  get text    xpath =/html/body/div[1]/div/main/div[1]/div[2]/section/div/div[2]/div[2]/div/a/div/div[2]/div[4]/div[1]/div/div[2]/span
    sleep    1s

    ${fuel_type}    get text    css=#__next > div > main > div.css-cct8s7.e1mfd0dm2 > div.css-1tyg3qz.e1mfd0dm1 > section > div > div.css-1f3egm3.e1qmtrzl0 > div:nth-child(1) > div > a > div > div.css-1lcfenz.e1oahio82 > div.css-1pmpzjz.e181zu8w1 > div:nth-child(5) > span.css-1yrmnaj.e181zu8w0
    sleep    1s
    ${transmission}  get text    css=#__next > div > main > div.css-cct8s7.e1mfd0dm2 > div.css-1tyg3qz.e1mfd0dm1 > section > div > div.css-1f3egm3.e1qmtrzl0 > div:nth-child(1) > div > a > div > div.css-1lcfenz.e1oahio82 > div.css-1pmpzjz.e181zu8w1 > div:nth-child(4) > span.css-1yrmnaj.e181zu8w0
    sleep    2s

    ${price}        get text    css=#__next > div > main > div.css-cct8s7.e1mfd0dm2 > div.css-1tyg3qz.e1mfd0dm1 > section > div > div.css-1f3egm3.e1qmtrzl0 > div:nth-child(1) > div > a > div > div.css-1lcfenz.e1oahio82 > div.css-4ogn8q.e1678j7h3 > div.css-fw6r17.e1678j7h1 > div > div.css-rp7a66.e1wac6lx1 > div.css-1djtyue.e14v3bw45 > div > div.css-zer5ec.e14v3bw44
    sleep    1s


    ${car_dict}     create dictionary
    ...     name=${name}
    ...     price=${price}
    ...     transmission=${transmission}
    ...     country=${country}
    ...     fuel_type=${fuel_type}
    ...     total_km=${total_km}
    ...     horse_power=${horse_power}

    log to console    ${car_dict}
    Append to Excel    ${car_dict}

Append to Excel
    [Arguments]     ${car_dict}
    open workbook    C:\\Users\\admin\\Documents\\robot_scrape_reportlist.xlsx
    append rows to worksheet    ${car_dict}     header=True
    save workbook
    close browser

    #close browser
*** Tasks ***
Main
    #open available browser
    Create Excel Report
    Read Excel
    close browser


