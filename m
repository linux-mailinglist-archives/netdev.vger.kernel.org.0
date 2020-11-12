Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD8F2B12EC
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgKLX6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgKLX6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 18:58:12 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D4C20723;
        Thu, 12 Nov 2020 23:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605225492;
        bh=D7BWy4zT3PbHd0AJ1nIJLQwiLiRhReaFI7Ef1rnHFDs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=S4FV+tZpTU+OfMLs2eYEKR/CDcjXZHX5syjhq2Y0dg4O6sRfU0+rSRJ9V1wkm+ZH/
         mWp0vPD6Cl+vZen2NfpjleqxROKHz9dRNanmiLu2VcYdvdeRCowDxEXrF0kC5n5veA
         ASJDWZSBPF3ztBAaCeFYVeT7zJFondbYRcZJkU4I=
Message-ID: <06f889297f97217961e4e563d2715f28d1e8d953.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Fix passing zero to 'PTR_ERR'
From:   Saeed Mahameed <saeed@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org, vuhuong@mellanox.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 15:58:10 -0800
In-Reply-To: <20201112142845.54580-1-yuehaibing@huawei.com>
References: <20201112142845.54580-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 22:28 +0800, YueHaibing wrote:
> Fix smatch warnings:
> 
> drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c:105
> esw_acl_egress_lgcy_setup() warn: passing zero to 'PTR_ERR'
> drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c:177
> esw_acl_egress_ofld_setup() warn: passing zero to 'PTR_ERR'
> drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c:184
> esw_acl_ingress_lgcy_setup() warn: passing zero to 'PTR_ERR'
> drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c:262
> esw_acl_ingress_ofld_setup() warn: passing zero to 'PTR_ERR'
> 
> esw_acl_table_create() never returns NULL, so
> NULL test should be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 

Applied to net-next-mlx5 

thanks 

