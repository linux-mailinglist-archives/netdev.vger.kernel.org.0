Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A5D31ADEC
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhBMUSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:18:49 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:46599 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhBMUSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:18:48 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E8A01861;
        Sat, 13 Feb 2021 15:18:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 13 Feb 2021 15:18:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qqyWJP
        0UxwquMWfOUM4Gy+jQLU8HtAJGgG1gkcL4AX4=; b=B8/DzhlIDpeeudXoTr0pjm
        Jn0lhWA1IJEuDyiiqTl/WIyfiE/gpCin/l3uQ6fa02xmQx3RG/u6Cxr10dE9FPGV
        7SQEufExxkrb+q/PMJ7kKtmnxmBlUnm5lgJt7Radt13pHzYuvebWhuHoNakmpTdd
        aF9IMTy3tt9z7g8tPKhqadOeNGn8ef79px5qWCFjivadwcy/5Yul735l4oUvhsS/
        BKdUB4+JV+ttM2dDASir1Xgx+WaIPeUAWKkG8OwZoSBPqL7zDzHMFeSEzt7X1OGq
        SoICXL1k6Xg73HOUQi2H6mDXs6wv8Z25fMVityxMzMogs5y4VwCMZuRYAYxqOR7w
        ==
X-ME-Sender: <xms:-jMoYDMF4ZZFVJqTkloBPcyzVvelxk7FRda87K1GCpsdnuHa2LfpSg>
    <xme:-jMoYN8kdbXkNQB3fJ0HTmJlRMCU6ZyeqQKHDDdIj9o8hn8-CuugeyHa344seYWdN
    I6u-Ll_FIzTo6I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrieefgddufedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-jMoYCRl9dh1hLANZ-1uEXVF4DDQGnxDEQ8uIuDL4t2ItiQ9I2NVfw>
    <xmx:-jMoYHvUbZPI0ESvPLGVXW9vtSA9603dhKaunDxHQCMC-rJKMgBsIg>
    <xmx:-jMoYLe-UTo5kA8m-39P5WlPaUaRwuPWSDM5ZA_ABzhwOuBN8Q8pQw>
    <xmx:-jMoYH7KjbjrZopLhiQ7j8n0fsGoThScmbHIF1w0VilruY_BO419UQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED26B108005C;
        Sat, 13 Feb 2021 15:18:01 -0500 (EST)
Date:   Sat, 13 Feb 2021 22:17:58 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH 03/13] nexthop: Add netlink defines and enumerators
 for resilient NH groups
Message-ID: <20210213201758.GB401513@shredder.lan>
References: <cover.1612815057.git.petrm@nvidia.com>
 <893e22e2ad6413a98ca76134b332c8962fcd3b6a.1612815058.git.petrm@nvidia.com>
 <d3a64aea-d544-cd58-475c-57e89ea49be5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3a64aea-d544-cd58-475c-57e89ea49be5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 12:16:45PM -0700, David Ahern wrote:
> On 2/8/21 1:42 PM, Petr Machata wrote:
> > @@ -52,8 +53,50 @@ enum {
> >  	NHA_FDB,	/* flag; nexthop belongs to a bridge fdb */
> >  	/* if NHA_FDB is added, OIF, BLACKHOLE, ENCAP cannot be set */
> >  
> > +	/* nested; resilient nexthop group attributes */
> > +	NHA_RES_GROUP,
> > +	/* nested; nexthop bucket attributes */
> > +	NHA_RES_BUCKET,
> > +
> >  	__NHA_MAX,
> >  };
> >  
> >  #define NHA_MAX	(__NHA_MAX - 1)
> > +
> > +enum {
> > +	NHA_RES_GROUP_UNSPEC,
> > +	/* Pad attribute for 64-bit alignment. */
> > +	NHA_RES_GROUP_PAD = NHA_RES_GROUP_UNSPEC,
> > +
> > +	/* u32; number of nexthop buckets in a resilient nexthop group */
> > +	NHA_RES_GROUP_BUCKETS,
> 
> u32 is overkill; arguably u16 (64k) should be more than enough buckets
> for any real use case.

We wanted to make it future-proof, but I think we can live with 64k. At
least in Spectrum the maximum is 4k. I don't know about other devices,
but I guess it is not more than 64k.
