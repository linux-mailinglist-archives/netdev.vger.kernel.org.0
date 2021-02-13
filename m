Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA5331ADB8
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhBMTRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:17:12 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:56621 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229647AbhBMTRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:17:10 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 807187BD;
        Sat, 13 Feb 2021 14:16:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 13 Feb 2021 14:16:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DBm8Iv
        v4nULE4ynyVzzQ0D6z9yJdd9iQfQxXrcBh3P0=; b=fCM9sZzb11nVpvVpJ+W15X
        34C/b35OydsOkBGIJMOxgXnyWlJYx1wUAjq+XgOHTcny3BbFAaAGvEgfP+n/vOAr
        3IWsKidCPgqtTAWYesWt2cZpBGuQ0nS69jev8jRr+/1vsAp01JULbtUwNE2s5I/E
        As+W2FArslBqgAX50IOd80yweD2DX+sLEAmRysxLGbkIZTFHTTCTq1CazOmG7+ET
        fNidELSEHf59m9xf3SoFkWCxj0P3+tYN+AaerM4Xc6ic1vW6+yag9nmajEItPCwh
        U+pmL+9pZ9ZDqx6YXxnG8zLzXeNzRENp64is/q9I4J2wIPoaPaDGzgqJMpqmVpYg
        ==
X-ME-Sender: <xms:hyUoYCT31hAguYGeEVtffNA_ljf48PD26khnUg0O4EoZH-kfGwJktw>
    <xme:hyUoYHyut6L2b2qJfx9cpbxaAbW86qQmCBIyyNyUvWidzbQre9EkxOSNEUS6g861R
    gIN7wF39v_z2t4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrieefgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hyUoYP0Kqaj-e-ulxXkNi2OeMLb6nMy0nw5Bneq4-E9oUg0lGZbyrw>
    <xmx:hyUoYOBn-HuGrv4YVg_u0z4ZRTutxrty7yrlf44v0yim_eG8lhTh1A>
    <xmx:hyUoYLg-2zS-3BSeMJGZcylgPbY9BnV6qkl0aDk9oTEYJ62_NLfpOw>
    <xmx:iCUoYIuxcaTGw7vwV2prUr7UtZX4pfbNeWtP_aBUj3qKAU3SZhfGXA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52B1C1080057;
        Sat, 13 Feb 2021 14:16:23 -0500 (EST)
Date:   Sat, 13 Feb 2021 21:16:19 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH 00/13] nexthop: Resilient next-hop groups
Message-ID: <20210213191619.GA399200@shredder.lan>
References: <cover.1612815057.git.petrm@nvidia.com>
 <e15bfcec-7d1f-baea-6a9d-7bcc77104d8e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e15bfcec-7d1f-baea-6a9d-7bcc77104d8e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 11:57:03AM -0700, David Ahern wrote:
> On 2/8/21 1:42 PM, Petr Machata wrote:
> > To illustrate the usage, consider the following commands:
> > 
> >  # ip nexthop add id 1 via 192.0.2.2 dev dummy1
> >  # ip nexthop add id 2 via 192.0.2.3 dev dummy1
> >  # ip nexthop add id 10 group 1/2 type resilient \
> > 	buckets 8 idle_timer 60 unbalanced_timer 300
> > 
> > The last command creates a resilient next hop group. It will have 8
> > buckets, each bucket will be considered idle when no traffic hits it for at
> > least 60 seconds, and if the table remains out of balance for 300 seconds,
> > it will be forcefully brought into balance. (If not present in netlink
> > message, the idle timer defaults to 120 seconds, and there is no unbalanced
> > timer, meaning the group may remain unbalanced indefinitely.)
> 
> How did you come up with the default timer of 120 seconds?

It is the default in the Cumulus Linux implementation (deployed for
several years already), so we figured it should be OK.
