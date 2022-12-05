Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447FE6423D1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiLEHrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiLEHrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:47:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C8212761;
        Sun,  4 Dec 2022 23:47:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72190B80D5F;
        Mon,  5 Dec 2022 07:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5CBC433C1;
        Mon,  5 Dec 2022 07:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670226437;
        bh=XJcX69GGs4sfa8CI4cIXi9zjr1DKHpxfdL4uRgkTwQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fxdED2gEdRRIhsQUuvTDRrNJj9VpHDVbA3lh0eDGhKf3B1Eo4x+EGpUbHt5f47NRC
         xYVVLaQ/tqC355xve9eeI8sdiWUPVe7DJAavYhZRW0JLlwAyVhS3oSflPmKgDHpUWR
         y99tZ9eMXzCtL7xQS28BH34l/n3OHsfFUl9ahzx7WNYKLlme6i0k1qZQZW8DIe9wr0
         j6qVvg9iJHrRXOAG3i9s2+n41Q6JXO0SmLCEuPvoBVqxIGSpo+mECMZ5TnKaG1CS1M
         rI8y8GQAKwVBFtzycIu4z1JafMqVwQ1x0I7qmMPvf35wGQjK/f03STShkceI3vj5sz
         dOyVo1WbSmqZA==
Date:   Mon, 5 Dec 2022 09:47:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     ye.xingchen@zte.com.cn
Cc:     davem@davemloft.net, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, khalasa@piap.pl,
        shayagr@amazon.com, wsa+renesas@sang-engineering.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] sfc: use sysfs_emit() to instead of
 scnprintf()
Message-ID: <Y42iAAH7Yvk6rOP+@unreal>
References: <202212051021451139126@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212051021451139126@zte.com.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 10:21:45AM +0800, ye.xingchen@zte.com.cn wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
> v1 -> v2
> Fix the Subject.
>  drivers/net/ethernet/sfc/efx_common.c       | 2 +-
>  drivers/net/ethernet/sfc/siena/efx_common.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
