Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A172A6125
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgKDKFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:05:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47039 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728066AbgKDKFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 05:05:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DFB735C00A6;
        Wed,  4 Nov 2020 05:05:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 05:05:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+3zEKZ
        K0bipjuN+620fy3Gez1qenS1d4jPq+6p4Azfs=; b=IMBn3Aok7aVi5gJvsmHWwS
        N+wdeXEg6A+ghKYCDL8ut1YqT8rl2PggulRb/Z+a41xO3pOaaqzQXR7bBgqYvxOc
        bzzhUH5n+oc3GVDc/Hvmojk0R3oE+AKRBVJVmyK07SAz1yfUr/66CPimeyD/sO1U
        YloOfHx5VmSQKl3E9yUCMNtRm6k3YcP1ida/oULYQchcjygCIom0uy9Cv2NL4iQA
        U2KgpY1J+7Bc3w3xD6hBaThZCRgjHyg92nUA8/DkLvn0NO2roYd19gIQyUKKIqMR
        jawutw/or0L22MoJQd6NT1l0ic8A/iXR58Xzs4VxJgTCnqLBf70HamJbaj4kWXgw
        ==
X-ME-Sender: <xms:3nyiX5EqRuO3TsMahiyLsTAoWihzdEUcjxWygxkdFVLnndivgsoOVA>
    <xme:3nyiX-WBwBKkhHFmahPd9N5q0jKa-BREOo5B1qcdx_G_XKlahDDtH_v__EMzSge1f
    LXieksM4Haz7vs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeefieehjeegheeuieeiiedvjeeuvefgfeeiteelieevfeeigfdtjeeglefgieel
    ffenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkph
    epkeegrddvvdelrdduhedvrddvheehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3nyiX7JkJz0fNYAj6EVuMNZ0es1V-O8Pt28DY0ncDeytIf75KR6cqg>
    <xmx:3nyiX_E3OeNVuNUFo0JpgsN1ZS8BRaqqxE2UylULqUI43FfwogcNhg>
    <xmx:3nyiX_UbD_TzUxAQSDuGB3RmMlCGPQavoROZRIkBTzKbX_PlVaREmg>
    <xmx:3nyiX2fwSrSPAWv_n8fJWmn3bYZD2GsdcYHroOF602wzPZruVouzTA>
Received: from localhost (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 311E13064682;
        Wed,  4 Nov 2020 05:05:18 -0500 (EST)
Date:   Wed, 4 Nov 2020 12:05:15 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH ethtool] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201104100515.GA988778@shredder>
References: <20201102184036.866513-1-idosch@idosch.org>
 <20201102225803.pcrqf6nhjlvmfxwt@lion.mk-sys.cz>
 <20201103142430.GA951743@shredder>
 <20201103235501.sw27v355z7f375k3@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103235501.sw27v355z7f375k3@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 12:55:01AM +0100, Michal Kubecek wrote:
> On Tue, Nov 03, 2020 at 04:24:30PM +0200, Ido Schimmel wrote:
> > 
> > I have the changes you requested here:
> > https://github.com/idosch/ethtool/commit/b34d15839f2662808c566c04eda726113e20ee59
> > 
> > Do you want to integrate it with your nl_parse() rework or should I?
> 
> I pushed the combined series to
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkubecek/ethtool.git
> 
> as branch mk/master/advertise-all. I only ran few quick tests so far,
> it's not submission ready yet.
> 
> First two patches are unrelated fixes found while testing, I'm going to
> submit and push them separately. Third patch reworks nl_parser()
> handling of multiple request messages as indicated in my previous mail.
> Fourth patch is the ioctl compatibility fix.

Great, thank you. I pushed the patches to our regression. Will go over
the results tomorrow and let you know.
