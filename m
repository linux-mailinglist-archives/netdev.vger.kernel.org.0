Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401D52A7ED6
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 13:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgKEMnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 07:43:35 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44775 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgKEMne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 07:43:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 56FF55C0129;
        Thu,  5 Nov 2020 07:43:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 05 Nov 2020 07:43:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JB/EeF
        3GdQCMD5v32aZXPTGpl4O77qX2nCbB+0WmL2Q=; b=jfOHhc4HEIegxwyLv/wPlG
        +BI118o8W0Nkw6iizDIGViGoRZM2gGGlB5KxDsQq8CZO/BuaXv3mlZYw3Bh7pJx4
        ZoPp6gumLVJtb80g83IyoeX6Is8Oj9mzNKN88lvRZaJVvRRE8QkKYKg67+A4vJBU
        DofzjJT8TTzcsUKQWLj7RLAraO2I6tBdMb/1j4y7h6sgWv4v32C669z9HwpOZ7aU
        AZM3rJxzYA1VeKORkmc0Di8+X7BIlsweetfMML1tNMtmy4xXsWnHK9Ktggh12E+p
        wkYSiIUBzk6aMkoq2xMM5DGAFu9VB2DVllvvsgfkHpKDzWmGrJA+nhRSjXgidCWA
        ==
X-ME-Sender: <xms:dPOjX4kG-M88NZlayqALJHiQV-ioedgAwagjz1690_Io1vXiSxGi2g>
    <xme:dPOjX336u34Rjs0Ghiu0keIhP7tKmw77YPd3lSIRzuLXdo8LzlHPF63V4KUkj-gqR
    L6jIkzdWU-i-MU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtjedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeefieehjeegheeuieeiiedvjeeuvefgfeeiteelieevfeeigfdtjeeglefgieel
    ffenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkph
    epkeegrddvvdelrdduhedvrddvheehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dfOjX2pNsiF89n8Fw6dX3r7tBQWQDyW1UnZUVMZCXlbbRD0tRrud4Q>
    <xmx:dfOjX0meExnfdxGC5qiyWupqGnIeL5atrgqjPFAGPt5sajROt2T9dA>
    <xmx:dfOjX22_H8PilYgLM15xTna6s8OHMm7P65JGOv9sHhMUBNPUV-q23g>
    <xmx:dfOjX7_Jur1GWD1ccXu-JcRxpiUzuQ5hQgdkk9phxF6fVxAgOwV5ew>
Received: from localhost (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D6283060057;
        Thu,  5 Nov 2020 07:43:32 -0500 (EST)
Date:   Thu, 5 Nov 2020 14:43:29 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH ethtool] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201105124329.GA1287772@shredder>
References: <20201102184036.866513-1-idosch@idosch.org>
 <20201102225803.pcrqf6nhjlvmfxwt@lion.mk-sys.cz>
 <20201103142430.GA951743@shredder>
 <20201103235501.sw27v355z7f375k3@lion.mk-sys.cz>
 <20201104100515.GA988778@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104100515.GA988778@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 12:05:18PM +0200, Ido Schimmel wrote:
> On Wed, Nov 04, 2020 at 12:55:01AM +0100, Michal Kubecek wrote:
> > On Tue, Nov 03, 2020 at 04:24:30PM +0200, Ido Schimmel wrote:
> > > 
> > > I have the changes you requested here:
> > > https://github.com/idosch/ethtool/commit/b34d15839f2662808c566c04eda726113e20ee59
> > > 
> > > Do you want to integrate it with your nl_parse() rework or should I?
> > 
> > I pushed the combined series to
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mkubecek/ethtool.git
> > 
> > as branch mk/master/advertise-all. I only ran few quick tests so far,
> > it's not submission ready yet.
> > 
> > First two patches are unrelated fixes found while testing, I'm going to
> > submit and push them separately. Third patch reworks nl_parser()
> > handling of multiple request messages as indicated in my previous mail.
> > Fourth patch is the ioctl compatibility fix.
> 
> Great, thank you. I pushed the patches to our regression. Will go over
> the results tomorrow and let you know.

Looks OK. Thanks again.
