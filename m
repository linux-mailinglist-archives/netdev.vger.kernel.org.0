Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0652069F1EC
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjBVJii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjBVJiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:38:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CA136FF8;
        Wed, 22 Feb 2023 01:35:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83ECB612AC;
        Wed, 22 Feb 2023 09:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737E0C4339B;
        Wed, 22 Feb 2023 09:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677058468;
        bh=ikNB0EiwoY2lKpYRjIf1AbWFMbYpMf2rFPrkQqdkU7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aC33Pg8Gnyl5JVfC3DVMAupcNGW36zI64sBcnFRWZjZwDvtTUqCAcVSHsix3jqk1z
         d2xYQuvHDHIjBtZo6N8bpMcSPcDav96+mneJKD3/uBPzjuKId7o3Sd9dYBz9jA1uSo
         YVJGE+M4bZdLhD/wwyXEm0DFqAA9kKMM3Wq3UEvWri7gEZFJ8pRIlf43ZC7INT67e7
         BWwQfdeuj+CLdsKWJ4umtU0bVh3xKlMtXuMRnGgr6Kklv7roX9FTfaLPyEGaw/NNPP
         KeK08M6uxg2qIhwjIel98F1aOY48x+uGdD7MiS/pwrSlZQhoXaFm80kurgqbbgKP2h
         NtwnvxuE2CRSA==
Date:   Wed, 22 Feb 2023 11:34:23 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] net/mlx5: Remove NULL check before dev_{put, hold}
Message-ID: <Y/Xhn37K1WgkG5O8@unreal>
References: <20230222022944.48450-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230222022944.48450-1-yang.lee@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 10:29:44AM +0800, Yang Li wrote:
> The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> so there is no need to check before using dev_{put, hold},
> remove it to silence the warning：
> 
> ./drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c:714:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4174
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Please submit this patch with fixed title from -next to be net-next
after merge window.

Thanks
