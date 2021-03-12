Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04BC3398E3
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 22:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhCLVKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 16:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235142AbhCLVKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 16:10:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8578D64F8E;
        Fri, 12 Mar 2021 21:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615583423;
        bh=lGEDbHKZnqk1I6QsqITsjI4o4hsuJoZUcmky/RJYWYY=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=FLRr1rIag57/F9ftfyE8Ea/CrccJSnpvKOi1NNTKDVFrWmcO+PfEZcDvavjxAuGI4
         kwACCD+weHmJgaewnYAYnayWu6qAxPh3GJ305sBw4nIpm3khKMeYRavamX3m+Q6lTP
         5NCNB4BKcSjJazOdbiM5u36K8vTbG/w51d1DWuLG/Lz/PszFERmgvgBxmBvKivmUIZ
         APBBrwNlM7SKlFBjxR8yVVkdHD1bB37oCdjWRg8EVuPLY7QU6/T+LZdmmHYl+VmMOg
         KyVr4fvTRLWmPM/5XkC08WoSfGIacrL/4fKIe1RymXYg4bndJG5sXQx8C7CsCfXEZJ
         ooIC9lcTdeWLA==
Message-ID: <835d5159c061f1a1668872c676f4c937edf5ae94.camel@kernel.org>
Subject: Re: [PATCH mlx5-next 0/9] mlx5 next updates 2021-03-10
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Date:   Fri, 12 Mar 2021 13:10:22 -0800
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-03-10 at 23:09 -0800, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This series is targeting mlx5-next shared tree for mlx5
> netdev and rdma shared updates.
> 
> From Mark, E-Switch cleanups and refactoring, and the addition 
> of single FDB mode needed HW bits.
> 
> From Mikhael, Remove unused struct field
> 
> From Saeed, Cleanup W=1 prototype warning 
> 
> From Zheng, Esw related cleanup
> 
> From Tariq, User order-0 page allocation for EQs
> 
> In case of no objections, this series will be applied to mlx5-next
> first
> and then sent in one pull request to both netdev and rdma next trees.
> 
> Thanks,
> Saeed
> 
> Mark Bloch (5):
>   net/mlx5: E-Switch, Add match on vhca id to default send rules
>   net/mlx5: E-Switch, Add eswitch pointer to each representor
>   RDMA/mlx5: Use represntor E-Switch when getting netdev and metadata

Series applied and fixed up the above spelling error.

Thanks.


