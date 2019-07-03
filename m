Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CC85E101
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 11:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfGCJ1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 05:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGCJ1k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 05:27:40 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E113121882;
        Wed,  3 Jul 2019 09:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562146059;
        bh=RAVO5XzfNxIvBVXnbM1rsn/7lLkHV12mdi3EIqh9w8Y=;
        h=From:Date:To:Cc:Subject:References:In-Reply-To:From;
        b=VPQHq19ItLmdCGv2g5FyjeljYtPfySIbhRmmyIYRbAwqVMO7CbJV6aFliBvVbwXfK
         1hu0GTG5A/R2gtUqOgyS0GsXh/bsFTamo8PZHycGfYDM2GDO29W/0Ylj+s4zKqqkvb
         U0P2kcFOo5PETzTNHN4+TTsLOeZX0wREb/bsWbg0=
From:   leon@kernel.org
Date:   Wed, 3 Jul 2019 12:27:35 +0300
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH mlx5-next 4/5] net/mlx5: Introduce TLS TX offload
 hardware bits and structures
Message-ID: <20190703092735.GZ4727@mtr-leonro.mtl.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
 <20190703073909.14965-5-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703073909.14965-5-saeedm@mellanox.com>
erom:   Leon Romanovsky <leonro@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 07:39:32AM +0000, Saeed Mahameed wrote:
> From: Eran Ben Elisha <eranbe@mellanox.com>
>
> Add TLS offload related IFC structs, layouts and enumerations.
>
> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  include/linux/mlx5/device.h   |  14 +++++
>  include/linux/mlx5/mlx5_ifc.h | 104 ++++++++++++++++++++++++++++++++--
>  2 files changed, 114 insertions(+), 4 deletions(-)

<...>

> @@ -2725,7 +2739,8 @@ struct mlx5_ifc_traffic_counter_bits {
>
>  struct mlx5_ifc_tisc_bits {
>  	u8         strict_lag_tx_port_affinity[0x1];
> -	u8         reserved_at_1[0x3];
> +	u8         tls_en[0x1];
> +	u8         reserved_at_1[0x2];

It should be reserved_at_2.

Thanks
