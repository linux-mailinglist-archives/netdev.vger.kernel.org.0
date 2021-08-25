Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525BA3F76FF
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 16:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240920AbhHYOTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 10:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240148AbhHYOTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 10:19:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FEDF61073;
        Wed, 25 Aug 2021 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629901124;
        bh=fDtNSTEYyOXNle4YzEzsDGLFQ+vxMYJdh6Vy7iJQy8M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=falDQpo3fOQ8n4bpyEj8fMH3mf9AvCCwJAADR6r0ROROepK69mnryB5ALylrBBc5j
         APq3i/FifuTfxjFfhHGQcN0td+jQLGK4z0X/a1b0txy4ChDDaYTu/Eg+F7j9xyJ0Y8
         s+ByM9MbSqDnsra4R49OodVkCMDM/indl1pvQyluz34W+DkgtFrRYH0siz8ONle3j9
         L2HtXr2CGXLcOv7XUNOV+p/bIl2cr0aSlPoGZ2FC1m2WPXXW1C+uysHUprjmhsbkr+
         /kcbSpIcFPRJAvJZMOFbMTl9yyUT0oq8aHefIZV8oqMO7TuRDCbF/tHkVcCRFaX3Ak
         JNy9AOMQ46DKQ==
Date:   Wed, 25 Aug 2021 07:18:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dmytro Linkin <dlinkin@nvidia.com>, <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>,
        Yicong Yang <yangyicong@hisilicon.com>
Subject: Re: [PATCH net] net/mlx5: Remove all auxiliary devices at the
 unregister event
Message-ID: <20210825071843.17f7831d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YSYG4it61d7ztmuq@unreal>
References: <10641ab4c3de708f61a968158cac7620cef27067.1629547326.git.leonro@nvidia.com>
        <YSYG4it61d7ztmuq@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 12:01:22 +0300 Leon Romanovsky wrote:
> On Sat, Aug 21, 2021 at 03:05:11PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The call to mlx5_unregister_device() means that mlx5_core driver is
> > removed. In such scenario, we need to disregard all other flags like
> > attach/detach and forcibly remove all auxiliary devices.
> > 
> > Fixes: a5ae8fc9058e ("net/mlx5e: Don't create devices during unload flow")
> > Tested-and-Reported-by: Yicong Yang <yangyicong@hisilicon.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/dev.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)  
> 
> Any reason do not apply this patch?

'Awaiting upstream' => we expect Saeed to take it via his tree.
If special handling is requested is should be noted somewhere.
