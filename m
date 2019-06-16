Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE48A4736A
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 08:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfFPG4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 02:56:25 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:43326 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbfFPG4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 02:56:25 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5G6lGJu003268;
        Sat, 15 Jun 2019 23:56:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=/cMVQDSocldfNQqXn3Fc8nTA3rhR6FrvZYVi9FZ6WwA=;
 b=I13XC7OYd/GtmzF7m9XHWWt8yMvpGqtkvtP9KmopvfGI5GjUSYSKpj01GAf9Ogd9we9P
 Btl/khRRS04DA8Z88qNePhzL8hi9piEtvezYEnpLgEaPbh1YSrGzWh7Nm2r+Ul1IL6sj
 G7d8ggzcBViDxpgCsKsoC7S+VZJcxZKLTA55uR70YhsGZFx83Y83YqTkuQiRpv4DiHMr
 B/9BrITenWeFAKhitO9gITkM7ts1RWkXa9Nn+ZyAg+05YCs3o2/n4LMgRO7dkAg9Oeix
 07PLJVyQH9PTSYf90l6oOcxGri9FM++q/Z78rfKqEzNuxG8jmQi/8B0oQZXnPiMbiIu1 hQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2057.outbound.protection.outlook.com [104.47.44.57])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t4w7v2g3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jun 2019 23:56:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cMVQDSocldfNQqXn3Fc8nTA3rhR6FrvZYVi9FZ6WwA=;
 b=kJz2L3ZwrbasFCLH0UpT4aLSaAN9VGsgR49vHw4RVE3fiiP7h57sYJsJkphMpGwvv6a6X6u6APrSvMIpxbMLoro8JxynJH3d5zbWEgNaAtmJkNlAJjk4zvkkOnfeKp9VFBrgmNfmdQcie0VAzoKlEB0pXANqTicNHaKQZjwRJWw=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2583.namprd07.prod.outlook.com (10.166.92.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Sun, 16 Jun 2019 06:56:15 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1965.019; Sun, 16 Jun 2019
 06:56:14 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Parshuram Raju Thombare <pthombar@cadence.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH 0/6] net: macb patch set cover letter
Thread-Topic: [PATCH 0/6] net: macb patch set cover letter
Thread-Index: AQHVI9Rx053wx8/6CUGjNUCvusFgp6ad2QKw
Date:   Sun, 16 Jun 2019 06:56:14 +0000
Message-ID: <CO2PR07MB2469362F8B7DA65D7A73315DC1E80@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
In-Reply-To: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1kMDVmZTVmYi05MDAzLTExZTktODRmNy0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcZDA1ZmU1ZmQtOTAwMy0xMWU5LTg0ZjctMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIyODkzIiB0PSIxMzIwNTE0MTc2Nzc0NTU0OTMiIGg9ImEwR3c1L3pEQ3c1V2Q3Ky96SE94WC9rUTdkWT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7363fa9-4aa4-49d3-c86b-08d6f227b97e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2583;
x-ms-traffictypediagnostic: CO2PR07MB2583:
x-microsoft-antispam-prvs: <CO2PR07MB25834769041981F50F7F0F55C1E80@CO2PR07MB2583.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0070A8666B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(366004)(376002)(39850400004)(136003)(199004)(189003)(13464003)(36092001)(53754006)(71200400001)(14454004)(486006)(2501003)(71190400001)(74316002)(229853002)(7736002)(305945005)(316002)(66446008)(64756008)(25786009)(476003)(66946007)(66476007)(66556008)(3846002)(6116002)(76116006)(11346002)(81166006)(81156014)(446003)(73956011)(8676002)(8936002)(110136005)(5660300002)(54906003)(33656002)(66066001)(107886003)(2906002)(256004)(14444005)(55016002)(6436002)(52536014)(4326008)(53936002)(9686003)(86362001)(68736007)(26005)(6246003)(7696005)(186003)(2201001)(99286004)(478600001)(102836004)(6506007)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2583;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: daH7KxsQRpWzLSZv7e+AR+SCLPvkhAn+Us5h/DStNbGKr0hk74TMM0HFHAs82/6SpDlLwG1zLmrD7yK7TQp7GNs2tV7vfdJ2v2RDpoCBiMdbgp8Qq9ZubYMyNWUN6ur+h60kptJifFpFco344O49vo8esrQj5yOFzimll7owYe7NVBOez1FIs53Vm9XKmzDmY/2bGpTD+UFTXKquaIQTJ7osI56MGef0phFfOmw7bVS+nWE6ktNBsJuqvjVcjaVp6snReg5ArqBcD6Msc6kbE+b1QJKlkJ1eLm+RQU1Y8jMf6RMbUFY3CtX6DHAcbv0mQ+g4uH6dKpWKPlbMiji8Y1rFtSDTvS1lDZ6OFrG75gFzkoNwLmBgdrROC4zAUARZ0nMkVjRRMTjRGrmMJNIxxIlGPjuw0XcFl8mO41uFfaE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7363fa9-4aa4-49d3-c86b-08d6f227b97e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2019 06:56:14.8353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2583
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906160066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Please ignore patches sent in-reply chain to patch 0001.
Sending all patches in reply to patch 0000-cover-letter.patch.

Regards,
Parshuram Thombare


>-----Original Message-----
>From: Parshuram Thombare <pthombar@cadence.com>
>Sent: Sunday, June 16, 2019 5:15 AM
>To: andrew@lunn.ch; nicolas.ferre@microchip.com; davem@davemloft.net;
>f.fainelli@gmail.com
>Cc: netdev@vger.kernel.org; hkallweit1@gmail.com; linux-
>kernel@vger.kernel.org; Rafal Ciepiela <rafalc@cadence.com>; Anil Joy
>Varughese <aniljoy@cadence.com>; Piotr Sroka <piotrs@cadence.com>;
>Parshuram Raju Thombare <pthombar@cadence.com>
>Subject: [PATCH 0/6] net: macb patch set cover letter
>
>Hello !,
>
>This is second version of patch set containing following patches for Caden=
ce
>ethernet controller driver.
>
>1. 0001-net-macb-add-phylink-support.patch
>   Replace phylib API's with phylink API's.
>2. 0002-net-macb-add-support-for-sgmii-MAC-PHY-interface.patch
>   This patch add support for SGMII mode.
>3. 003-net-macb-add-PHY-configuration-in-MACB-PCI-wrapper.patch
>   This patch is to configure TI PHY DP83867 in SGMII mode from
>   our MAC PCI wrapper driver.
>   With this change there is no need of PHY driver and dp83867
>   module must be disabled. Users wanting to setup DP83867 PHY
>   in SGMII mode can disable dp83867.ko driver, else dp83867.ko
>   overwrite this configuration and PHY is setup as per dp83867.ko.
>4. 0004-net-macb-add-support-for-c45-PHY.patch
>   This patch is to support C45 PHY.
>5. 0005-net-macb-add-support-for-high-speed-interface
>   This patch add support for 10G USXGMII PCS in fixed mode.
>   Since emulated PHY used in fixed mode doesn't seems to
>   support anything above 1G, additional parameter is used outside
>   "fixed-link" node for selecting speed and "fixed-link"
>   node speed is still set at 1G.
>6. 0006-net-macb-parameter-added-to-cadence-ethernet-controller-DT-binding
>   New parameters added to Cadence ethernet controller DT binding
>   for USXGMII interface.
>
>Regards,
>Parshuram Thombare
>
>Parshuram Thombare (6):
>  net: macb: add phylink support
>  net: macb: add support for sgmii MAC-PHY interface
>  net: macb: add PHY configuration in MACB PCI wrapper
>  net: macb: add support for c45 PHY
>  net: macb: add support for high speed interface
>  net: macb: parameter added to cadence ethernet controller DT binding
>
> .../devicetree/bindings/net/macb.txt          |   4 +
> drivers/net/ethernet/cadence/Kconfig          |   2 +-
> drivers/net/ethernet/cadence/macb.h           | 136 +++-
> drivers/net/ethernet/cadence/macb_main.c      | 659 ++++++++++++++----
> drivers/net/ethernet/cadence/macb_pci.c       | 225 ++++++
> 5 files changed, 860 insertions(+), 166 deletions(-)
>
>--
>2.17.1

