Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BA32CDEA3
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgLCTRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:17:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgLCTRb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 14:17:31 -0500
Date:   Thu, 3 Dec 2020 11:16:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607023010;
        bh=jVfAtjxjwYd/n0n+h+d+9a0J+3UHrSy09PN7PdewrQM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=IMEim52G73YWynot00GSGFI7w9F7U8sD0SxfquAqCj1Fkb6yrAr4v7VZ46nkD2cdA
         ZV2l9vCk18kI5xPY7sr9uouEGD7BgFtgoIqf6MgFFbd+2NGwaC7/6ulUxM2ICRMYas
         xFfVqnHU5CaEjyOetTnhefgwNcv11dBx3h3Y9nVVjJoVl/S4Og+zccZRJ8v527S8g4
         gSohW/Jgv1/ZXpmQnke8jq3MmE3q3f8GFQV3ar1NP9Fxpk2wcXHjD8Kfy2cc+QVbfA
         Fi4pl13gBuB+8o8M5dX6RxQyMdLwjrp4yXG7TTkt8ySs/JZ6Uv3sH/8oiI4AYMuIy0
         2bAxoACC0juFQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [pull request][net 0/4] mlx5 fixes 2020-12-01
Message-ID: <20201203111648.5bbf1d1d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203105239.3e189565@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201203043946.235385-1-saeedm@nvidia.com>
        <20201203105239.3e189565@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 10:52:39 -0800 Jakub Kicinski wrote:
> On Wed, 2 Dec 2020 20:39:42 -0800 Saeed Mahameed wrote:
> > Hi Jakub,
> > 
> > This series introduces some fixes to mlx5 driver.
> > Please pull and let me know if there is any problem.
> > 
> > For the DR steering patch I will need it in net-next as well, I would
> > appreciate it if you will take this small series before your pr to linus.
> > 
> > For -stable v5.4:
> >  ('net/mlx5: DR, Proper handling of unsupported Connect-X6DX SW steering')
> > 
> > For -stable v5.8
> >  ('net/mlx5: Fix wrong address reclaim when command interface is down')
> > 
> > For -stable v5.9
> >  ('net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled')  
> 
> Your tree is missing your signoff on:
> 
> Commit 3041429da89b ("net/mlx5e: kTLS, Enforce HW TX csum offload with kTLS")
> 	committer Signed-off-by missing
> 	author email:    tariqt@nvidia.com
> 	committer email: saeedm@nvidia.com
> 	Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> 
> You can fix it or I'll just apply the patches from the ML.

Well, it's the last thing I got in the queue before I prep the PR so
let me just apply from the ML.

Thanks!
