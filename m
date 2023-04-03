Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBDD6D4FEE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbjDCSGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbjDCSGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:06:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F1A30D0;
        Mon,  3 Apr 2023 11:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF9EF621D5;
        Mon,  3 Apr 2023 18:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B43C433D2;
        Mon,  3 Apr 2023 18:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680545159;
        bh=bQaOjfuXlS/fADZRDD4pGua1uw9DycIU4X61ab+46/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OIbqJFPCTzHu5YCDZWaRfIOyF07aJs2Wp335tQ8qMZg+ouNVk0VU5CSNWxBySt/tQ
         2SJI2lwYY0yQxiaJdKZvyMQCdaNhYw4iNqITcXtaP8BzSHUXxRQiKEaqk+27lTE46Y
         yROcCgBj/aI8OH1t+k/6grPahvdyEyhXpej80yq/Nm556m/4B2EmnYsi78R99hyAqt
         CCVY6JYS8mIfiS12PeR+2VOuDQ5h4OYD39vJGa5ELjwZnpdtNDzb3GWy0H0yE0x8d5
         EprXF8X37+zVDQ2rtKDHEhgQJS0BlhnJuQaV1jmnBh6+XUAQJSIr6nIIw9aoZ2p8iO
         ALmUE/LBn56/w==
Date:   Mon, 3 Apr 2023 21:05:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Eli Cohen <elic@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: Fix check for allocation failure in
 comp_irqs_request_pci()
Message-ID: <20230403180554.GA4514@unreal>
References: <6652003b-e89c-4011-9e7d-a730a50bcfce@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6652003b-e89c-4011-9e7d-a730a50bcfce@kili.mountain>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:03:47AM +0300, Dan Carpenter wrote:
> This function accidentally dereferences "cpus" instead of returning
> directly.
> 
> Fixes: b48a0f72bc3e ("net/mlx5: Refactor completion irq request/release code")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
