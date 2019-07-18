Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61986D3D7
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 20:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390864AbfGRS0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 14:26:15 -0400
Received: from mail.us.es ([193.147.175.20]:38564 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbfGRS0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 14:26:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4BD2EB5AB0
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 20:26:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C6DA91F4
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 20:26:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 316DF115107; Thu, 18 Jul 2019 20:26:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8692FDA704;
        Thu, 18 Jul 2019 20:26:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 18 Jul 2019 20:26:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 53B7A4265A31;
        Thu, 18 Jul 2019 20:26:09 +0200 (CEST)
Date:   Thu, 18 Jul 2019 20:26:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     yangxingwu <xingwu.yang@gmail.com>
Cc:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH v2] net/netfilter: remove unnecessary spaces
Message-ID: <20190718182608.apjgz5xbpsyvxfp6@salvia>
References: <20190715082747.fdlpvekbqyhwx724@salvia>
 <20190716021301.27753-1-xingwu.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716021301.27753-1-xingwu.yang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good, but you will have to wait until net-next reopens:

http://vger.kernel.org/~davem/net-next.html

Will keep this in my patchwork until that happens.

Thanks.

On Tue, Jul 16, 2019 at 10:13:01AM +0800, yangxingwu wrote:
> this patch removes extra spaces
> 
> Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> ---
>  net/netfilter/ipset/ip_set_hash_gen.h  | 2 +-
>  net/netfilter/ipset/ip_set_list_set.c  | 2 +-
>  net/netfilter/ipvs/ip_vs_core.c        | 2 +-
>  net/netfilter/ipvs/ip_vs_mh.c          | 4 ++--
>  net/netfilter/ipvs/ip_vs_proto_tcp.c   | 2 +-
>  net/netfilter/nf_conntrack_ftp.c       | 2 +-
>  net/netfilter/nf_conntrack_proto_tcp.c | 2 +-
>  net/netfilter/nfnetlink_log.c          | 4 ++--
>  net/netfilter/nfnetlink_queue.c        | 4 ++--
>  net/netfilter/xt_IDLETIMER.c           | 2 +-
>  10 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 10f6196..eb907d2 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -954,7 +954,7 @@ struct htype {
>  		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]));
>  #endif
>  		key = HKEY(d, h->initval, t->htable_bits);
> -		n =  rcu_dereference_bh(hbucket(t, key));
> +		n = rcu_dereference_bh(hbucket(t, key));
>  		if (!n)
>  			continue;
>  		for (i = 0; i < n->pos; i++) {
> diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
> index 8ada318..5c2be76 100644
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@ -289,7 +289,7 @@ struct list_set {
>  	if (n &&
>  	    !(SET_WITH_TIMEOUT(set) &&
>  	      ip_set_timeout_expired(ext_timeout(n, set))))
> -		n =  NULL;
> +		n = NULL;
>  
>  	e = kzalloc(set->dsize, GFP_ATOMIC);
>  	if (!e)
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 7138556..6b3ae76 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -615,7 +615,7 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
>  		unsigned int flags = (svc->flags & IP_VS_SVC_F_ONEPACKET &&
>  				      iph->protocol == IPPROTO_UDP) ?
>  				      IP_VS_CONN_F_ONE_PACKET : 0;
> -		union nf_inet_addr daddr =  { .all = { 0, 0, 0, 0 } };
> +		union nf_inet_addr daddr = { .all = { 0, 0, 0, 0 } };
>  
>  		/* create a new connection entry */
>  		IP_VS_DBG(6, "%s(): create a cache_bypass entry\n", __func__);
> diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
> index 94d9d34..da0280c 100644
> --- a/net/netfilter/ipvs/ip_vs_mh.c
> +++ b/net/netfilter/ipvs/ip_vs_mh.c
> @@ -174,8 +174,8 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
>  		return 0;
>  	}
>  
> -	table =  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> -			 sizeof(unsigned long), GFP_KERNEL);
> +	table = kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> +			sizeof(unsigned long), GFP_KERNEL);
>  	if (!table)
>  		return -ENOMEM;
>  
> diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> index 915ac82..c7b46a9 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> @@ -710,7 +710,7 @@ static int __ip_vs_tcp_init(struct netns_ipvs *ipvs, struct ip_vs_proto_data *pd
>  							sizeof(tcp_timeouts));
>  	if (!pd->timeout_table)
>  		return -ENOMEM;
> -	pd->tcp_state_table =  tcp_states;
> +	pd->tcp_state_table = tcp_states;
>  	return 0;
>  }
>  
> diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
> index 8c6c11b..26c1ff8 100644
> --- a/net/netfilter/nf_conntrack_ftp.c
> +++ b/net/netfilter/nf_conntrack_ftp.c
> @@ -162,7 +162,7 @@ static int try_rfc959(const char *data, size_t dlen,
>  	if (length == 0)
>  		return 0;
>  
> -	cmd->u3.ip =  htonl((array[0] << 24) | (array[1] << 16) |
> +	cmd->u3.ip = htonl((array[0] << 24) | (array[1] << 16) |
>  				    (array[2] << 8) | array[3]);
>  	cmd->u.tcp.port = htons((array[4] << 8) | array[5]);
>  	return length;
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 1e2cc83..48f3a67 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1225,7 +1225,7 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
>  	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = { .type = NLA_U8 },
>  	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = { .type = NLA_U8 },
>  	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  = { .len = sizeof(struct nf_ct_tcp_flags) },
> -	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len =  sizeof(struct nf_ct_tcp_flags) },
> +	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len = sizeof(struct nf_ct_tcp_flags) },
>  };
>  
>  #define TCP_NLATTR_SIZE	( \
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 6dee4f9..d69e186 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -651,7 +651,7 @@ static void nfulnl_instance_free_rcu(struct rcu_head *head)
>  	/* FIXME: do we want to make the size calculation conditional based on
>  	 * what is actually present?  way more branches and checks, but more
>  	 * memory efficient... */
> -	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
> +	size = nlmsg_total_size(sizeof(struct nfgenmsg))
>  		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hdr))
>  		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
>  		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
> @@ -668,7 +668,7 @@ static void nfulnl_instance_free_rcu(struct rcu_head *head)
>  		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
>  
>  	if (in && skb_mac_header_was_set(skb)) {
> -		size +=   nla_total_size(skb->dev->hard_header_len)
> +		size += nla_total_size(skb->dev->hard_header_len)
>  			+ nla_total_size(sizeof(u_int16_t))	/* hwtype */
>  			+ nla_total_size(sizeof(u_int16_t));	/* hwlen */
>  	}
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 89750f7..a1ef6e3 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -394,7 +394,7 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
>  	char *secdata = NULL;
>  	u32 seclen = 0;
>  
> -	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
> +	size = nlmsg_total_size(sizeof(struct nfgenmsg))
>  		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
>  		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
>  		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
> @@ -453,7 +453,7 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
>  	}
>  
>  	if (queue->flags & NFQA_CFG_F_UID_GID) {
> -		size +=  (nla_total_size(sizeof(u_int32_t))	/* uid */
> +		size += (nla_total_size(sizeof(u_int32_t))	/* uid */
>  			+ nla_total_size(sizeof(u_int32_t)));	/* gid */
>  	}
>  
> diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
> index 9cec9ea..f56d3ed 100644
> --- a/net/netfilter/xt_IDLETIMER.c
> +++ b/net/netfilter/xt_IDLETIMER.c
> @@ -283,7 +283,7 @@ static int __init idletimer_tg_init(void)
>  
>  	idletimer_tg_kobj = &idletimer_tg_device->kobj;
>  
> -	err =  xt_register_target(&idletimer_tg);
> +	err = xt_register_target(&idletimer_tg);
>  	if (err < 0) {
>  		pr_debug("couldn't register xt target\n");
>  		goto out_dev;
> -- 
> 1.8.3.1
> 
