Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848662B0A07
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgKLQdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:33:13 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45869 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727646AbgKLQdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 11:33:11 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C58F5C00C2;
        Thu, 12 Nov 2020 11:33:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 12 Nov 2020 11:33:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=F1cPPC
        Wql/rfrn4UySuUzH8Jeh/NeA/yPmCSipWGL00=; b=H2LBj05g9MUFn5bgIpyRJ8
        yRbSrmfzWTY3Tn0LxUtVdDa3SxVXpBWKD1rYenm7Z3WVCTM5cRf3cwcI0eF6Ojol
        cH3uIXj+B30MGodVDdq1cHKVC9/zk7nQJVBGuPpePoXWwwTqZwKIFc8lXBiOigUD
        H4TGCRl1KJiN6Nt2RoOhafcEv1G0blMdtvtYx8s5Z56Rh7TzSO/px9IItHs0//Bp
        z5IS+090nHVzi1CLv1KTO2dAopXa0qHlZIke68N2Q2JRlOVz4xVxotx8lzWPkSi5
        UdFg/imfpHVkx6mPIdoQgC7BtjSJ4jJkRtXqIUgh3/5fviQxYtPXCJ6R41QidnxA
        ==
X-ME-Sender: <xms:xWOtXyb9obywjW8cwQ3r_dKkSh0eDHYCuoye86jj0VXhxPXeYwVcPg>
    <xme:xWOtX1YJZ3UrmgxIyETJR9YGKDFXrAcfQPXbzUNBB1otgbE7vkFs4WoxxfsnUFSeN
    TeI7yMezT1zKR8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvfedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheegrddugeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xWOtX8-V6rW5w3tR1iULFfn-06M2VaOT0MYs3--0aVG07SowgOu24A>
    <xmx:xWOtX0ovMRmgAjOLYqW2DsdDrf6TfC37qKildt0WpYO2LhuDyeMyiQ>
    <xmx:xWOtX9pi6eqr8B-poPU693X96gPaKoagBw8o3qtca4e2oioBkja89g>
    <xmx:xmOtX-f3wMnvQkxxYqXY7J7cg-7gImFFNJvIzvRe2sX6V33FYBQPPw>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1DD6B3067E36;
        Thu, 12 Nov 2020 11:33:08 -0500 (EST)
Date:   Thu, 12 Nov 2020 18:33:07 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Moshe Shemesh <moshe@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>
Subject: Re: bug report: WARNING in bonding
Message-ID: <20201112163307.GA2140537@shredder>
References: <fb299ee2-4cf0-31d8-70f4-874da43e0021@gmail.com>
 <20201112154627.GA2138135@shredder>
 <e864f9a3-cda7-e498-91f4-894921527eaf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e864f9a3-cda7-e498-91f4-894921527eaf@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 05:54:30PM +0200, Tariq Toukan wrote:
> 
> 
> On 11/12/2020 5:46 PM, Ido Schimmel wrote:
> > On Thu, Nov 12, 2020 at 05:38:44PM +0200, Tariq Toukan wrote:
> > > Hi all,
> > > 
> > > In the past ~2-3 weeks, we started seeing the following WARNING and traces
> > > in our regression testing systems, almost every day.
> > > 
> > > Reproduction is not stable, and not isolated to a specific test, so it's
> > > hard to bisect.
> > > 
> > > Any idea what could this be?
> > > Or what is the suspected offending patch?
> > 
> > Do you have commit f8e48a3dca06 ("lockdep: Fix preemption WARN for spurious
> > IRQ-enable")? I think it fixed the issue for me
> > 
> 
> We do have it. Yet issue still exists.

I checked my mail and apparently we stopped seeing this warning after I
fixed a lockdep issue (spin_lock() vs spin_lock_bh()) in a yet to be
submitted patch. Do you see any other lockdep warnings in the log
besides this one? Maybe something in mlx4/5 which is why syzbot didn't
hit it?
