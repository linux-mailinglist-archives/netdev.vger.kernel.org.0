Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304592CDF2E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgLCTvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:51:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbgLCTvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 14:51:05 -0500
Message-ID: <5d8c1f432431bddf03e5e2579b59c9d02f60b647.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607025024;
        bh=jWVZsBrWjnUcqOueOa28pRWAcnf6lcmixXnD8QyjMqM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=S8n7HXZ/5nX29OK9J+DfSQDvylhMnazOwAlHu7VbOb6iFBHiXQgvTaN2TVR/AR4ZX
         SyIY3+r5OpE1GMv+kAYbaPArYwAnXy5viKh6wobfAsbbQwZye38sbd1dyw6gEzPCUR
         f9i3pLnnx8RageRBEKd5SEllO4jlGFmpP7u8LF13UxIBj76yRKqgT/fO1d7s0ZcI+l
         OL29u9q4fZXWsP4Mdx2Pe2FjCvs1rfdpNrBmcXuNVP2EM1euPnPlB9qNHfKqBN0QGG
         UkBgY5AFvCJQH4H9FU90fVKps4u0uc93mhMRUmgaEyVh0D8pM83BuYSGDGx0RPcRtt
         a7DZ6nrdul8UQ==
Subject: Re: [pull request][net 0/4] mlx5 fixes 2020-12-01
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Thu, 03 Dec 2020 11:50:22 -0800
In-Reply-To: <20201203111648.5bbf1d1d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201203043946.235385-1-saeedm@nvidia.com>
         <20201203105239.3e189565@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <20201203111648.5bbf1d1d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-03 at 11:16 -0800, Jakub Kicinski wrote:
> On Thu, 3 Dec 2020 10:52:39 -0800 Jakub Kicinski wrote:
> > On Wed, 2 Dec 2020 20:39:42 -0800 Saeed Mahameed wrote:
> > > Hi Jakub,
> > > 
> > > This series introduces some fixes to mlx5 driver.
> > > Please pull and let me know if there is any problem.
> > > 
> > > For the DR steering patch I will need it in net-next as well, I
> > > would
> > > appreciate it if you will take this small series before your pr
> > > to linus.
> > > 
> > > For -stable v5.4:
> > >  ('net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW
> > > steering')
> > > 
> > > For -stable v5.8
> > >  ('net/mlx5: Fix wrong address reclaim when command interface is
> > > down')
> > > 
> > > For -stable v5.9
> > >  ('net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled')  
> > 
> > Your tree is missing your signoff on:
> > 
> > Commit 3041429da89b ("net/mlx5e: kTLS, Enforce HW TX csum offload
> > with kTLS")
> > 	committer Signed-off-by missing
> > 	author email:    tariqt@nvidia.com
> > 	committer email: saeedm@nvidia.com
> > 	Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> > 
> > You can fix it or I'll just apply the patches from the ML.
> 
> Well, it's the last thing I got in the queue before I prep the PR so
> let me just apply from the ML.
> 
> Thanks!

That works too, Sorry for the inconvenience !
Tariq did the maintainer review on this patch, so this patch didn't go
through my normal submission queue and i forgot to explicitly sign it
off :/ .. I will fix my patch flow.

Thanks!


