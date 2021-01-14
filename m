Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22952F560C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbhANBcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:32:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbhANB3P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:29:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 481B423406;
        Thu, 14 Jan 2021 01:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610587707;
        bh=RHHlC1yuVHUUT+gzqPQq3+iIWLovAjcaTmexIph4NAM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wmd8MlFCq3RROwac35rt4H6h49O4+iefuJfpdnTWWzvntvDqKM1anwJqgBGsI8nqK
         L8hLNkRnP4CZFdZ3+wyUtAX2n7PqPiQw9stc8MZBUZTK20J/MyM/ODTv8hbqgFbzMV
         rN+aKqOM06XVgZpDEbldPplaKZ4imOkKUPnoQAFtHWoyoh3Sj1u/xyY9xLmTs9EUxP
         kdrhxldg/V2HLUQdqEYWS/EfNFJ7mVzTJVMsFc1omxXx3c0hVmL/RarbbFH3pVA8TV
         lqwMIy1XmkbFxn/07igpjUxkLvBI7IAcacFfv2+ADLHzwQtnjgEaCR3cpXQtKL1yWW
         SoOrKx3zvWk7Q==
Date:   Wed, 13 Jan 2021 17:28:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net-next V2 00/11] mlx5 updates 2021-01-07
Message-ID: <20210113172826.06f8c1f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <88a2b0ea7554a4ac44e86314cfa0c2794be50d71.camel@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
        <20210113154155.1cfa9f0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <88a2b0ea7554a4ac44e86314cfa0c2794be50d71.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 16:01:57 -0800 Saeed Mahameed wrote:
> On Wed, 2021-01-13 at 15:41 -0800, Jakub Kicinski wrote:
> > On Mon, 11 Jan 2021 23:05:23 -0800 Saeed Mahameed wrote:  
> > > From: Saeed Mahameed <saeedm@nvidia.com>
> > > 
> > > Hi Dave, Jakub
> > > 
> > > This series provides misc updates for mlx5 driver. 
> > > v1->v2:
> > >   - Drop the +trk+new TC feature for now until we handle the module
> > >     dependency issue.
> > > 
> > > For more information please see tag log below.
> > > 
> > > Please pull and let me know if there is any problem.  
> > 
> > The PR lacks sign-offs, I can apply from the list but what's the
> > story  
> 
> Sing-off where ? the tag ?

This is what I got when I pulled:

Commit 85d1f989d2ed ("net/mlx5e: IPsec, Remove unnecessary config flag usage")
	committer Signed-off-by missing
	author email:    tariqt@nvidia.com
	committer email: saeedm@nvidia.com
	Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Commit 509c603a3527 ("net/mlx5e: IPsec, Inline feature_check fast-path function")
	committer Signed-off-by missing
	author email:    tariqt@nvidia.com
	committer email: saeedm@nvidia.com
	Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Commit 1ba296c667ac ("net/mlx5e: IPsec, Avoid unreachable return")
	committer Signed-off-by missing
	author email:    tariqt@nvidia.com
	committer email: saeedm@nvidia.com
	Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Commit b4385e7db7ee ("net/mlx5e: IPsec, Enclose csum logic under ipsec config")
	committer Signed-off-by missing
	author email:    tariqt@nvidia.com
	committer email: saeedm@nvidia.com
	Signed-off-by: Tariq Toukan <tariqt@nvidia.com>


> > with the fixes tags on the patches for -next?  
> 
> the patch got migrated from net to net-next as it wasn't deemed to be a
> critical bug fix but it is a bug fix .. 
> do you want me to remove it ? 

I dropped the fixes tags and applied from the list, thanks!
