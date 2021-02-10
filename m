Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A58E316087
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhBJIEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233199AbhBJID7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 03:03:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EF8C64E40;
        Wed, 10 Feb 2021 08:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612944199;
        bh=WsMSyAEmMttrpA8GI/1mYiDsVlSiEUfBMFcMja+VhtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PX1xHRLrSLbH5235ieKoPk/oZm50InmdS1R0j1XbhFZCiOlL7VrrPEmNC7VcRYpvH
         Xh21pSStTlBGZqkXuUTcYIWMKPI6unef4ZZ64BJoWadz7SqFUBCQbEZ0dqck7VOPTr
         rSZQ4EOJiUl2k+yHg9YPI+5Ghv+M4Oxtze22piRDbspGTC5Wtn76Q+9QaAMUsVTz0e
         CjdWyWIkC42dO02RMyII51uv+pSPsTQ9ROorDP7rPcqMeHujs9wa1ZqBbZnliXWAD+
         rbT7/0Vj7DMNOG17nnEPimUBaxIeX2RxAZcLxXK3ujxiJ2NcDShq6mRdhaaT2knuJb
         y/X6DSaLSOf3Q==
Date:   Wed, 10 Feb 2021 10:03:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: SF, Fix error return code in
 mlx5_sf_dev_probe()
Message-ID: <20210210080315.GG139298@unreal>
References: <20210210075417.1096059-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210075417.1096059-1-weiyongjun1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 07:54:17AM +0000, Wei Yongjun wrote:
> Fix to return negative error code -ENOMEM from the ioremap() error
> handling case instead of 0, as done elsewhere in this function.
>
> Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/sf/dev/driver.c  | 1 +
>  1 file changed, 1 insertion(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
