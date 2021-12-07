Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDFF46BB7F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhLGMn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:43:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42156 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbhLGMn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:43:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 095B5CE1A08;
        Tue,  7 Dec 2021 12:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB64C341C1;
        Tue,  7 Dec 2021 12:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638880825;
        bh=czzNDj3y7GJtsT+VpmI57RrDMh6jhmcsUILlmvcfTK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Urg4GzWKwxNRBPqlJCdPXmh8Yz1I8rGDXTQJOXz5y4EXmhN/SODCLbLgGrqXB2Mrh
         kkDXN5xEGbh4BTLuvmd7DuaSRJHmNEkFqOWD0NRT3o6hppDEStUAtQUZFegbs4BbrQ
         wlfyeVhepacWVjAT43NmHWSSEDkdRBrpK6QPaBrCy50IZdvEINjunGXLjiVlRYTliv
         nnjPLb8umLK32aeWMUc0CBrhGYCiQqil7+5Ce3bINm0LAfNZNd6mX/THKxoMpG4ewh
         f9mjCylkro5R/LcWIjXY5W3tGOrYNtik5ncAlfEHcT3DxX+mIvmexrWQnsbmFPiSbX
         vj0NaGgcHV4wg==
Date:   Tue, 7 Dec 2021 14:40:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net/mlx5: Remove the repeated declaration
Message-ID: <Ya9WMysibKB7e5CF@unreal>
References: <20211207123515.61295-1-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207123515.61295-1-zhangshaokun@hisilicon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 08:35:15PM +0800, Shaokun Zhang wrote:
> Function 'mlx5_esw_vport_match_metadata_supported' and
> 'mlx5_esw_offloads_vport_metadata_set' are declared twice, so remove
> the repeated declaration and blank line.
> 
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 3 ---
>  1 file changed, 3 deletions(-)
> 

Fixes: 4f4edcc2b84f ("net/mlx5: E-Switch, Add ovs internal port mapping to metadata support")

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
