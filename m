Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7E231843E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 05:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBKESE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 23:18:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhBKESC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 23:18:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30A4060C40;
        Thu, 11 Feb 2021 04:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613017042;
        bh=u9AilSQ3JPMtRWmyqHps+61EZMoDhyhqxbWKYUwZNLc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YP8la2pZNHfgCOxWWh+CQ6gVMKrDNC3GojPmOPjL+QZpyT6nbcjf9MseXpIoYQ1OT
         FQxTgWYDeg8lcLusvkTIgZ37sj9r1h3MphjHrVdRa2pjGITJwEnA7iiRe7/NiZJLX4
         WOXIJjkiJY6nM4EUgSWuiwUIXWkfYsgwCX0p02/G+P2Y/07Ogv4Nl7aLeLaeT8TNbG
         zs4rrAZan9dZb8BEa6Pl3W89V5EkDF6pigmfYIw8XVrT43cNbUexNuBD6hciulLYvl
         VrFFaChWErkLeceofKf5bQ99a0li3I20AyWdZjRR4mDPHB0zEdDc4qQAUebq0By6MY
         9mVt5wQBl4Lqw==
Message-ID: <7490ce4c5dee18cc639addc3ca595103e6ad6815.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: SF, Fix error return code in
 mlx5_sf_dev_probe()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date:   Wed, 10 Feb 2021 20:17:21 -0800
In-Reply-To: <20210210080315.GG139298@unreal>
References: <20210210075417.1096059-1-weiyongjun1@huawei.com>
         <20210210080315.GG139298@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-10 at 10:03 +0200, Leon Romanovsky wrote:
> On Wed, Feb 10, 2021 at 07:54:17AM +0000, Wei Yongjun wrote:
> > Fix to return negative error code -ENOMEM from the ioremap() error
> > handling case instead of 0, as done elsewhere in this function.
> > 
> > Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/sf/dev/driver.c  | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Applied to net-next-mlx5,
Thanks!


