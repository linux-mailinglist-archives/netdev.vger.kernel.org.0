Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EB628F823
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732868AbgJOSGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:06:16 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:35320
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbgJOSGP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 14:06:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5rifx6JClyvgaAeTtWkFKaDJT4zQTikQRxTBS56JYHQ0Bmh6VpQZ+kc2rMYCrml08VnMarRfGiIJdexUllYAjmblF/8DZbrjMh3/v8QfVpdqgNq4S9vCDXlkXEtdlWkUEEU+fCF3K2sGwbzk26MTNMzyi8QrCBpbnF8a9+DKCZdHSUA82aZDMb3LJAw7KOUAX6EZnO7W3QWSUvmiYdQ7kAdJoDaJNyhzZY3DJ/RPRfocVR7ML7GvYOv/XJg9V8NWT1NpOvT3YBfoMRlNc0x2OQwdaEPi7u6e3Nor8tIrs9F1w8yHGHD4zclPjedv9f2xappUWkGBf/E+ta27XzlVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqcV7VeeTk9jHjW/apRidEnMdSP9I4/5O01pePzYiFI=;
 b=XehROXVpy82BqKhs6l9qOCk6cJVtWE9EJApLeZGef1SrhADR4l1dIY64uVq4BImv+5ILAMdFOdhjvJQiQLQXV3lfBZz1iqsKqVgeTUVEq4faN7gTL/WL6VKE5n/EXv2KiLiQ0ocKJMw7mkfA83dlf2UPFGYWg7uVtTjb2j0Tm27iRS3NaK9RXVGRGoxrgEDaWAvBuBOYxkHuyfF8UlqrIo9R1pHErUlv+z8nnyB95vFFMJX2HPztuibe0WxMVhXdiamU+Ioei5wsbib01KsbdGnrLLDJq2Cq6Udc8FjTcT9zr0LI41EM0tq42L1PhMiIX+B5gP7LehvyzBLy0XoRTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqcV7VeeTk9jHjW/apRidEnMdSP9I4/5O01pePzYiFI=;
 b=T0BMjz1tNedYfqg90SxfPBr4ERMqDrBP6KBC6Gq+gZG3X0kZ1rtxdr6qgH6PbAphqAhk4ExZXhys2tSuTmellfqhJkRebUtdMHuebSzrmBycd2hk1kCcxOQT9xiyTsT2MSg5NCnac6CHN29RkGfuBTFcO6uHnnGbt9ay2ILArJU=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4029.eurprd04.prod.outlook.com
 (2603:10a6:803:40::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Thu, 15 Oct
 2020 18:06:08 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3455.030; Thu, 15 Oct 2020
 18:06:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Randy Dunlap <rdunlap@infradead.org>
CC:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 15 (drivers/net/pcs/pcs-xpcs.o)
Thread-Topic: linux-next: Tree for Oct 15 (drivers/net/pcs/pcs-xpcs.o)
Thread-Index: AQHWowIM9GlE3TKOm0uVxOyhfasoWqmYw5AAgAAgOwCAAA0YAIAABM6A
Date:   Thu, 15 Oct 2020 18:06:08 +0000
Message-ID: <20201015180607.xtackyvta7nsiwzh@skbuf>
References: <20201015182859.7359c7be@canb.auug.org.au>
 <e507b1ec-a3ae-0eaa-8fed-6c77427325c3@infradead.org>
 <BN6PR12MB17798590707177F08FD60653D3020@BN6PR12MB1779.namprd12.prod.outlook.com>
 <20201015170204.bnnpgogczjiwntyc@skbuf>
 <3418cac1-eff7-d06a-6ba7-9877f0f266e9@infradead.org>
In-Reply-To: <3418cac1-eff7-d06a-6ba7-9877f0f266e9@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 079e671d-9ce3-49b3-3d66-08d87134fdc7
x-ms-traffictypediagnostic: VI1PR04MB4029:
x-microsoft-antispam-prvs: <VI1PR04MB4029AF5E398D79D34175B0B4E0020@VI1PR04MB4029.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7J590Kj2I8/Z/SKY2931HTkTpenHNu7HppirRxCM1Hfz1cap7BaQtBk3Xco2kSPLuWjA+2NBpR1S9TTL4AJhH+4rVU73wfYQBMEzDPH92x8dX1fZ24XqVd1WPcnmciuYWF76dIo3dKKmAvEaCa0v4yoXkwtQlZ3qWcTQNeqM69vNsI8/7k86VHfdSUr9dIc7qlXrd+YrO3Dgjo066Cj5fXm61z7y6aT5bzyuc+BfGZ9n+DBAD2mhJjKuVoMh84DntcSO0UT3NZTsanVcmgRzPFAiVtYbuab83f2D6jW2be9bwRvvKRrHuVDaab7wMpYB9Igqh0nbPnieuJS0hqahsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(71200400001)(1076003)(6916009)(33716001)(186003)(5660300002)(44832011)(8676002)(316002)(2906002)(54906003)(8936002)(91956017)(66946007)(4326008)(478600001)(86362001)(6512007)(9686003)(26005)(6486002)(64756008)(66476007)(66556008)(76116006)(66446008)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZDNUhFuvGVQwnZlpFQ4aTu7XTJuMZtUUJX1oAOMJrjg7geLHn5RjisqLT+qcnQy4w5NMY4QYdMEo68FXhbvw8ZwmAUdhObuX1heDQP4e35sAAHYmnfAxmj6ZYEgyUyJ4cBwUDSYpw5jwEUtDBBQwRXMC8uRlJV+7pBpyZILljVPMB+S/1O3Rmd/35YV0/VDM4JF+KdWtqedm+iAcMH1hAfiO5t8pOly8MJ7q5CYb/KysSHBsMkdporz1CNcElg33LNZx4pno212RfjQ6XvEeiPyu4FBb3AE6sgveXs68IedmIIynAE2HFLDztviO+niwfTiin9m4kuOFn0cZJcPzusZXFRDfGApmuuB4Rr9H051z7RrXvH64z0ws+ZLCj8pfMgEophR6Z8DvUAC5behKQ65mIfK+hFVOR2Hb/hAU1wrct3ongky6m11xc8fLULm6rSJWKaR7EIFoJqDK3Rk43eIF4GCZMi4haea0dhzR4KP4KQY2ocP7N7BIemAJ7g2+Q2/SpyUv/b2gQraTK7VEIAnCicIo2vl7Hh1n0EYSSBUogtatmCfhKkHshEhb9HdNrM/SsxobHYehqeWgT8i5JRP2YBsTkYtWwQTiASf0jAdQnWcIGYRjAu/YtHYhiOcmJBt2scf61MiUhschaLdBJg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C7AF28C101C3442B233B720E25CC119@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 079e671d-9ce3-49b3-3d66-08d87134fdc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 18:06:08.1716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ArIP59zNRMqPkHcUTxGiZpYYH5v/ogElzbL4XLiWNZtkiAWBxZqirMfnD+bXMJOVnqwsuFgxWy/WgGeKeKw/gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4029
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 10:48:56AM -0700, Randy Dunlap wrote:
> On 10/15/20 10:02 AM, Ioana Ciornei wrote:
> > On Thu, Oct 15, 2020 at 03:06:42PM +0000, Jose Abreu wrote:
> >> From: Randy Dunlap <rdunlap@infradead.org>
> >> Date: Oct/15/2020, 15:45:57 (UTC+00:00)
> >>
> >>> On 10/15/20 12:28 AM, Stephen Rothwell wrote:
> >>>> Hi all,
> >>>>
> >>>> Since the merge window is open, please do not add any v5.11 material=
 to
> >>>> your linux-next included branches until after v5.10-rc1 has been rel=
eased.
> >>>>
> >>>> News: there will be no linux-next releases next Monday or Tuesday.
> >>>>
> >>>> Changes since 20201013:
> >>>>
> >>>
> >>> on i386:
> >>>
> >>> ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_read':
> >>> pcs-xpcs.c:(.text+0x29): undefined reference to `mdiobus_read'
> >>> ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_soft_reset.constpro=
p.7':
> >>> pcs-xpcs.c:(.text+0x80): undefined reference to `mdiobus_write'
> >>> ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_config_aneg':
> >>> pcs-xpcs.c:(.text+0x318): undefined reference to `mdiobus_write'
> >>> ld: pcs-xpcs.c:(.text+0x38e): undefined reference to `mdiobus_write'
> >>> ld: pcs-xpcs.c:(.text+0x3eb): undefined reference to `mdiobus_write'
> >>> ld: pcs-xpcs.c:(.text+0x437): undefined reference to `mdiobus_write'
> >>> ld: drivers/net/pcs/pcs-xpcs.o:pcs-xpcs.c:(.text+0xb1e): more undefin=
ed references to `mdiobus_write' follow
> >>>
> >>>
> >=20
> > I think this stems from the fact that PHYLIB is configured as a module
> > which leads to MDIO_BUS being a module as well while the XPCS is still
> > built-in. What should happen in this configuration is that PCS_XPCS
> > should be forced to build as module. However, that select only acts in
> > the opposite way so we should turn it into a depends.
> >=20
> > Is the below patch acceptable? If it is, I can submit it properly.
>=20
> Hi,
> Did you copy-paste this patch?  It contains spaces instead of tabs
> so it doesn't apply cleanly/easily, but I managed to apply and test it, s=
o
>=20

Yes, it was a quick copy-paste. Sorry for the trouble.

> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
>=20

Thanks.

Ioana=
