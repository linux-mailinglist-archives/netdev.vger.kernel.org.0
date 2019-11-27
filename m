Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095FD10B6B6
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfK0T0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:26:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbfK0T0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:26:36 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97D0514A6F7FF;
        Wed, 27 Nov 2019 11:26:35 -0800 (PST)
Date:   Wed, 27 Nov 2019 11:26:35 -0800 (PST)
Message-Id: <20191127.112635.1621097212312385906.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     saeedm@mellanox.com, leon@kernel.org, eli@mellanox.com,
        roid@mellanox.com, elibr@mellanox.com, kliteyn@mellanox.com,
        ozsh@mellanox.com, pablo@netfilter.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Fix build error without IPV6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191127132700.25872-1-yuehaibing@huawei.com>
References: <20191127132700.25872-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 11:26:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 27 Nov 2019 21:27:00 +0800

> If IPV6 is not set and CONFIG_MLX5_ESWITCH is y,
> building fails:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:322:5: error: redefinition of mlx5e_tc_tun_create_header_ipv6
>  int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:7:0:
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:67:1: note: previous definition of mlx5e_tc_tun_create_header_ipv6 was here
>  mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
>  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Use #ifdef to guard this, also move mlx5e_route_lookup_ipv6
> to cleanup unused warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: e689e998e102 ("net/mlx5e: TC, Stub out ipv6 tun create header function")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Saeed et al., how do you want to handle this?

Thanks.
