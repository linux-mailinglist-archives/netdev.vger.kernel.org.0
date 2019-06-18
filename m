Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA624A98D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbfFRSM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:12:26 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:49200 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727616AbfFRSM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:12:26 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5II8T1u026866;
        Tue, 18 Jun 2019 11:12:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=JYKN/Bc6SG0wGsbz+2W0JK4KRKS6hzwSm5ehwAREC14=;
 b=ZvW/XEAJvOn0lqPO+YVgOyO7zVL2FSSSHqJnHimlBCtvvQ00Hd1ToeEIJPllcqXMoDR2
 8qCMlhepll4oh6qoTQCh/Qj81EJVQhL7/B/x1O+lVsnWudBTAplRASKNXnGW7XnaxZlm
 vtngHjLBg2sZrB+LkHD8F0ot5Ygxp7xFblVpAqVW72nxRINAN7Q18TmxFwP+2FMCeXcK
 Ay2FAKPg+K1Xdl5/KVgZFvUEadBFAfFnyOmPJBjBHCEQc3q/PVI30uoQsQ7NOi3dQge8
 kID0kA7Iov4mOitQ7+47eGYnf0ESDsMOeI75+F5E/HDHxiOgex/3UWP1J/aqpJwpWSro EA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2051.outbound.protection.outlook.com [104.47.40.51])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t6qgsu4px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 11:12:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYKN/Bc6SG0wGsbz+2W0JK4KRKS6hzwSm5ehwAREC14=;
 b=VoxMaibRUFcX+WN5FB+wrHhCzzfUvmUQ/JKbHIvDl6JOoGFPSKiWjVicFQGXrX9HLlP+Y74aoOemuHRK28aOhsoA0mCLfHQnhqjgSU3BtegWgpVrD3MXq3WlaPWhsv6vYK4u4GLXM7AW07g2d6YuNU9E/ubONvPiKrQEqlT+Ra0=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2472.namprd07.prod.outlook.com (10.166.200.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 18:12:16 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 18:12:16 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH 0/6] net: macb patch set cover letter
Thread-Topic: [PATCH 0/6] net: macb patch set cover letter
Thread-Index: AQHVI9Rx053wx8/6CUGjNUCvusFgp6af9F2AgAHFrNA=
Date:   Tue, 18 Jun 2019 18:12:16 +0000
Message-ID: <CO2PR07MB24693D250D8F2BF72FC0B7E5C1EA0@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
 <20190617150451.GG25211@lunn.ch>
In-Reply-To: <20190617150451.GG25211@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy05NjE1ZTQzMS05MWY0LTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcOTYxNWU0MzMtOTFmNC0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSIxMzk5IiB0PSIxMzIwNTM1NTEyOTgxMTk2MjUiIGg9IlZIZXBBWDZTYlFpbXFNLzNlK2dQNU15WjZSST0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5606f52d-1a20-4eef-174c-08d6f4187eee
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2472;
x-ms-traffictypediagnostic: CO2PR07MB2472:
x-microsoft-antispam-prvs: <CO2PR07MB2472E6DD8EF7F3F44F724EDDC1EA0@CO2PR07MB2472.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(39860400002)(396003)(366004)(13464003)(199004)(189003)(36092001)(81166006)(7736002)(6246003)(107886003)(186003)(26005)(71190400001)(71200400001)(229853002)(305945005)(66066001)(14454004)(476003)(5660300002)(11346002)(316002)(256004)(446003)(486006)(54906003)(14444005)(33656002)(52536014)(68736007)(8936002)(55016002)(73956011)(9686003)(66946007)(6916009)(2906002)(76176011)(6116002)(53936002)(6436002)(66556008)(76116006)(64756008)(99286004)(7696005)(102836004)(86362001)(3846002)(4326008)(66476007)(74316002)(8676002)(25786009)(478600001)(6506007)(81156014)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2472;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WodEL+L7LaecqzplPefJOkWBS3rglwQOYE/6pLFTOKmNfg1o6xXXRYzYvxNfz9HtQig7v+TJRHMjWH76dftrBqA0gZF8duiLHkKlRUl5+yBQcSSM0u650Kh+ek95AhhKEVIYsAOt9bd7unqOSqk00s842I6AXMCKtoqUdHeSkQb8RuASIMHUskjBz0akl8I8IC5XDCfbn/cmsWgxOetYF5EOpLhGujIG1iFL+2Jl8me+0W+k9TkoeM8PGYQv4tTltUyCu7wqhn0MeZ0953di7OVstv9ZDFEdzyvcTNBm1Z1F8OQNQIDM08DTE8AHA6jCAM6feS1WB2leabTBUXhjj5+XTUFlSDERBdKzkv4rlNzqrivpsZ3AHa+J0VmqUiVv6FoG4/1EWPHPDABL7Qhh+mYZwSXWs2sFGURpKRojgNQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5606f52d-1a20-4eef-174c-08d6f4187eee
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 18:12:16.3937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2472
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As this change doesn't affect other users I thought it is safe to do it=20
from PCI wrapper driver. But yes I agree that right way is to do it in PHY =
driver.
I would like to drop this patch, please ignore only this patch from series.

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Monday, June 17, 2019 8:35 PM
>To: Parshuram Raju Thombare <pthombar@cadence.com>
>Cc: nicolas.ferre@microchip.com; davem@davemloft.net; f.fainelli@gmail.com=
;
>netdev@vger.kernel.org; hkallweit1@gmail.com; linux-kernel@vger.kernel.org=
;
>Rafal Ciepiela <rafalc@cadence.com>; Anil Joy Varughese
><aniljoy@cadence.com>; Piotr Sroka <piotrs@cadence.com>
>Subject: Re: [PATCH 0/6] net: macb patch set cover letter
>
>EXTERNAL MAIL
>
>
>> 3. 003-net-macb-add-PHY-configuration-in-MACB-PCI-wrapper.patch
>>    This patch is to configure TI PHY DP83867 in SGMII mode from
>>    our MAC PCI wrapper driver.
>>    With this change there is no need of PHY driver and dp83867
>>    module must be disabled. Users wanting to setup DP83867 PHY
>>    in SGMII mode can disable dp83867.ko driver, else dp83867.ko
>>    overwrite this configuration and PHY is setup as per dp83867.ko.
>
>This sounds very wrong. Why not make the dp83867 driver support SGMII?
>
>     Andrew

Regards,
Parshuram Thombare
