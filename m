Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F1D2C786B
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 09:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgK2ICh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 03:02:37 -0500
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:34273
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725468AbgK2ICg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 03:02:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gF3A9LbWksrq6rJxMLs08Hsz0rd+T9p7CEhXFzrkkjBEsyvlCENU6QLEyk972Lm80UNnkhCZFB4mx5vHXY9wPUsc0ArDxClccsMUvLGMOnEUzxoaXI7NsUCuT4xU6EkDymb57LwitpGGIgaewTjZPFLph9Ve3qfzf6qd2Hk9KtcUEEwvhw7l3niZftk579shAI4ygHf/4kYwz2DqDPzuqu2n6uOW7iGISrVN+6CBLurBR1UQOVPgcK+QKve5Qq+P85NAV0HoyCArnEbpbh3VEAV9aKtmLjg9got/tDqen0u4VMZl0jIBrxpRV6NWxzE3THb+51iA5IlcLcAuYyIeKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IeGQr9QUHmJIqHWPPj6JlK+CB62LUD9TTQg8f/8wlY=;
 b=kW1CWnOYFmfKgkpMUZ81HzN8hr1+JJwpc36vQp/weazhRCYHO8y4RhOsPNPPxhGz58ng7t70ANOln8QB7oKhnxkzgDrcpO7uEl1xxemoilQFGoHBsR6VcIBgYceTqsyyV4ZTU3IcpZhgsbvE4grPHZTFapRtfUrjEQbB3NcKIy8QIB4et0ADpYLk1FZsUdtHa2uD7ceJEDi46k9DUIwV8Pagt0ObURl1f1SgXMc+BxaqrcFF1EhSA3p+ELd8h/Ok04KT7ytD+P7312YJrrRpA89CsmmiUI9zP4H3EPmRoxjEc7IQdiS6P2KkIEWnw+5FbjhAvC5Ek5oE+ryvGautlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IeGQr9QUHmJIqHWPPj6JlK+CB62LUD9TTQg8f/8wlY=;
 b=HiIJ3IodvMV7lLqPsfg61++akHkayu4f8bubuNeo7I/i8SWtFeEdnO6nK6zgMUqmT9ioKPs9nIpFC7s1tMB6EZhuYrfx5bt2v/ozIvq/5v3+NXiXfNZ4RhdWtum4XusfH37+2L53fjUzEr7lWX14SNWzTmgHCFK8YWKi9iD4NN8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB2603.namprd11.prod.outlook.com (2603:10b6:5:c6::21) by
 DM6PR11MB4220.namprd11.prod.outlook.com (2603:10b6:5:204::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.25; Sun, 29 Nov 2020 08:01:46 +0000
Received: from DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::54f7:13ae:91ef:6ae4]) by DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::54f7:13ae:91ef:6ae4%5]) with mapi id 15.20.3589.022; Sun, 29 Nov 2020
 08:01:46 +0000
Subject: Re: [PATCH 01/10 net-next] net/tipc: fix tipc header files for
 kernel-doc
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jon Maloy <jmaloy@redhat.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
 <20201125042026.25374-4-rdunlap@infradead.org>
From:   Ying Xue <ying.xue@windriver.com>
Autocrypt: addr=ying.xue@windriver.com; keydata=
 xjMEX1nnURYJKwYBBAHaRw8BAQdAZxROH3r87AOhslT5tP2cdYcg89+pbHiYf+LIny/C0fLN
 GDx5aW5nLnh1ZUB3aW5kcml2ZXIuY29tPsJ3BBAWCgAfBQJfWedRBgsJBwgDAgQVCAoCAxYC
 AQIZAQIbAwIeAQAKCRC3Qmz/Z9beRSLiAP9kPgF+mG4F3elbrVTen/sybJfZidnvF1YVq5Ho
 sUbt+wEA6ByAVvGqlEbt4SE1JP6xVgTzwlwihyCgl/byRAQzeg7OOARfWedREgorBgEEAZdV
 AQUBAQdAsdHm3QQyX4RnhnVEmywHpipu0cUyHWeuAkYuLavc5QYDAQgHwmEEGBYIAAkFAl9Z
 51ECGwwACgkQt0Js/2fW3kXZKAEA0jTzhaLbmprQxi1BbUmAYtlpQCrrjCWdpFGwt5O3yO8A
 /jVE1VxnEgu71mYXX1QE1Lngk+SPVEfLm0BVZFk9fBAA
Message-ID: <14e84721-b2a4-9acd-c00f-c56b2aff3076@windriver.com>
Date:   Sun, 29 Nov 2020 16:01:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201125042026.25374-4-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR02CA0132.apcprd02.prod.outlook.com
 (2603:1096:202:16::16) To DM6PR11MB2603.namprd11.prod.outlook.com
 (2603:10b6:5:c6::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.155.152] (60.247.85.82) by HK2PR02CA0132.apcprd02.prod.outlook.com (2603:1096:202:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Sun, 29 Nov 2020 08:01:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ff27475-4313-4b62-3b6b-08d8943d047f
X-MS-TrafficTypeDiagnostic: DM6PR11MB4220:
X-Microsoft-Antispam-PRVS: <DM6PR11MB42204F8033195861E700032384F60@DM6PR11MB4220.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yqNxUjaTDQZTdX/mXXBzvPmn0mDNGxbnsH6B2CqdnIjuisbyyxoQ7tt184sIVsgfQAZB6WB92nNZlAtvs3OSSYGJReE4b+sU0bzsHwopgMj0sYfG7uI+hKav37Z4cB4T3847OAkyex/51S1go2zE4c64brmfB7dkknfPFy1+aob4zC7fDZx4yncloqukQIa3skoT2b6/Nomw3V/sbWzKERiljL/RUhGHbiK330VuPQ1K9Za/KaIOBCxUyHLEtO595kqFUTZe3lcuj+EfMLycpH5dd30wrh2af5WJ84gihCcIOEXywnkDEqp6SmtRqb5T/NEOotWDlrB3L8QL9ZacbRAtCi1v12SS+TJ4rBy2arDiCGEUmwAMl8Ukz4LGTO+ex299jKj1o/vaFDfPKWAsps5Iyzi2C5CfJBBEezz35MC4uByBlMRp+D4QicrQQqor
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(186003)(53546011)(66556008)(8936002)(6666004)(956004)(54906003)(16576012)(2906002)(508600001)(2616005)(52116002)(31696002)(26005)(5660300002)(34490700003)(16526019)(83380400001)(86362001)(8676002)(6486002)(66946007)(66476007)(6706004)(36756003)(31686004)(4326008)(44832011)(6916009)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V0lxYThpOWpKTlZ4NUZvT095T3U5d1ZmakxPdnBYcEI4SEl6NkoxSUZSMFJn?=
 =?utf-8?B?cTExcUhyZ0F2cnNjWkFURTRpZjlpLzNwVEt3bDkwbXRnT1NNdkpYZGxEbWZR?=
 =?utf-8?B?S3A2eFU5SDhBVWsxOWtTUlVvM2pIMmJhcnlTTW5OSFE3WGF0MVUxSHlkYUxI?=
 =?utf-8?B?ZDlzV2g3TDQ3U0xJYUZhTC9QWnFxZEpDSjR1ck12Mmc4d3dRVlhZaCttZ1BE?=
 =?utf-8?B?TkxaUUJWMHRDT1ZaR3Niek55ejhNdWFiSmkvTUV2L2ZSRHIvNkgvRlVGTkV5?=
 =?utf-8?B?MFIvc0NEaGZiMG1ob0RaNzNRZXJOWUQrNFJLUXZCUUFkdm1BQzVhZ2djTXg0?=
 =?utf-8?B?V25MV29NcHBMWm1tR1JRZjNmRVdQaW5zK2p3cmlCeVhxbGJwVm9ucnFreHo0?=
 =?utf-8?B?TXpPKytONGRMeDY4UXRtekNPZDN2bHVyS0Rsd3hhbVVyT2FqckdRMlU4Wk1v?=
 =?utf-8?B?ZFRmV3FiMzMxT2RSdCt6d21Sb0RJMXBCbk1QMzlJYVlCKzlxYThpR3kvQkN4?=
 =?utf-8?B?dkk5RXJYVnlFNDZBdkVYKzRTcUhscXlUOERYeS9PTmdGblR2Zm5BR2RPK1A2?=
 =?utf-8?B?RWk2VzB2WW00QUNmWTJyeExkdW0wQjlwN0xsZzNFaXVENlVkZVNoTGc0K1da?=
 =?utf-8?B?clIybkY2dVJpWC9WRmtLTk9EQkFVUXlXNUY2dkY5N2JkbmJLNzhQNGxuajQ4?=
 =?utf-8?B?ZWY2YkNIaUN5b0p1NXg2U203Zm9xMXRqOENpYWgvZXNUZlV2SFpjampIK2k0?=
 =?utf-8?B?UVhpR21HRGFUNmloRDJ4dGpncEhaZEhXS1hMT0NJa2x6WGNWN2lqSUdLSzk5?=
 =?utf-8?B?WWpqSDgwaWxidTJiRmk3di9LczVzQTBoYWRhK016UEczUXlvMlIwbjViVjJK?=
 =?utf-8?B?aW95V1BoUmx5a0xzY0ZibEhSYUdndUVYczlCUlBWTFQ2aEozNkdmQ0x5UUpw?=
 =?utf-8?B?aEI0SVJZNzFoenlmNXdIT09xVDlyNGdJbFhKZzY0NXpOTWF5YjZtNi9pVXJn?=
 =?utf-8?B?QjJDKytNVUQ2dE1QWm1XSm5ZWW9BNWh5N2Izck9XYVJ0Q3FRSktvSDJ6YlJ3?=
 =?utf-8?B?SDhibG1XeThGUjMxVndBQ2lXWVh0WjQ4THFudit3cUg2L0hRMlpRWWlSenRH?=
 =?utf-8?B?UElnaGdmU3RiZFpLbWlNcEdxR3k4Yzd1QWtORjBGSUcxN29kbmdPa1hxdHor?=
 =?utf-8?B?VHpTTnl4NUtPeDFvdHl4U0NyTGY0UkVyNGZxWmllTW15WnJuWlRtblNuTkxy?=
 =?utf-8?B?V3pFSUlHdE0xbnhWMDM4Y2hTMlJqZll6bWZORXp0MHJRaERjV0FuakxMVGQv?=
 =?utf-8?Q?SlWaEo2hYoz+n5kZRe+/E2ZR6CVh/EP3VI?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff27475-4313-4b62-3b6b-08d8943d047f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2020 08:01:46.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xduESi4aSecVogJmLuKis81EZUKdOAMgCJfwN4vouuHgYa2+6EUfLLgAeBU6eScpVBtnLwEq5V+9M9I9NWEI6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4220
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see my comments about parameters marked with "FIXME":

On 11/25/20 12:20 PM, Randy Dunlap wrote:
> Fix tipc header files for adding to the networking docbook.
> 
> Remove some uses of "/**" that were not kernel-doc notation.
> 
> Fix some source formatting to eliminate Sphinx warnings.
> 
> Add missing struct member and function argument kernel-doc descriptions.
> 
> Documentation/networking/tipc:18: ../net/tipc/name_table.h:65: WARNING: Unexpected indentation.
> Documentation/networking/tipc:18: ../net/tipc/name_table.h:66: WARNING: Block quote ends without a blank line; unexpected unindent.
> 
> ../net/tipc/bearer.h:128: warning: Function parameter or member 'min_win' not described in 'tipc_media'
> ../net/tipc/bearer.h:128: warning: Function parameter or member 'max_win' not described in 'tipc_media'
> 
> ../net/tipc/bearer.h:171: warning: Function parameter or member 'min_win' not described in 'tipc_bearer'
> ../net/tipc/bearer.h:171: warning: Function parameter or member 'max_win' not described in 'tipc_bearer'
> ../net/tipc/bearer.h:171: warning: Function parameter or member 'disc' not described in 'tipc_bearer'
> ../net/tipc/bearer.h:171: warning: Function parameter or member 'up' not described in 'tipc_bearer'
> ../net/tipc/bearer.h:171: warning: Function parameter or member 'refcnt' not described in 'tipc_bearer'
> 
> ../net/tipc/name_distr.h:68: warning: Function parameter or member 'port' not described in 'distr_item'
> 
> ../net/tipc/name_table.h:111: warning: Function parameter or member 'services' not described in 'name_table'
> ../net/tipc/name_table.h:111: warning: Function parameter or member 'cluster_scope_lock' not described in 'name_table'
> ../net/tipc/name_table.h:111: warning: Function parameter or member 'rc_dests' not described in 'name_table'
> ../net/tipc/name_table.h:111: warning: Function parameter or member 'snd_nxt' not described in 'name_table'
> 
> ../net/tipc/subscr.h:67: warning: Function parameter or member 'kref' not described in 'tipc_subscription'
> ../net/tipc/subscr.h:67: warning: Function parameter or member 'net' not described in 'tipc_subscription'
> ../net/tipc/subscr.h:67: warning: Function parameter or member 'service_list' not described in 'tipc_subscription'
> ../net/tipc/subscr.h:67: warning: Function parameter or member 'conid' not described in 'tipc_subscription'
> ../net/tipc/subscr.h:67: warning: Function parameter or member 'inactive' not described in 'tipc_subscription'
> ../net/tipc/subscr.h:67: warning: Function parameter or member 'lock' not described in 'tipc_subscription'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: netdev@vger.kernel.org
> Cc: tipc-discussion@lists.sourceforge.net
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/tipc/bearer.h     |   10 +++++++---
>  net/tipc/crypto.h     |    6 +++---
>  net/tipc/name_distr.h |    2 +-
>  net/tipc/name_table.h |    9 ++++++---
>  net/tipc/subscr.h     |   11 +++++++----
>  5 files changed, 24 insertions(+), 14 deletions(-)
> 
> --- linux-next-20201102.orig/net/tipc/bearer.h
> +++ linux-next-20201102/net/tipc/bearer.h
> @@ -93,7 +93,8 @@ struct tipc_bearer;
>   * @raw2addr: convert from raw addr format to media addr format
>   * @priority: default link (and bearer) priority
>   * @tolerance: default time (in ms) before declaring link failure
> - * @window: default window (in packets) before declaring link congestion
> + * @min_win: minimum window (in packets) before declaring link congestion
> + * @max_win: maximum window (in packets) before declaring link congestion
>   * @mtu: max packet size bearer can support for media type not dependent on
>   * underlying device MTU
>   * @type_id: TIPC media identifier
> @@ -138,12 +139,15 @@ struct tipc_media {
>   * @pt: packet type for bearer
>   * @rcu: rcu struct for tipc_bearer
>   * @priority: default link priority for bearer
> - * @window: default window size for bearer
> + * @min_win: minimum window (in packets) before declaring link congestion
> + * @max_win: maximum window (in packets) before declaring link congestion
>   * @tolerance: default link tolerance for bearer
>   * @domain: network domain to which links can be established
>   * @identity: array index of this bearer within TIPC bearer array
> - * @link_req: ptr to (optional) structure making periodic link setup requests
> + * @disc: ptr to link setup request
>   * @net_plane: network plane ('A' through 'H') currently associated with bearer
> + * @up: bearer up flag (bit 0)
> + * @refcnt: tipc_bearer reference counter
>   *
>   * Note: media-specific code is responsible for initialization of the fields
>   * indicated below when a bearer is enabled; TIPC's generic bearer code takes
> --- linux-next-20201102.orig/net/tipc/crypto.h
> +++ linux-next-20201102/net/tipc/crypto.h
> @@ -1,5 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -/**
> +/*
>   * net/tipc/crypto.h: Include file for TIPC crypto
>   *
>   * Copyright (c) 2019, Ericsson AB
> @@ -53,7 +53,7 @@
>  #define TIPC_AES_GCM_IV_SIZE		12
>  #define TIPC_AES_GCM_TAG_SIZE		16
>  
> -/**
> +/*
>   * TIPC crypto modes:
>   * - CLUSTER_KEY:
>   *	One single key is used for both TX & RX in all nodes in the cluster.
> @@ -69,7 +69,7 @@ enum {
>  extern int sysctl_tipc_max_tfms __read_mostly;
>  extern int sysctl_tipc_key_exchange_enabled __read_mostly;
>  
> -/**
> +/*
>   * TIPC encryption message format:
>   *
>   *     3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
> --- linux-next-20201102.orig/net/tipc/name_distr.h
> +++ linux-next-20201102/net/tipc/name_distr.h
> @@ -46,7 +46,7 @@
>   * @type: name sequence type
>   * @lower: name sequence lower bound
>   * @upper: name sequence upper bound
> - * @ref: publishing port reference
> + * @port: publishing port reference
>   * @key: publication key
>   *
>   * ===> All fields are stored in network byte order. <===
> --- linux-next-20201102.orig/net/tipc/name_table.h
> +++ linux-next-20201102/net/tipc/name_table.h
> @@ -60,8 +60,8 @@ struct tipc_group;
>   * @key: publication key, unique across the cluster
>   * @id: publication id
>   * @binding_node: all publications from the same node which bound this one
> - * - Remote publications: in node->publ_list
> - *   Used by node/name distr to withdraw publications when node is lost
> + * - Remote publications: in node->publ_list;
> + * Used by node/name distr to withdraw publications when node is lost
>   * - Local/node scope publications: in name_table->node_scope list
>   * - Local/cluster scope publications: in name_table->cluster_scope list
>   * @binding_sock: all publications from the same socket which bound this one
> @@ -92,13 +92,16 @@ struct publication {
>  
>  /**
>   * struct name_table - table containing all existing port name publications
> - * @seq_hlist: name sequence hash lists
> + * @services: name sequence hash lists
>   * @node_scope: all local publications with node scope
>   *               - used by name_distr during re-init of name table
>   * @cluster_scope: all local publications with cluster scope
>   *               - used by name_distr to send bulk updates to new nodes
>   *               - used by name_distr during re-init of name table
> + * @cluster_scope_lock: lock for accessing @cluster_scope
>   * @local_publ_count: number of publications issued by this node
> + * @rc_dests: broadcast destinations counter (FIXME)

@rc_dests: destination node counter

> + * @snd_nxt: next sequence number to be used
>   */
>  struct name_table {
>  	struct hlist_head services[TIPC_NAMETBL_SIZE];
> --- linux-next-20201102.orig/net/tipc/subscr.h
> +++ linux-next-20201102/net/tipc/subscr.h
> @@ -47,12 +47,15 @@ struct tipc_conn;
>  
>  /**
>   * struct tipc_subscription - TIPC network topology subscription object
> - * @subscriber: pointer to its subscriber
> - * @seq: name sequence associated with subscription
> + * @kref: reference count for this subscription
> + * @net: network namespace associated with subscription
>   * @timer: timer governing subscription duration (optional)
> - * @nameseq_list: adjacent subscriptions in name sequence's subscription list
> + * @service_list: adjacent subscriptions in name sequence's subscription list
>   * @sub_list: adjacent subscriptions in subscriber's subscription list
>   * @evt: template for events generated by subscription
> + * @conid: connection ID for this subscription (FIXME)

@conid: connection identifier of topology server

> + * @inactive: true if this subscription is inactive
> + * @lock: serialize up/down and timer events
>   */
>  struct tipc_subscription {
>  	struct kref kref;
> @@ -63,7 +66,7 @@ struct tipc_subscription {
>  	struct tipc_event evt;
>  	int conid;
>  	bool inactive;
> -	spinlock_t lock; /* serialize up/down and timer events */
> +	spinlock_t lock;
>  };
>  
>  struct tipc_subscription *tipc_sub_subscribe(struct net *net,
> 
