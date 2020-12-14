Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3212D9FE1
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502314AbgLNTEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407785AbgLNTEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 14:04:33 -0500
Date:   Mon, 14 Dec 2020 11:03:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607972633;
        bh=tUbgPIb0kdLyYxebsOXCvImkUd1kKwQiIDvtChZEX+8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=mmVFQJ3sq3E0oBF2/dK3TgcpGT4M3MDoRsYsuOOt3nikDIwXKkwOkd6BNED/FkKMd
         ghZm+ryLLtIN47yHqYcqhN9wrl05vlDgQKn9ToEG4kksIcT1NNax7Amfrlrg5PQBD6
         JuF5dc4JRCtJQ5/m/lD50jBtlaWtvum7YqOoPaRqm4jDmo6k84EC8BqdYW3uXbW34A
         31LAMGpq87x4PhjAlUbA+rthQPr7mElmgD3tn0TSDbHgijt+vkEBj/DzkinVUt83nG
         NQNey5XPSRKqzpRFa5R/6Hzrf8MqnS1Z9ywg/vE5MmtoHNdpq9VRDbytnwEcv63Usx
         2UZxpyKFConOQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Vasyl Gomonovych <gomonovych@gmail.com>, tariqt@nvidia.com,
        joe@perches.com, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
Message-ID: <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214111608.GE5005@unreal>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201214103008.14783-1-gomonovych@gmail.com>
        <20201214111608.GE5005@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 13:16:08 +0200 Leon Romanovsky wrote:
> On Mon, Dec 14, 2020 at 11:30:08AM +0100, Vasyl Gomonovych wrote:
> > It is fix for semantic patch warning available in
> > scripts/coccinelle/misc/boolinit.cocci
> > Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> > Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable
> >
> > Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
> > ---
> >  - Add coccicheck script name
> >  - Simplify if condition
> > ---
> >  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
> >  drivers/net/ethernet/mellanox/mlx4/main.c  | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)  
> 
> Please refrain from sending new version of patches as reply-to to
> previous variants. It makes to appear previous patches out-of-order
> while viewing in threaded mode.

Yes, please! I'm glad I'm not the only one who feels this way! :)
