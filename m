Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB78644274
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbiLFLuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbiLFLuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2329727FC2;
        Tue,  6 Dec 2022 03:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6818616D4;
        Tue,  6 Dec 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20E7AC433C1;
        Tue,  6 Dec 2022 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670327416;
        bh=b07s2sNE6hg0YiuREv3r9mgcBnusf2Rlu8O2Wh+ZSOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A85yE0hndxxffjFwdIoPb3x4K35j4YkAaNI0ZwnKAqU/ZmyeflS5zx2PrNnRpV4Ly
         ZQ29BHBOU/+/4KNWIyXUJZKxpiedJNTvjXZdnv+iqWK7G5VHEj4AAjnLqArEEoB2yb
         xPHtgz/g/xd4Rm57JKEamGomS1qTkh0zepPV0TBsQMt2WJXc/pXeIrHIP7iyZQKISD
         HPjbccjYmhkiv/zZlLIYZpaVj/706Zykuv388/7ToS83tJaPBRyAqqH/QgUaxMrSMH
         a1K7jShKlSHkc3pQ85i1offErU5BB+lfvmB4wTxQ7FqAtTj3Nlw6iUC6NNelOp9iqW
         MZiHKjLyDYhIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0421AE56AA0;
        Tue,  6 Dec 2022 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: thunderx: Fix missing destroy_workqueue of
 nicvf_rx_mode_wq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032741601.10641.4366220220611889414.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 11:50:16 +0000
References: <20221203094125.602812-1-liuyongqiang13@huawei.com>
In-Reply-To: <20221203094125.602812-1-liuyongqiang13@huawei.com>
To:     Yongqiang Liu <liuyongqiang13@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vlomovtsev@marvell.com, zhangxiaoxu5@huawei.com,
        weiyongjun1@huawei.com, sgoutham@marvell.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 3 Dec 2022 09:41:25 +0000 you wrote:
> The nicvf_probe() won't destroy workqueue when register_netdev()
> failed. Add destroy_workqueue err handle case to fix this issue.
> 
> Fixes: 2ecbe4f4a027 ("net: thunderx: replace global nicvf_rx_mode_wq work queue for all VFs to private for each of them.")
> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
> ---
>  drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - net: thunderx: Fix missing destroy_workqueue of nicvf_rx_mode_wq
    https://git.kernel.org/netdev/net/c/42330a32933f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


