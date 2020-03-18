Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BC81895C4
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 07:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgCRG00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 02:26:26 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:55783
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726802AbgCRG00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 02:26:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GzEKjDIPHVNtZgIbLr6tT8h+Sdco7g1mg5Rp9E5LGuwxX2ABNsJHVDys9OSmah3aN+OZvPuM7V+sNVuvDGZYCvYXA3Jhe91snUp8b7iIhJH3KmsK3Ss5mzx7DPysEL6x1bs/CvbxRedBQemCicgDrGdWv1x55eQe65Bdm/LcTcGCAdQePJlEw4pt4a2w3uZoWfaNUwv+ybFcLAJXQniluGv9ywXXdA8S156x4EEqE2UqbYRgAoWh3aYZZfLkE8YbMWG3tjcW5k2+0hKtMV9w2bUHAo9DGVfghXa62yBPDwjHJBWQmBr3G+xLibsD+fsLM7jX57hx15fJiAu5Cghtxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUeCXE/b5GcSXGnsqcIKepsQi3f8ds03ShjQGlK7IY8=;
 b=B4qiCtmnLO0UY77EJ3WTSxVK2x4MLoZ8Jcmc9iaKxx1HUlPyC+pUICyYF2DkV9T+c/PVK2zW9vFnX5NKS3p1XsuVT6QhxIuz6RrnEbSteRn5xaJXwC7Jg0Kaa4Fs9Zu915TKV3YE45qOnLay2eTVAWKYHApyBfkzbjLm+7k6NwiU2N4RZ740SW+DO7u7Fq1rCMWYN6kXKGzdxGECvz9CIK5RvBkGPDWsPV5TN5981jIgGivgZEFPFVv40GUb+QpHuo5puYnnP3Ech7UZmevGn0FLaxQWcwNZA8pf3biU0b6C8b36+dC+VxLuPvF4+t/+UPMJUbmnK7bhIqMNXHDTAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUeCXE/b5GcSXGnsqcIKepsQi3f8ds03ShjQGlK7IY8=;
 b=AeoxeEJfkT2TNKMVzLP9ZJuf4e6rJzYaFr8VCitFHHr7OSCWMVMzVeNPKOHx4gFFo7ZS0O46n5phW/I2vk8p9KjZkUekKbqYSXZHhzHwWxLwgSc2StLHVrFphOpMmeE5soyu0PGEaadDX08m4Q5LQHg3w+beAeJ8syIfh6QqIEo=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB2925.eurprd04.prod.outlook.com (10.175.24.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Wed, 18 Mar 2020 06:26:20 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 06:26:20 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] [PATCH 1/4] net: fec: set GPR bit on suspend by DT
 connfiguration.
Thread-Topic: [EXT] [PATCH 1/4] net: fec: set GPR bit on suspend by DT
 connfiguration.
Thread-Index: AQHV/Hwf7o5FT7bkakCxQQlLHyLZc6hN4MmA
Date:   Wed, 18 Mar 2020 06:26:19 +0000
Message-ID: <VI1PR0402MB3600396A11D0AB39FBF9C54AFFF70@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
 <1584463806-15788-2-git-send-email-martin.fuzzey@flowbird.group>
In-Reply-To: <1584463806-15788-2-git-send-email-martin.fuzzey@flowbird.group>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 925f9f2c-b02c-4377-f0d2-08d7cb0545be
x-ms-traffictypediagnostic: VI1PR0402MB2925:|VI1PR0402MB2925:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB29258586BDAB00512B553C68FFF70@VI1PR0402MB2925.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(199004)(9686003)(52536014)(2906002)(55016002)(71200400001)(33656002)(15650500001)(5660300002)(186003)(45080400002)(316002)(8676002)(81156014)(54906003)(81166006)(8936002)(4326008)(966005)(110136005)(7696005)(86362001)(76116006)(6506007)(66946007)(66476007)(66556008)(64756008)(66446008)(478600001)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2925;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: guNMhHjYbbXAqCTIu1003yawDitO+vpdB2H8mUSq/vQX5L/QIlMNg45WiNaNb39vP6CFk2s6mhp/QxPOrykNjB1v1mLiK82Gwhv9s5ACoqPpfNlmeknnyg3YsYq+o/JPVQ8LNKeQXUsux5i9XbUGAQeN+48cOExWW+zRXc8v16zPSDfEPrLXq0NGlgUDlFJT9e1vx1ULRr71bwHEiyBYZgwb3AeVozPA+Jav6AjXCX9HQsfkIDwsmaOuaZb23uPev2sn3tzwTu/pm1JQC7G4oR5yKiNUcbHprIBefhfsZiqX9cMMpLqJN84l3YmXKmDTf8LmzRiu61aNGNnTkLw7tEgqdkGv45NSC8SDk0M/6gwXoUZatBETZ9CY/Z3BXDWTZwpmEuMz57kpAeSIgexEypEUlT21+RSrzqClzZEkVMEit6slPAh069zPtrgNi6eKRO0L7UC2Ul/Dygm+jxsGWGdZrNJKtN+c9nBUzyPPcdprCAsF35LU8fnIfkSGYJQbQAlyikM8RG0T/9X/9zyiPA==
x-ms-exchange-antispam-messagedata: zNdKIzWSDTxVL+twvTM/qN9S72u4t/HbvC3pYDqSXFfGi/nE5ScFyh5GKORr/Q4SsRbuc+sQiljoMlCXWHsTt3oPzTax9LqB8YaPAMavfoinedHOzgfZS6L0okBrgqNiKcrAGBL8pQbJJnltUr0waA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 925f9f2c-b02c-4377-f0d2-08d7cb0545be
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 06:26:19.8582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SEsXXbmQW+cqF4d0TjB6mtxeeEzTa9/5NuYdwGGYL6CEkoKpq6VzNphlrk5N36orDHF9ddUPkho9II26cfRJww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2925
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group> Sent: Wednesday, March 1=
8, 2020 12:50 AM
> On some SoCs, such as the i.MX6, it is necessary to set a bit in the SoC =
level
> GPR register before suspending for wake on lan to work.
>=20
> The fec platform callback sleep_mode_enable was intended to allow this bu=
t
> the platform implementation was NAK'd back in 2015 [1]
>=20
> This means that, currently, wake on lan is broken on mainline for the i.M=
X6 at
> least.
>=20
> So implement the required bit setting in the fec driver by itself by addi=
ng a
> new optional DT property indicating the register and bit to set.
>=20
> [1]
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.s
> pinics.net%2Flists%2Fnetdev%2Fmsg310922.html&amp;data=3D02%7C01%7Cf
> ugang.duan%40nxp.com%7Ca9e64936ec9f45edc57108d7ca9340dd%7C686e
> a1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637200606109625887&am
> p;sdata=3D%2Bg4NIxZRwNY331k9cq5s6OIm22qD5qstiDIVlSQiL8E%3D&amp;res
> erved=3D0
>=20
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
> ---
>  drivers/net/ethernet/freescale/fec.h      |  7 +++
>  drivers/net/ethernet/freescale/fec_main.c | 72
> ++++++++++++++++++++++++++++---
>  2 files changed, 72 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec.h
> b/drivers/net/ethernet/freescale/fec.h
> index f79e57f..d89568f 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -488,6 +488,12 @@ struct fec_enet_priv_rx_q {
>         struct  sk_buff *rx_skbuff[RX_RING_SIZE];  };
>=20
> +struct fec_stop_mode_gpr {
> +       struct regmap *gpr;
> +       u8 reg;
> +       u8 bit;
> +};
> +
>  /* The FEC buffer descriptors track the ring buffers.  The rx_bd_base an=
d
>   * tx_bd_base always point to the base of the buffer descriptors.  The
>   * cur_rx and cur_tx point to the currently available buffer.
> @@ -562,6 +568,7 @@ struct fec_enet_private {
>         int hwts_tx_en;
>         struct delayed_work time_keep;
>         struct regulator *reg_phy;
> +       struct fec_stop_mode_gpr stop_gpr;
>=20
>         unsigned int tx_align;
>         unsigned int rx_align;
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 23c5fef..3c78124 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -62,6 +62,8 @@
>  #include <linux/if_vlan.h>
>  #include <linux/pinctrl/consumer.h>
>  #include <linux/prefetch.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
>  #include <soc/imx/cpuidle.h>
>=20
>  #include <asm/cacheflush.h>
> @@ -1092,11 +1094,28 @@ static void fec_enet_reset_skb(struct
> net_device *ndev)
>=20
>  }
>=20
> +static void fec_enet_stop_mode(struct fec_enet_private *fep, bool
> +enabled) {
> +       struct fec_platform_data *pdata =3D fep->pdev->dev.platform_data;
> +       struct fec_stop_mode_gpr *stop_gpr =3D &fep->stop_gpr;
> +
> +       if (stop_gpr->gpr) {
> +               if (enabled)
> +                       regmap_update_bits(stop_gpr->gpr,
> stop_gpr->reg,
> +                                          BIT(stop_gpr->bit),
> +                                          BIT(stop_gpr->bit));
> +               else
> +                       regmap_update_bits(stop_gpr->gpr,
> stop_gpr->reg,
> +                                          BIT(stop_gpr->bit), 0);
> +       } else if (pdata && pdata->sleep_mode_enable) {
> +               pdata->sleep_mode_enable(enabled);
> +       }
> +}
> +
>  static void
>  fec_stop(struct net_device *ndev)
>  {
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
> -       struct fec_platform_data *pdata =3D fep->pdev->dev.platform_data;
>         u32 rmii_mode =3D readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
>         u32 val;
>=20
> @@ -1125,9 +1144,7 @@ static void fec_enet_reset_skb(struct net_device
> *ndev)
>                 val =3D readl(fep->hwp + FEC_ECNTRL);
>                 val |=3D (FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
>                 writel(val, fep->hwp + FEC_ECNTRL);
> -
> -               if (pdata && pdata->sleep_mode_enable)
> -                       pdata->sleep_mode_enable(true);
> +               fec_enet_stop_mode(fep, true);
>         }
>         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
>=20
> @@ -3397,6 +3414,43 @@ static int fec_enet_get_irq_cnt(struct
> platform_device *pdev)
>         return irq_cnt;
>  }
>=20
> +static int fec_enet_of_parse_stop_mode(struct fec_enet_private *fep,
> +                                      struct device_node *np) {
> +       static const char prop[] =3D "fsl,stop-mode";
> +       struct of_phandle_args args;
> +       int ret;
> +
> +       ret =3D of_parse_phandle_with_fixed_args(np, prop, 2, 0, &args);
To save memory:

		 ret =3D of_parse_phandle_with_fixed_args(np, "fsl,stop-mode", 2, 0, &arg=
s);

> +       if (ret =3D=3D -ENOENT)
> +               return 0;
> +       if (ret)
> +               return ret;
> +
> +       if (args.args_count !=3D 2) {
> +               dev_err(&fep->pdev->dev,
> +                       "Bad %s args want gpr offset, bit\n", prop);
> +               ret =3D -EINVAL;
> +               goto out;
> +       }
> +
> +       fep->stop_gpr.gpr =3D syscon_node_to_regmap(args.np);
> +       if (IS_ERR(fep->stop_gpr.gpr)) {
> +               dev_err(&fep->pdev->dev, "could not find gpr regmap\n");
> +               ret =3D PTR_ERR(fep->stop_gpr.gpr);
> +               fep->stop_gpr.gpr =3D NULL;
> +               goto out;
> +       }
> +
> +       fep->stop_gpr.reg =3D args.args[0];
> +       fep->stop_gpr.bit =3D args.args[1];
> +
> +out:
> +       of_node_put(args.np);
> +
> +       return ret;
> +}
> +
>  static int
>  fec_probe(struct platform_device *pdev)  { @@ -3463,6 +3517,10 @@
> static int fec_enet_get_irq_cnt(struct platform_device *pdev)
>         if (of_get_property(np, "fsl,magic-packet", NULL))
>                 fep->wol_flag |=3D FEC_WOL_HAS_MAGIC_PACKET;
>=20
> +       ret =3D fec_enet_of_parse_stop_mode(fep, np);
> +       if (ret)
> +               goto failed_stop_mode;
> +
>         phy_node =3D of_parse_phandle(np, "phy-handle", 0);
>         if (!phy_node && of_phy_is_fixed_link(np)) {
>                 ret =3D of_phy_register_fixed_link(np); @@ -3631,6
> +3689,7 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
>         if (of_phy_is_fixed_link(np))
>                 of_phy_deregister_fixed_link(np);
>         of_node_put(phy_node);
> +failed_stop_mode:
>  failed_phy:
>         dev_id--;
>  failed_ioremap:
> @@ -3708,7 +3767,6 @@ static int __maybe_unused fec_resume(struct
> device *dev)  {
>         struct net_device *ndev =3D dev_get_drvdata(dev);
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
> -       struct fec_platform_data *pdata =3D fep->pdev->dev.platform_data;
>         int ret;
>         int val;
>=20
> @@ -3726,8 +3784,8 @@ static int __maybe_unused fec_resume(struct
> device *dev)
>                         goto failed_clk;
>                 }
>                 if (fep->wol_flag & FEC_WOL_FLAG_ENABLE) {
> -                       if (pdata && pdata->sleep_mode_enable)
> -                               pdata->sleep_mode_enable(false);
> +                       fec_enet_stop_mode(fep, false);
> +
>                         val =3D readl(fep->hwp + FEC_ECNTRL);
>                         val &=3D ~(FEC_ECR_MAGICEN |
> FEC_ECR_SLEEP);
>                         writel(val, fep->hwp + FEC_ECNTRL);
> --
> 1.9.1

