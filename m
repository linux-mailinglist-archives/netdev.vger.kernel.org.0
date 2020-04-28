Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E451BB811
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgD1HvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:51:04 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:34756
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726253AbgD1HvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 03:51:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqhxsqVt898UV23l7kP0L4+EnLM7liNNFJpV2D0QxbZnsQ2cJJy4t1yXhv1p+ih7Dc4dYx6caHwpcTdtBjNy0c/mPMj5p8LUVktikqp7ldRzItaM0SuLWBJPhCCrzqYMCVBYlN9sTM+7xLp7gdA3nTnjzdr6EJviidlLGWE2CDVqkTq0STc1CQgDkcSZjA90hb8t32VyJHKNjO0isiYrRvKFEBteEF55Mbn/8smKOcOSXlyBUnEYafeqITvkeoxsgc2WzElKcw0eHZTa/lNSEtAUj5QwjujlpE8Cfn3l+QmVmuZer/HnrQd64hfvo/YA2zmdnsPzU618Ryak5tgw6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5KrogbVu5z8OTf31KO43YxJqiF0Mze1haybHgCgcW4=;
 b=PwLfLDS68ldYWpt8B5C+r6fd5w3p2GE8qFkr09yaZE8id4hvB1sgcnhbvlDGIW9S5D2rJvje9GvEsTNLIf0SNtSqIfUVz5olHj0qqoHtDkxDYCWg65o5iofdBAQ6HtqhlNjz7tdTcN4uwC8V3DxP205HGYyW/Nm+LFMyzUv3LtTiWSvsCYaXLe2Cq93sz6jzqYisVbVCwyJFuXuJeVjKmWU6NNGQM7XHB/k04yGQ7QN9VsSInifeo96SmBPXVPqJBtXe37Nr8jBTEBoNuf77jTACnXbk5WqDf6D1t0N3cjdDC9ukHQTveHQnjYuOFEElkHHnObC/fcVBhDFwEPBuqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5KrogbVu5z8OTf31KO43YxJqiF0Mze1haybHgCgcW4=;
 b=tDAEEa07/X8lLAfqZo8IVXp0tTYZiTWRq8p0tuvPvJuffuj4HoPUhf1civi8Ni9n7ue1swTLew2AmwNwV7Zy3CBVedo5KC9uy/wnVxCOmkj1rEi/M7vvNv8sMZx5ooGzBK9iPDt5V0xL9dGkvwXsfMM5RCAM4JykMT6ZG3B1sh4=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB2827.eurprd04.prod.outlook.com (2603:10a6:3:e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 07:50:58 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.023; Tue, 28 Apr
 2020 07:50:58 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Leonard Crestez <leonard.crestez@nxp.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>, Chris Healy <cphealy@gmail.com>
Subject: RE: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Topic: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Index: AQHWHM6CT0RwD5X86UGpti/P/f0ND6iNZxCAgAC/mtA=
Date:   Tue, 28 Apr 2020 07:50:58 +0000
Message-ID: <HE1PR0402MB2745B6388B6BF7306629A305FFAC0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427164620.GD1250287@lunn.ch>
 <VI1PR04MB6941C603529307039AF7F4ABEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427201339.GJ1250287@lunn.ch>
In-Reply-To: <20200427201339.GJ1250287@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1491a588-eea4-4cc7-fbfb-08d7eb48e3a5
x-ms-traffictypediagnostic: HE1PR0402MB2827:|HE1PR0402MB2827:|HE1PR0402MB2827:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0402MB2827783CFCBF93F7D4EA4ECBFFAC0@HE1PR0402MB2827.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(5660300002)(8936002)(6506007)(7696005)(26005)(4326008)(186003)(33656002)(64756008)(66476007)(66446008)(66556008)(76116006)(66946007)(110136005)(316002)(478600001)(2906002)(71200400001)(52536014)(81156014)(6636002)(9686003)(86362001)(8676002)(54906003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4LJVi1GUDkD+Fxm56CU4IrOCnI+vZY70fWPGqxCNEGkqJVrv28qj94FZRsNuFT+OMyqbQwXGe87d9sAEZka90Dmu/lh4JK5oWjgybhd3SNzsmkI1ZRnlIcn0rgmJ6o7xKgTKYLuIhbNBG3JqeUCuyv7RyCbiywt9VRyV6D7wJXB/c6i5CCdVNifPYDvYUpbYBEWjgeIjhXeWOyhcrXFnvzITWxFrYk7mTqTRW9TbdywOFvsskTjhncSjN5eKBI6mww8enCPYf0ONQhGkEnu4/ste0xkwA8lPaSLpW07VqjCvwY5e7zlDnB77HOzr6Q1LKKs1+TRw41F4uTEDr/qBDyFJPr1zMYAJ24PuL8OFC9SarCNuVxNeudH+P4W0Qs5syesSAwomGOywjbyqTJMnCOtMAo/koDGej/YTvAO/s9ohW6xPwDZRD8GkF9/uXQav
x-ms-exchange-antispam-messagedata: ctphnrZaXCXVZqVNMW0ZdFMZT5HeFnpj3UansvsVjLRoulTNRcUmOwaAbp4uwZFWmLUJPvOlp/Ur50zaUz2bOc1NZfytdCnhvJh/H2tfbHOxG5hjgS9XSvqzYJcoLNS7oK6fUkMe42tnCnhYFrgIbD5iUbdVPKkcZtt4W/z5QLBPTGDDarvlv775/0NSyatNVdPzGpXZ+D/vC5xa0wUvddrlEYSWemca7O9dL9cAZrTziE0erJpLLkiH+e0DJD6Er85Ip0S1hudfUMtaPaPP9iw2+dDlaSH4eV+zNz3Mvrq5e8rl35OwOxdfI66bsbN5j55BcfdS4IQeJ7VmxMXt9gMNcBOp5FW+1y9QktL3mBYy2pJ+BnjsQw/hTHcw284GFixYKoOG5ZCzMIImK4QQmWO3muEwzqqeHGsMDQKcCmqlUBqA9vgfX8pAYtZpbFz1Sg+5lZnIgg2/0xyKa20hSmvy3b33H7N/IjFgkVQbgkCwi+kc13XJmu0fhv8K1fFftFLIXRv/ZYwDMT4Atnz6Ppn18wXkkN0M2etKVOmW0EHwrVLL62kutmveZcXJNnPegY3Ascr7LPMqIzTRh44YE3TEhuBov6dvTnpqDsdVsxNHuKFgzdUsUd42S6HJ9cNFfwiI1WUKWsN+uUUwB3wFZfjZ2EaLONBhNKg2Hz2OrWA3f4SulbaQtTkDiLKqL/6RgCARXXzWxfC/vyqg/Xu1CgiH2qu5TOOJ2OttBM+WTFsS+fc9pTjINN6hpvip1lJSLw0ShsezaCXKPI7/848oKdY+sSEcGzBslbis4nyPnew=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1491a588-eea4-4cc7-fbfb-08d7eb48e3a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 07:50:58.4433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7B91NybYv/h3d3C4jcHRtLCc0A8CCa/+DwQjkn8I/WM4G4Nw1HMEyKDwp3zx7TeA5MKgkYWXYfuXu4VCYb/oXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2827
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, April 28, 2020 4:14 AM
> Hi Leonard
>=20
> > Does not help.
>=20
> Thanks for testing it.
>=20
> > What does seem to help is inserting prints after the FEC_ENET_MII
> > check but that's probably because it inject a long delay equivalent to
> > the long udelay Andy has mentioned.
>=20
> Yes, serial ports are slow...
>=20
> > I found that in my case FEC_ENET_MII is already set on entry to
> > fec_enet_mdio_read, doesn't this make fec_enet_mdio_wait pointless?
> > Perhaps the problem is that the MII Interrupt pending bit is not
> > cleared. I can fix the problem like this:
> >
> > diff --git drivers/net/ethernet/freescale/fec_main.c
> > drivers/net/ethernet/freescale/fec_main.c
> > index 1ae075a246a3..f1330071647c 100644
> > --- drivers/net/ethernet/freescale/fec_main.c
> > +++ drivers/net/ethernet/freescale/fec_main.c
> > @@ -1841,10 +1841,19 @@ static int fec_enet_mdio_read(struct mii_bus
> > *bus, int mii_id, int regnum)
> >
> >          ret =3D pm_runtime_get_sync(dev);
> >          if (ret < 0)
> >                  return ret;
> >
> > +       if (1) {
> > +               u32 ievent;
> > +               ievent =3D readl(fep->hwp + FEC_IEVENT);
> > +               if (ievent & FEC_ENET_MII) {
> > +                       dev_warn(dev, "found FEC_ENET_MII
> pending\n");
> > +                       writel(FEC_ENET_MII, fep->hwp +
> FEC_IEVENT);
> > +               }
>=20
> How often do you see this warning?
>=20
> The patch which is causing the regression clears any pending events in
> fec_enet_mii_init() and after each time we wait. So the bit should not be=
 set
> here. If it is set, the question is why?
>=20
> The other option is that the hardware is broken. It is setting the event =
bit way
> too soon, before we can actually read the data from the register.
>=20
>         Andrew

Andrew, after investigate the issue, there have one MII event coming later =
then
clearing MII pending event when writing MSCR register (MII_SPEED).

Check the rtl design by co-working with our IC designer, the MII event gene=
ration
condition:
- writing MSCR:
	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero & mscr_reg_data_in[7:0] !=3D 0
- writing MMFR:
	- mscr[7:0]_not_zero
=09
mmfr[31:0]: current MMFR register value
mscr[7:0]: current MSCR register value
mscr_reg_data_in[7:0]: the value wrote to MSCR


Below patch can fix the block issue:
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2142,6 +2142,15 @@ static int fec_enet_mii_init(struct platform_device =
*pdev)
        if (suppress_preamble)
                fep->phy_speed |=3D BIT(7);

+       /*
+        * Clear MMFR to avoid to generate MII event by writing MSCR.
+        * MII event generation condition:
+        * - writing MSCR:
+        *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero & mscr_reg_data_i=
n[7:0] !=3D 0
+        * - writing MMFR:
+        *      - mscr[7:0]_not_zero
+        */
+       writel(0, fep->hwp + FEC_MII_DATA);
        writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
