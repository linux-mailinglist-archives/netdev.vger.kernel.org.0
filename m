Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808C9296C98
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461980AbgJWKQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 06:16:10 -0400
Received: from mail-eopbgr80128.outbound.protection.outlook.com ([40.107.8.128]:6197
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S461941AbgJWKQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 06:16:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YffptOV6VkA9/Zo1wuTXNpc9ZGF2PSXK6OnbGJ2+5R0Yt4dPOiGrMRyeqPur4JEomeYCxWcaW0H9KLfbxNRw+EC0QYOuGVNJfuPLDukBZvxre4tOz/qnA6VB3ehdHPFoINU9UMvy4tQ8H1UTo8i51GPjsTcoEUVCQVgDni8rVzRMMsaKJKDRZjH8Rji+2VSSdWd+tGCDzHvtI/nTFZhoZDctirivE64mokltCR9qDyX4eWJBcl9oCFqTegEUEhk2zw20+0+JFZ3GD55pOWj3wMLUk9MyhlZoh/QhcFqpwnHECr5LFiZQcbyuUeXpvV9cgGeWs0J1ZKg+V+9yEtt4Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrSOgEn18QfxMvSFCgUMpgUTcSEk9LXooxCqyEVBeo0=;
 b=QMF+rkeCFRfdJHppYS4PJVuaD0PaJSALQ5DMED5QWxYZh6PIuYK2olikjqA0//LYFuztLlE5T0YM3+9LEzf7v7/k1vDjx5C1V2P75Rkmwi1VoMgtJVSl5G6U0bpkLTqz1PO8Ox91baUk9i/UUSpPik2hCGO4I/Cx/kBmwK1QNFDmM6PIIbnbEVRV4Q04GgwB7/wuZC9uxLCLVgQpdL4/TXhojKD5VtMWTuEhEMAYgmiP8dQ5DJDa885+XDtt67XKltcExz89ePM9gNGHGWQ+ZXJZoyPAVVGskfy2Z3ZZpB3ICNc6A0ct8kT796q1OWARvoEPSGCyDxDAXLkHuxtN3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrSOgEn18QfxMvSFCgUMpgUTcSEk9LXooxCqyEVBeo0=;
 b=XbTUswpy0RFBLlflORMPZu4VC1wS52h62CavbXQAd6KwhbFZMjMTGvneySqQivsCVfr4CsjVQL/G/AEOe4pgZqf+/44VALACXqG7UMiw327YEY5tZk2kmKph2xSvmL7bDwWZF9zrYLiXNPdpAoH/zH0RiIX9zvx1zljXSsKK9DY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VE1PR08MB5760.eurprd08.prod.outlook.com
 (2603:10a6:800:1af::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Fri, 23 Oct
 2020 10:16:04 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::e84c:a74e:9d0f:841a]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::e84c:a74e:9d0f:841a%8]) with mapi id 15.20.3477.028; Fri, 23 Oct 2020
 10:16:03 +0000
Subject: Re: [PATCH -next] neigh: remove the extra slash
To:     Zhang Qilong <zhangqilong3@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     lirongqing@baidu.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org
References: <20201023100146.34948-1-zhangqilong3@huawei.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <e3e6a453-6a73-3f88-e94b-fa39b38252d9@virtuozzo.com>
Date:   Fri, 23 Oct 2020 13:16:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201023100146.34948-1-zhangqilong3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM4PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:205::24)
 To VI1PR0801MB1678.eurprd08.prod.outlook.com (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM4PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:205::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 23 Oct 2020 10:16:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a6041d8-ca88-4614-16a1-08d8773ca59c
X-MS-TrafficTypeDiagnostic: VE1PR08MB5760:
X-Microsoft-Antispam-PRVS: <VE1PR08MB57605785FB69A412B56A0D84AA1A0@VE1PR08MB5760.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:262;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FGvvxD9cm4c2pxoSfuqqYj1NimWVX/fEIePLtVpA4W5Tngw03Dfg9tfrVyL+XlRlVf/UlbgYEkVHWf5zlh4coUmMK9735QQCtg6+HRGPM5qmmclOQ1U2UzLfF5EngjngY0B7WmjMFHhBy4/0yeKH0eGTC/lc/77Rxg7I7cVkp+sLbZhvDOxeLfPKZ1GkUwBT4P5NkmszS/uYKsm21y2jSHVcAjf2TUAIppXbf1cntSto2SmqeDYdWQpYj4fZj/4Om6URdTglIsQEIgELMgmg9XMtRC6vwerat6Yr07uI6uuz/9cnMmyw3L3YNKvftpcT+m+k3qupZw6zWDVK2A+jutSEWSLJAxZfV6fXrgSnn2NqUPqTkNmN2kJkxRr/Udf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39850400004)(16576012)(316002)(2906002)(36756003)(86362001)(26005)(478600001)(6486002)(5660300002)(31686004)(186003)(16526019)(8936002)(66946007)(83380400001)(66476007)(4744005)(52116002)(2616005)(956004)(53546011)(4326008)(31696002)(8676002)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SxbIuXaOoqhInM1NRdEbu9Pu3R0JZzOKzfrmDBPDi9bqwQ+FbgRxMDSLDmTEWYJlQHrZI3Sb1ZM4tPo8EuOGEfSBXbHqS67l9d+yOzMbKFgPot25vnrWJMIwxbIKD81ZVIdeYST30ZUdc9femnZWvJQwtKct/nQ4klfpDe7c6IX8upFOvtK0JxHb3uRKXE0KPfLIBxri4BRo3QEwd0Ug+OdN5Hdkkfqy2jdtA4z59/kD9Zfm9hk9BKSccYSblu+sS2c9DxGsz7vAbAWvm7fkV1kVS7ASqjo+tp/7lLcklFDyh8VEFKXjP+TU1fSe9G8naZVrbri99Vf3Gv4VODoAEvFCt66ujSWgnPPICldce37q6qcjs3dQ/B7y4TYzaKBunqlj3+SMcRSjI+Ma2dGywtCkZekrtrHcEA0blb1o6Z80b3sr4FMTozoi8oPfc3YYpfONJpCFfKRwRCGWLxp/o8nlZJ4g8UFceMpqrcIyEwaclTK3AJC1yo1P3ih02dQNu7j7anPzo/Rqgr75KHoaJbxc4uy80Ogw/rfEcRVvzvHayOGYQvkgeIiOlUQ5jqGeCDR7Ya4CFSQ27WdYmAb+k0HmBanTPY+wqn1xedreiEy2lEgwd8WSS+1eBjEubNAc3tSblTGoZApzRweV8RaOwA==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6041d8-ca88-4614-16a1-08d8773ca59c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2020 10:16:03.8226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4r6U45zGSifJKam+Wh51wyB5eRnU+T6ixjTrjAVCG9cfd02tGlz9z3wraDK2VgKnTextj+hDGmoZUHldGie4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5760
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/20 1:01 PM, Zhang Qilong wrote:
> The normal path has only one slash.

it is not normal path
this string is used to calculate number of symbols in "net/%s/neigh/%s" used below

> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>  net/core/neighbour.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 8e39e28b0a8d..503501842a7d 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -3623,7 +3623,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
>  	int i;
>  	struct neigh_sysctl_table *t;
>  	const char *dev_name_source;
> -	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
> +	char neigh_path[sizeof("net/neigh/") + IFNAMSIZ + IFNAMSIZ];
>  	char *p_name;
>  
>  	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);
> 
