Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D41E47668F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhLOXfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbhLOXfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:35:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B9AC061574;
        Wed, 15 Dec 2021 15:35:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A35DCB82246;
        Wed, 15 Dec 2021 23:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD792C36AE1;
        Wed, 15 Dec 2021 23:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639611310;
        bh=7LRZOB4/9i8soFWDF/r51zp6yu+Y7+AP/AHqZnwMRNs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qPp0CLpKD9dTM4G6B4V9aF/C3Wph6/GE4mpReepEVI70hZQ+FB5KL/pEsS0E3Jlxf
         aMnREbSoLvnUMF29XscOTxsNGGSj1KRC2eROQ9+NX32Y8hmrDG10UTxz3cq++QDNIa
         KJhGOpW5wG+2aMSUV9pv+85J+ssuI1PmLz0Ag3qftgzr9byzVoJwlYDyskhtEr5+aa
         7sXctLnrYe974gw8axnFwWNDUoXJmqxi8LkUtISr9TvSukmc9erECAZhfFEgKfCQfL
         pCNGvSuVdasi94/T66JnOaMs6x8MsBNcn3z7yjDIV5fg4BAOR4UfPvjFqCvxLDVUNN
         b0OxmvZ0KFESw==
Message-ID: <2697f58ef720d6b8f9163ea1151a4daba7043e86.camel@kernel.org>
Subject: Re: [pull-request] mlx5-next branch 2021-12-15
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Wed, 15 Dec 2021 15:35:09 -0800
In-Reply-To: <20211215145856.4a29e48b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211215184945.185708-1-saeed@kernel.org>
         <20211215112319.44d7daea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <a0bf02eb4f7ca5501910521a0b32f18a0499cef9.camel@nvidia.com>
         <20211215145856.4a29e48b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-12-15 at 14:58 -0800, Jakub Kicinski wrote:
> On Wed, 15 Dec 2021 22:14:11 +0000 Saeed Mahameed wrote:
> > On Wed, 2021-12-15 at 11:23 -0800, Jakub Kicinski wrote:
> > > On Wed, 15 Dec 2021 10:49:45 -0800 Saeed Mahameed wrote:  
> > > > This pulls mlx5-next branch into net-next and rdma branches.
> > > > All patches already reviewed on both rdma and netdev mailing
> > > > lists.
> > > > 
> > > > Please pull and let me know if there's any problem.
> > > > 
> > > > 1) Add multiple FDB steering priorities [1]
> > > > 2) Introduce HW bits needed to configure MAC list size of
> > > > VF/SF.
> > > >    Required for ("net/mlx5: Memory optimizations") upcoming
> > > > series
> > > > [2].  
> > > 
> > > Why are you not posting the patches?  
> > 
> > already posted before :
> > [1]
> > https://lore.kernel.org/netdev/20211201193621.9129-1-saeed@kernel.org/
> > [2]
> > https://lore.kernel.org/lkml/20211208141722.13646-1-shayd@nvidia.com/
> 
> Post them as a reply to the pull request like you usually do, please.

They were already posted, and reviewed, and all maintainers were CC'ed,
including you, why do you want me to spam the mailing list over and
over again with the same patches ?  This is not how genuine pull
requests are supposed to work.



