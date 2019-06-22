Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D084F356
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 05:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfFVDTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 23:19:07 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:51520 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbfFVDTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 23:19:06 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5M3Imn7008111;
        Fri, 21 Jun 2019 20:18:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=5T5kWzTfs8wrb6AjxVGFCseaAijN2A0bqFIA0NBBkaY=;
 b=FsremDGxUJhRo+DbO9sjeuA/nvwI1qFD89Ubuo6NXQ+l3qrS34upPCtq+ZxlTmoGyyFJ
 4Bkq8w2RKgQOOMyXZYdRCgcKdPFy2Bmok0aFgDIZUj+3QI3QOxkwG2v8lq7x/V7rzlh7
 9GOn9gO19kusbQxF0XS+ZTjyxU8RO8DV0q9vZlozTYfPQvkxGvm4+q246DN6LA+gz0Hs
 WmJlhxHuPPw5HcWhYVJwpOM72xatLbQbXEV1FCKunfynmbOPepjiJ2tuGLMmcaY/2zku
 QTCbDhV8VESMAcKiE0/pv11/cKi/XjP4w0P+cx79l0lXZO4TbkeaLAzbj1q3TVtNc60q Yw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2056.outbound.protection.outlook.com [104.47.50.56])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t8cht7xcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 20:18:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5T5kWzTfs8wrb6AjxVGFCseaAijN2A0bqFIA0NBBkaY=;
 b=Bu7oUNHzZ8PwEr+Gkn3LYbsBq3z+4FEnhv/PAJCXDTbnziNl3tZH40EvtA1ftXSjr3iw+9KVXIIYiV+U5KiAxax+L6IlCAQ6+tPXsdYvr8fmpqbWEOqFWFZuROfHpSUP4heS/AWkialVgCI/JlLSXlpG458Mo9oNM5pgimunSIA=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2631.namprd07.prod.outlook.com (10.166.215.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Sat, 22 Jun 2019 03:18:44 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Sat, 22 Jun 2019
 03:18:43 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH v3 0/5] net: macb: cover letter
Thread-Topic: [PATCH v3 0/5] net: macb: cover letter
Thread-Index: AQHVKAweTMtpNIjojkOlvsrvBLmnGaamFuSAgADqlOA=
Date:   Sat, 22 Jun 2019 03:18:42 +0000
Message-ID: <CO2PR07MB2469E07AEBF64DFC8A3E3FAFC1E60@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
 <20190621131611.GB21188@lunn.ch>
In-Reply-To: <20190621131611.GB21188@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy02YzM3NjhkYi05NDljLTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcNmMzNzY4ZGQtOTQ5Yy0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSI2ODQiIHQ9IjEzMjA1NjQ3MTE3MzIxMjExMiIgaD0iTE00Mk1Tc08xWjJTbS83bXFDa2tJV3d0czFzPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: 
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c811c84-f0ee-499a-fad3-08d6f6c054d3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2631;
x-ms-traffictypediagnostic: CO2PR07MB2631:
x-microsoft-antispam-prvs: <CO2PR07MB263124C0AD12C248B399706CC1E60@CO2PR07MB2631.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0076F48C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(396003)(346002)(366004)(199004)(189003)(36092001)(446003)(8676002)(9686003)(74316002)(66946007)(66446008)(64756008)(68736007)(7696005)(11346002)(66066001)(476003)(478600001)(102836004)(6506007)(14454004)(66556008)(107886003)(55016002)(4744005)(5660300002)(53936002)(52536014)(6916009)(6246003)(4326008)(256004)(316002)(186003)(86362001)(76176011)(66476007)(81166006)(71200400001)(99286004)(3846002)(6116002)(486006)(76116006)(8936002)(25786009)(229853002)(6436002)(54906003)(7736002)(2906002)(26005)(81156014)(71190400001)(73956011)(305945005)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2631;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sV2Tn5RkRbRndQU5jqOYhq0hNCUWprDDSRt+Dvx1AkMBKiaKYckI0nbd4r7PDhb2TViZXeGNx3QeBHGfDqjmlbuByuHtydqrbB3r+ZHaZkfh/dVqD3XNrqlNmge52gCPQVHbci0dKgvw/OepM0fP5pg6/P2/jSEN67iEtxNsw3u9LupwbIsh5BopPvkFpMD2qRvEF7O9yReTCODQ2E4bJULgVFo9ieyEYaYstgZVEMrZeI/w93tTgPIW+DRL0/VYmZauLVkEjbPZPpioRecp4887FjMSTY8rPloUwjckw13AUu1LbHiIGMwZwfZ9MjS4pFN1yViUem5CmjBo3Dzdt0FlzjYUmMdh+xEx+Ml1rH0CUtskJV2h3lf8qS6wkZZf2a8Ws3HcCQ+dBA0NGvbq+0ZU68F7ua8OgD2da7gcM3g=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c811c84-f0ee-499a-fad3-08d6f6c054d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2019 03:18:42.9590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2631
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-22_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=832 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906220028
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

>On Fri, Jun 21, 2019 at 09:33:57AM +0100, Parshuram Thombare wrote:
>> Hello !
>>
>> 2. 0002-net-macb-add-support-for-sgmii-MAC-PHY-interface.patch
>>    This patch add support for SGMII mode.
>
>Hi Parshuram
>
>What PHYs are using to test this? You mention TI PHY DP83867, but that see=
ms to
>be a plain old 10/100/1000 RGMII PHY.
It is DP83867ISRGZ on VCU118 board. This PHY supports SGMII but driver dp83=
867=20
doesn't seems to support it, that was the reason previous patch set has pat=
ch
trying to configure PHY in SGMII mode from PCI wrapper driver.

Regards,
Parshuram Thombare
