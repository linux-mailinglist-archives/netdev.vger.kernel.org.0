Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54444A99D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbfFRSP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:15:57 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:36482 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729810AbfFRSP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:15:56 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5II4VUo012908;
        Tue, 18 Jun 2019 11:15:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=lQtRkfMAr6sIWwa/7BhjHkXT4iLKHCOKBJEvU0H4+KQ=;
 b=mmWcT30TAuFiyGxnoNO2tSTxOYRZ65ZhEFtUY/3APQYndHCxBlt1SAeRDwiUEKwOhzzf
 ox3uuLQRKajyNV+KtRPD2DGeIefO9HH1iKdGCzjCS/q+doWNjf+atGFaSwV9tbz5YmIv
 qbsMgdtdZSTDN7IL0dtBD6CvD5Gy2XmtK+6DCTdHRl2JxRutTQllJt2WMVdxAR+NLZm6
 zNuXy2qpH5+bARv/F5uXIIMBp0puktbJv7CjMuy5Vj88uqAjmW2PFYG4tLRDAQcME1ab
 8p4qsnBZ1VkOWpRedM3nL7KovuCTeBUqi27cja/xHQGlsr6cO7Iw6ffMBadvV3zZEC6G Dw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2056.outbound.protection.outlook.com [104.47.40.56])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8wd8qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 11:15:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQtRkfMAr6sIWwa/7BhjHkXT4iLKHCOKBJEvU0H4+KQ=;
 b=r0r+yU+KWJhGi2AmFHPk0quxeRtKRpQVdpVmpxA8f1LvOb4yvTQ5HtQccgSkE+1EhWy+WKNpQbF4KIm5P/XNMoVCPvIXrx93mMhcANE5Rg91LKw0k8bR+NrR/V7MzSuXxrNvPGQuOxnNiHckoAb3KNV9x6Xjj/Ew07yo/atGAOI=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2472.namprd07.prod.outlook.com (10.166.200.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 18:15:47 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 18:15:47 +0000
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
Thread-Index: AQHVI9Rx053wx8/6CUGjNUCvusFgp6af9VEAgAHFyJA=
Date:   Tue, 18 Jun 2019 18:15:47 +0000
Message-ID: <CO2PR07MB24698357445FB07451D7B890C1EA0@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
 <20190617150816.GH25211@lunn.ch>
In-Reply-To: <20190617150816.GH25211@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0xNGZhZWMxMy05MWY1LTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcMTRmYWVjMTUtOTFmNS0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSIxMzEyIiB0PSIxMzIwNTM1NTM0MjY4NDEyMDMiIGg9IjRQY3RTN2hUMzVmNTJXY1VOb1laMTV2ajFQVT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d145875-97d6-4a3f-f60e-08d6f418fca2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2472;
x-ms-traffictypediagnostic: CO2PR07MB2472:
x-microsoft-antispam-prvs: <CO2PR07MB2472A0057F49538FA0C6EE4BC1EA0@CO2PR07MB2472.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(39860400002)(396003)(366004)(13464003)(199004)(189003)(36092001)(81166006)(7736002)(6246003)(107886003)(186003)(26005)(71190400001)(71200400001)(229853002)(305945005)(66066001)(14454004)(476003)(5660300002)(11346002)(316002)(256004)(446003)(486006)(54906003)(33656002)(52536014)(68736007)(8936002)(55016002)(73956011)(9686003)(66946007)(6916009)(2906002)(76176011)(6116002)(53936002)(6436002)(66556008)(76116006)(64756008)(99286004)(7696005)(102836004)(86362001)(3846002)(4326008)(66476007)(74316002)(8676002)(25786009)(478600001)(6506007)(81156014)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2472;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AOyhUrNDYNo9ndcKCDgAk/LfZSKEAVND4Q8lqMye5KF2fCtqlrqiWYoE3Ytqg3w/GTB7+ylaFQJcQQTWd7T1poWGMhSmq1wQKaj5YsuutcXECXSWa9nqHCWdGk6AaB82O3UUPOaMANkOPiYY/xc+YeNdkGi0I05zX9zPtQk3AFdZHqJShhvDd3zMt+iSOAEMaMMZH/D3039A5xUqyBaGRyP+KGKDIg/pqLLIVr3nZpSMUfMjfie+Qd5QPj+y9fz9bZIlcYNiEPIVOc7q7FSJD6HzURHVpZCzFFvrFj4mWDMtIfWLT1DdsZudpU03CSduIbQsuMYNHIFXH8vWf9oYCCDOBZVElMaJOvAmvehTZR16fVZTjH6hIbE9QeJzYqzzg7XVeAtTad8WtVfvv0Hb0J+BjPgcEu6SRTXqiXz0sIM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d145875-97d6-4a3f-f60e-08d6f418fca2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 18:15:47.2893
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

Speed limitation of emulated PHY was because there was existing code
trying to register/emulate PHY for fixed mode.
By removing code to register emulated PHY for fixed mode I am able
to get fixed 10G link up and running.
I will send next version of patch.

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Monday, June 17, 2019 8:38 PM
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
>> 5. 0005-net-macb-add-support-for-high-speed-interface
>>    This patch add support for 10G USXGMII PCS in fixed mode.
>>    Since emulated PHY used in fixed mode doesn't seems to
>>    support anything above 1G, additional parameter is used outside
>>    "fixed-link" node for selecting speed and "fixed-link"
>>    node speed is still set at 1G.
>
>PHYLINK does support higher speeds for fixed-link.
>
>	Andrew

Regards,
Parshuram Thombare
