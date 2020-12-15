Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8A02DA813
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 07:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgLOGTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 01:19:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgLOGTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 01:19:32 -0500
Date:   Tue, 15 Dec 2020 08:18:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608013131;
        bh=ekDkSI9sBqXfdXUbP8FQ+ArQfViNs5tKBnnogjscfOI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=SxzthVLRvXPoIu5EHriMnDrKUKt+RygGFXKSKtHbTqVpSptquoD5R9qAr4FpibNZ0
         iVZvkspze967+4TW+i0qhSBZ5YmyPXwzYeR172K/LLb021JARPtD629iH7CeCZ5vxd
         iD44VnT5fMEBRbiXHobOwP2JWJwRKKmXlve1soKSmEoD97RoNp4r7SlK3snV1/F3PU
         d/xX/UEzGrb52NpRb3L95ooEQwYKxwXb2DmeuwqtTiiwFcSt0U2eSttOZbFr1XDqr/
         lDFN68IxD5tgqjAIhYhAp7l6KHPvOQYPcZx+dntvRPVRu/fekonuZHiTnFbkXity2a
         B8m2btYQuylGA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vasyl Gomonovych <gomonovych@gmail.com>, tariqt@nvidia.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
Message-ID: <20201215061847.GL5005@unreal>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201214103008.14783-1-gomonovych@gmail.com>
 <20201214111608.GE5005@unreal>
 <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1113d2d634d46adb9384e09c3f70cb8376a815c4.camel@perches.com>
 <20201215051838.GH5005@unreal>
 <19198242da4d01804dc20cb41e870b05041bede2.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19198242da4d01804dc20cb41e870b05041bede2.camel@perches.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 09:37:34PM -0800, Joe Perches wrote:
> On Tue, 2020-12-15 at 07:18 +0200, Leon Romanovsky wrote:
> > On Mon, Dec 14, 2020 at 11:15:01AM -0800, Joe Perches wrote:
> > > I prefer revisions to single patches (as opposed to large patch series)
> > > in the same thread.
> >
> > It depends which side you are in that game. From the reviewer point of
> > view, such submission breaks flow very badly. It unfolds the already
> > reviewed thread, messes with the order and many more little annoying
> > things.
>
> This is where I disagree with you.  I am a reviewer here.

It is ok, different people have different views.

>
> Not having context to be able to inspect vN -> vN+1 is made
> more difficult not having the original patch available and
> having to search history for it.

I'm following after specific subsystems and see all patches there,
so for me and Jakub context already exists.

Bottom line, it depends on the workflow.

>
> Almost no one adds URL links to older submissions below the ---.

Too bad, maybe it is time to enforce it.

>
> Were that a standard mechanism below the --- line, then it would
> be OK.

So let's me summarize, we (RDMA and netdev subsystems) would like to ask
do not submit new patch revisions as reply-to.

Thanks
