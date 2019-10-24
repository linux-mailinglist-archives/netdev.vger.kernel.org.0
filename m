Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8ADAE28A2
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437107AbfJXDJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 23:09:01 -0400
Received: from mail-eopbgr60082.outbound.protection.outlook.com ([40.107.6.82]:48581
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408284AbfJXDJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 23:09:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1wvY3b6T3r7KyV8WnyvWio9P6CULsAHO4cMTN9lbcPh83vz8zYm9eEYfPRUE2PyAXc/XWVNHJr1Shd/U7L7+QHO6weUtqBk21pz7fnrJXCibAhOKNliZwbd0v2UCPoxGmAfz6YOvivItp+zQjruixQCO6ckXqQQiz0tc1P19waimLREL2MdlHbHYK3OWJ/bb5jHS0E0NowFKEVuEZ0H4boHJKuq/UfouIqzIKw/Y1cdxvc6cz8IaTcdHnpC6MsBTBc8meCzM+pLIRiq1Dye50tk5m50+6NG0aJXMOwhRZR3gBi0GdfoDfLL0lX+njl+NI2JxR7rM8GuXOe0uE/u5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/BbvJv9YBVWVQzVl+ImzuUDzeL6alaQHLI90HbvhHI=;
 b=etJiHAxWkwAYfgJGab7nRA1B7f8RyvxLYHBPDfhd2I5zJ2O+P7DhrZAtwTy7zfMVhJ7a/JbJE20NrsIR2IY59eV0zZ84Aw+hyAWQWCAvg5kR0oyAb9yIDmdLny9t/Kux7ERbIRXZl0OYRff2ABZy+o+VLJmuAs3ILXj7/jvwGwd4gqDWz0dkc5Wza4+BKF4ElyBU/X0IkaSpn72Cske7nJLbSBM8oWp7pwfMB3oibgrWd7A+fOZfPWldTku4AYrq2O4hmx6Wz6IPfSpN3YswXm0dWOWuIYY3MjF6D9SNBR8J+7IWf0dBRGJPcIi1AHMBYwb5iVp7V8HjYFdxQV0zqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/BbvJv9YBVWVQzVl+ImzuUDzeL6alaQHLI90HbvhHI=;
 b=oTZfA1rUynYe9LU/6yn5WQDLDPal+I1P5VBvyL/L+/RLfhtxheqnsLFXwNThsvIDHTrmgz976bVONMMgAbYCrPMVf417Z3/mfvsXk6s68DDmEA4zOtElgCrOLWeJ1mar0nti9mlgKatLyB1OaJXPdzJBtfk7OXt+8c+QRDkYli8=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1SPR00MB255.eurprd04.prod.outlook.com (10.175.186.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 24 Oct 2019 03:08:53 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52%7]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 03:08:53 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Oliver Graute <oliver.graute@gmail.com>
CC:     "festevam@gmail.com" <festevam@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] fec driver: ethernet rx is deaf on variscite imx6ul board
Thread-Topic: [EXT] fec driver: ethernet rx is deaf on variscite imx6ul board
Thread-Index: AQHVid3ccKW0SK07a0uLTBKg9tYQoKdpG8jA
Date:   Thu, 24 Oct 2019 03:08:53 +0000
Message-ID: <VI1PR0402MB360013E0A785313D5D676633FF6A0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191023201000.GE20321@ripley>
In-Reply-To: <20191023201000.GE20321@ripley>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c107fedb-eec4-40f8-1cbd-08d7582f8026
x-ms-traffictypediagnostic: VI1SPR00MB255:|VI1SPR00MB255:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR00MB255D9E79AB0CEFA1CAE0E7DFF6A0@VI1SPR00MB255.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(189003)(199004)(229853002)(11346002)(446003)(486006)(25786009)(55016002)(26005)(102836004)(6506007)(71200400001)(71190400001)(256004)(9686003)(6436002)(6916009)(6116002)(3846002)(4326008)(478600001)(6246003)(2906002)(476003)(8676002)(8936002)(76116006)(81156014)(52536014)(66556008)(66446008)(64756008)(66476007)(66946007)(186003)(33656002)(14454004)(5660300002)(76176011)(7696005)(316002)(7736002)(66066001)(74316002)(305945005)(86362001)(99286004)(54906003)(81166006)(32563001)(473944003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR00MB255;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vqDbCZkFtb5MItHM7WIgx6jJuacP8aIHUJSDQd0eqMcm1GG/uMt4FazF0HJj5TIvyzYbLWYevesEiJa4oUWRk3iVxffleMG/SiLhWQ0oaYLN+6v0n7QvxfkjFE0fQ0MlK9f2hd/L+zVn6/hpkKeVOSv3h+iaqcI3Qw6IgqKMHdMjlkiYvTTE9am409dJzDRX/1VdYGQc03YhbEgWREm9vkZJE1/Ag42gwytoCKwEyj0ksWS4zRVzD6uBx1nRzCEAP0ivDo4CJvqHlkg7dWNpfN5fJ94gtDorT6R32QQ53AI3UVRf299x/pf2veK13NZwFK9pZJc36wO73mYWmCufWTgaAWAQqdTJVswdyk6/iURgsupwHRIBSHECgCFzMSCY1B0RVDiOxMeX7Iual38Bt6qjkDiPUGrYAqciUvq/6t0S6sDsyAGRoYN8nku0QYHy
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c107fedb-eec4-40f8-1cbd-08d7582f8026
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 03:08:53.2373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECgWuYxW/2WyaPSzsgt82fzK1xhiPRcJEZe7elE2zwhr7rflxR4k1HcVniLoA6GTXsZ7BemseY+1Ixv4koz/FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR00MB255
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Graute <oliver.graute@gmail.com> Sent: Thursday, October 24, 2=
019 4:10 AM
> Hello,
>=20
> I use the following nodes in my devicetree to get two ethernet ports work=
ing
> with fec driver on a Variscite DART-6UL SoM Board (imx6ul).
>=20
> But ethernet RX is deaf and not working. Some clue whats is the issue her=
e?
>=20
> Best regards,
>=20
> Oliver

It is for new board bringup ? If so, please ask support from NXP in normal =
operation.
I check your dts in simple, below are my comments:
- MDIO/MDC pins are not configurated
- Please ensure the RMII reference clock 50Mhz active on line, measured it =
by oscillometer.

Andy
>=20
> &fec1 {
>         pinctrl-names =3D "default";
>         pinctrl-0 =3D <&pinctrl_enet1>;
>         phy-mode =3D "rmii";
>         phy-reset-gpios =3D <&gpio5 0 1>;
>         phy-reset-duration =3D <100>;
>         phy-handle =3D <&ethphy0>;
> };
>=20
> &fec2 {
>         pinctrl-names =3D "default";
>         pinctrl-0 =3D <&pinctrl_enet2>;
>         phy-mode =3D "rmii";
>         phy-handle =3D <&ethphy1>;
>         phy-reset-gpios =3D <&gpio1 10 1>;
>         phy-reset-duration =3D <100>;
>=20
>         mdio {
>                 #address-cells =3D <1>;
>                 #size-cells =3D <0>;
>=20
>                 ethphy0: ethernet-phy@1 {
>                         compatible =3D "ethernet-phy-ieee802.3-c22";
>                         micrel,rmii-reference-clock-select-25-mhz;
>                         clocks =3D <&clk_rmii_ref>;
>                         clock-names =3D "rmii-ref";
>                         reg =3D <1>;
>                 };
>=20
>                 ethphy1: ethernet-phy@3 {
>                         compatible =3D "ethernet-phy-ieee802.3-c22";
>                         micrel,rmii-reference-clock-select-25-mhz;
>                         clocks =3D <&clk_rmii_ref>;
>                         clock-names =3D "rmii-ref";
>                         reg =3D <3>;
>                 };
>         };
> };
>         pinctrl_enet1: enet1grp {
>                 fsl,pins =3D <
>                         MX6UL_PAD_ENET1_RX_EN__ENET1_RX_EN
> 0x1b0b0
>                         MX6UL_PAD_ENET1_RX_ER__ENET1_RX_ER
> 0x1b0b0
>=20
> MX6UL_PAD_ENET1_RX_DATA0__ENET1_RDATA00 0x1b0b0
>=20
> MX6UL_PAD_ENET1_RX_DATA1__ENET1_RDATA01 0x1b0b0
>                         MX6UL_PAD_ENET1_TX_EN__ENET1_TX_EN
> 0x1b0b0
>=20
> MX6UL_PAD_ENET1_TX_DATA0__ENET1_TDATA00 0x1b0b0
>=20
> MX6UL_PAD_ENET1_TX_DATA1__ENET1_TDATA01 0x1b0b0
>=20
> MX6UL_PAD_ENET1_TX_CLK__ENET1_REF_CLK1  0x4001b031
>                 >;
>         };
>=20
>         pinctrl_enet2: enet2grp {
>                 fsl,pins =3D <
>                         MX6UL_PAD_ENET2_RX_EN__ENET2_RX_EN
> 0x1b0b0
>                         MX6UL_PAD_ENET2_RX_ER__ENET2_RX_ER
> 0x1b0b0
>=20
> MX6UL_PAD_ENET2_RX_DATA0__ENET2_RDATA00 0x1b0b0
>=20
> MX6UL_PAD_ENET2_RX_DATA1__ENET2_RDATA01 0x1b0b0
>                         MX6UL_PAD_ENET2_TX_EN__ENET2_TX_EN
> 0x1b0b0
>=20
> MX6UL_PAD_ENET2_TX_DATA0__ENET2_TDATA00 0x1b0b0
>=20
> MX6UL_PAD_ENET2_TX_DATA1__ENET2_TDATA01 0x1b0b0
>=20
> MX6UL_PAD_ENET2_TX_CLK__ENET2_REF_CLK2  0x4001b031
>                         MX6UL_PAD_JTAG_MOD__GPIO1_IO10
> 0x1b0b0
>                 >;
>         };
