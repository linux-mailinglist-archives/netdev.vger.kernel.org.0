Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AA842F5D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfFLSwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:52:23 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33012 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFLSwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:52:23 -0400
Received: by mail-qt1-f193.google.com with SMTP id x2so18754717qtr.0
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 11:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=5HEpHiZZqLSYJmZTImcPaOUkV3ZzlMOc/BOTY/7R83E=;
        b=MNK9zygkriOzvyyGgO9dxSyP8Kgsfx7HArawKAkPQHtFyrzyEq++sJhb6A98HrdtP6
         jp1bXaqlpdjfH6sR9LPKkxZGFjwf0KGSb3ot+hogeUmn1Eyd9OTYOkfqnLZx5XnisQ63
         AkCHmftmwoCvJCamtLyDH0fAANiN1bxYJDHt/WaHY/0syu7zKGMDHKv8l1bF8SR/Bn66
         WpL7Yo97rqkVPGrKjWG+S1TBzz628z9MKYsfXJE3UtH4ttC5HCCqcKDu2BoALIIAxmtQ
         2rN0welLNDcz/6PEP5D0PcFlpwDqvOqx/StVk3B/CGNIwsgIL/Qs4eapXqe6gUvmKvSk
         YURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=5HEpHiZZqLSYJmZTImcPaOUkV3ZzlMOc/BOTY/7R83E=;
        b=gVlMIOQ1BlZ/oVtndz3kmwQmRTtJtiQomq6d6jxmoX4Caylyu9qwi807+58RXkDaul
         MvEBQK5QDq00TiIwG1dzxtFtY2himFRwa9yBYpeM/6ajgkQzBbnu6v8IPsU7Y0LZa2yR
         rnazwxjnxghJKsuTLTyZAZzjs2RpkI5XyTyYWOIxCxTNN+ugCu+KACfHETC4oM4GmDBg
         pPfJtampL/qYFb3IcHeibYKhaL/Y6Jl5KuImLyB/VxQVP7HiGHOtMg1qHwqSNO7S/TXg
         XvsLzAUjzNw0m7F4vV6QznWCYhLLUkTjZCobj12A7cB5uWKg87YRfqkLbbDg+wmoZ2DG
         ldtg==
X-Gm-Message-State: APjAAAVwK9XORWC87wrUvgWzy6YHknFD17kWGiKr+W9CV2YMAs0Y2Lty
        1USaZ4ekcx/a2Af0wq0ViBQ=
X-Google-Smtp-Source: APXvYqxzsWt1xo/RoQ8TTHkl7iq01cxIvI4msLNbfm3vOEOxfSC2xhUPPzAOU8XBaSsLeCguHJtjkA==
X-Received: by 2002:a0c:a8d2:: with SMTP id h18mr161441qvc.16.1560365542097;
        Wed, 12 Jun 2019 11:52:22 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:7487:3cda:3612:d867:343f])
        by smtp.gmail.com with ESMTPSA id s11sm385056qte.49.2019.06.12.11.52.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 11:52:21 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C3FECC0FFC; Wed, 12 Jun 2019 15:52:18 -0300 (-03)
Date:   Wed, 12 Jun 2019 15:52:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>, dcaratti@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Message-ID: <20190612185218.GE3436@localhost.localdomain>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
 <20190612180239.GA3499@localhost.localdomain>
 <20190612114627.4dd137ab@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190612114627.4dd137ab@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 11:46:27AM -0700, Jakub Kicinski wrote:
> On Wed, 12 Jun 2019 15:02:39 -0300, Marcelo Ricardo Leitner wrote:
> > On Tue, May 28, 2019 at 05:03:50PM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> > ...
> > > +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
> > > +			   struct nlattr *est, struct tc_action **a,
> > > +			   int ovr, int bind, bool rtnl_held,
> > > +			   struct tcf_proto *tp,
> > > +			   struct netlink_ext_ack *extack)
> > > +{
> > > +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> > > +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
> > > +	struct tcf_ctinfo_params *cp_new;
> > > +	struct tcf_chain *goto_ch = NULL;
> > > +	u32 dscpmask = 0, dscpstatemask;
> > > +	struct tc_ctinfo *actparm;
> > > +	struct tcf_ctinfo *ci;
> > > +	u8 dscpmaskshift;
> > > +	int ret = 0, err;
> > > +
> > > +	if (!nla)
> > > +		return -EINVAL;
> > > +
> > > +	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);  
> >                                                                        ^^^^
> > Hi, two things here:
> > Why not use the extack parameter here? Took me a while to notice
> > that the EINVAL was actually hiding the issue below.
> > And also on the other two EINVALs this function returns.
> > 
> > 
> > Seems there was a race when this code went in and the stricter check
> > added by
> > b424e432e770 ("netlink: add validation of NLA_F_NESTED flag") and
> > 8cb081746c03 ("netlink: make validation more configurable for future
> > strictness").
> > 
> > I can't add these actions with current net-next and iproute-next:
> > # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
> > Error: NLA_F_NESTED is missing.
> > We have an error talking to the kernel
> > 
> > This also happens with the current post of act_ct and should also
> > happen with the act_mpls post (thus why Cc'ing John as well).
> > 
> > I'm not sure how we should fix this. In theory the kernel can't get
> > stricter with userspace here, as that breaks user applications as
> > above, so older actions can't use the more stricter parser. Should we
> > have some actions behaving one way, and newer ones in a different way?
> > That seems bad.
> > 
> > Or maybe all actions should just use nla_parse_nested_deprecated()?
> > I'm thinking this last. Yet, then the _deprecated suffix may not make
> > much sense here. WDYT?
> 
> Surely for new actions we can require strict validation, there is
> no existing user space to speak of..  Perhaps act_ctinfo and act_ct

Other than the inconsistency amongst the actions, agreed.

> got slightly confused with the race you described, but in principle
> there is nothing stopping new actions from implementing the user space
> correctly, right?

AFAICT we need to patch iproute2 outside of the action code to cope
with it. Something like:

--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -214,7 +214,7 @@ done0:
                         tail = addattr_nest(n, MAX_MSG, ++prio);
                         addattr_l(n, MAX_MSG, TCA_ACT_KIND, k, strlen(k) + 1);

-                       ret = a->parse_aopt(a, &argc, &argv, TCA_ACT_OPTIONS,
+                       ret = a->parse_aopt(a, &argc, &argv, TCA_ACT_OPTIONS | NLA_F_NESTED,

This wouldn't break the older actions, yes, but then again, to expect
a different parsing behavior from different actions.. seems weird. :)

  Marcelo
