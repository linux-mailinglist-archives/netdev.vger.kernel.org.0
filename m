Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC85D1268B7
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 19:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfLSSJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 13:09:34 -0500
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:2549
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726797AbfLSSJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 13:09:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGNpe6Psy5VpG1wg5vnaDR5JbmFthWJef2sImYW6k7deH1dMPHECp8Bxmzv4PfM7cw3IGiYjjtSysLkiBaQby5CAsRRsOPFCLPGJ/TyrsyTTPdsNYzkaEXdoiNXpQ4KGw+MrTGqW0F+brz7Xuvlgc1LXoF64Fn35SWPGGzIrjyL9biqe3e1ngs35Uo0m1L0Jy4kOgbMjPUKupkhzpqKhSWtOSM7/dksPXPXA1vzgkSccDPkulRq0OBtsKp8984908+DGY2KDTA9IZk2flKhSsK/MA6sday60UnalGKOr/kwBRhKHHaWt6/rj6shXF23uV8Q7E4CGX9+hig2HDgGJBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWh7VVjM9Oat2z4UrdXTuVsJtFzvCDrPWgsH31zBfkU=;
 b=DYrmbWxCntLeIdJjQmsubP4X5zolbgA+sGUfY+YygLdAJkTEvk2vwYPyWYlN/5MnWQwTMtZQ+VZ4xR0PSwXndFCpOgN0p33paD/G1tzp/GEWfeap11fortuLlRt6hVHgzYYLOs/hZVRnLCFuS+XAY+GxT2m6uI+27VT2BMP3uqnCykHDgEae7dhkZSlfuJkAwfcDKYgqtOz3t+XXq8Rw9znSop1krCCW2ouMXL9nQ0lhYUoI6ejWWtx1imdmXWFIa5JULudFiFqdLLFyfSCFtsej9y3TJDuexRlA3TFAYeMkrq2CkRzaWtxqn7rSEZSHY9/K3A5267B4AFpXU7bSig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWh7VVjM9Oat2z4UrdXTuVsJtFzvCDrPWgsH31zBfkU=;
 b=LuuIQaqcXjpVZEV6ssXN/E2I2DKFnCp0UwXYBGcJ/xwd9o1nGBkieNa+DIIFFAtUegZE+7QcLY3TW/dCZY6A+oRrAttCVSXoUNSGbIjy8fWM9U470OEsRl31wajVNJ3CsFXVvLiuTnbA+k3PmFnTze2kixRQ/i2eQ3Ftd/4SfNA=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB5343.eurprd04.prod.outlook.com (52.134.122.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Thu, 19 Dec 2019 18:09:29 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.015; Thu, 19 Dec 2019
 18:09:29 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 2/6] arm64: dts: ls104xardb: set correct PHY interface
 mode
Thread-Topic: [PATCH 2/6] arm64: dts: ls104xardb: set correct PHY interface
 mode
Thread-Index: AQHVtn//f78bYa9gd0u0I4pLNK+AgafBn02AgAAhfxA=
Date:   Thu, 19 Dec 2019 18:09:29 +0000
Message-ID: <VI1PR04MB55677C52CB536D79CCD8F3F2EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-3-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219160537.GI17475@lunn.ch>
In-Reply-To: <20191219160537.GI17475@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [188.27.188.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5bf4a404-a6df-4cf6-7726-08d784ae9768
x-ms-traffictypediagnostic: VI1PR04MB5343:
x-microsoft-antispam-prvs: <VI1PR04MB534360B21BFA5C8313F92043AD520@VI1PR04MB5343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(13464003)(199004)(189003)(71200400001)(6916009)(52536014)(86362001)(4326008)(478600001)(2906002)(54906003)(5660300002)(33656002)(316002)(8676002)(81166006)(81156014)(6506007)(53546011)(186003)(26005)(8936002)(7696005)(55016002)(9686003)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5343;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9QfUGT0MvxyQAD7Bab83QbCFvldzmOa5s2GMNSngl7A3Oj4/MO2c1EHIm7AC5iKITswH3TlwQNQLgXFhKcwHeaoWVqV04/LKS04rRnwHitHIMW9dcuIXulWHosnauhUwUGa9UKn7aK8avab4/g87GerBiZMQFH0BMA+8MbGKKS1i1+JPVw34ztwAIEdw01GM1bdD4vv80q4ymIiVAEDzBs1/SLIaHQDhdWu9DR1g8/liEKnxcpJsxKjZLR7KMbmsXdXba8TjFoZ9MvlXNONR3ubVaPAiR/7QDbds02IlY2Oi1k9wPFKxgKAPb53fcxX3lXC6F0eKbRs76OH0THNugQc613hN8jAL05+8BCravmXgCT3xxojD+6jGkRUwG6ow0RmDkSgnH6TQW8GaWrk1rXxmkdtHVdRs99onerH2iJ5oiZ+KH+F+A4OUC7RE5k2GH3364ykK40N3mD8dU2jFmUe20dB78eblOJGH1n3tiIRyM2qvcKjokMJmpb9/2CQa
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf4a404-a6df-4cf6-7726-08d784ae9768
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:09:29.3467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oF1mp3JANMOfjMHgL2uDxi//ZXDt2cIYPnbTmyJIpqhya0+QKQxGeSn/SOUfoCfC+RydnzQ7qUn9IdmnQhK17g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, December 19, 2019 6:06 PM
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux@armlinux.org.uk;
> f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH 2/6] arm64: dts: ls104xardb: set correct PHY interfac=
e
> mode
>=20
> On Thu, Dec 19, 2019 at 05:21:17PM +0200, Madalin Bucur wrote:
> > From: Madalin Bucur <madalin.bucur@nxp.com>
> >
> > The DPAA 1 based LS1043ARDB and LS1046ARDB boards are using
> > XFI for the 10G interfaces. Since at the moment of the addition
> > of the first DPAA platforms the only 10G PHY interface type used
> > was XGMII, although the boards were actually using XFI, they were
> > wrongly declared as xgmii. This has propagated along the DPAA
> > family of SoCs, all 10G interfaces being declared wrongly as
> > XGMII. This patch addresses the problem for the ARM based DPAA
> > SoCs. After the introduction of XFI PHY interface type we can
> > address this issue.
>=20
> Hi Madalin
>=20
> This patch should come at the end, after you have added support for
> these new modes. Otherwise anybody doing a git bisect could land on
> code which has broken ethernet.
>=20
>      Andrew

Hi Andrew,

you are right, if the device tree would arrive intact to the kernel that
could occur. Unfortunately there are some fix-ups performed by the bootload=
er
(u-boot) that are likely to override the compatible so this ordering issue
is shadowed by that other problem.

Madalin

