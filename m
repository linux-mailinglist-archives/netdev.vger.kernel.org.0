Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542EE2665A1
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIKRIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:08:37 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45509 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbgIKPB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:01:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id B30D56DB;
        Fri, 11 Sep 2020 10:50:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 10:50:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Aw+CDF
        YbAxbIKP7y5gHpYe/IagUN1HWLTY4iZ8GZlJM=; b=W06/qY9LJ3ZxdLNlclgV0h
        eOYxhj2oILuiofCl8C8qHn0IeBeTnllsW/9C7P68eMVRjhEgu1Y+ckH6AxmtQh8l
        2feZMDZh3OtY+aVHA4vHjM5FIB2rmNIDBq7nlQDETzmPmssDk9p8F8gIlY7OXC8G
        Nna/CzLQ6T6WP1FTAwOEWyeAnNoyml6cRXv5NxneqKf2VEBg2lkzxYgdilci7Uht
        SdRDhhX0GTfLyWjgUF3T6iP1TDRisx+jO3iqjGEgwnE13mU2qo3A2x57exGzRwal
        dnrZa6bQz/Ze8SwZk0WG5WMC534cWq3aeK414as4zbuqN9tkwEuetm4GzZE7ArMA
        ==
X-ME-Sender: <xms:sI5bX9KUMFJZsM4y6EWNUkfUgs2OrW9EwmzsYXAPPt3WOgCFPvg57w>
    <xme:sI5bX5Il8jkAcYI2j6GYCo17p4ZQp4lp8Kid3yfgcrAX4SSvNnQAJuNnZ96YurMMx
    4pgskkNab5GZGU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefiedrudefudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:sI5bX1uD02-Ob9kijTyq3ZAmpAKoFCCBJkvS0W2tDH_gXlVZVk479A>
    <xmx:sI5bX-Yb2usAfcd_SeDSqQM7edkCdGxE_6AwPY6QN-snsq1SA4I7UA>
    <xmx:sI5bX0ZJOsm7Oepe7CwoYo_TdkRTJHQFCM4Hey3-1VwS6AAup-yIQw>
    <xmx:sI5bX8FcNPQFt3-LfBZibjc-5BrD4b1XNFODgEAJ6x0zSXxO95MmfQ>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0FE0306467D;
        Fri, 11 Sep 2020 10:50:23 -0400 (EDT)
Date:   Fri, 11 Sep 2020 17:50:20 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 05/22] nexthop: Add nexthop notification
 data structures
Message-ID: <20200911145020.GB3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-6-idosch@idosch.org>
 <bd4902d0-3e69-aca8-c59c-9c2496b75173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4902d0-3e69-aca8-c59c-9c2496b75173@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 08:43:10AM -0600, David Ahern wrote:
> On 9/8/20 3:10 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Add data structures that will be used for nexthop replace and delete
> > notifications in the previously introduced nexthop notification chain.
> > 
> > New data structures are added instead of passing the existing nexthop
> > code structures directly for several reasons.
> > 
> > First, the existing structures encode a lot of bookkeeping information
> > which is irrelevant for listeners of the notification chain.
> > 
> > Second, the existing structures can be changed without worrying about
> > introducing regressions in listeners since they are not accessed
> > directly by them.
> > 
> > Third, listeners of the notification chain do not need to each parse the
> > relatively complex nexthop code structures. They are passing the
> > required information in a simplified way.
> 
> agreed. My preference is for only nexthop.{c,h} to understand and parse
> the nexthop structs.
> 
> 
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  include/net/nexthop.h | 35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> > 
> > diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> > index 2e44efe5709b..0bde1aa867c0 100644
> > --- a/include/net/nexthop.h
> > +++ b/include/net/nexthop.h
> > @@ -109,6 +109,41 @@ enum nexthop_event_type {
> >  	NEXTHOP_EVENT_DEL
> >  };
> >  
> > +struct nh_notifier_single_info {
> > +	struct net_device *dev;
> > +	u8 gw_family;
> > +	union {
> > +		__be32 ipv4;
> > +		struct in6_addr ipv6;
> > +	};
> > +	u8 is_reject:1,
> > +	   is_fdb:1,
> > +	   is_encap:1;
> 
> use has_encap since it refers to a configuration of a nexthop versus a
> nexthop type.

Will change.

> 
> I take it this is a placeholder until lwt offload is supported?

Yes, I will mention this in the commit message. I didn't bother parsing
all the encap configuration into the struct since no listener is going
to look at it. Only added this bit so that listeners could reject
nexthops that perform encapsulation.

> 
> besides the naming nit,
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks for the prompt review, David!
