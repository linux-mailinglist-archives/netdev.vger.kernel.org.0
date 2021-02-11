Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888E9318450
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 05:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhBKEVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 23:21:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhBKEVV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 23:21:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18B3860C40;
        Thu, 11 Feb 2021 04:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613017241;
        bh=XftMoFRgLInF8RYbaY1nQOipzUIyvpNiUppk3FPg4Ng=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TLSo1XnNZX72tbh7XiVqnAckhNhlYXvOaCmx+aL6sP4gDOhovQ114YEUoJg8CtrQ7
         yylpwu7ebwtOq0Kn3G8pkEblbb5Bu43Fi/9VYIZwm76jJGGQhM8KAOf5O3ZpsUpDrI
         NmL1Vy4YuKDgejhRd9dOE+klYetC91Y+E50N0Qg9x39HfZRA3KCRxz+2+Urla0l93z
         Zu2OB1tOqkD0uY6Uhvn1ISIoO/LxgS/KXWskA3D7nGYh5/drJvJUhjD9t8pEuvim2J
         0zfeP//dIKV2GPkyaRgnsB15sEhy8lWzuX5oGXXVmqnGiO2Wg/vYlYmNaAioe1qacm
         IY2yjzzx8DEVA==
Message-ID: <747afa737ab2924a64b5fd5f856c567f2d7dd888.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Fix error return code in
 mlx5e_tc_esw_init()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date:   Wed, 10 Feb 2021 20:20:40 -0800
In-Reply-To: <20210210074605.867456-1-weiyongjun1@huawei.com>
References: <20210210074605.867456-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-10 at 07:46 +0000, Wei Yongjun wrote:
> Fix to return negative error code from the mlx5e_tc_tun_init() error
> handling case instead of 0, as done elsewhere in this function.
> 
> This commit also using 0 instead of 'ret' when success since it is
> always equal to 0.
> 
> Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel
> endpoint device")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>


Applied to net-next-mlx5,

Thanks!

