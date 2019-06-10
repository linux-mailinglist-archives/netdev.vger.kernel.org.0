Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03E93B76E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403915AbfFJOcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:32:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37461 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403864AbfFJOcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 10:32:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6F43F222FF;
        Mon, 10 Jun 2019 10:32:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 Jun 2019 10:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oH5m8I
        3pt8Q9R91B1hHLJii/DpFG7X0rhge9YNn0x0s=; b=RMDQQBqeZuIvS7GoW2zBTw
        x4UEo2P38rHHalDxSFZcV1tLNT3zVRfnxlQAzryATeApUpzdAS9MX2sxkoH0nTE4
        Z8SNwxOqW3bvKt5Uo+IpuO04N/ij9v3beNdxxfDWc1uAmC5N0YK7XDBSgGmGn3jm
        GcXvEEcBjltSXZTJUfv/VQu4VTxxvaWSWjhLvBIQvLaLLv+udzIT4maxJq9usw3b
        sqMbaNSQkLRrdv7jTvaCklsGGLtA0JHl0iGzY2B4Wvz3A6E1OErHPhtzhiPw06Dx
        JbjqpdA9Ro/1rmOhaBjeJGtUU8R7hVJidsvp4WpXJtfcuiniG3hSXVYd1exsDhug
        ==
X-ME-Sender: <xms:32n-XDb4t5SdOCOsxcE04CSxz84wuFZXuo3LgqXJ5fnRQBrBXYGw_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehvddgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4Gn-XDzKN6OCNZhueEKc_kqhxYmUUjZ0ivP2NBcbpB2n0wSuY92ckQ>
    <xmx:4Gn-XPPCebFpruoxl4cgqLz5UL_AyGiLZ_alLi_RdFaupEPb_Dy75g>
    <xmx:4Gn-XB4K-Wt7Cgq__Lj-KVc5wFCtsnupZDxzvFBypSV7EQkEp_FtRg>
    <xmx:4Gn-XDMPPqnlaOk2bpdPLEewa8nAJaCKgRMxIsqyn2uFnd9mGxTNnA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 754D58005C;
        Mon, 10 Jun 2019 10:31:59 -0400 (EDT)
Date:   Mon, 10 Jun 2019 17:31:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/3] selftests: mlxsw: Add ethtool_lib.sh
Message-ID: <20190610143157.GA20333@splinter>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-2-idosch@idosch.org>
 <20190610135914.GH8247@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610135914.GH8247@lunn.ch>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 03:59:14PM +0200, Andrew Lunn wrote:
> > +speeds_get()
> > +{
> > +	local dev=$1; shift
> > +	local with_mode=$1; shift
> > +
> > +	local speeds_str=$(ethtool "$dev" | \
> > +		# Snip everything before the link modes section.
> > +		sed -n '/Supported link modes:/,$p' | \
> > +		# Quit processing the rest at the start of the next section.
> > +		# When checking, skip the header of this section (hence the 2,).
> > +		sed -n '2,${/^[\t][^ \t]/q};p' | \
> > +		# Drop the section header of the current section.
> > +		cut -d':' -f2)
> 
> ethtool gives you two lists of link modes:
> 
> $ sudo ethtool eth17
> Settings for eth17:
>          Supported ports: [ TP ]
>          Supported link modes:   10baseT/Half 10baseT/Full 
>                                  100baseT/Half 100baseT/Full 
>                                  1000baseT/Full 
>          Supported pause frame use: No
>          Supports auto-negotiation: Yes
>          Supported FEC modes: Not reported
>          Advertised link modes:  10baseT/Half 10baseT/Full 
>                                  100baseT/Half 100baseT/Full 
>                                  1000baseT/Full
> 
> and if auto-neg has completed, there is potentially a third list, what
> the peer is advertising.
> 
> Since this test is all about auto-neg, you should be using Advertised
> link modes, not Supported link modes. There can be supported link
> modes which you cannot advertise.

Andrew, are you suggestion to split speeds_get() into
supported_speeds_get() and advertised_speeds_get() and use each where
appropriate? Note that not all the tests are testing with autoneg on.
