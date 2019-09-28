Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A3C0FEE
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 08:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfI1GHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 02:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfI1GHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Sep 2019 02:07:48 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042AD207E0;
        Sat, 28 Sep 2019 06:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569650867;
        bh=rQNZoB0gH0Aw4WPpOsR6mMz1gOurH2mz6RAHTxynZwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jB2C4jOUEyYWGZ6i2GJkVSofV3TmAIBo87VqooWRrL+QjVz8YhN2cS8CsR5Hvzb4P
         0MxN2BeVe3ugXAyCJYRRRgu5yoBWhlfL2HTCRRosmRfhlHueoJJJGhNJCmwA42i5/e
         m2229E5DqFW2sN6FfywkXHE8n4Iiupq5mx2x46IU=
Date:   Sat, 28 Sep 2019 09:07:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
Message-ID: <20190928060743.GK14368@unreal>
References: <20190927223729.18043-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927223729.18043-1-navid.emamdoost@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 05:37:28PM -0500, Navid Emamdoost wrote:
> In mlx5_fw_fatal_reporter_dump if mlx5_crdump_collect fails the
> allocated memory for cr_data must be released otherwise there will be
> memory leak. To fix this, this commit changes the return instruction
> into goto error handling.
>
> Fixes: 9b1f29823605 ("net/mlx5: Add support for FW fatal reporter dump")
>
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

General note, if you don't write "To:" in your emails, most probably
your emails will be missed by relevant people.

I assume that Saeed will pick this patch and fix extra line between
Fixes and SOB.

Thanks, for fixing it.
