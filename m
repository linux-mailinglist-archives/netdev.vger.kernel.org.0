Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9500628F763
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390063AbgJORCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:02:09 -0400
Received: from mail-eopbgr80040.outbound.protection.outlook.com ([40.107.8.40]:30997
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388305AbgJORCJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 13:02:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwZ7K+yTAxjSMuXjwvZbwNCidiKUFwk97xPkPtRIYdgFHaZJW5vzExADcg3anG3RiWlelDte2/srNKYO0vv4C0T7syuayJtG4YO9KporHxeL1L9B+hUihWnU/IFhF8vJjuZO1+iIeLIOto/Ixo90X4C/fwDzJ7CjTSamV66a+FPLmYHHVy+AIJoTL6OcdYspktZX+TamSxvKFvVwZbhBm1u6QqOiZroI51mN6AkldqhrJvQwiaitCDp79ncJlcW91363L2spNVPVTBHPKWovh/gjA1mM2YtZrTJG4Xt2ngmW6VHzoVVY5oiRBJ1ChXcoBPY75CEYJk6ugXbVynEscQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFJzGxMftP0tL5sDvVC5Vtse8NmGENc8c5lqWV+BgUI=;
 b=UM8P2/e9vFgii3Uno2a/BdsN3VTHNZvg/rtDHrLjMRhvxOrttZWgpgGKCWvzMwrdqzPpzBhA4Lj0tQYfPzfcV88+rA8xKO24FJS1o26bcd79FneVf4ZeQ65d4LsF1y6YYU4ipsLDDo4TV6MVs6+h4MIfyHkBIfYuUlaP+GCcEkV9xA2YR/wswz/IiCfXAjX7yM2P+ickwdgjpv1XtSCnaqJsGqvIzj5pozDUIrNzgsEq9Be/sUVcCQXePEz8DbQDlxlW2nFb44oNJrQAWD7Ei7VYfNSnsuCwLhjhbhWhNN1K9Bki8hv2z0/61WbuN3dARkS7Ovxh7ii52M7/znYyLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFJzGxMftP0tL5sDvVC5Vtse8NmGENc8c5lqWV+BgUI=;
 b=lq2kVPOertSTt4N2SYK5vRCGzJCqUqPPSvRn4u8RI1H8SSPheCBgTDncKR6a6fGEJBStI8/HqfrIBZ/OhP4O1tcShKx0EDK41B+rCkAd6evtgHGdmqFM5rTzAMObVFgjoEq9Cmc9RAPgB2rioEvWm4jRkUg+vz5QOFi272l6/Ug=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0401MB2240.eurprd04.prod.outlook.com
 (2603:10a6:800:29::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24; Thu, 15 Oct
 2020 17:02:06 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3455.030; Thu, 15 Oct 2020
 17:02:06 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
CC:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 15 (drivers/net/pcs/pcs-xpcs.o)
Thread-Topic: linux-next: Tree for Oct 15 (drivers/net/pcs/pcs-xpcs.o)
Thread-Index: AQHWowIM9GlE3TKOm0uVxOyhfasoWqmYw5AAgAAgOwA=
Date:   Thu, 15 Oct 2020 17:02:05 +0000
Message-ID: <20201015170204.bnnpgogczjiwntyc@skbuf>
References: <20201015182859.7359c7be@canb.auug.org.au>
 <e507b1ec-a3ae-0eaa-8fed-6c77427325c3@infradead.org>
 <BN6PR12MB17798590707177F08FD60653D3020@BN6PR12MB1779.namprd12.prod.outlook.com>
In-Reply-To: <BN6PR12MB17798590707177F08FD60653D3020@BN6PR12MB1779.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1d17b61b-8886-4111-0a57-08d8712c0b9a
x-ms-traffictypediagnostic: VI1PR0401MB2240:
x-microsoft-antispam-prvs: <VI1PR0401MB2240CED730460E40463F1141E0020@VI1PR0401MB2240.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XfJfQKgoHL0qj9Loo5ehW+ZDQQEaLDd5MAgI8osUnMFcVMllGHPurUwOxAc3uILk4GKV8q5uFrfkFI4vc0GL6lkRmdb9VkDzDrXorsLyzmFB8Z34WH2CE5Z9ZgzZfwcTQ2Okp0kCrXetzA48V8LjhGTYpaKk4U3tZHdVHf+s63nCEDUOh5yecGh6bDDCXkhXdvx1IbBkzrpdOUtW0d5fMoIZ+1szlfMVlvLkcB+elNP4srjY438/OXWWl79Ju22UDC/fjx/pj6mS2LHyYiF2uQycMR3rEE1Bb+3gQiSmDipCaIMwFWiYw2X7pzU1EMhu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(136003)(396003)(346002)(376002)(366004)(9686003)(186003)(8936002)(54906003)(71200400001)(8676002)(6512007)(3716004)(6486002)(44832011)(316002)(5660300002)(26005)(91956017)(76116006)(1076003)(86362001)(4326008)(6916009)(2906002)(66446008)(478600001)(66476007)(66946007)(6506007)(64756008)(53546011)(33716001)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: p8uLu7MdwbqsJg22Uyo5hpGpU6chNBtGwnqqs6bYYnVt/vfBLTefkNKJG50DfpQheDyyxAQ/YFn7vMEZ6ZoUsPEv2e91eqi00RuHmVwxwz0UrRL+MufTUykUQLHjxqsvOGRXlNBIE+TXwk3BNpOdJcXCFVLpOFpwlX64KRpba/pW3v8GCQMVmo/SL85Xq3xizU1b7IUMRhk4GCNpTaWsG2uz+WOB1guh+rxC2Sxa130PfnVHawtFNmFiZysxXYp+xPg1YhY3jTNk3DdO9GxIFmJxmIF1JBOjHgWGxEjCwoG+xV019g3v98d6UOQXnbMixx/nw6FPXKayV0ZsdaioUc9ctf2LtXnGi1fO7N44tkFHH/tRqjRxk3vwKOfPL7PK9GzXrYDpFK6pHsfqzT3fFtHkpZ6w4uNg+uF6I2l6F+tu8LUCjKKQqDE3CrMCqZm1u/KypgEPIZicHeu9oN70iP/FfBkCasP5/sMckXP5+vd/dUhTtcSHyncUXCbi2r9Kd54u+G4FpfZF8C9N2mIHZ8yarQNDuxy1yDeMj//VbA+FV+O5vF4rQVbSHtl/sXaZMwoUrBPwsszXZRsFaQnVBff9zk/VmZAYMEBM7XzlVzNRIbgbI8WiyQE6GdmNSyVZs40UcnIFi/L+d7xmhN2Cww==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA1085BC7DFE7F4A9C2F4A15BD3BFACB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d17b61b-8886-4111-0a57-08d8712c0b9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 17:02:05.7440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 06V+2cDfoAxqPM1wjrmVOO/YbHBQ/P1B95QTs15MDj4kubmuqSQxwh/IL/HPobOAG3tLswo0f7/tQ6HdUw6fcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2240
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 03:06:42PM +0000, Jose Abreu wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> Date: Oct/15/2020, 15:45:57 (UTC+00:00)
>=20
> > On 10/15/20 12:28 AM, Stephen Rothwell wrote:
> > > Hi all,
> > >=20
> > > Since the merge window is open, please do not add any v5.11 material =
to
> > > your linux-next included branches until after v5.10-rc1 has been rele=
ased.
> > >=20
> > > News: there will be no linux-next releases next Monday or Tuesday.
> > >=20
> > > Changes since 20201013:
> > >=20
> >=20
> > on i386:
> >=20
> > ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_read':
> > pcs-xpcs.c:(.text+0x29): undefined reference to `mdiobus_read'
> > ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_soft_reset.constprop.=
7':
> > pcs-xpcs.c:(.text+0x80): undefined reference to `mdiobus_write'
> > ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_config_aneg':
> > pcs-xpcs.c:(.text+0x318): undefined reference to `mdiobus_write'
> > ld: pcs-xpcs.c:(.text+0x38e): undefined reference to `mdiobus_write'
> > ld: pcs-xpcs.c:(.text+0x3eb): undefined reference to `mdiobus_write'
> > ld: pcs-xpcs.c:(.text+0x437): undefined reference to `mdiobus_write'
> > ld: drivers/net/pcs/pcs-xpcs.o:pcs-xpcs.c:(.text+0xb1e): more undefined=
 references to `mdiobus_write' follow
> >=20
> >=20

I think this stems from the fact that PHYLIB is configured as a module
which leads to MDIO_BUS being a module as well while the XPCS is still
built-in. What should happen in this configuration is that PCS_XPCS
should be forced to build as module. However, that select only acts in
the opposite way so we should turn it into a depends.

Is the below patch acceptable? If it is, I can submit it properly.

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 074fb3f5db18..22ba7b0b476d 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -7,8 +7,7 @@ menu "PCS device drivers"

 config PCS_XPCS
        tristate "Synopsys DesignWare XPCS controller"
-       select MDIO_BUS
-       depends on MDIO_DEVICE
+       depends on MDIO_DEVICE && MDIO_BUS
        help
          This module provides helper functions for Synopsys DesignWare XPC=
S
          controllers.

Ioana=
