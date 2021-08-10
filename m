Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345A63E53FD
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 08:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhHJG7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 02:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhHJG7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 02:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 883FC60EB9;
        Tue, 10 Aug 2021 06:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628578724;
        bh=r2TlFzrYB61IumCcWDPnccmvdI67Lnz8CPpNcFuM3MA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FXSVXU8sypCUWEMxFk/9jU8EpXjgImFpa92xxxpkwF01n00trSLPT0ou/Gmx/uGaH
         nroDnvGNZ2N+z2Fb7LpHcZjxPfEvQnSVepNAsTpSKOoN/dCxyJBPVqFh+RsypLx3aP
         JjVNlppuY8015Q1SwPiRJulkN6MRjJWpWWIxw3X5nbxowPLVrtsqCCJvbjbJaPVhJC
         45RCjgJ51YWs7e4Tdr8l+YIp1odMRM2whGoDlEXva2HaQ+VhfXi9PIOYfBPWHSoIVX
         910ZK3UMJ3OKeRjrj7Yk1ajWAiHHrACKxaZa1axLevwOBaQTIddcTr7naenDTtZxXH
         +yw8rVR4AhDuw==
Date:   Tue, 10 Aug 2021 09:58:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "caihuoqing@baidu.com" <caihuoqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Make use of mlx5_core_warn()
Message-ID: <YRIjoCbxAo+3SemG@unreal>
References: <20210809121931.2519-1-caihuoqing@baidu.com>
 <7b7dba6e8d62e39343fd6e4dcbd0503aadfb9e40.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b7dba6e8d62e39343fd6e4dcbd0503aadfb9e40.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 08:39:10PM +0000, Saeed Mahameed wrote:
> On Mon, 2021-08-09 at 20:19 +0800, Cai Huoqing wrote:
> > to replace printk(KERN_WARNING ...) with mlx5_core_warn() kindly
> > if we use mlx5_core_warn(), the prefix "mlx5:" not needed
> 
> in mlx5e it is netdev stack so netdev_warn(priv->netdev, "foo bar");

Saeed,

That file is full of mlx5_core_* prints, even in the same function where
Cai is changing, you will find mlx5_core_warn().

Thanks

> please.
