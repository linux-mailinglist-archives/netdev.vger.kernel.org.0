Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC5E1BF65F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgD3LSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:18:10 -0400
Received: from mail-eopbgr140085.outbound.protection.outlook.com ([40.107.14.85]:4990
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726745AbgD3LSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 07:18:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBa9fUYYkBSKzLaYfEBs0sM6eqLzZKUSCwQmSYe/Xic9MMOvTvOoSSaYnvOGY3eMhSTWENv1/Pq+Wq5CfLiPVN+0BHLDx8gJ6N6Nm6HRbiiRw0W3IgEY6ZP+bkWS/s4WFrvXJG5lozjOgHkecPUk2aSWhEa/r0H0nW9BIJTNn7cFjZoj6TuIYzbBsjHwBjcW6p50GcanSHxX6rLWpgEC2516ODt+fTIzLdO1PRQpMnaORQ15jLwP/kz6+FOr+LjH7IAvyk2FqSRfIJSZl5oiP+LsMK0U5qWsMMZB37q4YLAwMCjifwDegM9BkoCSWTOWCK55oS1CEEjUGcmQIg7eGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ec9K5RdY/o0iA5L5I8/ZF94App+0tyPAeub2gfVXlMA=;
 b=ah+FHPpRITYTLmmkCzb39fIVP+eWQsdfrstNr2L4rzsTug+D6EDMgYO5oiwypjBsGzhMQIP1eHJa3JgPCZymrmFMkrbcOhO9jt9bKTGAzJ4xO8fUezr4QVP2kcyklZOVStGV8zUP/9zBaUCoL0NY3DHIDXPS4GFhM9Z3Ic10OTBml27NReI3Ma+VhYPfJzO8weHM2LmJoaFgDbuQjbTtUz3E7NLD+1PEpyy1frZBP0bt9lERQzmvlvmwzlxc9xH+zuZabRSmAt1o0pWG8ZRd0al2lJet0dLvBahr2ESNQL5qLCdiTgZ2SaQEchEZdCiXAoEN5TTyvZbXi7MQvRNrtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ec9K5RdY/o0iA5L5I8/ZF94App+0tyPAeub2gfVXlMA=;
 b=AejHkojfT8UTsi0MpRsswXm95UXQuEwMjJSQO4G42gkX5vAyiqjMNLOupvVt4Dpt5enkn1Ig7Xy9p3ViAwW8zWbJLxztXM2/kTWKNgxl1TGkhKZLUpUf5cyIDUkvf6aBxv3U5/EdO5hfyPE8V6BEuMt5ZxkLX1zQGvSgKBV/wyg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR05MB4157.eurprd05.prod.outlook.com (2603:10a6:803:4d::20)
 by VI1PR05MB3360.eurprd05.prod.outlook.com (2603:10a6:802:1d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 30 Apr
 2020 11:18:03 +0000
Received: from VI1PR05MB4157.eurprd05.prod.outlook.com
 ([fe80::90af:a464:b72d:e314]) by VI1PR05MB4157.eurprd05.prod.outlook.com
 ([fe80::90af:a464:b72d:e314%5]) with mapi id 15.20.2937.023; Thu, 30 Apr 2020
 11:18:03 +0000
Subject: Re: [PATCH net-next 2/3] net/mlx5e: Introduce
 mlx5e_eswitch_rep_uplink_priv helper
To:     xiangxia.m.yue@gmail.com, paulb@mellanox.com, saeedm@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org
References: <1588051455-42828-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1588051455-42828-2-git-send-email-xiangxia.m.yue@gmail.com>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <c5421bec-7887-bb87-dbd8-b9399f14db95@mellanox.com>
Date:   Thu, 30 Apr 2020 14:17:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <1588051455-42828-2-git-send-email-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::11)
 To VI1PR05MB4157.eurprd05.prod.outlook.com (2603:10a6:803:4d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.113.172) by FRYP281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 11:18:02 +0000
X-Originating-IP: [176.231.113.172]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b4bb770a-c069-42da-09f3-08d7ecf8262f
X-MS-TrafficTypeDiagnostic: VI1PR05MB3360:|VI1PR05MB3360:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3360BFACDC718A38FA261120B5AA0@VI1PR05MB3360.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4157.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(6486002)(2906002)(52116002)(66946007)(66556008)(478600001)(66476007)(31686004)(4326008)(36756003)(956004)(86362001)(31696002)(8676002)(186003)(16526019)(2616005)(316002)(5660300002)(26005)(53546011)(6666004)(8936002)(16576012);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: chj9Eu7BbnGaMOF6GuJSi4BZvWjcTYf6vgYmbMStuWMbExCfUusCTqJVX4sZCB1DIweqE3VTsu3M6MhJ9YANnp9hp8jgc7r0pMo9e6qt2HwmMEhLaq3FTfWo0f2JqGtvfnio4Z7PiAymiKEXYUOrcLahT8IyFVFGwS8ukXeA+IYqL15HqZY3KGxAnrR6d4aovmMiqfHVdenTUO6mvqF3wB6INJzxaSoKL7BY5nJqAtilZbkwhfizrn+juzLd0XWyBOPehNI/uJr68NYxHcGvS78fIxFQt80VyZhH64yDPesytO4ZxFEtWYozC0cis9vqcES+4DNniDyistUw8bxzpRoBLRMFAhqoUhmjMezKPCfMggQyKhNaWqmqqyQVNiv/sYXZNaX0NWYRULpjfGUgCRh2ai3VyCIxxHdxWoFPHLgYiX8m3Uwm1Ef1VIwO+o2t
X-MS-Exchange-AntiSpam-MessageData: ZyXeuojlMQzN66nkuPjcRzylLRd8T6amJj4Ms4/MFSR8Dr24OuT6ElyFemewkcY4fDOeiCRMQwsuJE2Hve7WOu222CfFV7Jl05ZLw0CsG6RzdSiwLy7raHFfJxodYjWQLXFJshKOj1y9ot75ZVgx8Lms8FsoWcIMYhxDkBVrJ4A7L+TUSG7rKCe1Cgbg6wOzJVAYwTxLG/xxsLQyVej5m5f+DNSvEL7figj29WBAo2iogmxUCce1rvxPn+t9eRu0j+Ukm7kGsOgJHy3qwK/YssKd3a3sGSdQrY5i1pbznB/wWsRzpDwMd2WUT2hZuLLHlc5aJJJ3bqY+5vetde/TUt9XiA0mT5ps5qbzVOEZT/TcuQYEs0iyiomOKiRjGz614IDkCOC40MVhJ5rrVkFinDh1hh4p6XJhBntLq/7S/sm1QKwWOxI4FFNQObVlX4e3KLXYFJFoXNHpAV/1iYcGiqbO99Q5XqG/TvN2Y8Cq2vYHMhzSfABDiU9KAL3eATNrB3zzKj3jaUK2uhsucvgNC3cW9sLscJUbRFjon3y+6iFX/05NhEWfaBfZfQlMyAoIrhUQ9f7LcyosDM7FuTyxWQSS6rkuYTMus3DBhQaJkgEadqxsS7BcV7UPN5occXm85WU/lk5dqAsV2AsOSKpa4I64yofzvzu9BvFaszXzeuK8rJS7i3kM3ApvGmvEFvZAZgNXXMCAHDStP6B1jMs9HXPfpWVgYjnQhflTHxXswCyBCDlMRqWQOPBuouaaFiltUQnjgFBhQ4eUTyNM0YKxkNpVrUnZTEAtNjw4w20aNieJvprcunBCXH4B+q/9cNDb
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bb770a-c069-42da-09f3-08d7ecf8262f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 11:18:03.5164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0w61vetUT6/szea/+Wxte1vWiwOJ/OjHJeDO747mmfEUMYiKk115daaXicE3tWin0PPtUF+kCmiRIAH0NMr9lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3360
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-04-28 8:24 AM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Introduce the mlx5e_eswitch_rep_uplink_priv helper
> to make the codes readable.
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  4 +--
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  9 +++++++
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 30 +++++-----------------
>  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 16416eaac39e..c5d5e69ff147 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -100,10 +100,8 @@ struct mlx5_ct_entry {
>  {
>  	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>  	struct mlx5_rep_uplink_priv *uplink_priv;
> -	struct mlx5e_rep_priv *uplink_rpriv;
>  
> -	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> -	uplink_priv = &uplink_rpriv->uplink_priv;
> +	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
>  	return uplink_priv->ct_priv;
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> index 6a2337900420..899ffa0872b7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> @@ -109,6 +109,15 @@ struct mlx5e_rep_priv *mlx5e_rep_to_rep_priv(struct mlx5_eswitch_rep *rep)
>  	return rep->rep_data[REP_ETH].priv;
>  }
>  
> +static inline struct mlx5_rep_uplink_priv *
> +mlx5e_eswitch_rep_uplink_priv(struct mlx5_eswitch *esw)
> +{
> +	struct mlx5e_rep_priv *priv;
> +
> +	priv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> +	return &priv->uplink_priv;
> +}
> +

since its in en_rep.h, please use "mlx5e_rep_" prefix.
thanks

>  struct mlx5e_neigh {
>  	struct net_device *dev;
>  	union {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 64f5c3f3dbb3..696544e2a25b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1250,12 +1250,10 @@ static void unready_flow_del(struct mlx5e_tc_flow *flow)
>  static void add_unready_flow(struct mlx5e_tc_flow *flow)
>  {
>  	struct mlx5_rep_uplink_priv *uplink_priv;
> -	struct mlx5e_rep_priv *rpriv;
>  	struct mlx5_eswitch *esw;
>  
>  	esw = flow->priv->mdev->priv.eswitch;
> -	rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> -	uplink_priv = &rpriv->uplink_priv;
> +	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
>  
>  	mutex_lock(&uplink_priv->unready_flows_lock);
>  	unready_flow_add(flow, &uplink_priv->unready_flows);
> @@ -1265,12 +1263,10 @@ static void add_unready_flow(struct mlx5e_tc_flow *flow)
>  static void remove_unready_flow(struct mlx5e_tc_flow *flow)
>  {
>  	struct mlx5_rep_uplink_priv *uplink_priv;
> -	struct mlx5e_rep_priv *rpriv;
>  	struct mlx5_eswitch *esw;
>  
>  	esw = flow->priv->mdev->priv.eswitch;
> -	rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> -	uplink_priv = &rpriv->uplink_priv;
> +	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
>  
>  	mutex_lock(&uplink_priv->unready_flows_lock);
>  	unready_flow_del(flow);
> @@ -1888,7 +1884,6 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
>  	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
>  	struct flow_match_enc_opts enc_opts_match;
>  	struct mlx5_rep_uplink_priv *uplink_priv;
> -	struct mlx5e_rep_priv *uplink_rpriv;
>  	struct tunnel_match_key tunnel_key;
>  	bool enc_opts_is_dont_care = true;
>  	u32 tun_id, enc_opts_id = 0;
> @@ -1897,8 +1892,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
>  	int err;
>  
>  	esw = priv->mdev->priv.eswitch;
> -	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> -	uplink_priv = &uplink_rpriv->uplink_priv;
> +	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
>  
>  	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
>  	err = mapping_add(uplink_priv->tunnel_mapping, &tunnel_key, &tun_id);
> @@ -1957,13 +1951,11 @@ static int mlx5e_lookup_flow_tunnel_id(struct mlx5e_priv *priv,
>  				       u32 *tun_id)
>  {
>  	struct mlx5_rep_uplink_priv *uplink_priv;
> -	struct mlx5e_rep_priv *uplink_rpriv;
>  	struct tunnel_match_key tunnel_key;
>  	struct mlx5_eswitch *esw;
>  
>  	esw = priv->mdev->priv.eswitch;
> -	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> -	uplink_priv = &uplink_rpriv->uplink_priv;
> +	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
>  
>  	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
>  	return mapping_find_by_data(uplink_priv->tunnel_mapping, &tunnel_key, tun_id);
> @@ -1974,12 +1966,10 @@ static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
>  	u32 enc_opts_id = flow->tunnel_id & ENC_OPTS_BITS_MASK;
>  	u32 tun_id = flow->tunnel_id >> ENC_OPTS_BITS;
>  	struct mlx5_rep_uplink_priv *uplink_priv;
> -	struct mlx5e_rep_priv *uplink_rpriv;
>  	struct mlx5_eswitch *esw;
>  
>  	esw = flow->priv->mdev->priv.eswitch;
> -	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> -	uplink_priv = &uplink_rpriv->uplink_priv;
> +	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
>  
>  	if (tun_id)
>  		mapping_remove(uplink_priv->tunnel_mapping, tun_id);
> @@ -4841,7 +4831,6 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
>  	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>  	struct flow_dissector_key_enc_opts enc_opts = {};
>  	struct mlx5_rep_uplink_priv *uplink_priv;
> -	struct mlx5e_rep_priv *uplink_rpriv;
>  	struct metadata_dst *tun_dst;
>  	struct tunnel_match_key key;
>  	u32 tun_id, enc_opts_id;
> @@ -4854,9 +4843,7 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
>  	if (!tun_id)
>  		return true;
>  
> -	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> -	uplink_priv = &uplink_rpriv->uplink_priv;
> -
> +	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
>  	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
>  	if (err) {
>  		WARN_ON_ONCE(true);
> @@ -4920,7 +4907,6 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
>  #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
>  	u32 chain = 0, reg_c0, reg_c1, tunnel_id, tuple_id;
>  	struct mlx5_rep_uplink_priv *uplink_priv;
> -	struct mlx5e_rep_priv *uplink_rpriv;
>  	struct tc_skb_ext *tc_skb_ext;
>  	struct mlx5_eswitch *esw;
>  	struct mlx5e_priv *priv;
> @@ -4956,9 +4942,7 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
>  		tc_skb_ext->chain = chain;
>  
>  		tuple_id = reg_c1 & TUPLE_ID_MAX;
> -
> -		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
> -		uplink_priv = &uplink_rpriv->uplink_priv;
> +		uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
>  		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, tuple_id))
>  			return false;
>  	}
> 
