Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABA962110A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbiKHMk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiKHMkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C1151C28
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8C87B81AB7
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 12:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76DFBC433D7;
        Tue,  8 Nov 2022 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667911215;
        bh=iktiCSkZHbrqB3HWxE9FHVPAwdqsL8+VKH+8ULt7qTg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cCV/2aPBwjZ7zZP6HniDVz+BfQtU/Rx39iwn14xUZbsbvnfqxYtPpe5Fs+Tc6KtoG
         7v7iMwLalrUCy+ze02GgF8uK2HGsW0yn7xElj9/n5mZwvMZXMVOWzUvpgPsFQYXYq6
         1FO5Ko7P4TF5yhQbLRA8qMPSd4lY5WSnbKvTUZH4WsJl4d5itNkTCD7800tktnyKxa
         1aSGCPdiOwets3LBn9A59yAh/bANfOGjk94WWmZ0hw6GsRVEGabKO3OwhB5pfphitB
         IimFDfb8HhJMGkePtC71HpaZLAmH6Kmx3uxARsDBtMeVbdmm85mvS0X1DIszYjL83O
         sBFmyMQC+AW7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5CAB3C4166D;
        Tue,  8 Nov 2022 12:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk-star-emac: disable napi when connect
 and start PHY failed in mtk_star_enable()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166791121537.583.13082535543863984299.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 12:40:15 +0000
References: <20221107012159.211387-1-shaozhengchao@huawei.com>
In-Reply-To: <20221107012159.211387-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        bgolaszewski@baylibre.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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

On Mon, 7 Nov 2022 09:21:59 +0800 you wrote:
> When failed to connect to and start PHY in mtk_star_enable() for opening
> device, napi isn't disabled. When open mtk star device next time, it will
> reports a invalid opcode issue. Fix it. Only be compiled, not be tested.
> 
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk-star-emac: disable napi when connect and start PHY failed in mtk_star_enable()
    https://git.kernel.org/netdev/net/c/b0c09c7f08c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


