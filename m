Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84679273B3
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfEWBC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:02:27 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:59139
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727691AbfEWBC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:02:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sCzebiMJcNVwjbDgELTbkaxHi9v3BIj6RdeuQVuaTo=;
 b=UG0nEMcbUok+jbe28llzmdAaBU3uiOc/3cn6SFqO2E9UST+v1gL/bUPc47lBzB8tJkodUlus0yVxFB+BjW7kQrOIYwFueyafSDe2RtWgiak+fWjvdtYXuTaV8AytlCt/iKyjSWOiSs9tCKNnhaizrHYoZT9OWMMFPaPqUXShiss=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3565.eurprd04.prod.outlook.com (52.134.4.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:02:22 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef%4]) with mapi id 15.20.1922.013; Thu, 23 May 2019
 01:02:22 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Baruch Siach <baruch@tkos.co.il>, Abel Vesa <abel.vesa@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: RE: [EXT] i.MX8MQ clk: enet1_root_clk already disabled
Thread-Topic: [EXT] i.MX8MQ clk: enet1_root_clk already disabled
Thread-Index: AQHVEKost0YS20cCEUOye2JuXYtTy6Z35K+w
Date:   Thu, 23 May 2019 01:02:22 +0000
Message-ID: <VI1PR0402MB36002F925E81085CA6A09916FF010@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20190522142511.7woox7asx636fiw7@sapphire.tkos.co.il>
In-Reply-To: <20190522142511.7woox7asx636fiw7@sapphire.tkos.co.il>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b44464de-7059-45c1-90d1-08d6df1a4ff6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3565;
x-ms-traffictypediagnostic: VI1PR0402MB3565:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0402MB35656C269FFD53AB1C671ABDFF010@VI1PR0402MB3565.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(396003)(39860400002)(136003)(189003)(199004)(52536014)(966005)(99286004)(66066001)(86362001)(4326008)(14454004)(5660300002)(53936002)(6246003)(102836004)(71190400001)(71200400001)(6506007)(256004)(14444005)(5024004)(25786009)(73956011)(81156014)(9686003)(76116006)(66946007)(8676002)(6436002)(6306002)(8936002)(55016002)(33656002)(74316002)(66476007)(66556008)(64756008)(81166006)(66446008)(229853002)(316002)(2906002)(7736002)(6636002)(478600001)(68736007)(305945005)(7696005)(486006)(110136005)(446003)(11346002)(6116002)(186003)(26005)(476003)(54906003)(76176011)(45080400002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3565;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: w8NdeFioOAriLxdAhqRi4eXKiYMO6fiZtdBlgm5KlO6EtqxqrS+F7S9BdhUiUDyguT5STxtw8lFhrXBF7lf5OXASt0Jug7K6W95MACf36l5qJYjJEYmRKZDXjHnOL01msmLgdsVKUu8aMjquv2khQKU0ZpqBNih8bbRLp9EYA3X3Uh8/5GBVbO8N/PzgfheZKiobYIQBExnalOqkGcghI9BVybnKf+pB8rDLNZhCBbUmV1kstrFIs6w7la+df8KpcM+r6fbBzd8pi5A3bQKBev/gJHKVx9wD0k1iaCU4sVp/l0r8lnwdcKBlmr3REFpaNcvc8RNrKoosdwSQI6iIz2PlhVsDy1V+SF612DcRQP48iBbBUuL3lVVzH2XqNBZlz+mYXyKN6jhIrh4rCCahsm/2kcK6kXTeR+mil1nod/g=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b44464de-7059-45c1-90d1-08d6df1a4ff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:02:22.1957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3565
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>
> I'm testing kernel v5.2-rc1 on my i.MX8MQ system, SolidRun Hummingboard
> Pulse. The fec driver happens to probe before the gpio driver that we nee=
d for
> the PHY reset. So fec_reset_phy() returns -EPROBE_DEFER. This triggers th=
e
> splat below when clk_ahb is disabled somewhere below the 'failed_reset'
> label:
>=20
> [    1.267218] enet1_root_clk already disabled
> [    1.271462] WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:924
> clk_core_disable+0xa0/0xa8
> [    1.279396] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 5.2.0-rc1-00002-gb88a935c6e3f-dirty #1340
> [    1.288105] Hardware name: SolidRun i.MX8MQ HummingBoard Pulse
> (DT)
> [    1.294383] pstate: 60000085 (nZCv daIf -PAN -UAO)
> [    1.299184] pc : clk_core_disable+0xa0/0xa8
> [    1.303376] lr : clk_core_disable+0xa0/0xa8
> [    1.307565] sp : ffff00001003bad0
> [    1.310886] x29: ffff00001003bad0 x28: ffff0000110c4000
> [    1.316208] x27: ffff00001099f0b0 x26: ffff8000bd9f50a8
> [    1.321530] x25: ffff00001099dfb0 x24: ffff0000110c4990
> [    1.326852] x23: ffff8000bd9f4810 x22: ffff8000b8820000
> [    1.332173] x21: ffff8000b949ec00 x20: ffff8000b91d0d00
> [    1.337495] x19: ffff8000b91d0d00 x18: 0000000000000010
> [    1.342816] x17: 0000000000000000 x16: 0000000000000000
> [    1.348138] x15: ffffffffffffffff x14: 0720072007200720
> [    1.353459] x13: 0720072007200720 x12: 0720072007200720
> [    1.358780] x11: 0720072007200720 x10: 0720072007200720
> [    1.364101] x9 : 0720072007200720 x8 : 0720072007200720
> [    1.369423] x7 : 000000000000009b x6 : ffff8000ba020f00
> [    1.374744] x5 : 0000000000000000 x4 : 0000000000000000
> [    1.380065] x3 : 00000000ffffffff x2 : ffff000011008ce0
> [    1.385386] x1 : dc292ba4797d3600 x0 : 0000000000000000
> [    1.390708] Call trace:
> [    1.393162]  clk_core_disable+0xa0/0xa8
> [    1.397006]  clk_core_disable_lock+0x20/0x38
> [    1.401286]  clk_disable+0x1c/0x28
> [    1.404698]  fec_probe+0x6a4/0x1248
> [    1.408196]  platform_drv_probe+0x50/0xa0
> [    1.412214]  really_probe+0xcc/0x280
> [    1.415797]  driver_probe_device+0x54/0xe8
> [    1.419901]  device_driver_attach+0x6c/0x78
> [    1.424092]  __driver_attach+0x68/0xe8
> [    1.427851]  bus_for_each_dev+0x70/0xc0
> [    1.431695]  driver_attach+0x20/0x28
> [    1.435279]  bus_add_driver+0x170/0x1d0
> [    1.439123]  driver_register+0x60/0x110
> [    1.442967]  __platform_driver_register+0x44/0x50
> [    1.447683]  fec_driver_init+0x18/0x20
> [    1.451443]  do_one_initcall+0x70/0x164
> [    1.455288]  kernel_init_freeable+0x1a0/0x234
> [    1.459657]  kernel_init+0x10/0x100
> [    1.463156]  ret_from_fork+0x10/0x18
> [    1.466743] ---[ end trace 5e50e985bb318e6c ]---
>=20
> On the following probe attempt after gpio probe, fec probes successfully,=
 and
> Ethernet is functional. So this is not a fatal error, but it is not nice.
>=20
> Any idea how to fix it?
Below patch can fix the issue. You can try it. I will send the patch later.

@@ -3556,7 +3555,7 @@ fec_probe(struct platform_device *pdev)
        if (fep->reg_phy)
                regulator_disable(fep->reg_phy);
 failed_reset:
-       pm_runtime_put(&pdev->dev);
+       pm_runtime_put_noidle(&pdev->dev);
        pm_runtime_disable(&pdev->dev);
 failed_regulator:
        clk_disable_unprepare(fep->clk_ahb);
>=20
> Thanks,
> baruch
>=20
> --
>=20
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fbaruch=
.
> siach.name%2Fblog%2F&amp;data=3D02%7C01%7Cfugang.duan%40nxp.com%
> 7C07955de3e2cb4aa8108108d6dec14e80%7C686ea1d3bc2b4c6fa92cd99c5
> c301635%7C0%7C0%7C636941319160064392&amp;sdata=3DSpuf9ByyHaxTHk
> nkCvwF0aRHeG49ymBQiCDQ7BTuSlU%3D&amp;reserved=3D0
> ~. .~   Tk Open Systems
> =3D}------------------------------------------------ooO--U--Ooo----------=
--{=3D
>    - baruch@tkos.co.il - tel: +972.2.679.5364,
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fwww.tk
> os.co.il&amp;data=3D02%7C01%7Cfugang.duan%40nxp.com%7C07955de3e2cb
> 4aa8108108d6dec14e80%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7
> C0%7C636941319160064392&amp;sdata=3DGbuRBKbH%2FPX3VJgki8NKnDssD
> v5hrrNdU4CjEYhSoys%3D&amp;reserved=3D0 -
