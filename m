Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7858F17BBC1
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 12:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCFLfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 06:35:31 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60952 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbgCFLfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 06:35:31 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B6007BC0067;
        Fri,  6 Mar 2020 11:35:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 6 Mar 2020
 11:35:21 +0000
Subject: Re: [PATCH net-next ct-offload 02/13] net/sched: act_ct: Instantiate
 flow table entry actions
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "Oz Shlomo" <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
 <1583422468-8456-3-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <ce72a853-a416-4162-5ffb-c719c98fb7cc@solarflare.com>
Date:   Fri, 6 Mar 2020 11:35:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1583422468-8456-3-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25272.003
X-TM-AS-Result: No-18.246400-8.000000-10
X-TMASE-MatchedRID: pS5owHKhBO3mLzc6AOD8DfHkpkyUphL9B4bXdj887A8Lt1T6w2Ze0t5Q
        ZVAH5Zt2YWTnOnMH547fbYqgOvx6nZ6CKaYYGfNGR0BY8wG7yRA1TzP60UkdHQpCjqVELlwVcfe
        90Z4b3U6I/qBnWaQ8VDUMagPvxtbW9IKRKjO372FtFkauyh5b+Da6AaQm7fhmT7zqZowzdpLUiz
        ka+GYZvMfdTYAcRj4zb9KPL7e9XxPBmNJeHoaMQy2416nc3bQleRqZANnpuF8d0WOKRkwsh0Ac6
        DyoS2rICM3xCXbfIgIKKAWoXV5BUHBgpI59xlp26GyDR2ZB+cZ+tO36GYDlspGhAvBSa2i/T512
        fbtiIR1UOenCpo9x0mRMBocOrKXuyaklZFmGgKNfYa9W9OjitUxAi7xkncUq1y0aXF5eX+h0LF/
        2Oo5TicbtCG+EaSu/l+tQuGzrDjrSQWFyZqVNvQLiZxZUfodHBGvINcfHqhe4M3bcbfcMpsx88f
        AZF3vb7Z62sqiPOyVljNliJG8RJDvPek3k5ArHMDYSOHyMogIO9z+P2gwiBegoDXVX5gF6LH10A
        ehd4xmDh+uIbbYLN+dfu/1JZ9RR21ybPoGN3MdDVDSltRE1wb/I3arxTrviKBVvFbsUM5XcyOrX
        ENN0xDcCzqGyq+hit+EvWYD5FoyvPOitCEFhh6MY62qeQBkLHkWa9nMURC7bspKx4YOD3eNp0ur
        p7RJ8UzHry8SXVOqlgdpSeBIE54zXmvx1b/a89FHjNotpdxCL5MCc+du22KT6hbegvOYedyNz/h
        GNwY0/JWTm7rxMYXDbV1bIWhh2TX7PJ/OU3vKDGx/OQ1GV8rHlqZYrZqdI+gtHj7OwNO38o7Ys1
        NK4Y2f/T8BtxalPaRuaXxgremy/ufKbAE101Dd82/kKReO9
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--18.246400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25272.003
X-MDID: 1583494529-ykkOz5LeIpr3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/03/2020 15:34, Paul Blakey wrote:
> NF flow table API associate 5-tuple rule with an action list by calling
> the flow table type action() CB to fill the rule's actions.
> 
> In action CB of act_ct, populate the ct offload entry actions with a new
> ct_metadata action. Initialize the ct_metadata with the ct mark, label and
> zone information. If ct nat was performed, then also append the relevant
> packet mangle actions (e.g. ipv4/ipv6/tcp/udp header rewrites).
On one hand, the mangle actions are what's already there and they're general
 enough to cover this.  But on the other hand, an explicit NAT flow_action
 would mean drivers didn't have to grovel through the mangles to figure out
 that NAT is what they're doing, in the case of HW that supports NAT but not
 arbitrary pedit mangles.  On the gripping hand, if the 'NAT recogniser' can
 be wrapped up in a library function that drivers can use, that would
 probably be OK too.

> Drivers that offload the ft entries may match on the 5-tuple and perform
> the action list.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---<snip>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 23eba61..0773456 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -55,7 +55,199 @@ struct tcf_ct_flow_table {
>  	.automatic_shrinking = true,
>  };
>  
> +static inline struct flow_action_entry *
> +tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
> +{
> +	int i = flow_action->num_entries++;
> +
> +	return &flow_action->entries[i];
> +}
> +
> +static void
> +tcf_ct_flow_table_add_action_nat_ipv4(const struct nf_conntrack_tuple *tuple,
> +				      struct nf_conntrack_tuple target,
> +				      struct flow_action *action)
This function could do with a comment explaining what it's doing.  On
 first reading I wondered whether those memcmp() were meant to be
 !memcmp().  (Though that could also just mean I need more caffeine.)

> +{
> +	struct flow_action_entry *entry;
> +
> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3))) {
> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> +		entry->id = FLOW_ACTION_MANGLE;
> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
> +		entry->mangle.mask = ~(0xFFFFFFFF);
These parens are unnecessary.
In fact, mask is a u32, so '0' would be equivalent, though I can see a
 documentational argument for keeping the ~0xffffffff spelling.

> +		entry->mangle.offset = offsetof(struct iphdr, saddr);
> +		entry->mangle.val = htonl(target.src.u3.ip);
AFAICT u3.ip is defined as __be32, so this htonl() is incorrect (did
 sparse not warn about it?).  It would rather be ntohl(), but in any
 case normal kernel practice is be32_to_cpu().

> +	} else if (memcmp(&target.dst.u3, &tuple->dst.u3,
> +			  sizeof(target.dst.u3))) {
There have been mutterings from OVS about doing both SNAT and DNAT in a
 single rule.  I'm not sure if anything got merged, but it might be
 worth at least checking that the branches aren't both true, rather than
 having an elseif that skips the dst check if the src changed.

> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> +		entry->id = FLOW_ACTION_MANGLE;
> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
> +		entry->mangle.mask = ~(0xFFFFFFFF);
> +		entry->mangle.offset = offsetof(struct iphdr, daddr);
> +		entry->mangle.val = htonl(target.dst.u3.ip);
> +	}
> +}
> +
> +static void
> +tcf_ct_flow_table_add_action_nat_ipv6(const struct nf_conntrack_tuple *tuple,
> +				      struct nf_conntrack_tuple target,
> +				      struct flow_action *action)
> +{
> +	struct flow_action_entry *entry;
> +	union nf_inet_addr *addr;
> +	u32 next_offset = 0;
> +	int i;
> +
> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3))) {
> +		addr = &target.src.u3;
> +		next_offset = offsetof(struct iphdr, saddr);
Instead of setting parameters for the function tail (which rules out the
 both-src-and-dst case), you could factor out the 'make the entries' loop
 and just call it from here.

> +	} else if (memcmp(&target.dst.u3, &tuple->dst.u3,
> +			  sizeof(target.dst.u3))) {
> +		addr = &target.dst.u3;
> +		next_offset = offsetof(struct iphdr, daddr);
> +	} else {
> +		return;
> +	}
> +
> +	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++) {
> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> +		entry->id = FLOW_ACTION_MANGLE;
> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP6;
> +		entry->mangle.mask = ~(0xFFFFFFFF);
> +		entry->mangle.val = htonl(addr->ip6[i]);
> +		entry->mangle.offset = next_offset;
You don't need to perform strength reduction, the compiler is smart
 enough to do that itself.  Just using 'offset + i * sizeof(u32)' here
 would be clearer imho.

> +
> +		next_offset += sizeof(u32);
> +	}
> +}
> +
> +static void
> +tcf_ct_flow_table_add_action_nat_tcp(const struct nf_conntrack_tuple *tuple,
> +				     struct nf_conntrack_tuple target,
> +				     struct flow_action *action)
> +{
> +	struct flow_action_entry *entry;
> +
> +	if (target.src.u.tcp.port != tuple->src.u.tcp.port) {
> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> +		entry->id = FLOW_ACTION_MANGLE;
> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
> +		entry->mangle.mask = ~(0xFFFF);
More unnecessary parens.

> +		entry->mangle.offset = offsetof(struct tcphdr, source);
> +		entry->mangle.val = htons(target.src.u.tcp.port);
> +	} else if (target.dst.u.tcp.port != tuple->dst.u.tcp.port) {
> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> +		entry->id = FLOW_ACTION_MANGLE;
> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
> +		entry->mangle.mask = ~(0xFFFF);
> +		entry->mangle.offset = offsetof(struct tcphdr, dest);
> +		entry->mangle.val = htons(target.dst.u.tcp.port);
> +	}
> +}
> +
> +static void
> +tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
> +				     struct nf_conntrack_tuple target,
> +				     struct flow_action *action)
> +{
> +	struct flow_action_entry *entry;
> +
> +	if (target.src.u.udp.port != tuple->src.u.udp.port) {
> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> +		entry->id = FLOW_ACTION_MANGLE;
> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
> +		entry->mangle.mask = ~(0xFFFF);
> +		entry->mangle.offset = offsetof(struct udphdr, source);
> +		entry->mangle.val = htons(target.src.u.udp.port);
> +	} else if (target.dst.u.udp.port != tuple->dst.u.udp.port) {
> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> +		entry->id = FLOW_ACTION_MANGLE;
> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
> +		entry->mangle.mask = ~(0xFFFF);
> +		entry->mangle.offset = offsetof(struct udphdr, dest);
> +		entry->mangle.val = htons(target.dst.u.udp.port);
> +	}
> +}
This is all very boilerplatey; I wonder if factoring it into some
 preprocessor [ab]use would improve matters.  Pro: less risk of a
 src/dst or udp/tcp typo hiding in there.  Con: have to read macros.

> +
> +static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
> +					      enum ip_conntrack_dir dir,
> +					      struct flow_action *action)
> +{
> +	struct nf_conn_labels *ct_labels;
> +	struct flow_action_entry *entry;
> +	u32 *act_ct_labels;
> +
> +	entry = tcf_ct_flow_table_flow_action_get_next(action);
> +	entry->id = FLOW_ACTION_CT_METADATA;
> +	entry->ct_metadata.zone = nf_ct_zone(ct)->id;
I'm not quite sure what the zone is doing in the action.  Surely it's
 a property of the match.  Or does this set a ct_zone for a potential
 *second* conntrack lookup?

> +#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
> +	entry->ct_metadata.mark = ct->mark;
> +#endif
> +
> +	act_ct_labels = entry->ct_metadata.labels;
> +	ct_labels = nf_ct_labels_find(ct);
> +	if (ct_labels)
> +		memcpy(act_ct_labels, ct_labels->bits, NF_CT_LABELS_MAX_SIZE);
> +	else
> +		memset(act_ct_labels, 0, NF_CT_LABELS_MAX_SIZE);
> +}
> +
> +static void tcf_ct_flow_table_add_action_nat(struct net *net,
> +					     struct nf_conn *ct,
> +					     enum ip_conntrack_dir dir,
> +					     struct flow_action *action)
> +{
> +	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
> +	struct nf_conntrack_tuple target;
> +
> +	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
> +
> +	tuple->src.l3num == NFPROTO_IPV4 ?
> +		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target, action) :
> +		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target, action);
I don't think this kind of ternary [ab]use is kernel style.  Also it
 doesn't let you check for the "not IPV6 either" case.
I'd suggest a switch statement.  (And this whole tree of functions
 should be able to return EOPNOTSUPPs for such "can't happen" / "we
 are confused" cases, rather than being void.)

> +
> +	nf_ct_protonum(ct) == IPPROTO_TCP ?
> +		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action) :
> +		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
> +}
> +
> +static int tcf_ct_flow_table_fill_actions(struct net *net,
> +					  const struct flow_offload *flow,
> +					  enum flow_offload_tuple_dir tdir,
> +					  struct nf_flow_rule *flow_rule)
> +{
> +	struct flow_action *action = &flow_rule->rule->action;
> +	const struct nf_conntrack_tuple *tuple;
> +	struct nf_conn *ct = flow->ct;
> +	enum ip_conntrack_dir dir;
> +
> +	switch (tdir) {
> +	case FLOW_OFFLOAD_DIR_ORIGINAL:
> +		dir = IP_CT_DIR_ORIGINAL;
> +		break;
> +	case FLOW_OFFLOAD_DIR_REPLY:
> +		dir = IP_CT_DIR_REPLY;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	tuple = &ct->tuplehash[dir].tuple;
> +	if (tuple->src.l3num != NFPROTO_IPV4 &&
> +	    tuple->src.l3num != NFPROTO_IPV6)
> +		return -EOPNOTSUPP;
Ah, is the proto check here rather than in
 tcf_ct_flow_table_add_action_nat() to ensure that you don't
 write *any* flow_action_entries in the unsupported case?  In
 that case maybe the real answer is to add a way to roll back
 entry additions.
Since tcf_ct_flow_table_flow_action_get_next() doesn't appear
 to do any allocation (or bounds-checking of num_entries!) it
 seems all that would be needed is to save the old num_entries,
 and restore it on failure exit.

-ed

> +
> +	if (nf_ct_protonum(ct) != IPPROTO_TCP &&
> +	    nf_ct_protonum(ct) != IPPROTO_UDP)
> +		return -EOPNOTSUPP;
> +
> +	tcf_ct_flow_table_add_action_meta(ct, dir, action);
> +	tcf_ct_flow_table_add_action_nat(net, ct, dir, action);
> +	return 0;
> +}
> +
>  static struct nf_flowtable_type flowtable_ct = {
> +	.action		= tcf_ct_flow_table_fill_actions,
>  	.owner		= THIS_MODULE,
>  };
>  
> 
