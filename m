Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86437A32A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhEKJN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:13:56 -0400
Received: from mail-dm6nam10on2089.outbound.protection.outlook.com ([40.107.93.89]:15489
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231313AbhEKJNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:13:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gk5WvcbDYVZOyk/KoD8liM+PZwbVSBVv3DRLO3d0aGxkCmBBF+Tx+GVwOmFQWlpsD1/GyYYV20Mh7x5nj71IT5rfJbCocR0IHkOKOzrEpp2za/SFVN4Rwzi1M0jd+ldB3h2/PIIeCtgjQ+oMC5FOI6JVEHOWK02jHQgnQU+E5IxwjiERBEufyPImPXVUIX2r4bleBYztm6yD6RD+mCWysIskWBbtfRmUgkMFh39G/+mJ602ilqAasC/pQEm0EbBD15/hb2BOpEhJlfoRkbvlFFfunEIbHuo+qDIUcyKPuKLX110jybsMfVJBpjwbPiOm0DaB5K/rL9qNPzOTz4nDbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfeWkfpoAPN/HbuYJW+NlUkb52sBFv9Y7eKfvs1Ystg=;
 b=BnDXdd2pXmtktSmU3GBqYOkwx32V6WQcmVXuLVSLvSBb9EK3SEWsq24R2sU7kbovdRHiLfgeof/rK/7aNxCN+QDDT6R78gb6c2GcUY/+r0rqJ6sF9t+ZRVCMkaKkNQtxd8IgrSW1r9g1ormRvVAL/HPHPW+HH4IIKtBwt8xsYENrXuz2Ye0+/ZGsUAhMs3spWM0LhPWWOaJrsMhJva1MMBahfkRY48wMOjod2ycLGMJe7K693qLcl3l6+B/LJMMZ0lKUDxjxxBW8H0J0rEFvoRI0mCqun4y9KLFkt9yR43+OlSTiOlyfshMPlzPJ/zUKlVb2G2wHSBmFEmLiQrvwjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfeWkfpoAPN/HbuYJW+NlUkb52sBFv9Y7eKfvs1Ystg=;
 b=G7pfdkktE9Gx/mw/A9Iya4rliTcsHgqQ+ckwU+9WfYFOnouHLW4yzPhOOD62NFO8euqGCPH8K2MyyXiYXi7nMgoqxaHmVk/Z/TLQCQM3GiVMKb/eE2dID57eJosI35+huQ+dw4A/nd5dknmlUSsLrlgJ05o6tY5nmN6rszztCuZBH1hQrzw0m0oASSqi+NtU5Dp9EZScuCqKIMkPW1dXERAJ1UNd0PIdxxz9gOIHRdfDl/K8AhrTrfKIm3Mrclt+zdrDkhbzdDm3cpprToK24/An+q6cDJC7DOycL1XTx4sopC33BxN70Auz85PZYTh+W+9q6x2KbuBXFKHanYy+aw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5326.namprd12.prod.outlook.com (2603:10b6:5:39f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 11 May
 2021 09:12:47 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:12:47 +0000
Subject: Re: [net-next v2 01/11] net: bridge: mcast: rename multicast router
 lists and timers
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-2-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <5c126c23-9ef2-7d7e-7574-538287f604ef@nvidia.com>
Date:   Tue, 11 May 2021 12:12:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-2-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0069.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::20) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0069.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 09:12:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87c70aed-920b-4ef0-4c81-08d9145cf161
X-MS-TrafficTypeDiagnostic: DM4PR12MB5326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5326AC367822E046EC5CBC9DDF539@DM4PR12MB5326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y98MnuiXIxrIyzIG+uIUQ8OWaTJ6l2S6nqaTNAaBnuTRwcry/nXz4W8FdZmMZdWPPDFj9Mzy/VCg+qPpN0qjXAzxf7v5UoxbPdLFkUgR6LrQbN+XdckOr9RsgEKfK9/JbbAs5h+BrF/DfGUeTfAOSgV7yRYEqCde+w4nVigpx5tn2gjtyMnm+sfK/WnSWf1f/GbX6T2xI/CqNGqqjPFb+szhgOs5BKWm+NvJRrntKPwVATbdA1CFfTLUmaqL0Rz1l8b4SOAMIPtD2Vj30I4+MvcOgHP2QCeq5ecgX4NhS6aDhh662aykTSsgT0j1vi/D14WtJrDCrS48jRrLyAExyDIb9KIoHVUTCkxavChUgaFs7/vIkJBcfIqpZGX9WmYD7I1xg24szT9T3lR3XIGhVGA35LfrKOI6oNn2YOyAcxQjgRMswr/4JuhMKgTq7gmWi9KXE8matj6VpdSUDS7gpN2mHQ/rGQSM3A+VQQMkP/LcZIaCH7oBgAOzVZrYo5+4VegH+33JDKCTjRJiBaN3rgAS5d0NHZdpqP3/G2SNQlRAdNqAIQv9HJxWjQh8v/qFpIfeiG/X0gVzoOFODHobLnvMODjk7G2dmShToRJPHbJYIL6jnHXh/LOlioaRUbxffZZxwBrptMWnoWBioZx1SlS0063s+AiRa39supasHcWZ9z5PwWpBtCjUg13yVIXp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(31696002)(36756003)(86362001)(66574015)(38100700002)(83380400001)(6666004)(66946007)(66476007)(66556008)(2616005)(2906002)(4326008)(316002)(16576012)(54906003)(8676002)(6486002)(478600001)(956004)(16526019)(186003)(30864003)(26005)(8936002)(53546011)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b0F1bTcvSVUrajlWbWpwZGxHVitnQWhVN1pVSDZjRGdHcFFCNGphdCt0QUVn?=
 =?utf-8?B?cG91VDhFaXBZckkwZDMvWDJWSXIxSG1MWVN6b3k0b3BRZEZvNzJLYyt5dnhS?=
 =?utf-8?B?cnBsaEhSRWl4WDlWbmRjZmJETzFGTll3cWQ1TUw4dWFvbDEzNHBwUnJHOTNn?=
 =?utf-8?B?ZEtsdzV2QkhZSWpLMnpGcGpFRkgvWFV1d01IenU4bjNIbFhjSFd0TGQ3ampO?=
 =?utf-8?B?Y1NURUVkOTRoNGZMT0FDaWFvOW0va0diekdrNFB4OGN1UUtiSVRyaTdZL1F2?=
 =?utf-8?B?OERodEJoWmR3TEQ5NWF6ZkprWVRSUjgzbkRoUnVmanRramVNVGl5RlM0bi9u?=
 =?utf-8?B?TjVGczNjZ1FFMS84ZWZJK1pVTnJ3OGNWTSs3UTRFaTZ6cnZNMFBNYzlmdGhF?=
 =?utf-8?B?M0RjWUxMR0I1U1p6Z1Ridno1MkF0bStQMmhFVDBweWlwRFpQRG1obEZQUElN?=
 =?utf-8?B?VWlHejZBMGJ1QkwrUlZ4R3NiN2ZqNGQ1RFBvaUlyV1dDcGh2UEdPWjhSc0pl?=
 =?utf-8?B?Zk4zZEpzTHpHbEttWVhTejhHL0ljUXdxTzJFOVFza25RVUhYZnJLVFQrbXdM?=
 =?utf-8?B?ZHJLdlVzZTFjNjJjbENSOFU1NzRlWGgzK1llRzloYXFiS0t3Ni9FUEp6U2dJ?=
 =?utf-8?B?aUU3dlZOZFdzL3VKdjdkNFRobk5yR3JtVTU3aEV2S2lKcDBkV0g3Q3dYNWJl?=
 =?utf-8?B?OWRHZDNjU1VXR04xL2dWV0FxK1B1bzZyS0lYSDBKbVBxcWlJTkx0OWdaYmVS?=
 =?utf-8?B?MEEzYWRGWkYyZ1M3WDlraVBlaFBaNUdJNG15TzRXWWlOck9PNUJ5U3lwRUxS?=
 =?utf-8?B?Ymd5ZDlvYkltUmJacVZGQ0Vodjdjamt2VU93Mi8yb0pOWkNTVndzN0dyT0F1?=
 =?utf-8?B?dGFqUHJHY0xFb0RtdC9wSnFCcnNsUFZuNlV4TjExTDF1TjI1UmUwaXFzSmwv?=
 =?utf-8?B?UmVqQWV3aCtYWjBaaDF2QVc2OFMwRFBUbHplVjlHVzNMelBPaXozTTQxd1dj?=
 =?utf-8?B?bDNnK0lVaW1ncVFwU0dISTRXeVRvSFJnWm9sWDI2WTBvWVJsZjdmbGZNc3ov?=
 =?utf-8?B?SUtxc1hRekhxdmtOMGhhbDBLS1ZrNzAzdVJkUXNobDlNdVFXSEQyeURoRHRv?=
 =?utf-8?B?Um9VQU5ydGVxREUwandhdjBiVkZBYlhib2NWQmt1MkR3bkVTcjl2R1cvMHFF?=
 =?utf-8?B?bWRLR0hrS1E0dUROb0toNEFkeE1yRURxdjFJVmlpaU8rSVJRL3JkSE5nWCsv?=
 =?utf-8?B?TXNHWkZ0ZW1TUkRDU3d4L05JeG1tSXZ6Y1B5YllHRkZmbm9IWURZK0JBMW90?=
 =?utf-8?B?V29uRGk1R0l3L24wdkhkNGpFWGN4cHEwdG92REFvL3NQdkNjWTFGeFNkc3dh?=
 =?utf-8?B?MjhBQnJYaWQyMi91bmR4L3k5cktnU2VlOTNWREJVMXBCU2JWckxYVUpwRVB2?=
 =?utf-8?B?WFB1NHRFeUxHcTY2ZHZENzlMYkZNSERyR3lVdncxK2s1L2JHVTR5VGJuVUIr?=
 =?utf-8?B?WXVPUnBzUWZLYmNnd2prem4rOWRJSk9IVUhHdXRtcnNKY0NmMDlBUzkxZnds?=
 =?utf-8?B?RTBmV29JNHVaT3YwYUNoSHdrZUoxOWFCM0twUkdKOXNPd2dkeUlPRi9ORW42?=
 =?utf-8?B?dlhkQmNMQkxDOGFLQll0eXh2anJUOVhSbXMxMjQycG94MzVFNkJDdUZ0bUxN?=
 =?utf-8?B?enNmLzFvR2R2c2hoUnJrcDlOMzd5QWJvcmRtZ20wbm0wM3lHS1J1OTAyaXlD?=
 =?utf-8?Q?lUsCP+4ODACYUL1koK+nmZKuvRXvhwcpf2iuQ0J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c70aed-920b-4ef0-4c81-08d9145cf161
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:12:47.1227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZWFCfYg6IDG9IakKObBIc/9Ow0eF3e941cEk4MQ7QzfF372oe1Fs0mjIdAsaBYBlc33LahAAJers6cE6/J7Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:44, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants, rename the affected variable to the IPv4
> version first to avoid some renames in later commits.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_forward.c   |  2 +-
>  net/bridge/br_mdb.c       |  6 ++---
>  net/bridge/br_multicast.c | 48 +++++++++++++++++++--------------------
>  net/bridge/br_private.h   | 10 ++++----
>  4 files changed, 33 insertions(+), 33 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> index 6e9b049..3b67184 100644
> --- a/net/bridge/br_forward.c
> +++ b/net/bridge/br_forward.c
> @@ -290,7 +290,7 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
>  		struct net_bridge_port *port, *lport, *rport;
>  
>  		lport = p ? p->key.port : NULL;
> -		rport = hlist_entry_safe(rp, struct net_bridge_port, rlist);
> +		rport = hlist_entry_safe(rp, struct net_bridge_port, ip4_rlist);
>  
>  		if ((unsigned long)lport > (unsigned long)rport) {
>  			port = lport;
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 95fa4af..d61def8 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -23,14 +23,14 @@ static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
>  	struct net_bridge_port *p;
>  	struct nlattr *nest, *port_nest;
>  
> -	if (!br->multicast_router || hlist_empty(&br->router_list))
> +	if (!br->multicast_router || hlist_empty(&br->ip4_mc_router_list))
>  		return 0;
>  
>  	nest = nla_nest_start_noflag(skb, MDBA_ROUTER);
>  	if (nest == NULL)
>  		return -EMSGSIZE;
>  
> -	hlist_for_each_entry_rcu(p, &br->router_list, rlist) {
> +	hlist_for_each_entry_rcu(p, &br->ip4_mc_router_list, ip4_rlist) {
>  		if (!p)
>  			continue;
>  		port_nest = nla_nest_start_noflag(skb, MDBA_ROUTER_PORT);
> @@ -38,7 +38,7 @@ static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
>  			goto fail;
>  		if (nla_put_nohdr(skb, sizeof(u32), &p->dev->ifindex) ||
>  		    nla_put_u32(skb, MDBA_ROUTER_PATTR_TIMER,
> -				br_timer_value(&p->multicast_router_timer)) ||
> +				br_timer_value(&p->ip4_mc_router_timer)) ||
>  		    nla_put_u8(skb, MDBA_ROUTER_PATTR_TYPE,
>  			       p->multicast_router)) {
>  			nla_nest_cancel(skb, port_nest);
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 226bb05..6fe93a3 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1357,13 +1357,13 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
>  static void br_multicast_router_expired(struct timer_list *t)
>  {
>  	struct net_bridge_port *port =
> -			from_timer(port, t, multicast_router_timer);
> +			from_timer(port, t, ip4_mc_router_timer);
>  	struct net_bridge *br = port->br;
>  
>  	spin_lock(&br->multicast_lock);
>  	if (port->multicast_router == MDB_RTR_TYPE_DISABLED ||
>  	    port->multicast_router == MDB_RTR_TYPE_PERM ||
> -	    timer_pending(&port->multicast_router_timer))
> +	    timer_pending(&port->ip4_mc_router_timer))
>  		goto out;
>  
>  	__del_port_router(port);
> @@ -1386,12 +1386,12 @@ static void br_mc_router_state_change(struct net_bridge *p,
>  
>  static void br_multicast_local_router_expired(struct timer_list *t)
>  {
> -	struct net_bridge *br = from_timer(br, t, multicast_router_timer);
> +	struct net_bridge *br = from_timer(br, t, ip4_mc_router_timer);
>  
>  	spin_lock(&br->multicast_lock);
>  	if (br->multicast_router == MDB_RTR_TYPE_DISABLED ||
>  	    br->multicast_router == MDB_RTR_TYPE_PERM ||
> -	    timer_pending(&br->multicast_router_timer))
> +	    timer_pending(&br->ip4_mc_router_timer))
>  		goto out;
>  
>  	br_mc_router_state_change(br, false);
> @@ -1613,7 +1613,7 @@ int br_multicast_add_port(struct net_bridge_port *port)
>  	port->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
>  	port->multicast_eht_hosts_limit = BR_MCAST_DEFAULT_EHT_HOSTS_LIMIT;
>  
> -	timer_setup(&port->multicast_router_timer,
> +	timer_setup(&port->ip4_mc_router_timer,
>  		    br_multicast_router_expired, 0);
>  	timer_setup(&port->ip4_own_query.timer,
>  		    br_ip4_multicast_port_query_expired, 0);
> @@ -1649,7 +1649,7 @@ void br_multicast_del_port(struct net_bridge_port *port)
>  	hlist_move_list(&br->mcast_gc_list, &deleted_head);
>  	spin_unlock_bh(&br->multicast_lock);
>  	br_multicast_gc(&deleted_head);
> -	del_timer_sync(&port->multicast_router_timer);
> +	del_timer_sync(&port->ip4_mc_router_timer);
>  	free_percpu(port->mcast_stats);
>  }
>  
> @@ -1674,7 +1674,7 @@ static void __br_multicast_enable_port(struct net_bridge_port *port)
>  	br_multicast_enable(&port->ip6_own_query);
>  #endif
>  	if (port->multicast_router == MDB_RTR_TYPE_PERM &&
> -	    hlist_unhashed(&port->rlist))
> +	    hlist_unhashed(&port->ip4_rlist))
>  		br_multicast_add_router(br, port);
>  }
>  
> @@ -1700,7 +1700,7 @@ void br_multicast_disable_port(struct net_bridge_port *port)
>  
>  	__del_port_router(port);
>  
> -	del_timer(&port->multicast_router_timer);
> +	del_timer(&port->ip4_mc_router_timer);
>  	del_timer(&port->ip4_own_query.timer);
>  #if IS_ENABLED(CONFIG_IPV6)
>  	del_timer(&port->ip6_own_query.timer);
> @@ -2666,19 +2666,19 @@ static void br_multicast_add_router(struct net_bridge *br,
>  	struct net_bridge_port *p;
>  	struct hlist_node *slot = NULL;
>  
> -	if (!hlist_unhashed(&port->rlist))
> +	if (!hlist_unhashed(&port->ip4_rlist))
>  		return;
>  
> -	hlist_for_each_entry(p, &br->router_list, rlist) {
> +	hlist_for_each_entry(p, &br->ip4_mc_router_list, ip4_rlist) {
>  		if ((unsigned long) port >= (unsigned long) p)
>  			break;
> -		slot = &p->rlist;
> +		slot = &p->ip4_rlist;
>  	}
>  
>  	if (slot)
> -		hlist_add_behind_rcu(&port->rlist, slot);
> +		hlist_add_behind_rcu(&port->ip4_rlist, slot);
>  	else
> -		hlist_add_head_rcu(&port->rlist, &br->router_list);
> +		hlist_add_head_rcu(&port->ip4_rlist, &br->ip4_mc_router_list);
>  	br_rtr_notify(br->dev, port, RTM_NEWMDB);
>  	br_port_mc_router_state_change(port, true);
>  }
> @@ -2690,9 +2690,9 @@ static void br_multicast_mark_router(struct net_bridge *br,
>  
>  	if (!port) {
>  		if (br->multicast_router == MDB_RTR_TYPE_TEMP_QUERY) {
> -			if (!timer_pending(&br->multicast_router_timer))
> +			if (!timer_pending(&br->ip4_mc_router_timer))
>  				br_mc_router_state_change(br, true);
> -			mod_timer(&br->multicast_router_timer,
> +			mod_timer(&br->ip4_mc_router_timer,
>  				  now + br->multicast_querier_interval);
>  		}
>  		return;
> @@ -2704,7 +2704,7 @@ static void br_multicast_mark_router(struct net_bridge *br,
>  
>  	br_multicast_add_router(br, port);
>  
> -	mod_timer(&port->multicast_router_timer,
> +	mod_timer(&port->ip4_mc_router_timer,
>  		  now + br->multicast_querier_interval);
>  }
>  
> @@ -3316,7 +3316,7 @@ void br_multicast_init(struct net_bridge *br)
>  	br_opt_toggle(br, BROPT_HAS_IPV6_ADDR, true);
>  
>  	spin_lock_init(&br->multicast_lock);
> -	timer_setup(&br->multicast_router_timer,
> +	timer_setup(&br->ip4_mc_router_timer,
>  		    br_multicast_local_router_expired, 0);
>  	timer_setup(&br->ip4_other_query.timer,
>  		    br_ip4_multicast_querier_expired, 0);
> @@ -3416,7 +3416,7 @@ void br_multicast_open(struct net_bridge *br)
>  
>  void br_multicast_stop(struct net_bridge *br)
>  {
> -	del_timer_sync(&br->multicast_router_timer);
> +	del_timer_sync(&br->ip4_mc_router_timer);
>  	del_timer_sync(&br->ip4_other_query.timer);
>  	del_timer_sync(&br->ip4_own_query.timer);
>  #if IS_ENABLED(CONFIG_IPV6)
> @@ -3453,7 +3453,7 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
>  	case MDB_RTR_TYPE_DISABLED:
>  	case MDB_RTR_TYPE_PERM:
>  		br_mc_router_state_change(br, val == MDB_RTR_TYPE_PERM);
> -		del_timer(&br->multicast_router_timer);
> +		del_timer(&br->ip4_mc_router_timer);
>  		br->multicast_router = val;
>  		err = 0;
>  		break;
> @@ -3472,9 +3472,9 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
>  
>  static void __del_port_router(struct net_bridge_port *p)
>  {
> -	if (hlist_unhashed(&p->rlist))
> +	if (hlist_unhashed(&p->ip4_rlist))
>  		return;
> -	hlist_del_init_rcu(&p->rlist);
> +	hlist_del_init_rcu(&p->ip4_rlist);
>  	br_rtr_notify(p->br->dev, p, RTM_DELMDB);
>  	br_port_mc_router_state_change(p, false);
>  
> @@ -3493,7 +3493,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
>  	if (p->multicast_router == val) {
>  		/* Refresh the temp router port timer */
>  		if (p->multicast_router == MDB_RTR_TYPE_TEMP)
> -			mod_timer(&p->multicast_router_timer,
> +			mod_timer(&p->ip4_mc_router_timer,
>  				  now + br->multicast_querier_interval);
>  		err = 0;
>  		goto unlock;
> @@ -3502,7 +3502,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
>  	case MDB_RTR_TYPE_DISABLED:
>  		p->multicast_router = MDB_RTR_TYPE_DISABLED;
>  		__del_port_router(p);
> -		del_timer(&p->multicast_router_timer);
> +		del_timer(&p->ip4_mc_router_timer);
>  		break;
>  	case MDB_RTR_TYPE_TEMP_QUERY:
>  		p->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
> @@ -3510,7 +3510,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
>  		break;
>  	case MDB_RTR_TYPE_PERM:
>  		p->multicast_router = MDB_RTR_TYPE_PERM;
> -		del_timer(&p->multicast_router_timer);
> +		del_timer(&p->ip4_mc_router_timer);
>  		br_multicast_add_router(br, p);
>  		break;
>  	case MDB_RTR_TYPE_TEMP:
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 7ce8a77..26e91d2 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -307,6 +307,8 @@ struct net_bridge_port {
>  
>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>  	struct bridge_mcast_own_query	ip4_own_query;
> +	struct timer_list		ip4_mc_router_timer;
> +	struct hlist_node		ip4_rlist;
>  #if IS_ENABLED(CONFIG_IPV6)
>  	struct bridge_mcast_own_query	ip6_own_query;
>  #endif /* IS_ENABLED(CONFIG_IPV6) */
> @@ -314,9 +316,7 @@ struct net_bridge_port {
>  	u32				multicast_eht_hosts_cnt;
>  	unsigned char			multicast_router;
>  	struct bridge_mcast_stats	__percpu *mcast_stats;
> -	struct timer_list		multicast_router_timer;
>  	struct hlist_head		mglist;
> -	struct hlist_node		rlist;
>  #endif
>  
>  #ifdef CONFIG_SYSFS
> @@ -449,9 +449,9 @@ struct net_bridge {
>  
>  	struct hlist_head		mcast_gc_list;
>  	struct hlist_head		mdb_list;
> -	struct hlist_head		router_list;
>  
> -	struct timer_list		multicast_router_timer;
> +	struct hlist_head		ip4_mc_router_list;
> +	struct timer_list		ip4_mc_router_timer;
>  	struct bridge_mcast_other_query	ip4_other_query;
>  	struct bridge_mcast_own_query	ip4_own_query;
>  	struct bridge_mcast_querier	ip4_querier;
> @@ -868,7 +868,7 @@ static inline bool br_multicast_is_router(struct net_bridge *br)
>  {
>  	return br->multicast_router == 2 ||
>  	       (br->multicast_router == 1 &&
> -		timer_pending(&br->multicast_router_timer));
> +		timer_pending(&br->ip4_mc_router_timer));
>  }
>  
>  static inline bool
> 

