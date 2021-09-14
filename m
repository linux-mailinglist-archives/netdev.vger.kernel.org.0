Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA4F40AD01
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhINMHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:07:41 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:17361
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232341AbhINMHj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:07:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxEO5uHLPlxGKUAB7p3OmrVRNs9hOMsaBc5q+Cc/R1y0VGj9tJ/Jz+0Tmg1c4D8L4W1U8/xcIXNB035AFOFkn8cYfOsfQ5DTiLtjqkewiPXCUbETx8XR8wrou/3uf4+7Qq7L/Qg23A+t501TrC7lHfFIOMG1NyK0zy73zB4DudzRDkmKrUQyhjZD3gso4WAkO569a9zYHF0MMVafmq1nHGJjQpal6IcY4JYLSKCOeMsAPJxGNL9jXd4b61KczJsfD9vwgXKtCG17YgvNMTx10dQGlIy0AxvbN3SlsMKya36oGjouL7Od528DZEVT0APmPng2NCCb3kTDjTLA26t/OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uYNTFaoqHRQrx3H/tUIwmHC6pPVOFszs7C+und0GUQc=;
 b=WDPSUKoXvcblhm471SOKm/KKFnFx0/qVDirKxS5jTtUcmwfRs26yMV2iYglDNGqxatksZ0oDnEvRUoqq5kCUtrdeQDFWIe0Tc3/rgXx4KC2o2949qHKLJr0M2sxiqK+SFBQBQMetsw/RVisLbO5K36hJwampAbFkQMTO+70zGTKpeGiUHJ0apojogrFpLq+n120dsQieq8HNRB3nF41wXOdHHzawkKX4S7LLJkoIVOdwkUXT5jUHL1INGA3RWygNkv7sq4jaohuKJSfO/RTF49N2WLJTWE9aoVSKGAja5clEls0VvNh4NA9NzMgjzT9TsE6mDaXhB4SywIOELoXBqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYNTFaoqHRQrx3H/tUIwmHC6pPVOFszs7C+und0GUQc=;
 b=gkWUG0ALBY4fRUGDyjNDf4b6KHUqAM/tHwQ4qy4q6yn8Z/jpsx8Go5ASjQMaaFZCWoJvZskqP7HEchEEvfSdndJVX2a8ca60rUGM543+RY6UL0t3b1zbj3P3lTvaUjjf+JfZImPeRLw0XgvrbWr6+JjJ04PM7QCXq/4Kdl5Dr6c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 14 Sep
 2021 12:06:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 12:06:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Thread-Topic: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Thread-Index: AQHXqAxVhGZiRJqQ+0q4p0VsyQZ526ug3z6AgAAN1YCAAWLygIABIbqA
Date:   Tue, 14 Sep 2021 12:06:18 +0000
Message-ID: <20210914120617.iaqaukal3riridew@skbuf>
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
 <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
 <20210912213855.kxoyfqdyxktax6d3@skbuf> <YT+dL1R/DTVBWQ7D@lunn.ch>
In-Reply-To: <YT+dL1R/DTVBWQ7D@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b81da60-9c70-4140-a4c1-08d977780f63
x-ms-traffictypediagnostic: VI1PR04MB5854:
x-microsoft-antispam-prvs: <VI1PR04MB585420DEABB03C4BDC3D8452E0DA9@VI1PR04MB5854.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 566PFE1KVl51w6+KZ441DTfssoHOTO1mAPFhsDoXGjE0U4t1G9dES5y7LazzGYdrnxA0sNzjhEt/RVZaQQ2d+EoaU3ADfd6cTlygJJlxbJElDqw9Q4tuzMdWlXRXMk2beQvZYY9hBNK7CMIS/27Xojt6C9Eey0HiVNqN4jo4JHA3zNLUyx8yGStMiCMJpzcroUrCrCOJb2KWwXHCaG14RGvKsV6US+3pbAnMXickVTx/oNBvh/gL7QtPkksyPArcWsUbynxFjeRJ7n5+uVHaIOSWY329vYl7eK85floQlBfXSqKylwSKTxkX6jPUulhOxZkgFt5ZQkwbtt+QgH9YsCsCvzy2Pv4M9T2PkQSE+2xqT8ibzq9XEto3LH3PNNfuj7k25293OAGcJ9WBp+5cxRQrZ/tK7Y0k4VLJnqnM4n+ZUOLyPcj5Txu4vHCzjPJimnZj6pwpQDnGgYMqsUWIfo4S7VG9/+PJsFK+rFlYzxQlSYUgUyiWbGsMDClKjDGvuFsyR38NoxBEMpAtGMErZwcDwPbVHDpogmylANRGxjKbPzVqzH7VgaNjrx33thVMPJcP8qXQb4Txpw97uG/1TRXLfzOj52l+58xQibNfOx55xSFAGBIITk7r1MKdCAWKwNHZej5ZTMdjalTp9FelIhRm2p9MFc7LQ7SKLfQXKTlla8hGJzDcwzwgXArKwGgcn2BQS/HhSkGUXoDbbUIuTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(376002)(39850400004)(346002)(136003)(366004)(316002)(4326008)(6506007)(86362001)(64756008)(6512007)(83380400001)(26005)(44832011)(8936002)(5660300002)(478600001)(38100700002)(54906003)(66556008)(1076003)(66476007)(9686003)(33716001)(8676002)(76116006)(71200400001)(2906002)(66446008)(91956017)(38070700005)(66946007)(186003)(122000001)(6486002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q2/5k3lBJGYot90EkeMP6WxtHrGdcCXEt5AESC9iPKp0jXCMqpXaJ3LdGfO0?=
 =?us-ascii?Q?u62lUaDcLuhVXAJ3g72kictgKZDZt8CmUtGKdET0NLolgiW9RMjrbZDYMTKB?=
 =?us-ascii?Q?kOjtiMSlJgyVdPkUhqAXlo0c8wIhSs8GdT5w5UURilinG8Eq3TsTEneYFoJT?=
 =?us-ascii?Q?Pf429XtpxmhNpjPzEoRcgiXy58v6J/VQ1NovQm6ayHxgs+Q+8nDECpv/YbCd?=
 =?us-ascii?Q?/7fWZoi94XxnsvuFJuMu1NlASzSN6UVQbMD/16AKtWvplqqSmXc6ceDuKJow?=
 =?us-ascii?Q?kBObLPHiQftuDJMyFsQeHVUXrXztHs2wbKYzWfwLV13151fPXA0C+Mpct8ju?=
 =?us-ascii?Q?6q52Ac2K4IzI98bP7m/PwSBkBp8PkHH1AxDaK5/9GB3VCNY1ZBQNjyhoMOUO?=
 =?us-ascii?Q?KoK/VfbdoGXHzP1sKh2fzm9Q9i2mVv4/6LVVoBijDSL8QYqdDHu6nVj2zYkR?=
 =?us-ascii?Q?sOcdVMK+g+BrBloiannK748IwxsO56WrQikO5lxLYPPFRE3kU/pU0arDq/gu?=
 =?us-ascii?Q?vGg98BSD+1ZxU4g5WScdCdXXdbzm6owdBD97ahDRdIfP4l5/fRI5DOsFM6LX?=
 =?us-ascii?Q?2r2DQCesLQhaUeq1SGRo1xYDjqssAbzLwG9sS2n7cNHqcLCP6InnQaITYtF0?=
 =?us-ascii?Q?aJwKA0Xwh44agB7lmOuEbHGcMEFHI4844dk7OcZcTHHjLtBURJi/74xUrD1m?=
 =?us-ascii?Q?maBtVgfZwJk6MKWVTRuv6pinGKBl/hx4gZldGh8JCCgCOs+mTygAcH2AXjwL?=
 =?us-ascii?Q?1uwgDg4iUKDL1QnWq6mHsJ1Iuo4QRHduqzyjhysUMPERKhWXbkCmgszVssje?=
 =?us-ascii?Q?xCVmnlD7e/Rny06GgHT59koaOJY7UVyK61/UGLL1lWQij4y4VZqf3mPDcghx?=
 =?us-ascii?Q?T65eJaLYY0mHfHJqhf5w8MC21gkL3+CvDZgnSIZvQ62jndt70lavZvrqPsVA?=
 =?us-ascii?Q?u3Mvz/WyYG1XZKio/cSPeT4WVVW6/2Z1FR7h7lczSw6QTQ8XPlTiCtnGA69a?=
 =?us-ascii?Q?oOdscWT0ZLonomjKnvDzMX4qXm2gfhffe7l1mvYwwKIw4s+Nc74BwzSBoSqZ?=
 =?us-ascii?Q?n/eX7ItjCoCoSdjkhH6aZCGas3YX2Zniz6W9G7KjmAzltQ3a0b3M5S2058Fg?=
 =?us-ascii?Q?ezbiIAMR4Pmg44nTlgizAaVM7fTKLM3ZkQs368BhS+qFeJCr2UpFIGX7Ujt0?=
 =?us-ascii?Q?W9vpaAXGsEcIkDi0d4fdakIoPcn4DOtPc+E1RYmOS1x5b/FxlHwPfQ2nnc2k?=
 =?us-ascii?Q?eRruADvKZOiYjzFs4OCcO3hluLEaZGxPWVlvbS8p74ZsB7DqNY2J5ljUNJsU?=
 =?us-ascii?Q?1vlrYBkjzu8mzuH0a2naUu1T?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C2485A67104AA640A2D153EAC3F8E78C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b81da60-9c70-4140-a4c1-08d977780f63
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 12:06:18.6445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UJxO++TWZT+ygKn+3MzJKeQ/3j+NpinFMvBdOYdW6F3UoY+ZhzvxqJhVQkvt59U4xBpzuQ1l8JwMpXGKI5eS1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 08:49:19PM +0200, Andrew Lunn wrote:
> > I am not sure why "to_phy_driver" needs cleanup. Au contraire, I think
> > the PHY library's usage of struct phy_device :: drv is what is strange
> > and potentially buggy, it is the only subsystem I know of that keeps it=
s
> > own driver pointer rather than looking at struct device :: driver.
>=20
> There is one odd driver in the mix. Take a look at xilinx_gmii2rgmii.c.
>=20
> It probably could be done a better way, but that is what we have.

Interesting, to say the least. Also, is there any connection between
that and the revert I'm proposing?

So compared to other vendors, where the RGMII gasket is part of the MAC
device, with Xilinx Zynq it is accessible via MDIO?

This is not all that different from dpaa2-eth and dpaa2-mac which are
different devices on the bus, with different drivers, and the phy-handle
is present on the dpaa2-mac OF node, but the net_device is registered by
the dpaa2-eth device, is it? It seems to be even simpler in fact,
because the dpaa2-mac and dpaa2-eth can even connect/disconnect from
each other at runtime, something which does not appear possible with the
Xilinx MAC and its RGMII gasket.

What was done in that case was that all drivers which could possibly
connect to the DPMAC would need to call dpaa2_mac_connect(), this is
done currently from dpaa2-eth and dpaa2-switch.

It looks like it is said that this GMII2RGMII converter can be placed in
front of any GMII MAC. Nice that there are zero in-tree users of
"xlnx,gmii-to-rgmii-1.0" so that I could figure out exactly how that
plays out in practice. If it is only a few drivers that use the
GMII2RGMII converter, maybe something like that (export a few symbols
from this driver, make all MAC drivers call them) could take less of a
toll on the overall PHY library architecture.

Note that the usage of priv->phy_dev, priv->phy_drv, priv->conv_phy_drv
beats me. Why is "phy_dev" kept inside "priv" even though it is accessed
only inside xgmiitorgmii_probe? Why does xgmiitorgmii_configure() need to
be called from xgmiitorgmii_read_status() which in turn hooks into the
attached PHY driver's phy_read_status()? Why does xgmiitorgmii_configure
not get exported and called from an .adjust_link method or the phylink
equivalent, like any other MAC-side hardware linked with the PHY library
in the kernel?=
