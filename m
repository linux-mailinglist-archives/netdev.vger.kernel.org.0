Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314FF1F50F5
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 11:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgFJJK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 05:10:28 -0400
Received: from mail-eopbgr130075.outbound.protection.outlook.com ([40.107.13.75]:24726
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726981AbgFJJK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 05:10:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZF8fzQpA2hdM+4Ll/YuRqoqOH75szanXMjxrs9Avks8g7jJQY/MKdX+elcfwhPWHOJM+PCJAiW4MmalwSXeGNhJRKaSIUKYCyxotPoKApW/Utui/VYo0OgXIZafe+qDvVj12ffNJpJHE2o+NQ+mUsDwyuvQ+GrVljUT1NZjq3R8JQPO0gPPuI9UXAma0OwXFFxObE3lAA60RfSUN7nQKUzmscMFfIZ28l9x3iYDgHcCll5E6C8FMasOwsBIif201hUhG4ApOGzdmf8pNn5DC3cmUpNAJJNWLv7dCR5bXkyi3JjVbIqzvglhd02WcsFXkFRpouR5XNDOH2AQMhTAqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5uZgytsx82UbIhBvSI52gSmxCjxIDZZeS+GdXafOqU=;
 b=dP9TcMQJkqQESvbB7sm8hPIZ004QOyVyghQ7hQzLXAkCYCkoy/giAegHE3aMNoylgtweR8H6ZyIY/AFXX6d+T/SJ9h5qx8LZA0oxSFQx6K/g3Awnum/tA6BQO4Wp/1hNrnrrsjHC5k4uYWdFRbYHaTF+EGq3LoRmM+MvCpyayaMPwk55wih9DfDGNHRdmRZOlph57AJbfaHIAzoatJ/qrY1b+ZDw0w/JfpaJaC0GMwPU0J4o5w03JQzQaD7bEPXTISh1Qcs1RwdtRHSXQMqtDQfpMljJ9F1HJTFT3XVTPmQ3vdwJ5PelghH/whRyde9gWq4YB/2fbZr18ViqLh0EAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5uZgytsx82UbIhBvSI52gSmxCjxIDZZeS+GdXafOqU=;
 b=cCwkWbaQWmGGgDWe+S7lsclvBcE7V89AF6aNCH4FNoU6jFv5RGzuvid5UKa4e0DvhV01qXC4xCqF1E7JvKBM7Fd7x2FGe074Jcedku7jauhJdBLg4jGlcQYmU8WlodKJutqLBFy5Rom1OiIWoZARYIlWsaJ6QzZqT0QKRx6QlCY=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2864.eurprd04.prod.outlook.com
 (2603:10a6:800:b7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Wed, 10 Jun
 2020 09:10:24 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3088.018; Wed, 10 Jun 2020
 09:10:24 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Helmut Grohne <helmut.grohne@intenta.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
Thread-Topic: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
Thread-Index: AQHWPv+rJSUSn7JYpECgg8rsrkvkYajRio+w
Date:   Wed, 10 Jun 2020 09:10:23 +0000
Message-ID: <VI1PR0402MB3871F98C656BF1A0A599CA59E0830@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200610081236.GA31659@laureti-dev>
In-Reply-To: <20200610081236.GA31659@laureti-dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intenta.de; dkim=none (message not signed)
 header.d=none;intenta.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bd81d88c-d94d-466f-a39e-08d80d1e1bdd
x-ms-traffictypediagnostic: VI1PR0402MB2864:
x-microsoft-antispam-prvs: <VI1PR0402MB2864462A9DE0FC812D4422BFE0830@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0430FA5CB7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u30POUQSNCpyOFoFh9LT9hmx6CLP28qDKRmJbhMi0tOptvZJlCTbtexcfgoRxt0iewbBP7Om/9nZkRuOFRiWN4Y84A9w2m/f1aXJk4YtClz2I3L5cP2A1/8X+WbWSHGangk8rHQOlVWtoeJcg/Jy8eI8z73o1Cm41cypgayCY+h7H7U027JJJClGlqIX5k5hqOp1Hl3UCFaqvszZ06/WSNbk8c6P+DdgFHwr0+QwmthXMBlmjRKk6IBMXrO9QICURibWEOUpOgQP8asDfQiV1fw/xbD69KjEGrVNw1Zb2ZtatfeiHXQEFGpMR0S4+iO7orX+jTnHkhARkRzca5RnlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(316002)(66446008)(8936002)(7696005)(64756008)(33656002)(9686003)(66946007)(52536014)(76116006)(5660300002)(8676002)(55016002)(66556008)(66476007)(110136005)(26005)(86362001)(44832011)(71200400001)(2906002)(83380400001)(6506007)(186003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9Wdy7mwgzR24thdfxF9vH6NUgaH7W7+++b8AFFKR/20u2jBcRvLfZIYEV6xzumceEZBDfXG1qNh07PXI/Uhm/XfyBmgJZ/fJab3o7xXPIvdTqeeBTQI2uMx/0O8YAVNvPcxnx7ZcOVvScF1L4WI55Pp4IehG70dCj9Ei2wuInxeczeckj59GDx7uJlpP8YFdhsZODclmqldgO+k7ODDZa3/FvzRqGR4N3fInw9mkLqsHwXiKo6JumWlaa4bCDnScQTJOonL3tlSfVNayItmUj29Xc/T1wPOXwi1lkx98bU4mtF3FKK7d+cZPfZ+brZYT/TI8VAuNS3DZhpx1JnFufC7Pqh6pA8IZyw8HHW6rolBokLlTwuS3hlzvZLli7uq2wzyxo12cxAQskQAxiZ2sIw4A976pXGHDT89o9HJ5fZjSlrIgtRBJZ4kReRojmg+nZFBEuCDXsFzIMuc77GuFjrCFhhcrIY4POT0kTcd/z0I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd81d88c-d94d-466f-a39e-08d80d1e1bdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2020 09:10:23.9665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g8UY+0jOfyi41B2HAG23DHjVYSbWVF9IqvOqsx8eU7xlk7uTVnLPvcqp74jLr3KRu4Zu0uO2IRw9XPOJls0ygw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Helmut,

> Subject: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
>=20
> Hi,
>=20
> I've been trying to write a dt for a board and got quite confused about t=
he
> RGMII delays. That's why I looked into it and got even more confused by w=
hat I
> found. Different drivers handle this quite differently. Let me summarize.
>=20
> Some drivers handle the RGMII modes individually. This is how I expected =
it to
> be. Examples:
> * renesas/ravb_main.c
> * stmicro/stmmac/dwmac-rk.c
>=20
> A number of drivers handle all RGMII modes in uniformly. They don't actua=
lly
> configure any dealys. Is that supposed to work?  Examples:
> * apm/xgene/xgene_enet_main.c
> * aurora/nb8800.c
> * cadence/macb_main.c
> * freescale/fman/fman_memac.c
> * freescale/ucc_geth.c
> * ibm/emac/rgmii.c
> * renesas/sh_eth.c
> * socionext/sni_ave.c
> * stmicro/stmmac/dwmac-stm32.c
>=20
> freescale/dpaa2/dpaa2-mac.c is interesting. It checks whether any rgmii m=
ode
> other than PHY_INTERFACE_MODE_RGMII is used and complains that delays are
> not supported in that case. The above comment says that the MAC does not
> support adding delays. It seems that in that case, the only working mode =
should
> be PHY_INTERFACE_MODE_RGMII_ID rather than
> PHY_INTERFACE_MODE_RGMII. Is the code mixed up or my understanding?
>=20

The snippet that you are referring to is copied below for quick reference:

/* The MAC does not have the capability to add RGMII delays so
 * error out if the interface mode requests them and there is no PHY
 * to act upon them
 */
if (of_phy_is_fixed_link(dpmac_node) &&
    (mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
     mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
     mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)) {
	netdev_err(net_dev, "RGMII delay not supported\n");

The important part which you seem to be missing is that a functional RGMII =
link can
have the delays inserted by the PHY, the MAC or by PCB traces (in this exac=
t order
of preference). Here we check for any RGMII interface mode that
requests delays to be added when the interface is in fixed link mode
(using of_phy_is_fixed_link()), thus there is no PHY to act upon them.
This restriction, as the comment says, comes from the fact that the MAC
is not able to add RGMII delays.

When we are dealing with a fixed link, the only solution for DPAA2 is to us=
e plain
PHY_INTERFACE_MODE_RGMII and to hope that somebody external to this Linux
system made sure that the delays have been inserted (be those PCB delays, o=
r
internal delays added by the link partner).

Ioana

> Another interesting one is cadence/macb_main.c. While it handles all the =
RGMII
> modes uniformly, the Zynq GEM hardware (supported by the driver) does not
> actually support adding any delays. The driver happily accepts these mode=
s
> without telling the user that it really is using PHY_INTERFACE_MODE_RGMII=
_ID.
> Should the driver warn about or reject the other modes? Rejecting could b=
reak
> existing users. Some feedback (failure or warning) would be very useful
> however.
>=20
> stmicro/stmmac/dwmac-sti.c has a #define IS_PHY_IF_MODE_RGMII, which
> seems to be a duplicate of phy_interface_mode_is_rgmii from <linux/phy.h>=
.
> Should that or phy_interface_is_rgmii be used instead?
>=20
> Helmut
