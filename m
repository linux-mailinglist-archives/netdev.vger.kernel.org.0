Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92C212691F
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 19:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfLSSc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 13:32:56 -0500
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:37020
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726884AbfLSSc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 13:32:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oru0HYY1hVW5TlL8AZlmov7YFdMRN3xEhIRF1XWB18y+AZBsUR+AOx1SPGFrKUzhavL8BWWsLmVp7yKlGhGaDk6UPWVw+hbWDrWIZWljQSJuv0wQ6eJ+JZCGWqkBps1hTOKmnFiW/guaWSarD6KeNLbAYUdS3qSF+bHqo5ZYUKikwlzZz4BlD6Qy5o1bXyyS0YnIXRDfVigbieTdx2W0U9sR6CuNUPGBC5E+ufo+QPnmaF4iVCdZ0Xd4kxTFe2M+sTkmnwbKx/iCoojQJctI47fKW+rBRUuRP1aw7YultblkucZH+o2YWhgMRcKlrjyUM/Rqimcq1mwDzpNNK9EfCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZS4jVzTZok1mqeB9xxlh00YMVjmBmHo/pcVQ1DRA+nA=;
 b=CGG9WDPKfWEVvDyaYcqL1L2B5O8QZUxRb1kCI0xMQVMlmXNyomBtKAs8OU52UZYFutpjcThAjXMbZFooPPgKurqunOvLsNhN1trHCwDpoz8aXae8Ts1Wh8r/XE+idSUIzFd77a81ooXr0zchMBIxPgAeiwB4s8Mr1xNiMZrt/7UK9vXAhpFL5r4xP1kKASif35oHw+VkaQ4w7PGx8Sube5i9dt5FIp6VcFgZDrqQntShzOUWx1aWQkQXH5Geb2r6eXPYwKu3A/ePcopPWU0nt55hKtwjkdTbSAGaqSWbh6TBCRq98QV+ziGaERy0l4LjSzTY+36jF1ntzXMBt2I3+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZS4jVzTZok1mqeB9xxlh00YMVjmBmHo/pcVQ1DRA+nA=;
 b=g5qISFWsdwKb5ammZ8tEdNUMQdS+kYdoCCtHNoeTH/zvjKaRnAvlRZgvCgYF/WBB0yKdNaHbnjq7PwYyzFUQTGmX93DapzIghRytnJQ/1grA5OuKtf5KxGtFrZ1kXws5UIF169Bgp3zhPv3QdDdxwjZqaAYDVtiajpjQKd3qHII=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB4974.eurprd04.prod.outlook.com (20.177.48.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Thu, 19 Dec 2019 18:32:51 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.015; Thu, 19 Dec 2019
 18:32:51 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVtn//emqdPRPEmEKC7Ncoej9h46fBtnoAgAAMIfA=
Date:   Thu, 19 Dec 2019 18:32:51 +0000
Message-ID: <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
In-Reply-To: <20191219172834.GC25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [188.27.188.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 623fcd49-b91b-4c5d-2054-08d784b1db20
x-ms-traffictypediagnostic: VI1PR04MB4974:
x-microsoft-antispam-prvs: <VI1PR04MB497451CF47FD663B529C57D6EC520@VI1PR04MB4974.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(13464003)(199004)(189003)(81156014)(8936002)(86362001)(71200400001)(478600001)(64756008)(66556008)(66476007)(66446008)(66946007)(52536014)(76116006)(5660300002)(4326008)(44832011)(186003)(26005)(53546011)(7696005)(2906002)(81166006)(9686003)(55016002)(54906003)(316002)(33656002)(6916009)(6506007)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4974;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J5JCFUZsT1j8VHd0AhBQK4qSfRfS033nMOeRx/CtV+11v3Iv3MczXyFQbCr6o8l9+f1U8gvSYBEiHdv4joO2DZsbjkJFmvz6vpHWuE7z9p9XfHuufdJqk1HHop9p4AqWVWmvbLPZFVg/LCTSuCPpF8T8i2ccGx5Y29iS2lItx5IVwMY0scWDktOBxYPxaRf7KTjTmzI3Dk0/VtNBz8E2L7cnmCK58WzSc4PtrolKMEO1TuPXvaKCoXKXrxl0rW36TGhNzfHMjBWB/c/rX/euLVLmARmz9BBtAQeU+GmrnCWCqQ+ibgyAYYzUSlblJLo7kyuBicTB5MkIPXhlF0//s/e99h4eh2f3Dq7cMBjFu3it7XZ191bJwdMrCYhq3/R7eLT5ELr8nc6fBYYro8FoK39wtHmH33uGRsE28ehuWDfwsKmVOekeRJxccqVGTFwH7JFIiMTCGlz54/FqFQsjhn/JUbtFLrB5V1XCfK59BMOXyWNftIpH3UJLaetycCwd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623fcd49-b91b-4c5d-2054-08d784b1db20
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:32:51.5108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K7zHUhPK/I6z0QS9p4BD2bgIzOp57LTWwbaH28FJq/WFWLZRv2Jq7fgZgW1aw0jrP5T/tSw/TcIqcFsyUGx1KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4974
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Thursday, December 19, 2019 7:29 PM
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; andrew@lunn.ch;
> f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> On Thu, Dec 19, 2019 at 05:21:16PM +0200, Madalin Bucur wrote:
> > From: Madalin Bucur <madalin.bucur@nxp.com>
> >
> > Add explicit entries for XFI, SFI to make sure the device
> > tree entries for phy-connection-type "xfi" or "sfi" are
> > properly parsed and differentiated against the existing
> > backplane 10GBASE-KR mode.
>=20
> 10GBASE-KR is actually used for XFI and SFI (due to a slight mistake on
> my part, it should've been just 10GBASE-R).
>=20
> Please explain exactly what the difference is between XFI, SFI and
> 10GBASE-R. I have not been able to find definitive definitions for
> XFI and SFI anywhere, and they appear to be precisely identical to
> 10GBASE-R. It seems that it's just a terminology thing, with
> different groups wanting to "own" what is essentially exactly the
> same interface type.

Hi Russell,

10GBase-R could be used as a common nominator but just as well 10G and
remove the rest while we're at it. There are/may be differences in
features, differences in the way the HW is configured (the most
important aspect) and one should be able to determine what interface
type is in use to properly configure the HW. SFI does not have the CDR
function in the PMD, relying on the PMA signal conditioning vs the XFI
that requires this in the PMD. We kept the xgmii compatible for so long
without much issues until someone started cleaning up the PHY supported
modes. Since we're doing that, let's be rigorous. The 10GBase-KR is
important too, we have some backplane code in preparation and having it
there could pave the way for a simpler integration.

Thank you,
Madalin
