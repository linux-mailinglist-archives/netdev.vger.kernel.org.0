Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655CA2663D4
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgIKQZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:25:34 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41815 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbgIKP0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:26:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id C82D4308;
        Fri, 11 Sep 2020 11:26:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 11:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mFlqUt
        /8BLKg7P43W/phyBdp9DFVhBsV70oZNNCSdio=; b=mwDhN41fxSABGCCjXtujRl
        w7fgjU+jAu14hqbEDFctJqb5cvSgXQVZ1oOIOE+pkNq276BwM74dQus4orHYuz0V
        3Fn4fKYFK13S0iMwd/zfUDWeEjn+Sr51yf2KUfG+WCThY7blzcI8AsLgcuhwGCNk
        JFOcuBdrGifTnwgA3uj+f2klkUrT7c7jF9vjKKCRGfIbojk9dWaIxZQqZWp+ZtKN
        /G/+fHeogPD3fyqms8ovPlKV887Jt4gsdfdZ09FNmRrBE0bx3rU2FL/jkLpU0iuN
        QVP1/SUa8N9RbcysVxq61ajyB5Nm7oRciO0Obt2GxxemaFjRl4FR+dkxbAjZs5/Q
        ==
X-ME-Sender: <xms:DJdbXwHKdWLUHZVwPAQvdoz5NFXOOBqX1PPw3bHR1lGlNw3sIkpnog>
    <xme:DJdbX5UEhh7qwuRoSgmdQlA6xok9NocRceNSEHJB_0TWMDX_Sk0yTiFvOmzXMd3qJ
    aKrLZNyLGIxjjc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefiedrudefudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:DJdbX6Ip6s2ujrRKMKBbPp88lDXfc68MbsxzSuI4u-yJu-tBZuMtVg>
    <xmx:DJdbXyGyVjDYDHZpIjzl-pFhnezdJ34puYzUjOd7xJDPNmkiARqZeA>
    <xmx:DJdbX2VCo4kUy6koiznqZCPk5jYDrbYGJJgWrNQkxVb6P6Lvd6Ic8A>
    <xmx:DJdbX1R8XEr2Vzvz02K1MNB6GEmeTV8PR7PaLV2F-DIgU0M4LoaOVw>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id C7D0E3064683;
        Fri, 11 Sep 2020 11:26:03 -0400 (EDT)
Date:   Fri, 11 Sep 2020 18:26:01 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 09/22] rtnetlink: Add RTNH_F_TRAP flag
Message-ID: <20200911152601.GE3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-10-idosch@idosch.org>
 <c7159988-c052-0a5c-8b6b-670fd16be1ac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7159988-c052-0a5c-8b6b-670fd16be1ac@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 09:02:33AM -0600, David Ahern wrote:
> On 9/8/20 3:10 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > The flag indicates to user space that the nexthop is not programmed to
> > forward packets in hardware, but rather to trap them.
> 
> please elaborate in the commit message on what 'trap' is doing. I most
> likely will forget a few years from now.

Reworded to:

"
rtnetlink: Add RTNH_F_TRAP flag

The flag indicates to user space that the nexthop is not programmed to
forward packets in hardware, but rather to trap them to the CPU. This is
needed, for example, when the MAC of the nexthop neighbour is not
resolved and packets should reach the CPU to trigger neighbour
resolution.

The flag will be used in subsequent patches by netdevsim to test nexthop
objects programming to device drivers and in the future by mlxsw as
well.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
"

> 
> > 
> > The flag will be used in subsequent patches by netdevsim to test nexthop
> > objects programming to device drivers and in the future by mlxsw as
> > well.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  include/uapi/linux/rtnetlink.h | 6 ++++--
> >  net/ipv4/fib_semantics.c       | 2 ++
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> > 
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>
