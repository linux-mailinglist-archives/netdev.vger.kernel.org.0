Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE72B17BF76
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCFNpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:45:45 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38095 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgCFNpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:45:44 -0500
Received: by mail-qt1-f194.google.com with SMTP id e20so1718510qto.5
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nk7C3XxGyTF7iWPu2/EkF9VGRiJacLeDeBvqcyxmwHI=;
        b=nUJPWwx0NidqZNW8X2+cEop3n2UEKabpj2zuWfXNkjH7LINmM/ejp/GdFfEA5eQlLx
         5pc3UFXAQ9vlAC2UbAXldV3+9CePgIQR65wR8qq0PjSISlyMsxlWNgAyQkjEIbllCXiK
         mj08H7enbwocYlhjL+Rq0NVOwnkEl0jGTF328knFuTKIac7hkVyz2wHfJVdwlriKOWvZ
         JFGQ8TWLmR8ZN7VrGSergOgDtrhI4MIFoiOagTKwBg3yGX4/3ro80VOsbUDVnnV2IoQM
         YwrZNzh6gkVXY+8FbKPisryygKavgWra1mEv6RdNPYE6x6IXSmAwBamd39+IC/zDaFqn
         +TWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nk7C3XxGyTF7iWPu2/EkF9VGRiJacLeDeBvqcyxmwHI=;
        b=I88NihMjroAhhU4+K26mZiVdXS+23RBJhz4pgLXVzbjJpXhSt87nMHPQKf8R7S9orb
         pV3xyHGdwEVR8FNcukwNhqp3wjGzpkyE98O4k6biQImWcdzKbWPyxsvYRdkr1NDAggtD
         twnyAPJff8iAxoYiJYhkeGLL0eWj9e0H/UvhKTxd4BQWa9MIMPAzxWlfrgAFZ/Al/FEj
         wBbzh6VZMGugRqBdqDtICcli/y1evP7F/HS90GKrkL9meWp4GmoKuBnmU5GxY3nnDo+u
         rKx7+HeHzDZijbQCUU+b7R0I4HHLuIlj1Mzp5oTH2CQxZX/+ZCwgTrj6Vc/nxchANy1W
         Z3ow==
X-Gm-Message-State: ANhLgQ0uVuMAv7UFGfmpnpFbDUjHp+Io3ebrt4Jk4UvY6S8fSgF/ORKf
        4Xd3o3bf/Dwi0g8rslr1duA=
X-Google-Smtp-Source: ADFU+vvrjz+w7rs/Js75utd3O20U+pNvl7/4ZiVaNfT1Fwzq/VxaOcZZR/0Z1BmUuRoqa+aB6oTWFA==
X-Received: by 2002:ac8:7592:: with SMTP id s18mr2937696qtq.8.1583502343139;
        Fri, 06 Mar 2020 05:45:43 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.122])
        by smtp.gmail.com with ESMTPSA id p191sm832243qke.6.2020.03.06.05.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:45:42 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 033F4C1BF2; Fri,  6 Mar 2020 10:45:39 -0300 (-03)
Date:   Fri, 6 Mar 2020 10:45:39 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next ct-offload 02/13] net/sched: act_ct: Instantiate
 flow table entry actions
Message-ID: <20200306134539.GI2546@localhost.localdomain>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
 <1583422468-8456-3-git-send-email-paulb@mellanox.com>
 <ce72a853-a416-4162-5ffb-c719c98fb7cc@solarflare.com>
 <8f58e2b3-c1f6-4c75-6662-8f356f3b4838@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f58e2b3-c1f6-4c75-6662-8f356f3b4838@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 06, 2020 at 03:22:01PM +0200, Paul Blakey wrote:
> 
> On 06/03/2020 13:35, Edward Cree wrote:
> > On 05/03/2020 15:34, Paul Blakey wrote:
> >> NF flow table API associate 5-tuple rule with an action list by calling
> >> the flow table type action() CB to fill the rule's actions.
> >>
> >> In action CB of act_ct, populate the ct offload entry actions with a new
> >> ct_metadata action. Initialize the ct_metadata with the ct mark, label and
> >> zone information. If ct nat was performed, then also append the relevant
> >> packet mangle actions (e.g. ipv4/ipv6/tcp/udp header rewrites).
> > On one hand, the mangle actions are what's already there and they're general
> >  enough to cover this.  But on the other hand, an explicit NAT flow_action
> >  would mean drivers didn't have to grovel through the mangles to figure out
> >  that NAT is what they're doing, in the case of HW that supports NAT but not
> >  arbitrary pedit mangles.  On the gripping hand, if the 'NAT recogniser' can
> >  be wrapped up in a library function that drivers can use, that would
> >  probably be OK too.
> >
> >> Drivers that offload the ft entries may match on the 5-tuple and perform
> >> the action list.
> >>
> >> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> >> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> >> ---<snip>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> >> index 23eba61..0773456 100644
> >> --- a/net/sched/act_ct.c
> >> +++ b/net/sched/act_ct.c
> >> @@ -55,7 +55,199 @@ struct tcf_ct_flow_table {
> >>  	.automatic_shrinking = true,
> >>  };
> >>  
> >> +static inline struct flow_action_entry *
> >> +tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
> >> +{
> >> +	int i = flow_action->num_entries++;
> >> +
> >> +	return &flow_action->entries[i];
> >> +}
> >> +
> >> +static void
> >> +tcf_ct_flow_table_add_action_nat_ipv4(const struct nf_conntrack_tuple *tuple,
> >> +				      struct nf_conntrack_tuple target,
> >> +				      struct flow_action *action)
> > This function could do with a comment explaining what it's doing.  On
> >  first reading I wondered whether those memcmp() were meant to be
> >  !memcmp().  (Though that could also just mean I need more caffeine.)

These memcmp() had caught me as well. My reading of it is: "if the
addresses are different, it needs translation".

Similar situation happens with tcp/udp translations below, but there
it's just a port so '!=' was used. (like in
tcf_ct_flow_table_add_action_nat_tcp)

> Sure I'll add one.
> >> +{
> >> +	struct flow_action_entry *entry;
> >> +
> >> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3))) {
> >> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> >> +		entry->id = FLOW_ACTION_MANGLE;
> >> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
> >> +		entry->mangle.mask = ~(0xFFFFFFFF);
> > These parens are unnecessary.
> > In fact, mask is a u32, so '0' would be equivalent, though I can see a
> >  documentational argument for keeping the ~0xffffffff spelling.
> Yes its this way because mangles masks are weird for some reason. ill remove the ().
> >
> >> +		entry->mangle.offset = offsetof(struct iphdr, saddr);
> >> +		entry->mangle.val = htonl(target.src.u3.ip);
> > AFAICT u3.ip is defined as __be32, so this htonl() is incorrect (did
> >  sparse not warn about it?).  It would rather be ntohl(), but in any
> >  case normal kernel practice is be32_to_cpu().
> Will do.
> >
> >> +	} else if (memcmp(&target.dst.u3, &tuple->dst.u3,
> >> +			  sizeof(target.dst.u3))) {
> > There have been mutterings from OVS about doing both SNAT and DNAT in a
> >  single rule.  I'm not sure if anything got merged, but it might be
> >  worth at least checking that the branches aren't both true, rather than
> >  having an elseif that skips the dst check if the src changed.
> right, it is possible as the recent changes to act ct allows the same,ill change this to an if.
> >
> >> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> >> +		entry->id = FLOW_ACTION_MANGLE;
> >> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
> >> +		entry->mangle.mask = ~(0xFFFFFFFF);
> >> +		entry->mangle.offset = offsetof(struct iphdr, daddr);
> >> +		entry->mangle.val = htonl(target.dst.u3.ip);
> >> +	}
> >> +}
> >> +
> >> +static void
> >> +tcf_ct_flow_table_add_action_nat_ipv6(const struct nf_conntrack_tuple *tuple,
> >> +				      struct nf_conntrack_tuple target,
> >> +				      struct flow_action *action)
> >> +{
> >> +	struct flow_action_entry *entry;
> >> +	union nf_inet_addr *addr;
> >> +	u32 next_offset = 0;
> >> +	int i;
> >> +
> >> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3))) {
> >> +		addr = &target.src.u3;
> >> +		next_offset = offsetof(struct iphdr, saddr);
> > Instead of setting parameters for the function tail (which rules out the
> >  both-src-and-dst case), you could factor out the 'make the entries' loop
> >  and just call it from here.
> 
> right now its needed with src and dst
> 
> >
> >> +	} else if (memcmp(&target.dst.u3, &tuple->dst.u3,
> >> +			  sizeof(target.dst.u3))) {
> >> +		addr = &target.dst.u3;
> >> +		next_offset = offsetof(struct iphdr, daddr);
> >> +	} else {
> >> +		return;
> >> +	}
> >> +
> >> +	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++) {
> >> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> >> +		entry->id = FLOW_ACTION_MANGLE;
> >> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP6;
> >> +		entry->mangle.mask = ~(0xFFFFFFFF);
> >> +		entry->mangle.val = htonl(addr->ip6[i]);
> >> +		entry->mangle.offset = next_offset;
> > You don't need to perform strength reduction, the compiler is smart
> >  enough to do that itself.  Just using 'offset + i * sizeof(u32)' here
> >  would be clearer imho.
> >  
> Not my intention :) but will do.
> >> +
> >> +		next_offset += sizeof(u32);
> >> +	}
> >> +}
> >> +
> >> +static void
> >> +tcf_ct_flow_table_add_action_nat_tcp(const struct nf_conntrack_tuple *tuple,
> >> +				     struct nf_conntrack_tuple target,
> >> +				     struct flow_action *action)
> >> +{
> >> +	struct flow_action_entry *entry;
> >> +
> >> +	if (target.src.u.tcp.port != tuple->src.u.tcp.port) {
> >> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> >> +		entry->id = FLOW_ACTION_MANGLE;
> >> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
> >> +		entry->mangle.mask = ~(0xFFFF);
> > More unnecessary parens.
> will remove the all .
> >
> >> +		entry->mangle.offset = offsetof(struct tcphdr, source);
> >> +		entry->mangle.val = htons(target.src.u.tcp.port);
> >> +	} else if (target.dst.u.tcp.port != tuple->dst.u.tcp.port) {
> >> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> >> +		entry->id = FLOW_ACTION_MANGLE;
> >> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
> >> +		entry->mangle.mask = ~(0xFFFF);
> >> +		entry->mangle.offset = offsetof(struct tcphdr, dest);
> >> +		entry->mangle.val = htons(target.dst.u.tcp.port);
> >> +	}
> >> +}
> >> +
> >> +static void
> >> +tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
> >> +				     struct nf_conntrack_tuple target,
> >> +				     struct flow_action *action)
> >> +{
> >> +	struct flow_action_entry *entry;
> >> +
> >> +	if (target.src.u.udp.port != tuple->src.u.udp.port) {
> >> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> >> +		entry->id = FLOW_ACTION_MANGLE;
> >> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
> >> +		entry->mangle.mask = ~(0xFFFF);
> >> +		entry->mangle.offset = offsetof(struct udphdr, source);
> >> +		entry->mangle.val = htons(target.src.u.udp.port);
> >> +	} else if (target.dst.u.udp.port != tuple->dst.u.udp.port) {
> >> +		entry = tcf_ct_flow_table_flow_action_get_next(action);
> >> +		entry->id = FLOW_ACTION_MANGLE;
> >> +		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
> >> +		entry->mangle.mask = ~(0xFFFF);
> >> +		entry->mangle.offset = offsetof(struct udphdr, dest);
> >> +		entry->mangle.val = htons(target.dst.u.udp.port);
> >> +	}
> >> +}
> > This is all very boilerplatey; I wonder if factoring it into some
> >  preprocessor [ab]use would improve matters.  Pro: less risk of a
> >  src/dst or udp/tcp typo hiding in there.  Con: have to read macros.
> 
> like ADD_MANGLE_ENTRY(action, htype,....,val)...
> 
> 		entry = tcf_ct_flow_table_flow_action_get_next(action);
> 		entry->id = FLOW_ACTION_MANGLE;
> 		entry->mangle.htype = htype;
> 		entry->mangle.mask = mask;
> 		entry->mangle.offset = offset;
> 		entry->mangle.val = val;
> ?
> then im for it.
> 
> >
> >> +
> >> +static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
> >> +					      enum ip_conntrack_dir dir,
> >> +					      struct flow_action *action)
> >> +{
> >> +	struct nf_conn_labels *ct_labels;
> >> +	struct flow_action_entry *entry;
> >> +	u32 *act_ct_labels;
> >> +
> >> +	entry = tcf_ct_flow_table_flow_action_get_next(action);
> >> +	entry->id = FLOW_ACTION_CT_METADATA;
> >> +	entry->ct_metadata.zone = nf_ct_zone(ct)->id;
> > I'm not quite sure what the zone is doing in the action.  Surely it's
> >  a property of the match.  Or does this set a ct_zone for a potential
> >  *second* conntrack lookup?
> 
> this is part of the metadata that driver should mark the with, as it
> can be matched against in following hardware tables/rules. consider
> this set of offloaded rules:

IOW, it's how it adds the zone information to packets just received,
so that it can be matched later on.

> 
> tc filter add ...... chain 0 flower ct_state -trk action ct zone 5 goto chain 1
> 
> tc filter add ...... chain 0 flower ct_state -trk action ct zone 3 goto chain 1
> 
> tc filter add ...... chain 1 flower ct_state  +trk+new action ct zone 3 commit pipe  action mirred redirect dev1
> 
> tc filter add ...... chain 1 flower ct_state  +trk+new action ct zone 5 commit pipe  action mirred redirect dev2
> 
> tc filter add ...... chain 1 flower ct_state  +trk+est ct_zone 3 action mirred redirect dev1
> 
> tc filter add ...... chain 1 flower ct_state  +trk+est ct_zone 5 action mirred redirect dev2
> 
> 
> so both offloaded +est rules match on packet metadata zone field to figure out the output port,
> 
> this is what this action tell hardware to do, mark the packet with this zone, so it can be matched against.
> 
> 
> >> +#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
> >> +	entry->ct_metadata.mark = ct->mark;
> >> +#endif
> >> +
> >> +	act_ct_labels = entry->ct_metadata.labels;
> >> +	ct_labels = nf_ct_labels_find(ct);
> >> +	if (ct_labels)
> >> +		memcpy(act_ct_labels, ct_labels->bits, NF_CT_LABELS_MAX_SIZE);
> >> +	else
> >> +		memset(act_ct_labels, 0, NF_CT_LABELS_MAX_SIZE);
> >> +}
> >> +
> >> +static void tcf_ct_flow_table_add_action_nat(struct net *net,
> >> +					     struct nf_conn *ct,
> >> +					     enum ip_conntrack_dir dir,
> >> +					     struct flow_action *action)
> >> +{
> >> +	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
> >> +	struct nf_conntrack_tuple target;
> >> +
> >> +	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
> >> +
> >> +	tuple->src.l3num == NFPROTO_IPV4 ?
> >> +		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target, action) :
> >> +		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target, action);
> > I don't think this kind of ternary [ab]use is kernel style.  Also it
> >  doesn't let you check for the "not IPV6 either" case.
> > I'd suggest a switch statement.  (And this whole tree of functions
> >  should be able to return EOPNOTSUPPs for such "can't happen" / "we
> >  are confused" cases, rather than being void.)
> we check the proto support earlier. i can change this to a switch and  move the check here.
> >
> >> +
> >> +	nf_ct_protonum(ct) == IPPROTO_TCP ?
> >> +		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action) :
> >> +		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
> >> +}
> >> +
> >> +static int tcf_ct_flow_table_fill_actions(struct net *net,
> >> +					  const struct flow_offload *flow,
> >> +					  enum flow_offload_tuple_dir tdir,
> >> +					  struct nf_flow_rule *flow_rule)
> >> +{
> >> +	struct flow_action *action = &flow_rule->rule->action;
> >> +	const struct nf_conntrack_tuple *tuple;
> >> +	struct nf_conn *ct = flow->ct;
> >> +	enum ip_conntrack_dir dir;
> >> +
> >> +	switch (tdir) {
> >> +	case FLOW_OFFLOAD_DIR_ORIGINAL:
> >> +		dir = IP_CT_DIR_ORIGINAL;
> >> +		break;
> >> +	case FLOW_OFFLOAD_DIR_REPLY:
> >> +		dir = IP_CT_DIR_REPLY;
> >> +		break;
> >> +	default:
> >> +		return -EOPNOTSUPP;
> >> +	}
> >> +
> >> +	tuple = &ct->tuplehash[dir].tuple;
> >> +	if (tuple->src.l3num != NFPROTO_IPV4 &&
> >> +	    tuple->src.l3num != NFPROTO_IPV6)
> >> +		return -EOPNOTSUPP;
> > Ah, is the proto check here rather than in
> >  tcf_ct_flow_table_add_action_nat() to ensure that you don't
> >  write *any* flow_action_entries in the unsupported case?  In
> >  that case maybe the real answer is to add a way to roll back
> >  entry additions.
> > Since tcf_ct_flow_table_flow_action_get_next() doesn't appear
> >  to do any allocation (or bounds-checking of num_entries!) it
> >  seems all that would be needed is to save the old num_entries,
> >  and restore it on failure exit.
> >
> > -ed
> 
> ill add the bounds check so there is reason for this functions to fail :)
> 
> and memset the new entries on fail.
> 
> thanks for the review.
> 
> Paul.
> 
> >
> >> +
> >> +	if (nf_ct_protonum(ct) != IPPROTO_TCP &&
> >> +	    nf_ct_protonum(ct) != IPPROTO_UDP)
> >> +		return -EOPNOTSUPP;
> >> +
> >> +	tcf_ct_flow_table_add_action_meta(ct, dir, action);
> >> +	tcf_ct_flow_table_add_action_nat(net, ct, dir, action);
> >> +	return 0;
> >> +}
> >> +
> >>  static struct nf_flowtable_type flowtable_ct = {
> >> +	.action		= tcf_ct_flow_table_fill_actions,
> >>  	.owner		= THIS_MODULE,
> >>  };
> >>  
> >>
> 
