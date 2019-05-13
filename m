Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DD91AF10
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 05:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfEMDGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 23:06:49 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:49678
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727167AbfEMDGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 May 2019 23:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQklZkTn1qk+A3qOyh4BE+f6SZxaT3EsAdJPACGKm0o=;
 b=DnwW9g45ItatzzXaZ4Bb6OY3mN+2yj+RoXALhDno9hJ/2AIYrSgG67jDdl4TA7fULwKijDbTuNCQh3WzPcsx45OvB8m/RoTcRqf73UYdVtn1V3PuR9Qmw/m//cc0dUZcwzaw/VZeG4XOZofoXQ0MOPrUyfDXvuUHBQ3xvWkL7zY=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3424.eurprd04.prod.outlook.com (52.134.3.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Mon, 13 May 2019 03:06:41 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df%6]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 03:06:41 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     =?iso-8859-2?Q?Petr_=A9tetiar?= <ynezz@true.cz>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net 0/3] add property "nvmem_macaddr_swap" to
 swap macaddr bytes order
Thread-Topic: [EXT] Re: [PATCH net 0/3] add property "nvmem_macaddr_swap" to
 swap macaddr bytes order
Thread-Index: AQHVByN8cgfDehywt06hQvfjje4vh6ZkQYgg
Date:   Mon, 13 May 2019 03:06:41 +0000
Message-ID: <VI1PR0402MB360000EE60A8EE25534D7333FF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz>
In-Reply-To: <20190510112822.GT81826@meh.true.cz>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 017e0c74-f689-42ed-ee44-08d6d7500620
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3424;
x-ms-traffictypediagnostic: VI1PR0402MB3424:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0402MB3424F294C98DBE7348D557A4FF0F0@VI1PR0402MB3424.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(66066001)(86362001)(6246003)(71200400001)(71190400001)(76176011)(6506007)(53936002)(74316002)(966005)(14454004)(68736007)(45080400002)(478600001)(5660300002)(54906003)(7696005)(66574012)(99286004)(4326008)(102836004)(7416002)(33656002)(66476007)(66556008)(64756008)(66446008)(26005)(66946007)(446003)(76116006)(73956011)(486006)(476003)(11346002)(25786009)(316002)(8936002)(6916009)(186003)(7736002)(52536014)(14444005)(256004)(81156014)(81166006)(2906002)(229853002)(55016002)(8676002)(6436002)(3846002)(6116002)(305945005)(9686003)(6306002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3424;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m7RTAw2+sTyqzEQmTDUl+i5yWkD54KYmbxq8QoUn8qBxUUl3vP8vW7PCl25U8vgy5a2M83hgyCJGJzoQsCIEXrrdz1lxMqiGfgCefvq6vg8P1l3/o2RLe5NGRoVMwEpL2dF4uR53uSa6CWQNzGsEcTReZVTL9BGYJGWBrbGOU0WMqB5KFrBPyPVk19sgLR+wOThAB7zB1qIlv4wr2r8as8kaheee3TqqflDpbQJjkJMGJthTkJnZ7wj6DI3fMKdO3BV+Ia0JhUuLrEmyi71X5lrHFSRkM5q5P1gHdK21ViCkFlhzrvbBQ+mMVPeUZ375S5yVBfr0xKpKLFiRFTrN2irnKSlmnmHOxWcjmdXCuQhZj4bSr7Urjgf8VKWZJCyZtSZpcB8jWlvSvLryf5tm4fibgQdox0wr9/vBbgeO03w=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 017e0c74-f689-42ed-ee44-08d6d7500620
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 03:06:41.8359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr =A9tetiar <ynezz@true.cz> Sent: Friday, May 10, 2019 7:28 PM
> Andy Duan <fugang.duan@nxp.com> [2019-05-10 08:23:58]:
>=20
> Hi Andy,
>=20
> you've probably forget to Cc some maintainers and mailing lists, so I'm a=
dding
> them now to the Cc loop. This patch series should be posted against net-n=
ext
> tree as per netdev FAQ[0], but you've to wait little bit as net-next is c=
urrently
> closed for the new submissions and you would need to resend it anyway.
>=20
> 0.
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.
> kernel.org%2Fdoc%2Fhtml%2Flatest%2Fnetworking%2Fnetdev-FAQ.html&am
> p;data=3D02%7C01%7Cfugang.duan%40nxp.com%7Cdc1bcd43f3bd41701eed08
> d6d53a9dee%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C63693
> 0845065526608&amp;sdata=3DQQItI08aTcR%2Bl4k%2FCqPCEPwT9o4GfzpZSM
> gf37ollWc%3D&amp;reserved=3D0

Thanks for your reminder.  ^_^
>=20
> > ethernet controller driver call .of_get_mac_address() to get the mac
> > address from devictree tree, if these properties are not present, then
> > try to read from nvmem. i.MX6x/7D/8MQ/8MM platforms ethernet MAC
> > address read from nvmem ocotp eFuses, but it requires to swap the six
> > bytes order.
>=20
> Thanks for bringing up this topic, as I would like to extend the function=
ality as
> well, but I'm still unsure how to tackle this and where, so I'll (ab)use =
this
> opportunity to bring other use cases I would like to cover in the future,=
 so we
> could better understand the needs.
>=20
> This reverse byte order format/layout is one of a few other storage forma=
ts
> currently used by vendors, some other (creative) vendors are currently
> providing MAC addresses in NVMEMs as ASCII text in following two formats
> (hexdump -C /dev/mtdX):
>=20
>  a) 0090FEC9CBE5 - MAC address stored as ASCII without colon between
> octets
>=20
>   00000090  57 2e 4c 41 4e 2e 4d 41  43 2e 41 64 64 72 65 73
> |W.LAN.MAC.Addres|
>   000000a0  73 3d 30 30 39 30 46 45  43 39 43 42 45 35 00 48
> |s=3D0090FEC9CBE5.H|
>   000000b0  57 2e 4c 41 4e 2e 32 47  2e 30 2e 4d 41 43 2e 41
> |W.LAN.2G.0.MAC.A|
>=20
>   (From
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.
> com%2Fopenwrt%2Fopenwrt%2Fpull%2F1448%23issuecomment-442476695
> &amp;data=3D02%7C01%7Cfugang.duan%40nxp.com%7Cdc1bcd43f3bd41701e
> ed08d6d53a9dee%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6
> 36930845065526608&amp;sdata=3DVGzzDGMRrt6f%2FHZE%2BX4%2FieOkMQ
> EBC%2BiKNgKpu9Loltk%3D&amp;reserved=3D0)
>=20
>  b) D4:EE:07:33:6C:20 - MAC address stored as ASCII with colon between
> octets
>=20
>   00000180  66 61 63 5f 6d 61 63 20  3d 20 44 34 3a 45 45 3a  |fac_mac
> =3D D4:EE:|
>   00000190  30 37 3a 33 33 3a 36 43  3a 32 30 0a 42 44 49 4e
> |07:33:6C:20.BDIN|
>=20
>   (From
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.
> com%2Fopenwrt%2Fopenwrt%2Fpull%2F1906%23issuecomment-483881911
> &amp;data=3D02%7C01%7Cfugang.duan%40nxp.com%7Cdc1bcd43f3bd41701e
> ed08d6d53a9dee%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6
> 36930845065526608&amp;sdata=3Dy5%2F4e6tuEub%2Fj9fqOQXM3as%2BbKA
> vw6O3VY9oPE1qinU%3D&amp;reserved=3D0)
>=20
> > The patch set is to add property "nvmem_macaddr_swap" to swap macaddr
> > bytes order.
>=20
> so it would allow following DT construct (simplified):
>=20
>  &eth0 {
>         nvmem-cells =3D <&eth0_addr>;
>         nvmem-cell-names =3D "mac-address";
>         nvmem_macaddr_swap;
>  };
>=20
> I'm not sure about the `nvmem_macaddr_swap` property name, as currently
> there are no other properties with underscores, so it should be probably
> named as `nvmem-macaddr-swap`. DT specs permits use of the underscores,
> but the estabilished convention is probably prefered.
>=20
Yes, `nvmem-macaddr-swap` like is better.
It just to let i.MX series platform nvmem work for of_get_mac_address.

Not consider others' use cases like blew your mentioned since I am not fami=
liar with
others platforms. Your consider a more comprehensive cases, it is great.

> In order to cover all above mentioned use cases, it would make more sense=
 to
> add a description of the MAC address layout to the DT and use this
> information to properly postprocess the NVMEM content into usable MAC
> address?
>=20
> Something like this?
>=20
>  - nvmem-cells: phandle, reference to an nvmem node for the MAC address
>  - nvmem-cell-names: string, should be "mac-address" if nvmem is to be us=
ed
>  - nvmem-mac-address-layout: string, specifies MAC address storage layout=
.
>    Supported values are: "binary", "binary-swapped", "ascii",
> "ascii-delimited".
>    "binary" is the default.
>=20
> Or perhaps something like this?
>=20
>  - nvmem-cells: phandle, reference to an nvmem node for the MAC address
>  - nvmem-cell-names: string, should be any of the supported values.
>    Supported values are: "mac-address", "mac-address-swapped",
>    "mac-address-ascii", "mac-address-ascii-delimited".
>=20
> I'm more inclined towards the first proposed solution, as I would like to
> propose MAC address octet incrementation feature in the future, so it wou=
ld
> become:
>=20
>  - nvmem-cells: phandle, reference to an nvmem node for the MAC address
>  - nvmem-cell-names: string, should be "mac-address" if nvmem is to be us=
ed
>  - nvmem-mac-address-layout: string, specifies MAC address storage layout=
.
>    Supported values are: "binary", "binary-swapped", "ascii",
> "ascii-delimited".
>    "binary" is the default.
>  - nvmem-mac-address-increment: number, value by which should be
>    incremented MAC address octet, could be negative value as well.
>  - nvmem-mac-address-increment-octet: number, valid values 0-5, default i=
s
> 5.
>    Specifies MAC address octet used for `nvmem-mac-address-increment`.
>=20
> What do you think?
The last one is better.

>=20
> Cheers,
>=20
> Petr
