Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F89B273A62
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 07:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgIVFwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 01:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgIVFwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 01:52:32 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29D2523A84;
        Tue, 22 Sep 2020 05:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600753951;
        bh=2IByJ+bQXbK2DnwYue/7cbeDGY1GiEt1X1Rxrio1dP0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Tz8v8/noF8MZG/xJluWjuPAIpYT/boMnbKaQNDzVDucwCBzfjb+NQx6Z7a5j+WZVd
         XsMDKXXNFsgiMs8qRKidEoad+lKXjhyBIftIVHekLfT42HbDotE1ntfcuhbNlUhAvW
         7XT4acFUIqGXimiVY+jgA3cxavtbkbdvWUNmm7Qk=
Message-ID: <ae06288c3c4d5d8ad59202ff7967d479af1152a5.camel@kernel.org>
Subject: Re: [PATCH -next] net/mlx5: simplify the return expression of
 mlx5_ec_init()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 21 Sep 2020 22:52:30 -0700
In-Reply-To: <20200921131044.92430-1-miaoqinglang@huawei.com>
References: <20200921131044.92430-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-21 at 21:10 +0800, Qinglang Miao wrote:
> Simplify the return expression.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/ecpf.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> 

Applied to net-next-mlx5.

Thanks.

