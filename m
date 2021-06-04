Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087AA39B941
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFDM54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:57:56 -0400
Received: from mail-eopbgr60045.outbound.protection.outlook.com ([40.107.6.45]:2820
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230025AbhFDM5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 08:57:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViZLCaVJVMlw1aAhWiig9EHtH6l5evwzvAbsWhPGjhD8rAtHRBKa7rZu5KE1vZhgJIKXqRxdu2oc0kcSULgo7M80Mog1qH/iEmqBDCZSjLYwZtxxlxCx3VWH3g2Yr2ZVf/ChFOOW7xY8RaZVaTy33eXddTGwml1ijLbbTbMzFW28BB6vRFnqu1WPSRMH7iCxDLFsjan2ZVYIT1inJAWzco3MQ6yE2p/Vg00A8gslHbe0iaqfqv75JfizBjRKwB2ZqoZkrCf3PTr01AQenj4doho/dOeoiTBF8gRQ94g3Kc1REjLLltd2km4cp5plVdeHR2FhwuESBW156b40HiyFSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PM+tQxTUEaDvb63NnUK7qOrB2zDD79bypILTFPi/88=;
 b=YxWvI9EoJYvOvjDub0W7Fug2rgeGBOTCcO6vIX4pW4FFcDa2YMJZAqnN1cCRBAtw4I4HPoxm8HePNdJWnHbXvD+XAaODJU7AzFWTuG6sdfYRcQSqposM6yS71XUbRwPutNY5zg/c7wbkOun9/5kGLxSebFmvpIqVfw1OKYGbnm6DEGiHHA5P57QT9q2WIrJHDHhnA7y63Vw3Y8Do37ZkAwgIkZqKVHynG0CMBO9cPOlLZSjEVIXxQijQ1phuHJZ2OtEe+DkHrkSQ9DE4S+RzHoMNH8vCxllO0mrLRQyGn4p9AR7WQjKSRGM8FxEXDPf1al818QrmoPjiWgZ+kbrgyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PM+tQxTUEaDvb63NnUK7qOrB2zDD79bypILTFPi/88=;
 b=fQgkBQPxoV5vFti+DTTtZZa+x2+OsfPxOf5lBRlB7y0lg7Jbm6bgsTtwLhZKguDPN33Ogb/6Xy47fDKJ6N5vOEtoL2hDJi/9tRnBIUeC0znKiBZP8arGv/2RYuB8O5XHcDbAdKSyHp+gJSorwIAi2T1Vh93lU9msaq6pkEuLArA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 12:56:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 12:56:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Sriranjani P <sriranjani.p@samsung.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Thread-Topic: linux-next: manual merge of the net-next tree with the net tree
Thread-Index: AQHXWODvW3Cyc/eKxUqfofjzTgyJ76sD0DOA
Date:   Fri, 4 Jun 2021 12:56:06 +0000
Message-ID: <20210604125605.t3j67pbgeovguw2h@skbuf>
References: <20210604112825.011148a3@canb.auug.org.au>
In-Reply-To: <20210604112825.011148a3@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87a36c5c-0d8b-41f7-f398-08d927581dfd
x-ms-traffictypediagnostic: VI1PR04MB5342:
x-microsoft-antispam-prvs: <VI1PR04MB53420872201A887BDDB81861E03B9@VI1PR04MB5342.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sn6S1QjYYE+sUN1soAai1OQIRAqmM1K7BKPkf0yRqPd8Z5pjzFWHTCW3DBtENpg5scSIdxIOxHqvV3Tpd76dPF8f2RhTD0wUR8wghzQLyhYrNLlQ0IUt4fkpNrF7qz6x8kOOOlN21JoKFX9iFoSXqF+TrzD37IKJxkQNWPgS55mq2Tq2LLqmJkvxnKCZ1gVinM+7GgEx8vKAIqp6TUd52NnqZnz/aOFH20ZRIUW0hHLqJ70IiFhItrcVth568fASelv1fxKzQ5MMnLTVbl7tBXDDwpXlAZPwREIQ4sLOl4siX6OymOGTRghqTr9Tm9SO/q4wNLmqXk8auHtrLZWoab1mOUb0T3uJ9Wf+XdjdqQxsAzQcytRMUfPr5b6goRG7ijmo8GRaep5khBXN1G5yxdYiHsqzLchWs876GDqpsUcVdYwqhv4a6phUmkndOYPMpKG36Oiz2Xl2uld3yXbBPlAAgfrCMA69c4tNpKXYeEItD/A2zl4c05vJrTOy0tnXfa8w/1N31Co8bmIRVfubpDvFKQdKXflFNj6tuUM8lxfWzx0DHfssBHex7jB2MalasImXkveyP1d+RRTFk0roOyNK0lduVQFI0q57NgcaWgI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(376002)(136003)(366004)(396003)(346002)(122000001)(38100700002)(66946007)(4326008)(54906003)(66476007)(86362001)(478600001)(5660300002)(66556008)(66446008)(26005)(76116006)(91956017)(316002)(6512007)(9686003)(44832011)(2906002)(6506007)(186003)(6486002)(8936002)(8676002)(33716001)(71200400001)(6916009)(1076003)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?mopnxOLiteX7G1Wht17OHVD9mUxeAmqCWWbJssqCL0Wr/i0+Pj39E/Pt+VVS?=
 =?us-ascii?Q?OP5/e14Sy51eAUZebZo7X7Z/Bxd6k65Zcyaw9h9yEtogGeMMNtA4TTr6Rdcv?=
 =?us-ascii?Q?fCfiqH8lRuaFKnXIifRoRYloowRtfjSzP6Mw/A7VpVY6p43DC+VKRlE/CncH?=
 =?us-ascii?Q?Izeokk6aOt0lmJdxllST79md0vUEkWcZdPrJmXQ4DwjaWyb/lIsxbnMqucxJ?=
 =?us-ascii?Q?i7JCqfktI1Pzk3vzNmLryLxM14ubbB5XeGlsxMSvFycSJGcDHDvZP5Y4YL+1?=
 =?us-ascii?Q?VuuO5i+CIgOPHDLsEMnwBywOxhp1+PBTEcD/7cNyMSeYUP3A7mGPaNQrH1O7?=
 =?us-ascii?Q?YzNcdnVcMxx9glt/tDgipFtQw/h5TuWMf8va12HZ6yf6Yi3DsVM0RCn+355g?=
 =?us-ascii?Q?GR/Wj+myRLIN4UhRh685r53JvwTRRjLwIZ/t/GOIDYA7VXewGE4jb1+Ivzfo?=
 =?us-ascii?Q?+ybtzsjHB0GmPtD57LZRMrTzPRKMEU3KDSs+nEtejpR4X9Q549iCOYzMdHkO?=
 =?us-ascii?Q?MGA/KOHp7g92Do3pM7vf6Fpc1TdR5Ehm3Hh0OJeLhTe9s4776esMP1A1TFwr?=
 =?us-ascii?Q?8BXFbwxlcESQAUpNDaSqLLvIrI0MDPac9nwQxYpkWXpWdeD5DvdkkxZizwkU?=
 =?us-ascii?Q?RekOa+KwqvWXCAsy7Ti6Nlmi95gavfCgbZqvGUkX+toeTqBcLoRUEwBXL7ZO?=
 =?us-ascii?Q?d+2FYGXfDsTCi/yOSIQFhal5dVDZtcpNd6mZg+smKDu+rTcuxa5YZamiqMdB?=
 =?us-ascii?Q?0g+wQNNAHnhVmtDbUvI/0oX1xf6+W8st1luwStzXxywOu2dbqO9/2EHX+/Yo?=
 =?us-ascii?Q?4403J7sJW41ccXwsMd3SYpn2877QLP96naZYzDqfr5KRusr1a+fYnBJ5Xmdh?=
 =?us-ascii?Q?BGlhDptd/FA07JAAj6dzqpL91DYyP7m82uY1AGg/oOrIdisiN2FxN2t73Ndl?=
 =?us-ascii?Q?Cg7tO68HPehXvhnrtlbVJ2/N3808N4O/nVKMTC5z6jUzxbfQ7Li1Ht0/dU0f?=
 =?us-ascii?Q?ey0VC3VS/dDAgCuTdU+4SaxYu41B7GqRA/0TptzNhUL0tdnl8/So7kPTB94p?=
 =?us-ascii?Q?PGeUfdUe1Lgcsm3WJD5tp5zPmsaZX0CG7/91heE3XrpZli1rX8E/rGzM0Wkw?=
 =?us-ascii?Q?Yuc4w2yo4/4z7lb6facJteOSBxd7ejoz2kyLBSHbG/8Qa1HaCAW1ilOGypyM?=
 =?us-ascii?Q?Z3+6WAE+NqTs9/j9pWhzHA80oU3t3ZLUXUUMpYXqBTsDgnTYAIKG0LzIJTUT?=
 =?us-ascii?Q?2QDwIJ0ED1Pnt5SWrZgizHK7wExD8DCxG+g6+1a1i72AMTnJThoHhlqrIi3V?=
 =?us-ascii?Q?Stgd9LB6sc7EeN7uNoLPHDaI?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6162C526BFF3F24A9AC9EA02472E5B73@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a36c5c-0d8b-41f7-f398-08d927581dfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 12:56:06.2194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WadVZdJ/cDqXjkT77BD3+qnyZx07F8mHYlA9J8M+qHKqk5F1s8oEUNUgvEiCcTQYz/LH5EBpBy7sjDshsx7NDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Fri, Jun 04, 2021 at 11:28:25AM +1000, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>
> between commit:
>
>   593f555fbc60 ("net: stmmac: fix kernel panic due to NULL pointer derefe=
rence of mdio_bus_data")
>
> from the net tree and commit:
>
>   11059740e616 ("net: pcs: xpcs: convert to phylink_pcs_ops")
>
> from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
> --
> Cheers,
> Stephen Rothwell
>
> diff --cc drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index c87202cbd3d6,6d41dd6f9f7a..000000000000
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@@ -1240,9 -1222,7 +1222,9 @@@ static int stmmac_phy_setup(struct stmm
>   	priv->phylink_config.dev =3D &priv->dev->dev;
>   	priv->phylink_config.type =3D PHYLINK_NETDEV;
>   	priv->phylink_config.pcs_poll =3D true;
> - 	if (priv->plat->mdio_bus_data)
>  -	priv->phylink_config.ovr_an_inband =3D mdio_bus_data->xpcs_an_inband;
> ++	if (mdio_bus_data)
>  +		priv->phylink_config.ovr_an_inband =3D
> - 			priv->plat->mdio_bus_data->xpcs_an_inband;
> ++			mdio_bus_data->xpcs_an_inband;
>
>   	if (!fwnode)
>   		fwnode =3D dev_fwnode(priv->device);

Your conflict resolution looks fine. I touched that area minimally (only
to keep priv->plat_mdio_bus_data in a variable), it should still be
checked against NULL.=
