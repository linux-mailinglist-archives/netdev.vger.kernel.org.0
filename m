Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D19BEF38E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 03:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbfKECf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 21:35:28 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35306 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729823AbfKECf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 21:35:27 -0500
Received: by mail-lj1-f196.google.com with SMTP id r7so11267326ljg.2
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 18:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MyBf/Sy96FCqtz5f9Lb9GQm0FchwyKCI663y64OA1Xg=;
        b=m1LxAQW2ukMQqHdwnIUbM8jJYjxvAlW57wxAnu+pzNgfuWimRmH+FxkOHZXovC8Yd5
         DK+AopThRMNaPm9oxI130MuUNT7BKCdfMTQM1QLSIQgS5dV3syCxk1j+3HtsI6IrYFYr
         8q/cqyinc4jYzqgrL+lrOOFzK0vuWLrt+5b3Xvey3l5Wi2SyXMIRKAyUfXm7nuWWCiOk
         Wghu0kWIFKg28TzE24Ke+7TojmxTEeHxufbQuhpJtUkEdQOD5H1Kxv8GYc670vh8RB2m
         b6DzMbNm9nrdnt7aSUH6k9GtGWzjnJ9sJ3IGUCl5aWbI2nJWIceAOeHqtQy4KHtWp/rq
         1SLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MyBf/Sy96FCqtz5f9Lb9GQm0FchwyKCI663y64OA1Xg=;
        b=IbrTZh3g0LUgQH4wQVqcdNW4rQThfm9y79abmD3GlT8fZ2lm1NPe5pjrKW1aqA//oq
         vCaWZE94d7iqU/Rivi+/FgUTQ9MhnQ10LwiQlbvyf5y53dMSHUuMXi4e1C6VtWnu0BLU
         5tg9ehKT6S5QF20WnZX3bMQ4wAYjYsCm7a1YX5yoYT1KueGdd250N4EdIzV1/g2pelax
         mMCxCAkTkdGNnzIqFwspOLTLze3pJeDXOt1AtDgg6CVmP3a0riS/VfoDdf1Xpm5Dyr7Z
         AAV6CDMDpvdK1gOT159Y3WTJLXMon1oXBuH6cnzM0nhvBuAXmVWQli6LmOg9nNRwyxsi
         F4TA==
X-Gm-Message-State: APjAAAVLDQXg/M0BFS6TDgKTTrbz6yEgPukvrql8eZo30uSwipCoBSBM
        4EytqwwsnODjxDRzGMny6sj7Pi2aE8s=
X-Google-Smtp-Source: APXvYqyhYqtow/2SuT4R/torGxR3b3OqjhPzUUp3sPEqmd6IlYlhaaoHUtmM3oRMnkYWW4UtY8Ekow==
X-Received: by 2002:a2e:7a02:: with SMTP id v2mr15785908ljc.224.1572921325389;
        Mon, 04 Nov 2019 18:35:25 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v12sm8232087ljg.14.2019.11.04.18.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 18:35:24 -0800 (PST)
Date:   Mon, 4 Nov 2019 18:35:16 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Message-ID: <20191104183516.64ba481b@cakuba.netronome.com>
In-Reply-To: <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
        <20191031172330.58c8631a@cakuba.netronome.com>
        <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
        <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
        <20191101172102.2fc29010@cakuba.netronome.com>
        <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
        <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Nov 2019 18:47:32 -0700, David Ahern wrote:
> On 11/4/19 6:38 PM, Saeed Mahameed wrote:
> > On Fri, 2019-11-01 at 17:21 -0700, Jakub Kicinski wrote:  
> >> On Fri, 1 Nov 2019 21:28:22 +0000, Saeed Mahameed wrote:  
> >>> Bottom line, we tried to push this feature a couple of years ago,
> >>> and
> >>> due to some internal issues this submission ignored for a while,
> >>> now as
> >>> the legacy sriov customers are moving towards upstream, which is
> >>> for me
> >>> a great progress I think this feature worth the shot, also as Ariel
> >>> pointed out, VF vlan filter is really a gap that should be closed.
> >>>
> >>> For all other features it is true that the user must consider
> >>> moving to
> >>> witchdev mode or find a another community for support.
> >>>
> >>> Our policy is still strong regarding obsoleting legacy mode and
> >>> pushing
> >>> all new feature to switchdev mode, but looking at the facts here  I
> >>> do
> >>> think there is a point here and ROI to close this gap in legacy
> >>> mode.
> >>>
> >>> I hope this all make sense.   
> >>
> >> I understand and sympathize, you know full well the benefits of
> >> working
> >> upstream-first...
> >>
> >> I won't reiterate the entire response from my previous email, but the
> >> bottom line for me is that we haven't added a single legacy VF NDO
> >> since 2016, I was hoping we never will add more and I was trying to
> >> stop anyone who tried.
> >>  
> > 
> > The NDO is not the problem here, we can perfectly extend the current
> > set_vf_vlan_ndo to achieve the same goal with minimal or even NO kernel
> > changes, but first you have to look at this from my angel, i have been
> > doing lots of research and there are many points for why this should be
> > added to legacy mode:
> > 
> > 1) Switchdev mode can't replace legacy mode with a press of a button,
> > many missing pieces.
> > 
> > 2) Upstream Legacy SRIOV is incomplete since it goes together with
> > flexible vf vlan configuration, most of mlx5 legacy sriov users are
> > using customized kernels and external drivers, since upstream is
> > lacking this one basic vlan filtering feature, and many users decline
> > switching to upstream kernel due to this missing features.
> > 
> > 3) Many other vendors have this feature in customized drivers/kernels,
> > and many vendors/drivers don't even support switchdev mode (mlx4 for
> > example), we can't just tell the users of such device we are not
> > supporting basic sriov legacy mode features in upstream kernel.
> > 
> > 4) the motivation for this is to slowly move sriov users to upstream
> > and eventually to switchdev mode.  
> 
> If the legacy freeze started in 2016 and we are at the end of 2019, what
> is the migration path?

The migration path is to implement basic bridge offload which can take
care of this trivially.

Problem is people equate switchdev with OvS offload today, so bridge
offload is not actually implemented. It's really hard to convince
product marketing that it's work worth taking on.

Adding incremental features to legacy API is always going to be cheaper
than migrating controllers to switchdev.

IDK if you remember the net_failover argument about in-kernel VF to
virtio bonding. The controllers are doing the bare minimum and it's 
hard for HW vendors to justify the expense of moving forward all parts 
of the stack.

Which means SR-IOV is either stuck in pure-L2 middle ages or requires
all the SDN complexity and overhead. Switchdev bridge offload can be
trivially extended to support eVPN and simplify so many deployments,
sigh..

> > Now if the only remaining problem is the uAPI, we can minimize kernel
> > impact or even make no kernel changes at all, only ip route2 and
> > drivers, by reusing the current set_vf_vlan_ndo.  
> 
> And this caught my eye as well -- iproute2 does not need the baggage either.
> 
> Is there any reason this continued support for legacy sriov can not be
> done out of tree?

Exactly. Moving to upstream is only valuable if it doesn't require
brining all the out-of-tree baggage.
