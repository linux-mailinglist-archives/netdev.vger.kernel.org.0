Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A517476727
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhLPAzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLPAzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:55:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959FDC061574;
        Wed, 15 Dec 2021 16:55:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3416A61B9D;
        Thu, 16 Dec 2021 00:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443D5C36AE0;
        Thu, 16 Dec 2021 00:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639616134;
        bh=MgOVf7oYnbO0CV8WsVsPfMF9dAleUAT184aOIMZy4f4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i7UYbGhnM2WWxFyozM3Yk5g+dkhscighvYkcendwxWCXwNHRxO/fKDZJ+SoKFZRwm
         Ix17TZNcLzmoO9OmkSF7pC6vGNTsBzLVqlZLOQL9JDOL5MmQZ0GIxN5hgm+XlWu0Im
         VwuWSYKms5OVK6/nsYveCchm8eJOqXddmrvD6sgcy2upqAUATgTZevlOMVmL8rYbiZ
         kuwMn3bnffq47rVq2BKide6O1H4bWyx8H6jcBz5jz/07NavRUXB41mWucSYQGwTp7O
         xKcVvUV+a3SoFM9l+dUf3n8piXt11cvKicaSoVCLhzUJp7xxooRgCuXaQEwvQ8kxJ6
         xKhFv7xN1PRTA==
Message-ID: <e54c8c88254d7768ba7a7dfbdfc798ce90bf17ab.camel@kernel.org>
Subject: Re: [pull-request] mlx5-next branch 2021-12-15
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Wed, 15 Dec 2021 16:55:33 -0800
In-Reply-To: <20211215154403.40563759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211215184945.185708-1-saeed@kernel.org>
         <20211215112319.44d7daea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <a0bf02eb4f7ca5501910521a0b32f18a0499cef9.camel@nvidia.com>
         <20211215145856.4a29e48b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <2697f58ef720d6b8f9163ea1151a4daba7043e86.camel@kernel.org>
         <20211215154403.40563759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-12-15 at 15:44 -0800, Jakub Kicinski wrote:
> On Wed, 15 Dec 2021 15:35:09 -0800 Saeed Mahameed wrote:
> > On Wed, 2021-12-15 at 14:58 -0800, Jakub Kicinski wrote:
> > > On Wed, 15 Dec 2021 22:14:11 +0000 Saeed Mahameed wrote:  
> > > > already posted before :
> > > > [1] https://lore.kernel.org/netdev/20211201193621.9129-1-
> > > > saeed@kernel.org/
> > > > [2] https://lore.kernel.org/lkml/20211208141722.13646-1-
> > > > shayd@nvidia.com/ 
> > > 
> > > Post them as a reply to the pull request like you usually do,
> > > please.  
> > 
> > They were already posted, and reviewed, and all maintainers were
> > CC'ed,
> > including you, why do you want me to spam the mailing list over and
> > over again with the same patches ?
> 
> You reposting measly 5 patches is hardly spamming. I have scripts
> which

That's not the point, sometimes it is less or much more than 5.
For mlx5-next (Shared branch between RDMA and netdev), I would like to
submit standard clean PRs like all other maintainers.

> check if the contents of the PR match the posting, which obviously
> can't follow random links from the email.
> 

The script is great to validate pseudo-PRs (netdev only) where we post
patches for the first time in the PR.

but this is different, this is a true clean PR where all patches
already posted and reviewed. the tree is already written genuinely in
ink!

> > This is not how genuine pull requests are supposed to work.
> 
> I'm not comfortable with blindly pulling patches from vendor trees.

Good to know and very disappointing, is there anything i could do to
make you better trust my mlx5-next PRs ? other than RE-posting ?

Again I don't see any point of RE-posting the patches together with a
clean PR, redundant and unnecessary and against all standards, it just
cancels the whole process and duplicates my work, and will confuse
other maintainers who might have already pulled part or all of the
patches in the branch.



