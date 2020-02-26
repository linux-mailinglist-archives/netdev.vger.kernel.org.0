Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDCEC16FB57
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgBZJxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:53:15 -0500
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:8327
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbgBZJxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 04:53:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhpyP+DjRlsPLs+xLxfRP+rZb9jy7dwDCD5HkLL86bfevRt/J4rkG5Car/FjtSkNGSGq7eg1fLHo3Qqq56ocNhAEaJzdzLPMdkzGJ63iWBrY+eyXSseGfnRGUSY/Rc1McIn6RYnvlj60Phy2oz26wjtSbfBHgtheMemNxAlufNgDr6b1WmdO1vqLiXDSaDchpjzunoSzguUHkfTioZZodVjQsMlntrmoXNCEg80bn7ciCFT2D1wCirJoe02qZR1P436zGD5TvruC8FXQqJhwkrHVUt6PVEa8QUl6uxgnkvy08Tk9oRSdHFuxW9XEZJtpYhOgY9SV9fpPfVePL7UsMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxYN6hInXCULpcsdK2L6aqKBELCUqDb6liZMjPWYrMk=;
 b=kP7dJM+QkCflqj0iNwmBS8+I8j0NAKQrM2C5MdD9qcfUvGrFYzQ+NVp62w2IT5KrosWk1XdKONsMnJhhitk57PiVzgGSrXrh1gnGp9A8HrKPrL+kNuJD/g110MNFN9YaWbjl756Hc/CBhv0nHrfJ+VE3aDWmzyHnBnNczH0vR1D7zx88EhyUW5bY7n+Lx+z6IMKsVYm8xm9b03ckUHoDx8UEoUfojVurR58zhRqaZIZVOPTM/eMYQZBY6D8UaPes0aq9mfrgX7mk6RIGtckOgohti4Ff64Avs9k9nqXI/ufQ0da8IE1Q0wrihJYbMVzBfnv3nCvqqnOmKF9oeRe9XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxYN6hInXCULpcsdK2L6aqKBELCUqDb6liZMjPWYrMk=;
 b=gyqiLoORTy5nflKwb/9EDZMb6jFLd9m6v8WSBpx/Krf/yqAY+MzZDZSs/C3AtYIfrGozV5UeCB8wYGShd+f4+SrxsK+nVnJhi6xL5AZELEmEWUDfFk4cIMGLZPXKFltE1Vf0LdnlcwaJS8IuHE6czETRQup5p12ZmXUeEdlgTcg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5443.eurprd05.prod.outlook.com (20.177.117.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Wed, 26 Feb 2020 09:53:08 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 09:53:08 +0000
Subject: Re: [net-next] net/mlx5e: Remove the unnecessary parameter
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1582646588-91471-1-git-send-email-xiangxia.m.yue@gmail.com>
 <5361639fee997ea6239d6115978f86f26fb918b4.camel@mellanox.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <5c4604cd-1cfc-6116-12e6-95054e77736a@mellanox.com>
Date:   Wed, 26 Feb 2020 11:53:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <5361639fee997ea6239d6115978f86f26fb918b4.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR06CA0103.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::44) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR06CA0103.eurprd06.prod.outlook.com (2603:10a6:208:fa::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 09:53:07 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3e00bb48-0c79-462b-a0a7-08d7baa1aee9
X-MS-TrafficTypeDiagnostic: AM6PR05MB5443:|AM6PR05MB5443:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB544344436F6C868DEF376E2ACFEA0@AM6PR05MB5443.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(189003)(110136005)(6486002)(8936002)(81156014)(81166006)(31686004)(2616005)(2906002)(8676002)(16576012)(956004)(36756003)(66476007)(6666004)(53546011)(66946007)(66556008)(498600001)(5660300002)(86362001)(26005)(4326008)(31696002)(52116002)(186003)(16526019);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5443;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWPZ2KmmtxNjvcYPVjvAMEGL1vWstMk0Adgs76tqIyYnx3lk37HVnRVvtpsZwZK2JbhKuknQXIKPPkIoQSo2uhrArwregWpr+hMOtIC8WF2ljXKeCS2fWF/NDrbn8cMCs+hurxkTSJBltamQvA/jP0+DYYEL4mwFLd8fWFML8BbbqMvD9DGZYXYHp6wpIelUWsuKTPGz80MUk/C2MUE4YU3AZBJmriXwtG76nwc5J8ExmZg22pI853e1YiUtOz0xiM/QVLGx3fOypT+0KQKbRNgAiadgzYRoVDhWFO2BlDdlYZ2YMiC286RlX3rXptytqr5Ktjm8aLBozowyLIpgVqZZva/xdB3m8/M9JMVB0+OOgtaJGmOcMFbEyGb/RpaldvZ//jKL+egkuXlVBzR6o+UctPSVwWxJ8Jab+kTMhwu8kkP5DD69CbT7c+pXro7g
X-MS-Exchange-AntiSpam-MessageData: Tvzpysa0lhphIVm5n9+gN+vsf9zLNpIsjwjbrOcdJ/3YTsUzCRqOtnkIqpIH+xH2kmmqRc8bKalEoTnwkVtv9lM/MvAI6uIVWmRtJctNEdt28uCG6ZWhxpeWkuAoYUZHlsTOAIL+SfyZyEDAC8cK9g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e00bb48-0c79-462b-a0a7-08d7baa1aee9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 09:53:08.4581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKWbPWn0G/cNoNPlq+5LcXW7rC0CLvwNGKQ/zKvKfx6guQdTUZxdWnNWuU+XPL6xu1fjMmZ8rg059T5sC2pR7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5443
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/26/2020 12:50 AM, Saeed Mahameed wrote:
> On Wed, 2020-02-26 at 00:03 +0800, xiangxia.m.yue@gmail.com wrote:
>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>
>> The parameter desired_size is always 0, and there is only one
>> function calling the mlx5_esw_chains_get_avail_sz_from_pool.
>> Deleting the parameter desired_size.
> Paul, what is the reasoning behind desired size, i confirm that it  is
> not actually used right now, do we have a pending patch that needs it
> ? 
> if this is not going to happen in the near future i vote to apply this
> patch and bring it back when needed.

Right, it will be used in a following patch that reduces the size given for nft flow tables.

I planned on submitting it after connection tracking offload is complete, but it can be sent now.

This is the patch:

From 66d3cb9706ed09f00150a42f555a51404602bba4 Mon Sep 17 00:00:00 2001
From: Paul Blakey <paulb@mellanox.com>
Date: Wed, 8 Jan 2020 14:31:53 +0200
Subject: [PATCH] net/mlx5: Allocate smaller size tables for ft offload

Instead of giving ft tables one of the largest tables available - 4M,
give it a more reasonable size - 64k. Especially since it will
always be created as a miss hook in the following patch.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 3990066..dabbc05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -39,6 +39,7 @@
                                          1 * 1024 * 1024,
                                          64 * 1024,
                                          128 };
+#define ESW_FT_TBL_SZ (64 * 1024)

 struct mlx5_esw_chains_priv {
        struct rhashtable chains_ht;
@@ -205,7 +206,9 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
                ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
                                  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);

-       sz = mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
+       sz = (chain == mlx5_esw_chains_get_ft_chain(esw)) ?
+            mlx5_esw_chains_get_avail_sz_from_pool(esw, ESW_FT_TBL_SZ) :
+            mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
        if (!sz)
                return ERR_PTR(-ENOSPC);
        ft_attr.max_fte = sz;
--
1.8.3.1


>
> Thanks,
> Saeed.
>
>> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>> ---
>>  .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c | 11
>> +++--------
>>  1 file changed, 3 insertions(+), 8 deletions(-)
>>
>> diff --git
>> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
>> index c5a446e..ce5b7e1 100644
>> ---
>> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
>> +++
>> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
>> @@ -134,19 +134,14 @@ static unsigned int
>> mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
>>  	return FDB_TC_LEVELS_PER_PRIO;
>>  }
>>  
>> -#define POOL_NEXT_SIZE 0
>>  static int
>> -mlx5_esw_chains_get_avail_sz_from_pool(struct mlx5_eswitch *esw,
>> -				       int desired_size)
>> +mlx5_esw_chains_get_avail_sz_from_pool(struct mlx5_eswitch *esw)
>>  {
>>  	int i, found_i = -1;
>>  
>>  	for (i = ARRAY_SIZE(ESW_POOLS) - 1; i >= 0; i--) {
>> -		if (fdb_pool_left(esw)[i] && ESW_POOLS[i] >
>> desired_size) {
>> +		if (fdb_pool_left(esw)[i])
>>  			found_i = i;
>> -			if (desired_size != POOL_NEXT_SIZE)
>> -				break;
>> -		}
>>  	}
>>  
>>  	if (found_i != -1) {
>> @@ -198,7 +193,7 @@ static unsigned int
>> mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
>>  		ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
>>  				  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
>>  
>> -	sz = mlx5_esw_chains_get_avail_sz_from_pool(esw,
>> POOL_NEXT_SIZE);
>> +	sz = mlx5_esw_chains_get_avail_sz_from_pool(esw);
>>  	if (!sz)
>>  		return ERR_PTR(-ENOSPC);
>>  	ft_attr.max_fte = sz;
