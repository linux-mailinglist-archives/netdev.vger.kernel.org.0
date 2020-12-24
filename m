Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D8D2E24CC
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 07:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgLXG1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 01:27:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgLXG1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Dec 2020 01:27:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B613B22571;
        Thu, 24 Dec 2020 06:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608791216;
        bh=J5cPf2HCJlp1S19+ZO1iRv1yS7vy1/6LsafEPOCZYTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GeC2xyY4ZWTsFi9kPysV4kK9ItOXSqFlVNsP6Ygf7MIeNGVKWkLBk18vSqlE5Y2Qs
         d4j3kdGxeWyJWcaCfB1b0DUFlIuZSsfNQg9VUZzCWc6lDkzfdL3uRz8FG9KuRzRYiL
         nSCzEaMDJc9n/AngVYASY+kWUCd6LXgN5SytD4QlAj22KiT+GQNDMqoJj5rHfruWBK
         /MNCa3bG6JSeA8xyJ4yJsrlSENutTrGI4jXDaYHKcfvSKN1RagCJ5DQqAiuhW6RR/g
         z4R6gG/K5vet8UC8kxAZ6jtQzh68tHFRq98xiXlWGIgcXjZ9E2rbfBA7GY+6c+wB3S
         25lpF0lImRKxg==
Date:   Thu, 24 Dec 2020 08:26:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     trix@redhat.com
Cc:     saeedm@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        vladyslavt@nvidia.com, maximmi@mellanox.com, tariqt@nvidia.com,
        bjorn.topel@intel.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: remove h from printk format specifier
Message-ID: <20201224062652.GB18357@unreal>
References: <20201223194512.126231-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223194512.126231-1-trix@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 11:45:12AM -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
>
> This change fixes the checkpatch warning described in this commit
> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")
>
> Standard integer promotion is already done and %hx and %hhx is useless
> so do not encourage the use of %hh[xudi] or %h[xudi].
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
