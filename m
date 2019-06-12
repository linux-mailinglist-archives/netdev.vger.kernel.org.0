Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2342F42E47
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfFLSDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:03:41 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36357 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfFLSDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:03:41 -0400
Received: by mail-qt1-f193.google.com with SMTP id p15so98976qtl.3
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 11:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TQd0FKFQqI8pi3y3hVFKhEFezVIvP/kYZJHFjTZ77Zw=;
        b=UW9qfgPMEpejxmmpMb16Lax0gylbNIZZlcONmZqkyHOSoeBzJpM5aHp614dLt86raD
         f1cNI4IDPnhBFQM8HmQrmaLeqvN4KzvwqMzWAzSsh45pToUBCg0P7rKI5BSI/xCuhkp3
         6Bs/HFNuX3F5rnTf0gRA7QzwF1P76A719uaVvROnfIvcXGjxu/4vsmrZI+zhqSssefow
         DDCthaFT4qjmmi47sLaD3llVAUkxZqOXc8UqDZxhxoojCOLN4xq6yzDwVs+Aw6HzIkhP
         64X7aX7lu2323RMBVYfZJskQtoaghF0AIU3iknMX2EpPhhUWLdq1KqTMZkHEYutVtZHK
         uPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TQd0FKFQqI8pi3y3hVFKhEFezVIvP/kYZJHFjTZ77Zw=;
        b=An3rM6gwSyeAoeFwBZ6FvxEGx58B47zbfbA5ZjakEzioi4IAEWlxFS76L6IOiGHH/o
         oYmUTz1T1WwFINP7bbuk6MGmeHcypzG6pQij61m6hzC+RmuXfg/GzKWpfrloswhOyTsj
         VuCwoehWMex3DuRLETxxawTswewhCz7jdcOV9PN6QM7mwKe2Mn3+1wx1b6l1gsOtOv5s
         z29podgnBN3iX4Jgqsox0+y679wxk0yDU1fZ1o+RbUNoXZnaVFi5c8I/GCqCqy5Rxroo
         64I24rhT8kcH72LfZh3BneQy+ENYAjMNqb8B/5sxmysrdQj3wuyw2S7W8EVcPwAaoJ/L
         Wn1A==
X-Gm-Message-State: APjAAAWXP1INBtMLQUzKEwOihUupfYUOVnefxUPX1VoFqXhNoasEsR1X
        NuEI8DD6BBkGp8mtR3ZT2Gk=
X-Google-Smtp-Source: APXvYqz0bWLYNEq54xjih+C6oUdoo5iN3PC5TyhjoAc1by7IMbW/ukl9L7tmKcL5SjKaJZAJ+be0Cg==
X-Received: by 2002:ac8:7545:: with SMTP id b5mr63165544qtr.234.1560362620001;
        Wed, 12 Jun 2019 11:03:40 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:7487:3cda:3612:d867:343f])
        by smtp.gmail.com with ESMTPSA id j66sm187825qkf.86.2019.06.12.11.03.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 11:03:39 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id CABCDC1BD5; Wed, 12 Jun 2019 15:03:36 -0300 (-03)
Date:   Wed, 12 Jun 2019 15:03:36 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net-next 1/3] net: sched: add mpls manipulation actions
 to TC
Message-ID: <20190612180336.GB3499@localhost.localdomain>
References: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
 <1560343906-19426-2-git-send-email-john.hurley@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560343906-19426-2-git-send-email-john.hurley@netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 01:51:44PM +0100, John Hurley wrote:
> Currently, TC offers the ability to match on the MPLS fields of a packet
> through the use of the flow_dissector_key_mpls struct. However, as yet, TC
> actions do not allow the modification or manipulation of such fields.
> 
> Add a new module that registers TC action ops to allow manipulation of
> MPLS. This includes the ability to push and pop headers as well as modify
> the contents of new or existing headers. A further action to decrement the
> TTL field of an MPLS header is also provided.
> 
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  include/net/tc_act/tc_mpls.h        |  27 +++
>  include/uapi/linux/pkt_cls.h        |   2 +
>  include/uapi/linux/tc_act/tc_mpls.h |  32 +++
>  net/sched/Kconfig                   |  11 +
>  net/sched/Makefile                  |   1 +
>  net/sched/act_mpls.c                | 450 ++++++++++++++++++++++++++++++++++++
>  6 files changed, 523 insertions(+)
>  create mode 100644 include/net/tc_act/tc_mpls.h
>  create mode 100644 include/uapi/linux/tc_act/tc_mpls.h
>  create mode 100644 net/sched/act_mpls.c
> 
> diff --git a/include/net/tc_act/tc_mpls.h b/include/net/tc_act/tc_mpls.h
> new file mode 100644
> index 0000000..ca7393a
> --- /dev/null
> +++ b/include/net/tc_act/tc_mpls.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
> +/* Copyright (C) 2019 Netronome Systems, Inc. */
> +
> +#ifndef __NET_TC_MPLS_H
> +#define __NET_TC_MPLS_H
> +
> +#include <linux/tc_act/tc_mpls.h>
> +#include <net/act_api.h>
> +
> +struct tcf_mpls_params {
> +	int tcfm_action;
> +	u32 tcfm_label;
> +	u8 tcfm_tc;
> +	u8 tcfm_ttl;
> +	__be16 tcfm_proto;
> +	struct rcu_head	rcu;
> +};
> +
> +#define ACT_MPLS_TC_NOT_SET	0xff
> +
> +struct tcf_mpls {
> +	struct tc_action common;
> +	struct tcf_mpls_params __rcu *mpls_p;
> +};
> +#define to_mpls(a) ((struct tcf_mpls *)a)
> +
> +#endif /* __NET_TC_MPLS_H */
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index a93680f..197621a 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -83,6 +83,7 @@ enum {
>  #define TCA_ACT_SIMP 22
>  #define TCA_ACT_IFE 25
>  #define TCA_ACT_SAMPLE 26
> +#define TCA_ACT_MPLS 27
>  
>  /* Action type identifiers*/
>  enum tca_id {
> @@ -104,6 +105,7 @@ enum tca_id {
>  	TCA_ID_SIMP = TCA_ACT_SIMP,
>  	TCA_ID_IFE = TCA_ACT_IFE,
>  	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
> +	TCA_ID_MPLS = TCA_ACT_MPLS,
>  	/* other actions go here */
>  	TCA_ID_CTINFO,
>  	__TCA_ID_MAX = 255
> diff --git a/include/uapi/linux/tc_act/tc_mpls.h b/include/uapi/linux/tc_act/tc_mpls.h
> new file mode 100644
> index 0000000..6e8907b
> --- /dev/null
> +++ b/include/uapi/linux/tc_act/tc_mpls.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* Copyright (C) 2019 Netronome Systems, Inc. */
> +
> +#ifndef __LINUX_TC_MPLS_H
> +#define __LINUX_TC_MPLS_H
> +
> +#include <linux/pkt_cls.h>
> +
> +#define TCA_MPLS_ACT_POP	1
> +#define TCA_MPLS_ACT_PUSH	2
> +#define TCA_MPLS_ACT_MODIFY	3
> +#define TCA_MPLS_ACT_DEC_TTL	4
> +
> +struct tc_mpls {
> +	tc_gen;
> +	int m_action;
> +};
> +
> +enum {
> +	TCA_MPLS_UNSPEC,
> +	TCA_MPLS_TM,
> +	TCA_MPLS_PARMS,
> +	TCA_MPLS_PAD,
> +	TCA_MPLS_PROTO,
> +	TCA_MPLS_LABEL,
> +	TCA_MPLS_TC,
> +	TCA_MPLS_TTL,
> +	__TCA_MPLS_MAX,
> +};
> +#define TCA_MPLS_MAX (__TCA_MPLS_MAX - 1)
> +
> +#endif
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index d104f7e..a34dcd3 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -842,6 +842,17 @@ config NET_ACT_CSUM
>  	  To compile this code as a module, choose M here: the
>  	  module will be called act_csum.
>  
> +config NET_ACT_MPLS
> +	tristate "MPLS manipulation"
> +	depends on NET_CLS_ACT
> +	help
> +	  Say Y here to push or pop MPLS headers.
> +
> +	  If unsure, say N.
> +
> +	  To compile this code as a module, choose M here: the
> +	  module will be called act_mpls.
> +
>  config NET_ACT_VLAN
>          tristate "Vlan manipulation"
>          depends on NET_CLS_ACT
> diff --git a/net/sched/Makefile b/net/sched/Makefile
> index d54bfcb..c266036 100644
> --- a/net/sched/Makefile
> +++ b/net/sched/Makefile
> @@ -18,6 +18,7 @@ obj-$(CONFIG_NET_ACT_PEDIT)	+= act_pedit.o
>  obj-$(CONFIG_NET_ACT_SIMP)	+= act_simple.o
>  obj-$(CONFIG_NET_ACT_SKBEDIT)	+= act_skbedit.o
>  obj-$(CONFIG_NET_ACT_CSUM)	+= act_csum.o
> +obj-$(CONFIG_NET_ACT_MPLS)	+= act_mpls.o
>  obj-$(CONFIG_NET_ACT_VLAN)	+= act_vlan.o
>  obj-$(CONFIG_NET_ACT_BPF)	+= act_bpf.o
>  obj-$(CONFIG_NET_ACT_CONNMARK)	+= act_connmark.o
> diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> new file mode 100644
> index 0000000..ff56ada
> --- /dev/null
> +++ b/net/sched/act_mpls.c
> @@ -0,0 +1,450 @@
> +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +/* Copyright (C) 2019 Netronome Systems, Inc. */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mpls.h>
> +#include <linux/rtnetlink.h>
> +#include <linux/skbuff.h>
> +#include <linux/tc_act/tc_mpls.h>
> +#include <net/mpls.h>
> +#include <net/netlink.h>
> +#include <net/pkt_sched.h>
> +#include <net/pkt_cls.h>
> +#include <net/tc_act/tc_mpls.h>
> +
> +static unsigned int mpls_net_id;
> +static struct tc_action_ops act_mpls_ops;
> +
> +#define ACT_MPLS_TTL_DEFAULT	255
> +
> +static void tcf_mpls_mod_lse(struct mpls_shim_hdr *lse,
> +			     struct tcf_mpls_params *p, bool set_bos)
> +{
> +	u32 new_lse = be32_to_cpu(lse->label_stack_entry);
> +
> +	if (p->tcfm_label) {
> +		new_lse &= ~MPLS_LS_LABEL_MASK;
> +		new_lse |= p->tcfm_label << MPLS_LS_LABEL_SHIFT;
> +	}
> +	if (p->tcfm_ttl) {
> +		new_lse &= ~MPLS_LS_TTL_MASK;
> +		new_lse |= p->tcfm_ttl << MPLS_LS_TTL_SHIFT;
> +	}
> +	if (p->tcfm_tc != ACT_MPLS_TC_NOT_SET) {
> +		new_lse &= ~MPLS_LS_TC_MASK;
> +		new_lse |= p->tcfm_tc << MPLS_LS_TC_SHIFT;
> +	}
> +	if (set_bos)
> +		new_lse |= 1 << MPLS_LS_S_SHIFT;
> +
> +	lse->label_stack_entry = cpu_to_be32(new_lse);
> +}
> +
> +static inline void tcf_mpls_set_eth_type(struct sk_buff *skb, __be16 ethertype)
> +{
> +	struct ethhdr *hdr = eth_hdr(skb);
> +
> +	skb_postpull_rcsum(skb, &hdr->h_proto, ETH_TLEN);
> +	hdr->h_proto = ethertype;
> +	skb_postpush_rcsum(skb, &hdr->h_proto, ETH_TLEN);
> +}
> +
> +static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
> +			struct tcf_result *res)
> +{
> +	struct tcf_mpls *m = to_mpls(a);
> +	struct mpls_shim_hdr *lse;
> +	struct tcf_mpls_params *p;
> +	u32 temp_lse;
> +	int ret;
> +	u8 ttl;
> +
> +	tcf_lastuse_update(&m->tcf_tm);
> +	bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
> +
> +	/* Ensure 'data' points at mac_header prior calling mpls manipulating
> +	 * functions.
> +	 */
> +	if (skb_at_tc_ingress(skb))
> +		skb_push_rcsum(skb, skb->mac_len);
> +
> +	ret = READ_ONCE(m->tcf_action);
> +
> +	p = rcu_dereference_bh(m->mpls_p);
> +
> +	switch (p->tcfm_action) {
> +	case TCA_MPLS_ACT_POP:
> +		if (unlikely(!eth_p_mpls(skb->protocol)))
> +			goto out;
> +
> +		if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> +			goto drop;
> +
> +		skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
> +		memmove(skb->data + MPLS_HLEN, skb->data, ETH_HLEN);
> +
> +		__skb_pull(skb, MPLS_HLEN);
> +		skb_reset_mac_header(skb);
> +		skb_set_network_header(skb, ETH_HLEN);
> +
> +		tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> +		skb->protocol = p->tcfm_proto;
> +		break;
> +	case TCA_MPLS_ACT_PUSH:
> +		if (unlikely(skb_cow_head(skb, MPLS_HLEN)))
> +			goto drop;
> +
> +		skb_push(skb, MPLS_HLEN);
> +		memmove(skb->data, skb->data + MPLS_HLEN, ETH_HLEN);
> +		skb_reset_mac_header(skb);
> +		skb_set_network_header(skb, ETH_HLEN);
> +
> +		lse = mpls_hdr(skb);
> +		lse->label_stack_entry = 0;
> +		tcf_mpls_mod_lse(lse, p, !eth_p_mpls(skb->protocol));
> +		skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> +
> +		tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> +		skb->protocol = p->tcfm_proto;
> +		break;
> +	case TCA_MPLS_ACT_MODIFY:
> +		if (unlikely(!eth_p_mpls(skb->protocol)))
> +			goto out;
> +
> +		if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> +			goto drop;
> +
> +		lse = mpls_hdr(skb);
> +		skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> +		tcf_mpls_mod_lse(lse, p, false);
> +		skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> +		break;
> +	case TCA_MPLS_ACT_DEC_TTL:
> +		if (unlikely(!eth_p_mpls(skb->protocol)))
> +			goto out;
> +
> +		if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> +			goto drop;
> +
> +		lse = mpls_hdr(skb);
> +		temp_lse = be32_to_cpu(lse->label_stack_entry);
> +		ttl = (temp_lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
> +		if (!--ttl)
> +			goto drop;
> +
> +		temp_lse &= ~MPLS_LS_TTL_MASK;
> +		temp_lse |= ttl << MPLS_LS_TTL_SHIFT;
> +		skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> +		lse->label_stack_entry = cpu_to_be32(temp_lse);
> +		skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> +		break;
> +	default:
> +		WARN_ONCE(1, "Invalid MPLS action\n");
> +	}
> +
> +out:
> +	if (skb_at_tc_ingress(skb))
> +		skb_pull_rcsum(skb, skb->mac_len);
> +
> +	return ret;
> +
> +drop:
> +	qstats_drop_inc(this_cpu_ptr(m->common.cpu_qstats));
> +	return TC_ACT_SHOT;
> +}
> +
> +static int valid_label(const struct nlattr *attr,
> +		       struct netlink_ext_ack *extack)
> +{
> +	const u32 *label = nla_data(attr);
> +
> +	if (!*label || *label & ~MPLS_LABEL_MASK) {
> +		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
> +	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
> +	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
> +	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
> +	[TCA_MPLS_TC]		= NLA_POLICY_RANGE(NLA_U8, 0, 7),
> +	[TCA_MPLS_TTL]		= NLA_POLICY_MIN(NLA_U8, 1),
> +};
> +
> +static int tcf_mpls_init(struct net *net, struct nlattr *nla,
> +			 struct nlattr *est, struct tc_action **a,
> +			 int ovr, int bind, bool rtnl_held,
> +			 struct tcf_proto *tp, struct netlink_ext_ack *extack)
> +{
> +	struct tc_action_net *tn = net_generic(net, mpls_net_id);
> +	struct nlattr *tb[TCA_MPLS_MAX + 1];
> +	struct tcf_chain *goto_ch = NULL;
> +	struct tcf_mpls_params *p;
> +	struct tc_mpls *parm;
> +	bool exists = false;
> +	struct tcf_mpls *m;
> +	int ret = 0, err;
> +	u8 mpls_ttl = 0;
> +
> +	if (!nla) {
> +		NL_SET_ERR_MSG_MOD(extack, "missing netlink attributes");
> +		return -EINVAL;
> +	}
> +
> +	err = nla_parse_nested(tb, TCA_MPLS_MAX, nla, mpls_policy, extack);

Please see my reply to
[PATCH net-next v6] net: sched: Introduce act_ctinfo action
regarding the usage of nla_parse_nested() here. Thanks.

