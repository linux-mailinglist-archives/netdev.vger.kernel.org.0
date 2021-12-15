Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4D24766A7
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhLOXoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:44:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42610 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhLOXoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:44:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F98C61B75;
        Wed, 15 Dec 2021 23:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEE7C36AE3;
        Wed, 15 Dec 2021 23:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639611844;
        bh=/mpmSGuR9Hoyc0BPGbhgRnAcbdbKBxjL2tKNC5hDLHo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bqB9l6r7rbrIhcUTvT5FHnRV+M/uQ8SCvi64Hcw2ydTdxSsXe9Mfd1xyRHgaAcMJ3
         0fEvbdK+K+3mHfcbNP2cqvlqqJhwZLXMypmJChsZwo5SxvSJ7cDMEylPRkh0+RyjpO
         ZLORXZtPXIpN9qP80uRr6GR63mkw+Z8Sg292A0z6A+yCcPxWkj+sRZ/8e77ATQ6juN
         H3N2SVUTaS70sJvd8vgGkqMgLe2/H4PzisGkZCTs3Bu25EefluT83FuCdt4KZ40uAD
         X6c7A+WenKrrgqANmlkGBk9xwqYe3ePVho1uVM1robprqhufkH448NR/BgsspATGL0
         qw8UAwq9cDeWg==
Date:   Wed, 15 Dec 2021 15:44:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull-request] mlx5-next branch 2021-12-15
Message-ID: <20211215154403.40563759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2697f58ef720d6b8f9163ea1151a4daba7043e86.camel@kernel.org>
References: <20211215184945.185708-1-saeed@kernel.org>
        <20211215112319.44d7daea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a0bf02eb4f7ca5501910521a0b32f18a0499cef9.camel@nvidia.com>
        <20211215145856.4a29e48b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2697f58ef720d6b8f9163ea1151a4daba7043e86.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 15:35:09 -0800 Saeed Mahameed wrote:
> On Wed, 2021-12-15 at 14:58 -0800, Jakub Kicinski wrote:
> > On Wed, 15 Dec 2021 22:14:11 +0000 Saeed Mahameed wrote:  
> > > already posted before :
> > > [1] https://lore.kernel.org/netdev/20211201193621.9129-1-saeed@kernel.org/
> > > [2] https://lore.kernel.org/lkml/20211208141722.13646-1-shayd@nvidia.com/  
> > 
> > Post them as a reply to the pull request like you usually do, please.  
> 
> They were already posted, and reviewed, and all maintainers were CC'ed,
> including you, why do you want me to spam the mailing list over and
> over again with the same patches ?

You reposting measly 5 patches is hardly spamming. I have scripts which
check if the contents of the PR match the posting, which obviously
can't follow random links from the email.

> This is not how genuine pull requests are supposed to work.

I'm not comfortable with blindly pulling patches from vendor trees.
