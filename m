Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8C626CD81
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 23:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIPVAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 17:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbgIPQae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 12:30:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA2892224B;
        Wed, 16 Sep 2020 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600259630;
        bh=26flU1uuMKxzqG/k2vWLqMH8v0mxEamsV3PKiwvOl04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F1rWIe3U/LJwC2fUFiA7cpkXEI8/wXJ1Es+jsKJWBZ7f0jWQ2FnsHCReX9Q3TBuR/
         lLrhvfjHBUs2Cl8zY3cfOEJMIB8KtWolCFFYn29oJwtuGwvb7/tgbB6Th6iK+0TQRl
         md1PZsgNYtgb/BUuEYXSrYVTtxZt+4o/TbG7Cres=
Date:   Wed, 16 Sep 2020 14:34:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     linux-spdx@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: IPsec: make spdxcheck.py happy
Message-ID: <20200916123425.GA2808885@kroah.com>
References: <20200916085824.30731-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916085824.30731-1-lukas.bulwahn@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 10:58:24AM +0200, Lukas Bulwahn wrote:
> Commit 2d64663cd559 ("net/mlx5: IPsec: Add HW crypto offload support")
> provided a proper SPDX license expression, but slipped in a typo.
> 
> Fortunately, ./scripts/spdxcheck.py warns:
> 
>   drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c: 1:39 \
>   Invalid License ID: Linux-OpenIBt
> 
> Remove the typo and make spdxcheck.py happy.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> 
> Greg, please pick this minor non-urgent patch into your spdx tree.

Will do, thanks!
