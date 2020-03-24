Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDD41915E8
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCXQPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:15:33 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:6238
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727426AbgCXQPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 12:15:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1Sw7FfAdtqzNtLM4ep62pTpQP/XMs2MEvJ4frYdNwTgnyaIgA6FFMSje80x6Afifyq4sF9jT+kIztuLErpahg+9zBz5a6P+oLAMjUUGsFf7EhtrCdzjh0l4pdMDR4Ni2nM3DulKZa1bUzaJGCu4X4gKoIPfyJyLKLgIBtK2t98mk5a4PIa9pXqM5bPcG0NYv2xLyqqrEmf/EZ5fmT0igvWnfLqaahHsoVFxoux43g55tg3iXzJOr72QvlsZiqQU9A3IiMKrydRmwwx3o4K77T6lunMQSnGH2qDkfg6BqQj1AGP1niLis9Y27XN7z427AB9nZtcOkUY07Os8icemBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I//xoUvP/bc+bCAtJy406yNBj9RQR0uDhT1CJuiEXgo=;
 b=gR/f2MRHT8XlOLuXZ0xeHrbOhVgszzsjq94A/VDvNdccRwuw8665XU1CN3Mc5lgfwnUUFYjW5j7/e+8y1E8pLDR4O1LegYwhXEe7MIuPGF5eAAFJoPDpQ1M/vpGm3hFkR7xUdNTSUwPMEWuUgMnv5MWEtlHLyU484pWbmADaMlvXsGAkAibVUqviVvxnfSkaCRUqyfyKcDOS940fndDAlG5h8z/0KTByIL9AzvOe0bRRPICto423FDSa9hdXynd2j7Ng0fHazjhNZygit8TKuLOjI2TIrh3FkyYBeVQ9BRu0E4lrmd1XMmfrGvxCgHJwURJ9Ji8hzwNBQLaZ83RVVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I//xoUvP/bc+bCAtJy406yNBj9RQR0uDhT1CJuiEXgo=;
 b=NighsCFa7PCWR1ULa0qZ/z4VXnB5BUK3yQmRG5D9R5s3QHPGOBh6cuvrCHlFOsWen8Zb6+nywxKLhZu/oZXUu4Gz1CYyRvcELYGqtTvdzckJ0hcYujXyVUE1Ksf8JD8z8P+ak12jPvPUkLWvqUV61I/YFOHJpCbzAL5fNbEi+OQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB6128.eurprd05.prod.outlook.com (20.178.205.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Tue, 24 Mar 2020 16:15:26 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4%7]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 16:15:26 +0000
References: <1585061059-6591-1-git-send-email-wenxu@ucloud.cn> <1585061059-6591-3-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     saeedm@mellanox.com, paulb@mellanox.com, vladbu@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support
In-reply-to: <1585061059-6591-3-git-send-email-wenxu@ucloud.cn>
Date:   Tue, 24 Mar 2020 18:15:22 +0200
Message-ID: <vbfftdxenl1.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR1PR01CA0035.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::48) To VI1PR05MB3359.eurprd05.prod.outlook.com
 (2603:10a6:802:1c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR1PR01CA0035.eurprd01.prod.exchangelabs.com (2603:10a6:102::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Tue, 24 Mar 2020 16:15:25 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4b4f5cec-ea2d-4ee4-0f5b-08d7d00e9003
X-MS-TrafficTypeDiagnostic: VI1PR05MB6128:|VI1PR05MB6128:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB612802068C90B39F2B1ED73AADF10@VI1PR05MB6128.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(6666004)(6916009)(81156014)(8936002)(4326008)(8676002)(478600001)(81166006)(6486002)(956004)(2616005)(316002)(16526019)(5660300002)(36756003)(86362001)(7696005)(186003)(26005)(52116002)(66946007)(2906002)(66476007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6128;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pFkaAXwFOewG5CnqOBvYwSB+OY804jTIFkQ8P0Y7KfoelfMwt3bwyl61PI9ZI/IWq2O/pY9J0sFhoPZj84JRohG5ItCjwoKCwszT4iWHOjReu/P71zoxEYNAmG87+dbL2nURUf4bsd79B9taFtRen9/IIhwykEMXVSLgFptHLafcek2Iiw4q/y16pxyXdc5CguRTbTsxeAfdkCVMkAp44dE9ARAaFXXTod7rp7CM+RA2rO/rm/8XZd5mHS4UuUVin28MgdwYWRftyKt0jtvbEzgu4ceoe2JFhAaTEF+v5qPm2trlnyYmQEjRWoO1iUoiN9MH+ti6ld4Qs4IgH6X+VCTaEyJXgU5dCB7sS5AFCdyyWBpPYy82coVaXpI26kRQKO0liNXKRYaMYzB4D61kFiuiN1BHsGd4WeApeRzvRFlijcEGVUhPjDXEus0HnejJ
X-MS-Exchange-AntiSpam-MessageData: hPRFJ3rPTxq3AfXEuIB2DTRm3JdsLFoCnwbe+4oQyR5XoN9FZZtuFHCw1fya0Fdb/FNvjiCeAAV+TtsYiD66IUIWdzmuyJwh1yMmxHr1TaEkHdEdKISm8M7RmNqL8lW78vMYh7fQ/tJJqFqgftgT1A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4f5cec-ea2d-4ee4-0f5b-08d7d00e9003
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 16:15:26.3102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INIQPtsCpVYMUue9XGG7ZvG4rmwndZT10qhweDEVP11+GHn6GLGEO4FYisBWwOTze69lZS/CoFJtQ1aP5AwWgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 24 Mar 2020 at 16:44, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
> in FT mode.
> Both tc rules and flow table rules are of the same format,
> It can re-use tc parsing for that, and move the flow table rules
> to their steering domain(the specific chain_index), the indr
> block offload in FT also follow this scenario.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v6: modify the comments
>
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 52 ++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 057f5f9..30c81c3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -732,6 +732,55 @@ static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
>  	}
>  }
>
> +static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
> +				      void *type_data, void *indr_priv)
> +{
> +	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
> +	struct flow_cls_offload *f = type_data;
> +	struct flow_cls_offload tmp;
> +	struct mlx5e_priv *mpriv;
> +	struct mlx5_eswitch *esw;
> +	unsigned long flags;
> +	int err;
> +
> +	mpriv = netdev_priv(priv->rpriv->netdev);
> +	esw = mpriv->mdev->priv.eswitch;
> +
> +	flags = MLX5_TC_FLAG(EGRESS) |
> +		MLX5_TC_FLAG(ESW_OFFLOAD) |
> +		MLX5_TC_FLAG(FT_OFFLOAD);
> +
> +	switch (type) {
> +	case TC_SETUP_CLSFLOWER:
> +		memcpy(&tmp, f, sizeof(*f));
> +
> +		if (!mlx5_esw_chains_prios_supported(esw))
> +			return -EOPNOTSUPP;
> +
> +		/* Re-use tc offload path by moving the ft flow to the
> +		 * reserved ft chain.
> +		 *
> +		 * FT offload can use prio range [0, INT_MAX], so we normalize
> +		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
> +		 * as with tc, where prio 0 isn't supported.
> +		 *
> +		 * We only support chain 0 of FT offload.
> +		 */
> +		if (tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw))
> +			return -EOPNOTSUPP;
> +		if (tmp.common.chain_index != 0)
> +			return -EOPNOTSUPP;

Here you have three consecutive conditionals returning the same value
-EOPNOTSUPP. Perhaps it would be better to combine all the checks in
single if statement?

> +
> +		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
> +		tmp.common.prio++;
> +		err = mlx5e_rep_indr_offload(priv->netdev, &tmp, priv, flags);
> +		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
> +		return err;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>  {
>  	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
> @@ -809,6 +858,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
>  	case TC_SETUP_BLOCK:
>  		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
>  						  mlx5e_rep_indr_setup_tc_cb);
> +	case TC_SETUP_FT:
> +		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
> +						  mlx5e_rep_indr_setup_ft_cb);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
