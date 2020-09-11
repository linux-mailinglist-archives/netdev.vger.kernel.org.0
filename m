Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED8426658F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgIKRGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:06:47 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59691 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726040AbgIKPCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:02:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 395B25FD;
        Fri, 11 Sep 2020 11:01:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 11:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZBkwRA
        7NmwUIgfCFhD2iLxQnKMFDDovL9M6lmFS46ow=; b=A1ik8nc8LZ9AWKjiayh8O+
        fJdFJXuFItVrQfswB+zyayrCQK6humK1oV04XhgKTRc+K37iKx5fy+ci2+0y+bsJ
        DD3HStGm6RJHmZbtsNz0uTJ7Ux2plPHEwe2yJXVMiMJVzKZsmnyooZoEwbiS8zI9
        3VSzum/bdU1+487G++WH59uAGO6sWzgllz4aHHKzj7+O4wd40aUmJtbuHNdfvMpr
        ckCGpmVknJEUW067tvOAwV28Kxke1XRLwz2b2HxHCHsFGZbUEj0KSlkqEd8w8B7M
        T49eRkoaC+Yn1geFy5qKNjE6gBvFWhayo0ilQTrjRsACNEuqQESakFyuYSej+HrA
        ==
X-ME-Sender: <xms:U5FbX1NxuWSdPgr2_qqoKZsdekYM1DYr_sQjIuVcGPOVcsPThKpZaQ>
    <xme:U5FbX3_uPzn5TZAi82Yp_7_kJMZE2mimhvZK2J0MguqsNvYAS6pQ6rp8-DSdkAsnS
    CjwWELY-4urXWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefiedrudefudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:U5FbX0T-8sbDZDeZWZ0PVoU5Q_isdLUxq9Jpq7NXsT-Qlmb-HYxWAA>
    <xmx:U5FbXxvHeqncLnKEivYUNz45zMri-IM_mqevYtm5o1CP2QpEl-v7-A>
    <xmx:U5FbX9fMUKt7tvfGs-aZVqzusbvTjuG6ub-zUBeFBUOQas_YGlRzTQ>
    <xmx:U5FbXx5iMNHiK-HksKt_gvckzrQJjqN_Kb00lSnDspgLwkp7-KVqdg>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14C433280063;
        Fri, 11 Sep 2020 11:01:38 -0400 (EDT)
Date:   Fri, 11 Sep 2020 18:01:37 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 07/22] nexthop: Prepare new notification info
Message-ID: <20200911150137.GC3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-8-idosch@idosch.org>
 <1c27afdc-870e-f775-18c9-a7ea5afee6dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c27afdc-870e-f775-18c9-a7ea5afee6dc@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 08:55:06AM -0600, David Ahern wrote:
> On 9/8/20 3:10 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Prepare the new notification information so that it could be passed to
> > listeners in the new patch.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  net/ipv4/nexthop.c | 108 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 108 insertions(+)
> > 
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>
> 
> one trivial comment below.
> 
> > +static void
> > +__nh_notifier_single_info_init(struct nh_notifier_single_info *nh_info,
> > +			       const struct nexthop *nh)
> > +{
> > +	struct nh_info *nhi = rtnl_dereference(nh->nh_info);
> > +
> > +	nh_info->dev = nhi->fib_nhc.nhc_dev;
> > +	nh_info->gw_family = nhi->fib_nhc.nhc_gw_family;
> > +	if (nh_info->gw_family == AF_INET)
> > +		nh_info->ipv4 = nhi->fib_nhc.nhc_gw.ipv4;
> > +	else if (nh_info->gw_family == AF_INET6)
> > +		nh_info->ipv6 = nhi->fib_nhc.nhc_gw.ipv6;
> 
> add a blank line here to make it easier to read.

Done

> 
> > +	nh_info->is_reject = nhi->reject_nh;
> > +	nh_info->is_fdb = nhi->fdb_nh;
> > +	nh_info->is_encap = !!nhi->fib_nhc.nhc_lwtstate;

Also changed this to 'has_encap' given your previous comment

> > +}
> > +
> 
