Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A51A2A652E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgKDN32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:29:28 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:60327 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbgKDN30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:29:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1604496565; x=1636032565;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=cOZoxS1fWc3bvJMIh5nwbhSoxi7CmOxQ28+mm12+kuE=;
  b=h4jHJr8BoxMnxBFgCsa/iC8P/s4gQBko3Wm1rlmU66kNsAG2bEFDhkP9
   WMQOa9Iogh1cmtNvEenCBK22axwzFPVDyKp4ZJ61U4ApbEM9Xn1Er1v1l
   MGd7pU9iNaxcipVWaZ58/WrCSRskkfXosJ2xS5eBe14mivpImXFYybaza
   gjLmF5LGydXe0GMo7D0L5xKP77LtoLPyeIvx2eoWoWi3IWMJBD1bsXKxf
   JfV/ueclBUbXbgJ1B/AjdFVhfmVe+ZeZCGruirgWtm/m2r5wvduGX5Me8
   VIp3GBOTxJ5duG1mSIOM2ZdzpbkGGPAQE0cmNlMc9gfA8K8sIDQtq3lBE
   Q==;
IronPort-SDR: WCXt4JXFQCrFUb8IJX7/ofAZ5jNdyY6ljlv+vX8vGoR66fhvFUy5JXMzVGQRW5btzZU1m1Uv/r
 A9LgAviY8yOy9V6j+O2HrRhLccNoD1mlvo7L/KXEXJyGgWqhdeet0fNcbtLhl3jGbq/SnvUG/o
 6tptlr6hzqbeGf9wX/xO2rIZit/9DGehLP517YyPsTo74myufcOGZe+kjnVbRewRU486kQUJW5
 Yow7XDrRXoGgR6nr3C6GZO3Abx/OGBQ8vLJBNldvRAs1GQ8AcHsTay+oRBov3p2qaNdJlYMMZz
 7XI=
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="97735655"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Nov 2020 06:29:25 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 06:29:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 4 Nov 2020 06:29:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRs1FsHNSrk3Ur5iIwlQ8qC7zOR5XvS/HmK1bOOcyLYwB4f4CziBtgYxFAGEp65YGQaCWQ0RzYDlXC1x0m+09FQGJ6N/tsM0qjoLmaKTXAPFRc5IjRuZ/92FoCedJf3FBCci4jUXGkhGEpM/exW4YtU5IatSdYFQz057SZbFsPxkumBQgdCz1IM/dfxkMfLs5TXWcV3lFxjVuW8Uo2E9uksRw33KEoG/x8+xXSlIOTeTJDbMbQ3Zchh8/yKh9JCXmNY0grYh5THT2IJcyuu6ut6ImQ15vGizH/IuMSYVyhyLeFtY8UXsA2qd4yPb6FY4rwphWBIBox7dey3DDGm2lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eVj5c2duIF81zM96auZ4t8Op3o3rxLGWE6rxDrcZho=;
 b=QLYa62sho0U07rFbLV6M2SQLKdhPoOB5uLuiQGQDuNCb0DOMWmOqfA7eCHHyFS/1L031R9x5rtFYFzDaq17lxM1q9iWv0eI+py4X0seAZN2v5l0I4gw2M05BXv11sx0p/M/y+wiSpGKIbC+drE7YI79Hdg3HC8ICRAGMiZNiQJApu1tWpLUN3tZ7esHvnQ8xc4V4YkQCSCYRAIMrHasL+Ghkfiv5KttDUaiaP/0XDy9srAvgksvd9D3ntv4i23PKFgRnFPPWSmTTloilxICn+G1J2CP0yAmn+fDlxwSrwFR+xXIDce/6TdbLkNK25mQwNlnHBOsO2CEFNRdzI0t2nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eVj5c2duIF81zM96auZ4t8Op3o3rxLGWE6rxDrcZho=;
 b=nkPdKuLxBBfKbghHIuiR/ic27rgBwrM438tQiCUDnTa2T4bD9jM3aUy2Wnj/B/l1NRO2ouuqxskm/lHN8sWmfa8EjHeOCZjI7Qu4R2r7ogdNopr6h/iVwZ+WQwWe3S72CEjmYLAzF/mQr1MKYKhkZQwEnIdE00EiIVSjMqUQLHE=
Received: from BYAPR11MB3477.namprd11.prod.outlook.com (2603:10b6:a03:7c::28)
 by BYAPR11MB2728.namprd11.prod.outlook.com (2603:10b6:a02:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Wed, 4 Nov
 2020 13:29:21 +0000
Received: from BYAPR11MB3477.namprd11.prod.outlook.com
 ([fe80::cd28:b37a:77af:a196]) by BYAPR11MB3477.namprd11.prod.outlook.com
 ([fe80::cd28:b37a:77af:a196%3]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 13:29:21 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <pthombar@cadence.com>, <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <Claudiu.Beznea@microchip.com>, <Santiago.Esteban@microchip.com>,
        <andrew@lunn.ch>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <harini.katakam@xilinx.com>, <michal.simek@xilinx.com>
Subject: net: macb: linux-next: null pointer dereference in
 phylink_major_config()
Thread-Topic: net: macb: linux-next: null pointer dereference in
 phylink_major_config()
Thread-Index: AQHWsq6BvPM9dPOV2Uq2LXB0FhVdIg==
Date:   Wed, 4 Nov 2020 13:29:21 +0000
Message-ID: <2db854c7-9ffb-328a-f346-f68982723d29@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: cadence.com; dkim=none (message not signed)
 header.d=none;cadence.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [2a01:cb1c:8c:b200:d971:56e2:4c0c:2a6f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9590c31a-77e0-4adc-89b4-08d880c5a3dd
x-ms-traffictypediagnostic: BYAPR11MB2728:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2728C9199341BBC8ADD2430AE0EF0@BYAPR11MB2728.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xyj8L00PBUV1rPQ2nSF19H0Xt6eRwb0jjLmoyfwXDDmNmmiN9IdWn5HLJgF3QEjSBddzJdkb+1eV4IilL0+EayMluV0TmJsCF1KcnjnH0NGPEiOIma7p9IWIzuiq3jrNvHOWtBi+a6Uq+pswrgXXXE39kI+TOHVIgQYgE1GGmvIWsZOmv0GypW4rcHGpNsvQGcCdhReEOZxpR4Fv2p0YDE/5fsnG7aDwPS3vugibEkWnJj1T61no7y1eOkkqgdCE70jHBLn1NIguWLQoIAZF9zXpnSv4D5VnyTJvo4255JpSuyqNtM+RWQtuQBUC68TuBsFvDuOAdIw+OsX39TX4rQTJkSNpjFMmJ+a4/BKJA4SwnKbj8dz2Z8iO89deBsxCLfzuJZQh3H8aNlJT62QrmEUuio5EY2WPe9nr60TDFlg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3477.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(8936002)(54906003)(83380400001)(8676002)(6486002)(6512007)(5660300002)(31696002)(110136005)(71200400001)(2906002)(4326008)(36756003)(91956017)(76116006)(186003)(31686004)(2616005)(86362001)(45080400002)(316002)(64756008)(66446008)(66476007)(66556008)(66946007)(478600001)(7416002)(6506007)(43740500002)(414714003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 4xLGeZN6L8md3uaEay1agpJDKi40nNXmcl5VCjAwOoBDC4bTRQ+V6jeYE9iLI531G0eERihZQT+GONEUGBPa/GKji2R9rvX2HF72urWYnWixMZ2+l3aRDdbFVjpKIbA7k18n02gh+q3HcSwCff1UWhi/dlIIWx9A79M2WOQpHU1S7LY3H03BREZ+eqC45/UHuqEiAnSK9D+ZOsZUG1xpdSk/HGseVH6ZJJdP5YfrXRelKvJt7CK2pzMvl+JCPipUaymk+8xuJE01GB+vHgh4koGn+jIpWsho6j3DXu2icOCFW11riCArjOsdG09PGPnptSrs2Ds1oRSfLj4F75J2OgryNQBeEpLXuMoSgp/N7AxTBN9V0YPOxZeXayp6PWJgQyDtda07YVKcK59EfugoaRwXjoJPU5dM5r9HsZ9J69Ahq1ez29cpcS1fGWpQh0VX3Yg/o07n0N6TUb/M3xKy3Net0DGugYFvUu50DbAgaWQlKroxK/rpVNZBJj1AdMmblpuAmfz+g2xlIM/wog0NIT92S8W6BYQperQlyqUHnPdVA/K5zRMwiWbabLS+oeA76zG2I0pyF0TTczxWcxqOGAtZc4qvZWJ63br2uN8V7ZTjnkVW0yKna8zooX+UhogYtN2HaD3A3sOI5bFgvxRaUcYfghkWlj5J5Kn0Vbl5j6NKid/kN2HKIG0CYIvgex1X9Zy7Dr1tvsCeIIXqrFiDzg==
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9B2BE35AC697A647A03C5ED2CAD8161D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3477.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9590c31a-77e0-4adc-89b4-08d880c5a3dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 13:29:21.8123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t6nQfbGJVnjyOmWc4fFZ0CxcHTNAOOsLvbYU03kLwQgytGKfnPa0aSqJ5ZFsyIp6q3s5aFINpnN4k1ZhGsFeT+2JXw/MPeF1/1OQoS37ioo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2728
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Heads-up on this kernel Oops that happened and has been observed on
linux-next since 20201103 and was not existing in 20201030.

I didn't went further until now but wanted to report it
as soon as possible.
Could it be related to newly included patch
e4e143e26ce8 ("net: macb: add support for high speed interface")?

Tell us if you saw it on other platforms or if you couldn't reproduce it.

[..]
Linux version 5.10.0-rc2-next-20201104 (root@linux-ci-43h78-cjbps) (arm-lin=
ux-gnueabihf-gcc (GNU Toolchain for the A-profile Architecture 8.3-2019.03 =
(arm-rel-8.36)) 8.3.0, GNU ld (GNU Toolchain for the A-profile Architecture=
 8.3-2019.03 (arm-rel-8.36)) 2.32.0.20190321) #2 Wed Nov 4 07:31:39 UTC 202=
0

[..]
OF: fdt: Machine model: Atmel SAMA5D4 Xplained

[..]
libphy: Fixed MDIO Bus: probed
libphy: MACB_mii_bus: probed
macb f8020000.ethernet eth0: Cadence GEM rev 0x00020120 at 0xf8020000 irq 2=
7 (fc:c2:3d:0d:eb:27)

[..]

Configuring network interfaces...
macb f8020000.ethernet eth0: PHY [f8020000.ethernet-ffffffff:01] driver [Mi=
crel KSZ8081 or KSZ8091] (irq=3D46)
macb f8020000.ethernet eth0: configuring for phy/rmii link mode
8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 0000000=
0
pgd =3D 8fd7a220
[00000000] *pgd=3D00000000
Internal error: Oops: 80000005 [#1] ARM
Modules linked in:
CPU: 0 PID: 250 Comm: ip Not tainted 5.10.0-rc2-next-20201104 #2
Hardware name: Atmel SAMA5
PC is at 0x0
LR is at phylink_major_config+0x84/0x1a8
pc : [<00000000>]    lr : [<c0509ebc>]    psr: a0050013
sp : c1cdb8f0  ip : c09530c4  fp : c09530d4
r10: c12204e0  r9 : 00000000  r8 : 00000001
r7 : 00000001  r6 : 00000000  r5 : c1cdb918  r4 : c1266800
r3 : c1cdb918  r2 : 00000007  r1 : 00000000  r0 : c1221100
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c53c7d  Table: 21d60059  DAC: 00000051
Process ip (pid: 250, stack limit =3D 0x362b1cfa)
Stack: (0xc1cdb8f0 to 0xc1cdc000)
b8e0:                                     00000001 c0a58564 c1cdb8f0 c12668=
00
b900: c0d03208 c1cdb918 c1220000 c050b3c8 c0a4bc38 00000000 00000000 000000=
00
b920: 00000000 00000000 00000000 00000000 00000007 ffffffff 000000ff 000000=
00
b940: 00000000 a0250c4f c12204e0 00000000 dfbf0318 c051c450 c12206a4 c12200=
00
b960: c1221000 c1220668 00000001 c051fbac 00000000 fffffff1 c1220000 c0d032=
08
b980: c09530d4 c1cdbd48 00001002 c1cdbd48 c1cdbd48 c064af9c 00000000 000000=
00
b9a0: 00000000 c1220000 c1cdbd48 a0250c4f 00000000 c1220000 00000001 000010=
03
b9c0: c0d03208 c064b368 00000000 00000000 00000000 00000000 00000000 a0250c=
4f
b9e0: 00000000 c1220000 00001002 00000000 c1220138 c1cdbc68 c1082810 c064b3=
e0
ba00: c0d03208 c1cdbb88 c1220000 c1d29900 c1cdbc68 c0656f20 00000000 000000=
00
ba20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
ba40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
ba60: 00000000 a0250c4f 00000000 c1082820 c1d29900 c1082800 c1cdbd48 a0250c=
4f
ba80: c1cdbd48 c1082800 c1220000 00000000 c1cdbd48 00000000 00000000 000000=
00
baa0: c097c1dc c065d2c4 c1cdbb88 c1cdbc68 00000000 c1220000 c0d3cce0 c10828=
10
bac0: 00000000 c0d03208 c1d44a00 c1d29900 00000009 c070df20 c1d29900 000000=
00
bae0: 00000000 00000000 00000000 00000000 00000000 00000000 c1bd0000 c0d3d7=
2c
bb00: 00000180 c03a6a70 c1d29900 c1bd03c0 c1d29900 c03a6ab4 c1d29900 c065c0=
d0
bb20: 00000003 a0250c4f c0656170 c1cdbb54 c0d03208 c068a824 f601f5ae c101e0=
00
bb40: c1cdbb38 00040000 02940000 00000000 00010000 00000000 c068a2c8 c06882=
38
bb60: c1cc7c00 c0d03208 a0250c4f c1cc7c00 c1d29900 000003bc c1087400 c10875=
64
bb80: f601f5ae c0d03208 00000000 00000000 00000000 00000000 00000000 000000=
00
bba0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
bbc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
bbe0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
bc00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
bc20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
bc40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
bc60: 00000000 00000000 c1082800 00000000 00000000 00000000 00000000 000000=
00
bc80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
bca0: 00000000 00000000 c0d03208 c064ce3c 00000000 a0250c4f 00000000 c1d44a=
00
bcc0: c1d29900 c1082800 c1cdbd48 c1d29900 c1cdbd48 c1082800 c0d5fb34 c065d5=
48
bce0: 00000000 00000000 c0d03208 c0d5fb34 c1d29900 c0657e90 c1d09ac0 c10800=
c0
bd00: c0d03208 c1cdbf60 000003bc c0d03208 c1d41bbc c1cdbd3c c0d03208 a0250c=
4f
bd20: 00000000 c1d29900 c0d03208 c0657c48 c1082800 00000020 00000000 c0d032=
08
bd40: 00000000 c068cb10 00000000 00000000 00000000 00000000 00000000 000000=
00
bd60: 00000000 00000000 00000000 a0250c4f c1087400 00000020 c1d29900 c1cc74=
00
bd80: c1cc7564 c068c270 7fffffff a0250c4f 00000008 c1cdbf58 c0d03208 c1cc74=
00
bda0: c1d29900 00000020 00000000 c068c4d8 00000001 c035ca40 00000000 c1cdbe=
64
bdc0: 00000000 c1cdbe64 c1024780 00000000 000000fa 00000000 00000000 a0250c=
4f
bde0: 00000000 c1cdbf58 c068c318 00000000 c0d03208 c15b9a80 c1cdbe0c 000000=
00
be00: 00000020 c0628408 00000000 00000000 c0d03208 c0629af8 c1cdbe60 c1cdbf=
60
be20: 00000000 c101e000 bea7176c a0250c4f 00000000 c0d03208 c1cdbf58 000000=
00
be40: c15b9a80 00000000 00000000 00000128 00546cc0 c0629b84 00000000 029400=
00
be60: 00000000 bea7179c 00000020 c068a2c8 c0688238 00040000 02940000 000000=
00
be80: 00010000 00000000 c068a2c8 a0250c4f 00000007 ffffffff c15b9c70 c097b5=
00
bea0: c0d03208 00000010 00000000 00000000 5ac3c35a a0050013 00000000 c1cdbe=
bc
bec0: c1cdbebc a0250c4f fffffe30 c1c76300 002e0003 c15b9c70 c15e4110 c101b4=
90
bee0: fffffe30 c0d03208 5ac3c35a c01cdc68 00000000 c15b9c70 00000000 000000=
00
bf00: c1d0aaa8 00000000 c1c804c4 c1c80180 00000000 c1c804c4 5ac3c35a c012ed=
04
bf20: ffffe000 a0250c4f c0100264 c0d03208 bea71718 00000000 c15b9a80 c01002=
64
bf40: c1cda000 c0629f7c 00000000 00000000 00000000 fffffff7 c1cdbea4 000000=
0c
bf60: 00000005 00000000 00000000 c1cdbe6c 00000000 c1cdbfb0 00000000 c1c763=
01
bf80: 00000000 00000000 00000000 a0250c4f b6f644d0 00000000 00000010 b6f644=
d0
bfa0: 00000128 c0100060 00000000 00000010 00000003 bea71718 00000000 000000=
00
bfc0: 00000000 00000010 b6f644d0 00000128 00547008 5aa2f689 00000000 00546c=
c0
bfe0: 00000128 bea716b8 b6e8cd7f b6e0eba6 60050030 00000003 00000000 000000=
00
[<c0509ebc>] (phylink_major_config) from [<c050b3c8>] (phylink_start+0x190/=
0x33c)
[<c050b3c8>] (phylink_start) from [<c051c450>] (macb_phylink_connect+0x40/0=
xb4)
[<c051c450>] (macb_phylink_connect) from [<c051fbac>] (macb_open+0x1e0/0x2a=
0)
[<c051fbac>] (macb_open) from [<c064af9c>] (__dev_open+0xfc/0x180)
[<c064af9c>] (__dev_open) from [<c064b368>] (__dev_change_flags+0x16c/0x1cc=
)
[<c064b368>] (__dev_change_flags) from [<c064b3e0>] (dev_change_flags+0x18/=
0x48)
[<c064b3e0>] (dev_change_flags) from [<c0656f20>] (do_setlink+0x2d8/0xbdc)
[<c0656f20>] (do_setlink) from [<c065d2c4>] (__rtnl_newlink+0x4e8/0x72c)
[<c065d2c4>] (__rtnl_newlink) from [<c065d548>] (rtnl_newlink+0x40/0x5c)
[<c065d548>] (rtnl_newlink) from [<c0657e90>] (rtnetlink_rcv_msg+0x248/0x2c=
0)
[<c0657e90>] (rtnetlink_rcv_msg) from [<c068cb10>] (netlink_rcv_skb+0xb8/0x=
110)
[<c068cb10>] (netlink_rcv_skb) from [<c068c270>] (netlink_unicast+0x188/0x2=
30)
[<c068c270>] (netlink_unicast) from [<c068c4d8>] (netlink_sendmsg+0x1c0/0x4=
08)
[<c068c4d8>] (netlink_sendmsg) from [<c0628408>] (____sys_sendmsg+0x1a4/0x2=
38)
[<c0628408>] (____sys_sendmsg) from [<c0629b84>] (___sys_sendmsg+0x6c/0x98)
[<c0629b84>] (___sys_sendmsg) from [<c0629f7c>] (__sys_sendmsg+0x50/0x8c)
[<c0629f7c>] (__sys_sendmsg) from [<c0100060>] (ret_fast_syscall+0x0/0x58)
Exception stack(0xc1cdbfa8 to 0xc1cdbff0)
bfa0:                   00000000 00000010 00000003 bea71718 00000000 000000=
00
bfc0: 00000000 00000010 b6f644d0 00000128 00547008 5aa2f689 00000000 00546c=
c0
bfe0: 00000128 bea716b8 b6e8cd7f b6e0eba6
Code: bad PC value
---[ end trace f10e0fdf87618077 ]---

Best regards,
--=20
Nicolas Ferre
