Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1141370ABF
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 09:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhEBHmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 03:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhEBHmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 03:42:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B20D610A5;
        Sun,  2 May 2021 07:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619941323;
        bh=t2AWVgBt64kW6rndk3NkV+hojEG6OsDxb3UcSOjsCGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VgpJJyT9xpu+uMetjaT5aaKVElEupGsCbZzoWwhM5Q0Kn7lfqPOKAYXahFtYK/sLC
         dUQQ6HVFg0eL0Yf1mrDFuU6yzqkzLkvEPqlqDeMJyYQOa5icItFseoB/j/2kkc2lhr
         aNOsGak6eVOTF6qJJdXdAozNflrD/FnNA2RNj/5zel/4/idLFr3teEAi98P/CfOXo4
         KdW1xwmB/sv5PnAVUiMKySyLQKbVnOWPCG6zw0dyhRARwa/Fq7N8IXjMYwD9LKQ2ST
         3zJWpaIVc+VDXwjfVVI8+d0Rn3Rg2XIUFG4VxUHCIidFj1D0yhvaACx8EdyIsqEn1e
         YBGQnGV8vW3pA==
Date:   Sun, 2 May 2021 10:41:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <dddavem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net/mlx5: net/mlx5: Fix some error messages
Message-ID: <YI5Xxw9R4DqEQ1uv@unreal>
References: <YIqTHAq37U57ehAa@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIqTHAq37U57ehAa@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 02:06:04PM +0300, Dan Carpenter wrote:
> This code was using IS_ERR() instead of PTR_ERR() so it prints 1 instead
> of the correct error code.  Even better would be to use %pe which prints
> out the name of the error, as in "ENOMEM", "EINVAL" etc.
> 
> Fixes: 25cb31768042 ("net/mlx5: E-Switch, Improve error messages in term table creation")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2:  Use %pe instead of %ld.
> 
> Leon says this goes through netdev instead of the RDMA tree.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
