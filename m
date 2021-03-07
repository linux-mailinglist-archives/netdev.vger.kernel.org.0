Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDA032FFBE
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 09:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhCGIuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 03:50:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhCGIuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 03:50:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E34A965128;
        Sun,  7 Mar 2021 08:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615107007;
        bh=RyrzOKBjD3Cw2eItGuby/Ri2355vEW2bs64dRDjRbFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rxmx0Rr/E56tayDbpBsAK/B8oKaS3/MFKLIZ7JFKuMUQ0KqecbL3MA7PTNgiuflWI
         0J+CUH6EgwAwvR5pIlxwm5JZjiQhnaJzL0Js0XP+GAvyUlIzkU3kNwCvAjRD+bsa6W
         U+DkAO3i45zOD46a9MkFh77ZYD4XnpqkOiTlCLjmOM+PM9cadUeQFr2drPW4c/DmUx
         VjSet8JWpFFEE3ar9A9L2DzxzdIPwrlsCmfF0CQYcUnQAxET8XtD94thGk5hkYa39U
         5UEG5ZnBXLiVgPLxs20109oEyghwXlnAynADOOjb/ir9k7IqyX/3QIphq59QG24hR6
         dF/uEt4vqKMAQ==
Date:   Sun, 7 Mar 2021 10:50:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     borisp@nvidia.com, saeedm@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mellanox: mlx5: fix error return code in
 mlx5_fpga_device_start()
Message-ID: <YESTu9lXAgvYaroG@unreal>
References: <20210304141814.8508-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304141814.8508-1-baijiaju1990@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 06:18:14AM -0800, Jia-Ju Bai wrote:
> When mlx5_is_fpga_lookaside() returns a non-zero value, no error
> return code is assigned.
> To fix this bug, err is assigned with -EINVAL as error return code.
>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Like Heiner said, the current code has correct behavior.
The mlx5_fpga_device_load_check() has same mlx5_is_fpga_lookaside()
check and it is not an error if it returns true.

NAK: Leon Romanovsky <leonro@nvidia.com>

Thanks
