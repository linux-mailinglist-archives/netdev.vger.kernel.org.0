Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC976D6922
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbjDDQoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjDDQog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:44:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D45E6C;
        Tue,  4 Apr 2023 09:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02212636F7;
        Tue,  4 Apr 2023 16:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD8FC433D2;
        Tue,  4 Apr 2023 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680626674;
        bh=HXCyuISoExALr7JjHiFDGv1Fp7sOKciwatitis3fUU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FcgsyrEBQIxtACWdbbgenaSe8u+IROx4n76BXadCu1dJIOB4y6Ho4LliFJvLSqPqC
         4Sg1jwQ6E1183kkfAyKwbLrNh+yjgL0mlO70fEUqMfa/a8cLJRWg91E+GwiD5MW1DS
         9QN2M5ZtLkZkl5bvfdnaNpiqVFYOrQTcPO49j+Ux+PvcDHDS3Qfvq1vSI5DZQ16GlM
         MZ9KkWEiRekkqwWpHLgehG0uvy4ectU0To2ZIH6xGqzyi7bNjsUpgCZKQdxIrNBda0
         pCn9NeklNOe+0G8G9oTkhoQ/wqmiSXjbf5o9ceHCJiumDnm3m2CTbLuG28dOHn43f0
         1gkYkIJUkWH7g==
Date:   Tue, 4 Apr 2023 19:44:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        simon.horman@corigine.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH net-next v3] net/mlx5e: Remove NULL check before
 dev_{put, hold}
Message-ID: <20230404164429.GL4514@unreal>
References: <20230404072932.88383-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404072932.88383-1-yang.lee@linux.alibaba.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 03:29:32PM +0800, Yang Li wrote:
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:35:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:72:2-10: WARNING: NULL check before dev_{put, hold} functions is not needed.
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:80:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:35:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:734:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:769:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> ./drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:1450:2-10: WARNING: NULL check before dev_{put, hold} functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4667
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
> 
> change in v3:
> --According to Leon's suggestion, do this cleanup for whole driver.
> 
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  9 +++------
>  .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 10 +++-------
>  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c      |  3 +--
>  3 files changed, 7 insertions(+), 15 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
