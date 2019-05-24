Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A44E29A03
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 16:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391271AbfEXOYn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 May 2019 10:24:43 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39861 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390885AbfEXOYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 10:24:42 -0400
Received: by mail-lj1-f194.google.com with SMTP id a10so8839442ljf.6
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 07:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=whdW+edEk/JnjeGjxpqqrVS/s5AqG2fNOU43HboMZIU=;
        b=IxFBXcEinrhZ1nT5llOH1etJjPSrNCy6QDxIqSSVpveZ6ogczHMupsX1YB9tDdHnUl
         aU61kE1N+7bwmyAqcVTer2g2ZUvw4Vmw3KoopiOHuWg7IZ9pXGlFrij69uYAg18xIk66
         D1jCUPb5ZNLJXox6hpgJdxVi9la9NqDAaUAxFdiqv5IdkUCUpNgC7k6et4lrtf5fHH/1
         afU2CNnF6mT8a7Snk1PLqs//Z+6woJ0xZKqd6FvDEbGuDEarKOgr1VKW41RG8nAVKsVE
         3ywQ6hsIOkT6Zy9bVk/gKFxxWts83BJdixaCeNscilgg52e0Hk4EZScWf1JSWFnHsXkS
         7xyA==
X-Gm-Message-State: APjAAAVP3ehRlh578BNWJO0/AogqIcobn6KgLNh1JxB4TN2q9i8Ru2dU
        VNsj7wePot/cFNJ01mp4ImTxSz1Kbcg=
X-Google-Smtp-Source: APXvYqxZyFHorE2cEvbbCNxGvzKtE1PPri0jEttSYeKxUvCvE/2VYsx5ebIAG/XxCOfyulsT+Q/vug==
X-Received: by 2002:a2e:9b0c:: with SMTP id u12mr22314029lji.189.1558707878687;
        Fri, 24 May 2019 07:24:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id n10sm662298lfk.39.2019.05.24.07.24.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 07:24:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3DF2A18031C; Fri, 24 May 2019 16:24:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net: sched: Introduce act_ctinfo action
In-Reply-To: <D6710354-3D3D-4731-8864-B89F7037AE81@darbyshire-bryant.me.uk>
References: <20190523160906.44081-1-ldir@darbyshire-bryant.me.uk> <87pno8ywjx.fsf@toke.dk> <D6710354-3D3D-4731-8864-B89F7037AE81@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 May 2019 16:24:37 +0200
Message-ID: <87h89kx74q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

>> On 24 May 2019, at 11:30, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> 
>> Hi Kevin
>> 
>> I couldn't get 'git am' to accept your email. Not sure if it's because
>> it's base64 encoded, or because it doesn't apply cleanly to current
>> net-next.
>
> Bizarre, haven’t changed the method by which I send in patches so am
> confused. I’ll be sending a v5 so let’s see if the problem persists.

I may just be that 'git am' is very strict about how the patch should
apply; when doing i manually I get this:

$  patch -p1 < test.patch 
patching file include/net/tc_act/tc_ctinfo.h
patching file include/uapi/linux/pkt_cls.h
patching file include/uapi/linux/tc_act/tc_ctinfo.h
patching file net/sched/Kconfig
Hunk #1 succeeded at 877 (offset 1 line).
patching file net/sched/Makefile
patching file net/sched/act_ctinfo.c
patching file tools/testing/selftests/tc-testing/config

So I'm guessing maybe that 'offset 1 line' is the problem. In which case
it should go away as long as you make sure to rebase on the latest
net-next before submitting v5 :)

>> However, I could get it to apply by manually copying over the diff to a
>> .patch file, so here are some comments:
>> 
>>> ctinfo is a new tc filter action module.  It is designed to restore
>>> information contained in conntrack marks to other places.  At present it
>>> can restore DSCP values to IPv4/6 diffserv fields and also copy
>>> conntrack marks to skb marks.  As such the 2nd function effectively
>>> replaces the existing act_connmark module
>>> 
>>> The DSCP restoration is intended for use and has been found useful for
>>> restoring ingress classifications based on egress classifications across
>>> links that bleach or otherwise change DSCP, typically home ISP Internet
>>> links.  Restoring DSCP on ingress on the WAN link allows qdiscs such as
>>> CAKE to shape inbound packets according to policies that are easier to
>>> indicate on egress.
>>> 
>>> Ingress classification is traditionally a challenging task since
>>> iptables rules haven't yet run and tc filter/eBPF programs are pre-NAT
>>> lookups, hence are unable to see internal IPv4 addresses as used on the
>>> typical home masquerading gateway.
>>> 
>>> ctinfo understands the following parameters:
>>> 
>>> dscp dscpmask[/statemask]
>> 
>> The slash-separated syntax is usually used for "<value> / <mask applied
>> to value>", so it is a bit confusing that you are using the syntax for
>> two masks here.
>
> I’m trying and clearly failing to give a hint as to what parameters the
> module expects and how that may end up being achieved from user space.
> What eventual syntax is used from user space is very open, since I’ve
> not yet submitted that - I wanted to see if kernel space stuff was
> accepted before attempting to submit the user space side.  Opening up
> two fronts for me is going to end in personal defeat.

Yeah, happy to bikeshed over syntax on the iproute2 patch :)

That's why I suggested to just skip the syntax and only describe the
parameters.

>>> dscpmask - a 32 bit mask of at least 6 contiguous bits and indicates
>>> where ctinfo will find the DSCP bits stored in the conntrack mark.
>>> 
>>> statemask - a 32 bit mask of (usually) 1 bit length, outside the area
>>> specified by dscpmask.  This represents a conditional operation flag
>>> whereby the DSCP is only restored if the flag is set.  This is useful to
>>> implement a 'one shot' iptables based classification where the
>>> 'complicated' iptables rules are only run once to classify the
>>> connection on initial (egress) packet and subsequent packets are all
>>> marked/restored with the same DSCP.  A mask of zero disables the
>>> conditional behaviour ie. the conntrack mark DSCP bits are always
>>> restored to the ip diffserv field (assuming the conntrack entry is found
>>> & the skb is an ipv4/ipv6 type)
>>> 
>>> mark [mask]
>> 
>> Also, it took me a second reading to realise that the 'dscpmask' and
>> 'statemask' refer back to the two parameter already mentioned above, and
>> that 'mark [mask]' were the beginning of two new ones. Maybe just lose
>> the syntax here and just describe the parameter values?
>> 
>>> mark - enables copying the conntrack connmark value to the skb mark
>
>
>> 
>> Maybe make it explicit that this is the bit that is equivalent to the
>> existing act_connmark? Also, maybe rename this to 'markskb' or
>> something, to make it explicit that it operates on the skb (there are an
>> awful lot of 'marks' and 'masks' in this description ;)).
>
> Again it’s been a moving goalpost exercise “can you just add the
> conntrack functionality in”, which I’ve done.  The things discussed so
> far here I perceive as mostly ‘user space’ syntax.

Yup, such is life of submitting upstream; the process is biased towards
reviewer time, as that is the scarce resource. Which means that
submitters sometimes get asked to do more work than they originally
anticipated... :)

>>> mask - a 32 bit mask applied to the mark to mask out bit unwanted for
>>> restoration.  The CAKE qdisc for example understands both DSCP and 'tin'
>>> classification stored the mark, thus act_ctinfo may be used to restore
>>> both aspects of classification for CAKE in one action.  A default mask
>>> of 0xffffffff is applied if not specified.
>> 
>> Not sure I understand this description. What exactly is the use case
>> here?
>
> The point I’m trying to make is that the mark stored in the firewall
> mark may contain more than one parameter. It could contain both the
> DSCP value somewhere in the bitfield and some other stuff elsewhere in
> the bitfield. Restoring the whole firewall mark to the skb mark may or
> may not be desirable. We may not wish to pass on the DSCP coded stuff
> into the skb mark. We may wish to mask out other bits too. I’m aware
> that CAKE for example can use bits from the skb mark and indeed may be
> configured to apply a mask itself but other applications/use cases may
> not be so lucky.
>
> It’s why I tried to apply some ascii art to make things clearer. Is it
> still not clear?

Right, I do understand what it does, just didn't understand the
description in the commit msg. Maybe change the description to something
like:

copy_mark - enables copying the conntrack connmark value to the skb mark

copy_mask - a 32 bit mask applied to the mark before copying. This can
be used to only copy parts of the mark, in case bits of it is used for
different purposes (e.g., by different firewall packages). If not
specified, the whole mark field will be copied (i.e., the default mask
is 0xffffffff).

>>> zone - conntrack zone
>>> 
>>> control - action related control (reclassify | pipe | drop | continue |
>>> ok | goto chain <CHAIN_INDEX>)
>>> 
>>> e.g. dscp 0xfc000000/0x01000000
>>> 
>>> |----0xFC----conntrack mark----000000---|
>>> | Bits 31-26 | bit 25 | bit24 |~~~ Bit 0|
>>> | DSCP       | unused | flag  |unused   |
>>> |-----------------------0x01---000000---|
>>>      |                   |
>>>      |                   |
>>>      ---|             Conditional flag
>>>         v             only restore if set
>>> |-ip diffserv-|
>>> | 6 bits      |
>>> |-------------|
>>> 
>>> e.g. mark 0x00ffffff
>>> 
>>> |----0x00----conntrack mark----ffffff---|
>>> | Bits 31-24 |                          |
>>> | DSCP & flag|                          |
>>> |---------------------------------------|
>>> 			|
>>> 			|
>>> 			v
>>> |------------skb mark-------------------|
>>> |                                       |
>>> |                                       |
>>> |---------------------------------------|
>>> 
>>> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
>>> ---
>>> v2 - add equivalent connmark functionality with an enhancement
>>>     to accept a mask
>>>     pass statistics for each sub-function as individual netlink
>>>     attributes and stop (ab)using overlimits, drops
>>>     update the testing config correctly
>>> v3 - fix a licensing silly & tidy up GPL boilerplate
>>> v4 - drop stray copy paste inline
>>>     reverse christmas tree local vars
>>> 
>>> include/net/tc_act/tc_ctinfo.h            |  28 ++
>>> include/uapi/linux/pkt_cls.h              |   1 +
>>> include/uapi/linux/tc_act/tc_ctinfo.h     |  43 +++
>>> net/sched/Kconfig                         |  17 +
>>> net/sched/Makefile                        |   1 +
>>> net/sched/act_ctinfo.c                    | 402 ++++++++++++++++++++++
>>> tools/testing/selftests/tc-testing/config |   1 +
>>> 7 files changed, 493 insertions(+)
>>> create mode 100644 include/net/tc_act/tc_ctinfo.h
>>> create mode 100644 include/uapi/linux/tc_act/tc_ctinfo.h
>>> create mode 100644 net/sched/act_ctinfo.c
>>> 
>>> diff --git a/include/net/tc_act/tc_ctinfo.h b/include/net/tc_act/tc_ctinfo.h
>>> new file mode 100644
>>> index 000000000000..87334120dcb6
>>> --- /dev/null
>>> +++ b/include/net/tc_act/tc_ctinfo.h
>>> @@ -0,0 +1,28 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +#ifndef __NET_TC_CTINFO_H
>>> +#define __NET_TC_CTINFO_H
>>> +
>>> +#include <net/act_api.h>
>>> +
>>> +struct tcf_ctinfo_params {
>>> +	struct net *net;
>>> +	u32 dscpmask;
>>> +	u32 dscpstatemask;
>>> +	u32 markmask;
>>> +	u16 zone;
>>> +	u8 mode;
>>> +	u8 dscpmaskshift;
>>> +	struct rcu_head rcu;
>>> +};
>>> +
>>> +struct tcf_ctinfo {
>>> +	struct tc_action common;
>>> +	struct tcf_ctinfo_params __rcu *params;
>>> +	u64 stats_dscp_set;
>>> +	u64 stats_dscp_error;
>>> +	u64 stats_mark_set;
>>> +};
>>> +
>>> +#define to_ctinfo(a) ((struct tcf_ctinfo *)a)
>>> +
>>> +#endif /* __NET_TC_CTINFO_H */
>>> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
>>> index 51a0496f78ea..a93680fc4bfa 100644
>>> --- a/include/uapi/linux/pkt_cls.h
>>> +++ b/include/uapi/linux/pkt_cls.h
>>> @@ -105,6 +105,7 @@ enum tca_id {
>>> 	TCA_ID_IFE = TCA_ACT_IFE,
>>> 	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
>>> 	/* other actions go here */
>>> +	TCA_ID_CTINFO,
>>> 	__TCA_ID_MAX = 255
>>> };
>>> 
>>> diff --git a/include/uapi/linux/tc_act/tc_ctinfo.h b/include/uapi/linux/tc_act/tc_ctinfo.h
>>> new file mode 100644
>>> index 000000000000..8d254b82151c
>>> --- /dev/null
>>> +++ b/include/uapi/linux/tc_act/tc_ctinfo.h
>>> @@ -0,0 +1,43 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>> +#ifndef __UAPI_TC_CTINFO_H
>>> +#define __UAPI_TC_CTINFO_H
>>> +
>>> +#include <linux/types.h>
>>> +#include <linux/pkt_cls.h>
>>> +
>>> +struct tc_ctinfo {
>>> +	tc_gen;
>>> +};
>>> +
>>> +struct tc_ctinfo_dscp {
>>> +	__u32 mask;
>>> +	__u32 statemask;
>>> +};
>>> 
>>> +struct tc_ctinfo_stats_dscp {
>>> +	__u64 set;
>>> +	__u64 error;
>>> +};
>> 
>> Why these two structs, when everything else gets their own netlink TLVs?
>
> Because I’m trying to compartmentalise the individual sub-functions to
> their own area. And because other act_* code I’ve looked at in the
> process of copy/hack/pasting this together does similar things. Where
> there is more than one parameter involved with a sub-function I have
> put those parameters into a structure.

Well, most other actions and qdiscs pass their options entirely in
structs, which is fine as long as you never want to change them. In CAKE
we moved to using netlink TLVs for all options precisely because we
wanted to be able to add new ones.

Anyway, these are two different ways of doing things. What I'm objecting
to is you mixing them. Personally, I prefer the "one TLV per option"
mode.

>>> +
>>> +enum {
>>> +	TCA_CTINFO_UNSPEC,
>>> +	TCA_CTINFO_ACT,
>>> +	TCA_CTINFO_ZONE,
>>> +	TCA_CTINFO_DSCP_PARMS,
>>> +	TCA_CTINFO_MARK_MASK,
>>> +	TCA_CTINFO_MODE_DSCP,
>>> +	TCA_CTINFO_MODE_MARK,
>>> +	TCA_CTINFO_STATS_DSCP,
>>> +	TCA_CTINFO_STATS_MARK,
>>> +	TCA_CTINFO_TM,
>>> +	TCA_CTINFO_PAD,
>>> +	__TCA_CTINFO_MAX
>>> +};
>>> +#define TCA_CTINFO_MAX (__TCA_CTINFO_MAX - 1)
>>> +
>>> +enum {
>>> +	CTINFO_MODE_SETDSCP	= BIT(0),
>>> +	CTINFO_MODE_SETMARK	= BIT(1)
>>> +};
>>> +
>>> +#endif
>>> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
>>> index 5c02ad97ef23..f5773effcfdc 100644
>>> --- a/net/sched/Kconfig
>>> +++ b/net/sched/Kconfig
>>> @@ -876,6 +876,23 @@ config NET_ACT_CONNMARK
>>> 	  To compile this code as a module, choose M here: the
>>> 	  module will be called act_connmark.
>>> 
>>> +config NET_ACT_CTINFO
>>> +        tristate "Netfilter Connection Mark Actions"
>>> +        depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
>>> +        depends on NF_CONNTRACK && NF_CONNTRACK_MARK
>>> +        help
>>> +	  Say Y here to allow transfer of a connmark stored information.
>>> +	  Current actions transfer connmark stored DSCP into
>>> +	  ipv4/v6 diffserv and/or to transfer connmark to packet
>>> +	  mark.  Both are useful for restoring egress based marks
>>> +	  back onto ingress connections for qdisc priority mapping
>>> +	  purposes.
>>> +
>>> +	  If unsure, say N.
>>> +
>>> +	  To compile this code as a module, choose M here: the
>>> +	  module will be called act_ctinfo.
>>> +
>>> config NET_ACT_SKBMOD
>>>         tristate "skb data modification action"
>>>         depends on NET_CLS_ACT
>>> diff --git a/net/sched/Makefile b/net/sched/Makefile
>>> index 8a40431d7b5c..d54bfcbd7981 100644
>>> --- a/net/sched/Makefile
>>> +++ b/net/sched/Makefile
>>> @@ -21,6 +21,7 @@ obj-$(CONFIG_NET_ACT_CSUM)	+= act_csum.o
>>> obj-$(CONFIG_NET_ACT_VLAN)	+= act_vlan.o
>>> obj-$(CONFIG_NET_ACT_BPF)	+= act_bpf.o
>>> obj-$(CONFIG_NET_ACT_CONNMARK)	+= act_connmark.o
>>> +obj-$(CONFIG_NET_ACT_CTINFO)	+= act_ctinfo.o
>>> obj-$(CONFIG_NET_ACT_SKBMOD)	+= act_skbmod.o
>>> obj-$(CONFIG_NET_ACT_IFE)	+= act_ife.o
>>> obj-$(CONFIG_NET_IFE_SKBMARK)	+= act_meta_mark.o
>>> diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
>>> new file mode 100644
>>> index 000000000000..93f98d62a962
>>> --- /dev/null
>>> +++ b/net/sched/act_ctinfo.c
>>> @@ -0,0 +1,402 @@
>>> +// SPDX-License-Identifier: GPL-2.0+
>>> +/* net/sched/act_ctinfo.c  netfilter ctinfo connmark actions
>>> + *
>>> + * Copyright (c) 2019 Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
>>> + */
>>> +
>>> +#include <linux/module.h>
>>> +#include <linux/init.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/skbuff.h>
>>> +#include <linux/rtnetlink.h>
>>> +#include <linux/pkt_cls.h>
>>> +#include <linux/ip.h>
>>> +#include <linux/ipv6.h>
>>> +#include <net/netlink.h>
>>> +#include <net/pkt_sched.h>
>>> +#include <net/act_api.h>
>>> +#include <net/pkt_cls.h>
>>> +#include <uapi/linux/tc_act/tc_ctinfo.h>
>>> +#include <net/tc_act/tc_ctinfo.h>
>>> +
>>> +#include <net/netfilter/nf_conntrack.h>
>>> +#include <net/netfilter/nf_conntrack_core.h>
>>> +#include <net/netfilter/nf_conntrack_ecache.h>
>>> +#include <net/netfilter/nf_conntrack_zones.h>
>>> +
>>> +static unsigned int ctinfo_net_id;
>>> +static struct tc_action_ops act_ctinfo_ops;
>>> +
>>> +static void tcf_ctinfo_dscp_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
>>> +				struct tcf_ctinfo_params *cp,
>>> +				struct sk_buff *skb, int wlen, int proto)
>>> +{
>>> +	u8 dscp, newdscp;
>>> +
>>> +	newdscp = (((ct->mark & cp->dscpmask) >> cp->dscpmaskshift) << 2) &
>>> +		     ~INET_ECN_MASK;
>>> +
>>> +	switch (proto) {
>>> +	case NFPROTO_IPV4:
>>> +		dscp = ipv4_get_dsfield(ip_hdr(skb)) & ~INET_ECN_MASK;
>>> +		if (dscp != newdscp) {
>>> +			if (likely(!skb_try_make_writable(skb, wlen))) {
>>> +				ipv4_change_dsfield(ip_hdr(skb),
>>> +						    INET_ECN_MASK,
>>> +						    newdscp);
>>> +				ca->stats_dscp_set++;
>>> +			} else {
>>> +				ca->stats_dscp_error++;
>>> +			}
>>> +		}
>>> +		break;
>>> +	case NFPROTO_IPV6:
>>> +		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) & ~INET_ECN_MASK;
>>> +		if (dscp != newdscp) {
>>> +			if (likely(!skb_try_make_writable(skb, wlen))) {
>>> +				ipv6_change_dsfield(ipv6_hdr(skb),
>>> +						    INET_ECN_MASK,
>>> +						    newdscp);
>>> +				ca->stats_dscp_set++;
>>> +			} else {
>>> +				ca->stats_dscp_error++;
>>> +			}
>>> +		}
>>> +		break;
>>> +	default:
>>> +		break;
>>> +	}
>>> +}
>>> +
>>> +static void tcf_ctinfo_mark_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
>>> +				struct tcf_ctinfo_params *cp,
>>> +				struct sk_buff *skb)
>>> +{
>>> +	ca->stats_mark_set++;
>>> +	skb->mark = ct->mark & cp->markmask;
>>> +}
>>> +
>>> +static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
>>> +			  struct tcf_result *res)
>>> +{
>>> +	const struct nf_conntrack_tuple_hash *thash = NULL;
>>> +	struct tcf_ctinfo *ca = to_ctinfo(a);
>>> +	struct nf_conntrack_tuple tuple;
>>> +	struct nf_conntrack_zone zone;
>>> +	enum ip_conntrack_info ctinfo;
>>> +	struct tcf_ctinfo_params *cp;
>>> +	struct nf_conn *ct;
>>> +	int proto, wlen;
>>> +	int action;
>>> +
>>> +	cp = rcu_dereference_bh(ca->params);
>>> +
>>> +	tcf_lastuse_update(&ca->tcf_tm);
>>> +	bstats_update(&ca->tcf_bstats, skb);
>>> +	action = READ_ONCE(ca->tcf_action);
>>> +
>>> +	wlen = skb_network_offset(skb);
>>> +	if (tc_skb_protocol(skb) == htons(ETH_P_IP)) {
>>> +		wlen += sizeof(struct iphdr);
>>> +		if (!pskb_may_pull(skb, wlen))
>>> +			goto out;
>>> +
>>> +		proto = NFPROTO_IPV4;
>>> +	} else if (tc_skb_protocol(skb) == htons(ETH_P_IPV6)) {
>>> +		wlen += sizeof(struct ipv6hdr);
>>> +		if (!pskb_may_pull(skb, wlen))
>>> +			goto out;
>>> +
>>> +		proto = NFPROTO_IPV6;
>>> +	} else {
>>> +		goto out;
>>> +	}
>>> +
>>> +	ct = nf_ct_get(skb, &ctinfo);
>>> +	if (!ct) { /* look harder, usually ingress */
>>> +		if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
>>> +				       proto, cp->net, &tuple))
>>> +			goto out;
>>> +		zone.id = cp->zone;
>>> +		zone.dir = NF_CT_DEFAULT_ZONE_DIR;
>>> +
>>> +		thash = nf_conntrack_find_get(cp->net, &zone, &tuple);
>>> +		if (!thash)
>>> +			goto out;
>>> +
>>> +		ct = nf_ct_tuplehash_to_ctrack(thash);
>>> +	}
>>> +
>>> +	if (cp->mode & CTINFO_MODE_SETDSCP)
>>> +		if (!cp->dscpstatemask || (ct->mark & cp->dscpstatemask))
>>> +			tcf_ctinfo_dscp_set(ct, ca, cp, skb, wlen, proto);
>>> +
>>> +	if (cp->mode & CTINFO_MODE_SETMARK)
>>> +		tcf_ctinfo_mark_set(ct, ca, cp, skb);
>>> +
>>> +	if (thash)
>>> +		nf_ct_put(ct);
>>> +out:
>>> +	return action;
>>> +}
>>> +
>>> +static const struct nla_policy ctinfo_policy[TCA_CTINFO_MAX + 1] = {
>>> +	[TCA_CTINFO_ACT] = { .len = sizeof(struct tc_ctinfo) },
>>> +	[TCA_CTINFO_ZONE] = { .type = NLA_U16 },
>>> +	[TCA_CTINFO_MODE_DSCP] = { .type = NLA_FLAG },
>>> +	[TCA_CTINFO_MODE_MARK] = { .type = NLA_FLAG },
>>> +	[TCA_CTINFO_DSCP_PARMS] = { .len = sizeof(struct tc_ctinfo_dscp)
>>> },
>> 
>> Think you're missing some parameters here? At least
>> TCA_CTINFO_MARK_MASK.
>
> Good catch. That one is missing, the others are not as those are going
> from kernel to user space. So on the basis I have to do a v5, does
> anyone object if I make the policy order match the enum order in
> include/uapi/linux/tc_act/tc_ctinfo.h? Do I need to be wary of
> Christmas trees or spacing or …?

The compiler certainly doesn't care. Don't think there's any christmas
tree convention here, but lining them up on the first = seems to be
common, so I'd go with that :)

>> 
>>> +};
>>> +
>>> +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
>>> +			   struct nlattr *est, struct tc_action **a,
>>> +			   int ovr, int bind, bool rtnl_held,
>>> +			   struct tcf_proto *tp,
>>> +			   struct netlink_ext_ack *extack)
>>> +{
>>> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
>>> +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
>>> +	struct tcf_ctinfo_params *cp_new;
>>> +	struct tcf_chain *goto_ch = NULL;
>>> +	struct tc_ctinfo_dscp *dscpparm;
>>> +	struct tcf_ctinfo *ci;
>>> +	struct tc_ctinfo *actparm;
>>> +	int ret = 0, err, i;
>>> +
>>> +	if (!nla)
>>> +		return -EINVAL;
>>> +
>>> +	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);
>>> +	if (err < 0)
>>> +		return err;
>>> +
>>> +	if (!tb[TCA_CTINFO_ACT])
>>> +		return -EINVAL;
>>> +
>>> +	if (tb[TCA_CTINFO_MODE_DSCP] && !tb[TCA_CTINFO_DSCP_PARMS])
>>> +		return -EINVAL;
>>> +
>>> +	actparm = nla_data(tb[TCA_CTINFO_ACT]);
>>> +	dscpparm = nla_data(tb[TCA_CTINFO_DSCP_PARMS]);
>>> +
>>> +	if (dscpparm) {
>>> +		/* need at least contiguous 6 bit mask */
>>> +		i = dscpparm->mask ? __ffs(dscpparm->mask) : 0;
>>> +		if ((0x3f & (dscpparm->mask >> i)) != 0x3f)
>>> +			return -EINVAL;
>> 
>> Should this be enforced to be exactly 6 bits? Anything above that is
>> going to be discarded anyway…
>
> I don’t know. Might someone want to extend this function in the future
> and do something unforeseen and putting a hard limit now breaks that
> and backward compatibility? If difference between accepted or not
> clearly I’ll change it to something like
>
> if ((~0 & (dscpparm->mask >> i)) != 0x3f)
>
> but I’m somewhat ‘meh’ about it and findit hard to form an opinion one
> way or the other

If you restrict it now, we can always lift the restriction later, and
userspace will be able to tell (by trying a wider mask and see if it
works). If it's not restricted now, there's no way for userspace to
tell, if the behaviour changes.

So I'd say, go with the strict verification.

>> 
>>> +		/* mask & statemask must not overlap */
>>> +		if (dscpparm->mask & dscpparm->statemask)
>>> +			return -EINVAL;
>>> +	}
>>> +
>>> +	/* done the validation:now to the actual action allocation */
>>> +	err = tcf_idr_check_alloc(tn, &actparm->index, a, bind);
>>> +	if (!err) {
>>> +		ret = tcf_idr_create(tn, actparm->index, est, a,
>>> +				     &act_ctinfo_ops, bind, false);
>>> +		if (ret) {
>>> +			tcf_idr_cleanup(tn, actparm->index);
>>> +			return ret;
>>> +		}
>>> +	} else if (err > 0) {
>>> +		if (bind) /* don't override defaults */
>>> +			return 0;
>>> +		if (!ovr) {
>>> +			tcf_idr_release(*a, bind);
>>> +			return -EEXIST;
>>> +		}
>>> +	} else {
>>> +		return err;
>>> +	}
>>> +
>>> +	err = tcf_action_check_ctrlact(actparm->action, tp, &goto_ch, extack);
>>> +	if (err < 0)
>>> +		goto release_idr;
>>> +
>>> +	ci = to_ctinfo(*a);
>>> +
>>> +	cp_new = kzalloc(sizeof(*cp_new), GFP_KERNEL);
>>> +	if (unlikely(!cp_new)) {
>>> +		err = -ENOMEM;
>>> +		goto put_chain;
>>> +	}
>>> +
>>> +	cp_new->net = net;
>>> +	cp_new->zone = tb[TCA_CTINFO_ZONE] ?
>>> +			nla_get_u16(tb[TCA_CTINFO_ZONE]) : 0;
>>> +	if (dscpparm) {
>>> +		cp_new->dscpmask = dscpparm->mask;
>>> +		cp_new->dscpmaskshift = cp_new->dscpmask ?
>>> +				__ffs(cp_new->dscpmask) : 0;
>>> +		cp_new->dscpstatemask = dscpparm->statemask;
>>> +	}
>>> +	cp_new->markmask = tb[TCA_CTINFO_MARK_MASK] ?
>>> +			nla_get_u32(tb[TCA_CTINFO_MARK_MASK]) : ~0;
>>> +
>>> +	if (tb[TCA_CTINFO_MODE_DSCP])
>>> +		cp_new->mode |= CTINFO_MODE_SETDSCP;
>>> +	else
>>> +		cp_new->mode &= ~CTINFO_MODE_SETDSCP;
>>> +
>>> +	if (tb[TCA_CTINFO_MODE_MARK])
>>> +		cp_new->mode |= CTINFO_MODE_SETMARK;
>>> +	else
>>> +		cp_new->mode &= ~CTINFO_MODE_SETMARK;
>>> +
>>> +	spin_lock_bh(&ci->tcf_lock);
>>> +	goto_ch = tcf_action_set_ctrlact(*a, actparm->action, goto_ch);
>>> +	rcu_swap_protected(ci->params, cp_new,
>>> +			   lockdep_is_held(&ci->tcf_lock));
>>> +	spin_unlock_bh(&ci->tcf_lock);
>>> +
>>> +	if (goto_ch)
>>> +		tcf_chain_put_by_act(goto_ch);
>>> +	if (cp_new)
>>> +		kfree_rcu(cp_new, rcu);
>>> +
>>> +	if (ret == ACT_P_CREATED)
>>> +		tcf_idr_insert(tn, *a);
>>> +
>>> +	return ret;
>>> +
>>> +put_chain:
>>> +	if (goto_ch)
>>> +		tcf_chain_put_by_act(goto_ch);
>>> +release_idr:
>>> +	tcf_idr_release(*a, bind);
>>> +	return err;
>>> +}
>>> +
>>> +static int tcf_ctinfo_dump(struct sk_buff *skb, struct tc_action *a,
>>> +			   int bind, int ref)
>>> +{
>>> +	struct tcf_ctinfo *ci = to_ctinfo(a);
>>> +	struct tc_ctinfo opt = {
>>> +		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
>>> +		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
>>> +		.index   = ci->tcf_index,
>>> +	};
>>> +	unsigned char *b = skb_tail_pointer(skb);
>>> +	struct tc_ctinfo_stats_dscp dscpstats;
>>> +	struct tc_ctinfo_dscp dscpparm;
>>> +	struct tcf_ctinfo_params *cp;
>>> +	struct tcf_t t;
>>> +
>>> +	spin_lock_bh(&ci->tcf_lock);
>>> +	cp = rcu_dereference_protected(ci->params,
>>> +				       lockdep_is_held(&ci->tcf_lock));
>>> +	opt.action = ci->tcf_action;
>>> +
>>> +	if (nla_put(skb, TCA_CTINFO_ACT, sizeof(opt), &opt))
>>> +		goto nla_put_failure;
>>> +
>>> +	if (cp->mode & CTINFO_MODE_SETDSCP) {
>>> +		dscpparm.mask = cp->dscpmask;
>>> +		dscpparm.statemask = cp->dscpstatemask;
>>> +		if (nla_put(skb, TCA_CTINFO_DSCP_PARMS, sizeof(dscpparm),
>>> +			    &dscpparm))
>>> +			goto nla_put_failure;
>>> +
>>> +		if (nla_put_flag(skb, TCA_CTINFO_MODE_DSCP))
>>> +			goto nla_put_failure;
>>> +
>>> +		dscpstats.set = ci->stats_dscp_set;
>>> +		dscpstats.error = ci->stats_dscp_error;
>>> +		if (nla_put(skb, TCA_CTINFO_STATS_DSCP, sizeof(dscpstats),
>>> +			    &dscpstats))
>>> +			goto nla_put_failure;
>>> +	}
>>> +
>>> +	if (cp->mode & CTINFO_MODE_SETMARK) {
>>> +		if (nla_put_u32(skb, TCA_CTINFO_MARK_MASK, cp->markmask))
>>> +			goto nla_put_failure;
>>> +
>>> +		if (nla_put_flag(skb, TCA_CTINFO_MODE_MARK))
>>> +			goto nla_put_failure;
>>> +
>>> +		if (nla_put_u64_64bit(skb, TCA_CTINFO_STATS_MARK,
>>> +				      ci->stats_mark_set, TCA_CTINFO_PAD))
>>> +			goto nla_put_failure;
>>> +	}
>>> +
>>> +	if (cp->zone) {
>>> +		if (nla_put_u16(skb, TCA_CTINFO_ZONE, cp->zone))
>>> +			goto nla_put_failure;
>>> +	}
>>> +
>>> +	tcf_tm_dump(&t, &ci->tcf_tm);
>>> +	if (nla_put_64bit(skb, TCA_CTINFO_TM, sizeof(t), &t, TCA_CTINFO_PAD))
>>> +		goto nla_put_failure;
>>> +
>>> +	spin_unlock_bh(&ci->tcf_lock);
>>> +	return skb->len;
>>> +
>>> +nla_put_failure:
>>> +	spin_unlock_bh(&ci->tcf_lock);
>>> +	nlmsg_trim(skb, b);
>>> +	return -1;
>>> +}
>>> +
>>> +static int tcf_ctinfo_walker(struct net *net, struct sk_buff *skb,
>>> +			     struct netlink_callback *cb, int type,
>>> +			     const struct tc_action_ops *ops,
>>> +			     struct netlink_ext_ack *extack)
>>> +{
>>> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
>>> +
>>> +	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
>>> +}
>>> +
>>> +static int tcf_ctinfo_search(struct net *net, struct tc_action **a, u32 index)
>>> +{
>>> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
>>> +
>>> +	return tcf_idr_search(tn, a, index);
>>> +}
>>> +
>>> +static struct tc_action_ops act_ctinfo_ops = {
>>> +	.kind		=	"ctinfo",
>>> +	.id		=	TCA_ID_CTINFO,
>>> +	.owner		=	THIS_MODULE,
>>> +	.act		=	tcf_ctinfo_act,
>>> +	.dump		=	tcf_ctinfo_dump,
>>> +	.init		=	tcf_ctinfo_init,
>>> +	.walk		=	tcf_ctinfo_walker,
>>> +	.lookup		=	tcf_ctinfo_search,
>> 
>> After applying the patch, the = doesn't align for this line for me…
>
> I’ve looked in vi and a straightforward cat and it all lines up for me.
> Can’t find any stray whitespace.  Don’t know what I’m doing wrong.

Think this is just my editor being weird; so just disregard this :)

>>> +	.size		=	sizeof(struct tcf_ctinfo),
>>> +};
>>> +
>>> +static __net_init int ctinfo_init_net(struct net *net)
>>> +{
>>> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
>>> +
>>> +	return tc_action_net_init(tn, &act_ctinfo_ops);
>>> +}
>>> +
>>> +static void __net_exit ctinfo_exit_net(struct list_head *net_list)
>>> +{
>>> +	tc_action_net_exit(net_list, ctinfo_net_id);
>>> +}
>>> +
>>> +static struct pernet_operations ctinfo_net_ops = {
>>> +	.init = ctinfo_init_net,
>>> +	.exit_batch = ctinfo_exit_net,
>>> +	.id   = &ctinfo_net_id,
>>> +	.size = sizeof(struct tc_action_net),
>>> +};
>>> +
>>> +static int __init ctinfo_init_module(void)
>>> +{
>>> +	return tcf_register_action(&act_ctinfo_ops, &ctinfo_net_ops);
>>> +}
>>> +
>>> +static void __exit ctinfo_cleanup_module(void)
>>> +{
>>> +	tcf_unregister_action(&act_ctinfo_ops, &ctinfo_net_ops);
>>> +}
>>> +
>>> +module_init(ctinfo_init_module);
>>> +module_exit(ctinfo_cleanup_module);
>>> +MODULE_AUTHOR("Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>");
>>> +MODULE_DESCRIPTION("Connection tracking mark actions");
>>> +MODULE_LICENSE("GPL");
>>> diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
>>> index 203302065458..b235efd55367 100644
>>> --- a/tools/testing/selftests/tc-testing/config
>>> +++ b/tools/testing/selftests/tc-testing/config
>>> @@ -38,6 +38,7 @@ CONFIG_NET_ACT_CSUM=m
>>> CONFIG_NET_ACT_VLAN=m
>>> CONFIG_NET_ACT_BPF=m
>>> CONFIG_NET_ACT_CONNMARK=m
>>> +CONFIG_NET_ACT_CTINFO=m
>>> CONFIG_NET_ACT_SKBMOD=m
>>> CONFIG_NET_ACT_IFE=m
>>> CONFIG_NET_ACT_TUNNEL_KEY=m
>>> -- 
>>> 2.20.1 (Apple Git-117)
