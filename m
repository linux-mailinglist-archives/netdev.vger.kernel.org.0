Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E70823310D
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 13:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgG3Lhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 07:37:51 -0400
Received: from mail-eopbgr1410108.outbound.protection.outlook.com ([40.107.141.108]:15136
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726615AbgG3Lht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 07:37:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdfUNF/FBZggj/2+83icd024ckUky49ylZ72X6X+H1F3o2zt0JIzgc+a0dxsqTS4P8cCqlnrGMW5u3hWgOlhDSij0HtMvBi0948bThBxV7mp1fEj/dbJGAM/T7pqfCZnI5GcznmtFbri/M1RGrhwyuji42ZSNFj2G0i2i5NnEj6H7sUX42rW3uTOr5IF7I7ygZ1h10oYyUcayqD8mAqskaNZIPqbFJibGGGg3l3HYsg7Dx73Z9+V+ixkHjw5RYu9izbb3qPXr3TTAEpdqFWT4Lmwz+bhwNHqHcM/yW4S4e4cb5OFtTvkHUuzdq/A9zqX2zQFnmJQrhlHRyPHIg3GZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPw2me65FDJrx+Ok2UafmRsZ6KVPm+2iAZmgFnw1RUk=;
 b=U53k81GS81tO1d3oXkTrilC3zWCIKqN+8WpY7KQ5pPMLi2a/Mpimi4OsUR7F4W5cbeAwAOCIHlFEe3sMwC9FsKZiC/s3y/F0gbmglfNG+v89pkNqwpC58sg4eQw2eTlMIlcyKK5+1YStlEN5k3EciOe0YvBIGzHRnYgSdz4nzQwCMp0icx3OhrhErVZNsq701oDx8LhaHHN0X2WcViURv6gvx1ZvN7kkfWHUiYhEuPF7jE67bzF8dfk8UH/Alc3BbryneKVTNcKtGHeEf3yCz698uF6psSl9ChOEPB3B4gLw5R28pV0u2ZtVs7qhW6TaTj+qO/JF9aTQoIGNhp0jsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPw2me65FDJrx+Ok2UafmRsZ6KVPm+2iAZmgFnw1RUk=;
 b=I6Sb+mT94ksbUVGNqXplKLDyd2VeQsIwNLqbsxjjhxLhQTYS5X6G+g4CjIcbJHalnXu9M56PGU08gh7C216XdXedhrzqcziIpjvIhYKSH2cLZfdyf4J1Y3GQ9MrIKWOGabmVwCe+od+fPp9CrdI29qK1t9bp9LweLIoFagp9yYc=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYXPR01MB1549.jpnprd01.prod.outlook.com (2603:1096:403:c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18; Thu, 30 Jul
 2020 11:37:44 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3%6]) with mapi id 15.20.3239.017; Thu, 30 Jul 2020
 11:37:44 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        "sergei.shtylyov@gmail.com" <sergei.shtylyov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Topic: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Index: AQHWZlopa4nv6nqNlEaX6k+bLc2aS6kf9vzQ
Date:   Thu, 30 Jul 2020 11:37:44 +0000
Message-ID: <TY2PR01MB36928342A37492E8694A7625D8710@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
In-Reply-To: <20200730100151.7490-1-ashiduka@fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fujitsu.com; dkim=none (message not signed)
 header.d=none;fujitsu.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:7943:2b76:f13:ed54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c5849bcd-d9b0-4d8c-c5d6-08d8347cf9fa
x-ms-traffictypediagnostic: TYXPR01MB1549:
x-microsoft-antispam-prvs: <TYXPR01MB15496BEB6DDE80FB2D6321C0D8710@TYXPR01MB1549.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:568;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fx/IYuxoqb+Hjc7DdDAYQMoEGiLEjfkCRrlQocghFF8p9XUBSPRVH0NgGM0DJub1S2NV68mwW1JdGy78E3PBnGPH2QWsNJ8vxvkBLeF+daaoCsYhXARTNZPoIikt03v+SPYodf7dTDZkg2u1ZVe4FjXi4QByGUTPYROIhXpVKJKEOpLmejSIyIgs/R+VZ32YxsLLcW4XjYlLat0JGjF8xWcg8Yy+azC1Fdn2VlvlgiXWzzRF4/HOA5aBalHjy9ObJ5hBo2YF5KsviJUXagahfzC2rkK8HkZio4QWsUrSlhx37vUuihmbtYPHV19MjifV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(83380400001)(9686003)(55016002)(186003)(33656002)(7696005)(52536014)(53546011)(8676002)(5660300002)(8936002)(6506007)(66946007)(64756008)(66446008)(66476007)(54906003)(66556008)(71200400001)(76116006)(110136005)(478600001)(86362001)(316002)(4326008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: T1Q1kmHw2f5/MJbxnxwvorCZ0TfV/p478MFOFWJlqga+tK1iG2iQbU8Kp6aoFzu6KRw2oJLAfro2apCwsaJsFU0zjrg8G8cJZZKGVOqxEbGn5cUZzMM69phk5FKK94NBT2LCxcVu3pA5+S3dxKuPCpbGzzTm9XljqQy+SPvp7M3zR1l5ldgK9NhBWs4rzPYSMF5Q6OsR9jhEBLP2rJFifbv64oCElON8+6z7aLRodE9U+z2G3VNA4Wgg6NHSxX8XvYwoYReZJiy+75DPO6SfIBrManQysI7ilG1kNOdtmjSDe5LiEDUjTjsoDDis/VYvwSIciYwmMBIDvd70xbZuy9aWy8i8HpxukFkdqnOcvo0/D5ijc9pwrnt76LFAx/SxpSBytj0CoBh5uPM4NS7RNR9wKNTN9wxcWJWwlAG3FCEGSh2LNvGhHjQNfEoGkz7qooRa2b96KjaTtv3W3mZQwTBnPC6VmirE6sdafibRhQLl2czuslvGRLGrVRwKG2bFJOlJfReFTE53Y0xAxw09n0KaXcBGyJHD3vmnq17MxRM1bMPr92jryobEMP/8q/QgunhT5QrypS+F9avAYXDLvYSz/ZnR6PEvMbkgzJ+KxRMQKHfF4I2jAmdY3QGJ33l4Bh3pnNC9PTLEN5vSJ6RFr/dXI+q038H+RDiX0k/HL7B2c0g8GG6r9fCB2xD7k9ydu+7nlrm6d80x8dRt/DOKIw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5849bcd-d9b0-4d8c-c5d6-08d8347cf9fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 11:37:44.6156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IzUk1MnQ3XoxgcOHiPR2ADB5uDg4VE6/dkXXMfuLQKiuExaGJ4yB8QMrpwPG8Ifi+V+utltC5KWcORduMtDxB5/ca/NvpWX53uvbNO5yxxr4XeDF+agORhSKAfXBWg7R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYXPR01MB1549
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ashizuka-san,

> From: Yuusuke Ashizuka, Sent: Thursday, July 30, 2020 7:02 PM
> Subject: [PATCH v2] ravb: Fixed the problem that rmmod can not be done

Thank you for the patch! I found a similar patch for another driver [1].
So, we should apply this patch to the ravb driver.

[1]
fd5f375c1628 ("net-next: ax88796: Attach MII bus only when open")

> ravb is a module driver, but I cannot rmmod it after insmod it.

I think "When this driver is a module, I cannot ..." is better.

> ravb does mdio_init() at the time of probe, and module->refcnt is increme=
nted

I think "This is because that this driver calls ravb_mdio_init() ..." is be=
tter.

According to scripts/checkpatch.pl, I think it's better to be a maximum
75 chars per line in the commit description.

> by alloc_mdio_bitbang() called after that.
> Therefore, even if ifup is not performed, the driver is in use and rmmod =
cannot
> be performed.
>=20
> $ lsmod
> Module                  Size  Used by
> ravb                   40960  1
> $ rmmod ravb
> rmmod: ERROR: Module ravb is in use
>=20
> Fixed to execute mdio_init() at open and free_mdio() at close, thereby rm=
mod is

I think "Fixed to call ravb_mdio_init() at open and ravb_mdio_release() ...=
" is better.
However, I'm not sure whether that Sergei who is the reviwer of this driver=
 accepts
the descriptions which I suggested though :)

By the way, I think you have to send this patch to the following maintainer=
s too:
# We can get it by using scripts/get_maintainers.pl.
David S. Miller <davem@davemloft.net> (maintainer:NETWORKING DRIVERS,commit=
_signer:8/8=3D100%)
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)

Best regards,
Yoshihiro Shimoda

> possible in the ifdown state.
>=20
> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> ---
> Changes in v2:
>  - Fix build error
>=20
>  drivers/net/ethernet/renesas/ravb_main.c | 110 +++++++++++------------
>  1 file changed, 55 insertions(+), 55 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ether=
net/renesas/ravb_main.c
> index 99f7aae102ce..df89d09b253e 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1342,6 +1342,51 @@ static inline int ravb_hook_irq(unsigned int irq, =
irq_handler_t handler,
>  	return error;
>  }
>=20
> +/* MDIO bus init function */
> +static int ravb_mdio_init(struct ravb_private *priv)
> +{
> +	struct platform_device *pdev =3D priv->pdev;
> +	struct device *dev =3D &pdev->dev;
> +	int error;
> +
> +	/* Bitbang init */
> +	priv->mdiobb.ops =3D &bb_ops;
> +
> +	/* MII controller setting */
> +	priv->mii_bus =3D alloc_mdio_bitbang(&priv->mdiobb);
> +	if (!priv->mii_bus)
> +		return -ENOMEM;
> +
> +	/* Hook up MII support for ethtool */
> +	priv->mii_bus->name =3D "ravb_mii";
> +	priv->mii_bus->parent =3D dev;
> +	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
> +		 pdev->name, pdev->id);
> +
> +	/* Register MDIO bus */
> +	error =3D of_mdiobus_register(priv->mii_bus, dev->of_node);
> +	if (error)
> +		goto out_free_bus;
> +
> +	return 0;
> +
> +out_free_bus:
> +	free_mdio_bitbang(priv->mii_bus);
> +	return error;
> +}
> +
> +/* MDIO bus release function */
> +static int ravb_mdio_release(struct ravb_private *priv)
> +{
> +	/* Unregister mdio bus */
> +	mdiobus_unregister(priv->mii_bus);
> +
> +	/* Free bitbang info */
> +	free_mdio_bitbang(priv->mii_bus);
> +
> +	return 0;
> +}
> +
>  /* Network device open function for Ethernet AVB */
>  static int ravb_open(struct net_device *ndev)
>  {
> @@ -1350,6 +1395,13 @@ static int ravb_open(struct net_device *ndev)
>  	struct device *dev =3D &pdev->dev;
>  	int error;
>=20
> +	/* MDIO bus init */
> +	error =3D ravb_mdio_init(priv);
> +	if (error) {
> +		netdev_err(ndev, "failed to initialize MDIO\n");
> +		return error;
> +	}
> +
>  	napi_enable(&priv->napi[RAVB_BE]);
>  	napi_enable(&priv->napi[RAVB_NC]);
>=20
> @@ -1427,6 +1479,7 @@ static int ravb_open(struct net_device *ndev)
>  out_napi_off:
>  	napi_disable(&priv->napi[RAVB_NC]);
>  	napi_disable(&priv->napi[RAVB_BE]);
> +	ravb_mdio_release(priv);
>  	return error;
>  }
>=20
> @@ -1736,6 +1789,8 @@ static int ravb_close(struct net_device *ndev)
>  	ravb_ring_free(ndev, RAVB_BE);
>  	ravb_ring_free(ndev, RAVB_NC);
>=20
> +	ravb_mdio_release(priv);
> +
>  	return 0;
>  }
>=20
> @@ -1887,51 +1942,6 @@ static const struct net_device_ops ravb_netdev_ops=
 =3D {
>  	.ndo_set_features	=3D ravb_set_features,
>  };
>=20
> -/* MDIO bus init function */
> -static int ravb_mdio_init(struct ravb_private *priv)
> -{
> -	struct platform_device *pdev =3D priv->pdev;
> -	struct device *dev =3D &pdev->dev;
> -	int error;
> -
> -	/* Bitbang init */
> -	priv->mdiobb.ops =3D &bb_ops;
> -
> -	/* MII controller setting */
> -	priv->mii_bus =3D alloc_mdio_bitbang(&priv->mdiobb);
> -	if (!priv->mii_bus)
> -		return -ENOMEM;
> -
> -	/* Hook up MII support for ethtool */
> -	priv->mii_bus->name =3D "ravb_mii";
> -	priv->mii_bus->parent =3D dev;
> -	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
> -		 pdev->name, pdev->id);
> -
> -	/* Register MDIO bus */
> -	error =3D of_mdiobus_register(priv->mii_bus, dev->of_node);
> -	if (error)
> -		goto out_free_bus;
> -
> -	return 0;
> -
> -out_free_bus:
> -	free_mdio_bitbang(priv->mii_bus);
> -	return error;
> -}
> -
> -/* MDIO bus release function */
> -static int ravb_mdio_release(struct ravb_private *priv)
> -{
> -	/* Unregister mdio bus */
> -	mdiobus_unregister(priv->mii_bus);
> -
> -	/* Free bitbang info */
> -	free_mdio_bitbang(priv->mii_bus);
> -
> -	return 0;
> -}
> -
>  static const struct of_device_id ravb_match_table[] =3D {
>  	{ .compatible =3D "renesas,etheravb-r8a7790", .data =3D (void *)RCAR_GE=
N2 },
>  	{ .compatible =3D "renesas,etheravb-r8a7794", .data =3D (void *)RCAR_GE=
N2 },
> @@ -2174,13 +2184,6 @@ static int ravb_probe(struct platform_device *pdev=
)
>  		eth_hw_addr_random(ndev);
>  	}
>=20
> -	/* MDIO bus init */
> -	error =3D ravb_mdio_init(priv);
> -	if (error) {
> -		dev_err(&pdev->dev, "failed to initialize MDIO\n");
> -		goto out_dma_free;
> -	}
> -
>  	netif_napi_add(ndev, &priv->napi[RAVB_BE], ravb_poll, 64);
>  	netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll, 64);
>=20
> @@ -2202,8 +2205,6 @@ static int ravb_probe(struct platform_device *pdev)
>  out_napi_del:
>  	netif_napi_del(&priv->napi[RAVB_NC]);
>  	netif_napi_del(&priv->napi[RAVB_BE]);
> -	ravb_mdio_release(priv);
> -out_dma_free:
>  	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat=
,
>  			  priv->desc_bat_dma);
>=20
> @@ -2235,7 +2236,6 @@ static int ravb_remove(struct platform_device *pdev=
)
>  	unregister_netdev(ndev);
>  	netif_napi_del(&priv->napi[RAVB_NC]);
>  	netif_napi_del(&priv->napi[RAVB_BE]);
> -	ravb_mdio_release(priv);
>  	pm_runtime_disable(&pdev->dev);
>  	free_netdev(ndev);
>  	platform_set_drvdata(pdev, NULL);
> --
> 2.17.1

