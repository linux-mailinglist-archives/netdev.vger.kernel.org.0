Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B22118D0EB
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 15:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgCTOdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 10:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgCTOdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 10:33:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4821D20709;
        Fri, 20 Mar 2020 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584714784;
        bh=IlCuNHnE7yuBxsCSBh8bB/nS31hgXyIDFlpv2wLzFWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U5nlFmyl4cfweFbWdqh4wK8Pk/n7xf7Xddc8UGZsqhiFRuCMqxeD/j26J9BeBj/PF
         C1d+50+1B5MyjBrK8FJ2W7l9yREcIPFovt7AMxBjqcpYtvgGnj+4DWmyT65BUQ7wlF
         2Dbx9q7TYMh4cF3dQd3cGHWxpEqL2D46LYj1joB0=
Date:   Fri, 20 Mar 2020 16:33:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Fix actions_match_supported() return
Message-ID: <20200320143300.GH514123@unreal>
References: <20200320132305.GB95012@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320132305.GB95012@mwanda>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 04:23:05PM +0300, Dan Carpenter wrote:
> The actions_match_supported() function returns a bool, true for success
> and false for failure.  This error path is returning a negative which
> is cast to true but it should return false.
>
> Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
