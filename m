Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E2D62F593
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbiKRNKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239931AbiKRNKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B58B8C087;
        Fri, 18 Nov 2022 05:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E512EB823B5;
        Fri, 18 Nov 2022 13:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6ABCCC433D7;
        Fri, 18 Nov 2022 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668777015;
        bh=hD5pqTfRz9MxhjvgbTdX3fi22qgWfYtD8znIx6/jpI4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TYAMn7QlPNkPkyF1yXp8I/XcUni7K+DS+jRxMr32fvHn27qhmv7E7cXRL7++v4VKr
         0szw8a/htflGHCAlKfF4w9Cjyey1YZI6zFilb8ayFp+PWo9AviftdsTwAeJ6sXRebd
         pAspcyq7ek2Jb4fGvbckoFoBXsi4bNkxEoGFRh6s0mY7WYBqCQmxHVJ+ubLXtejvtT
         psG4zmE0BHpJjUba6dOLuv33bMRudzm54b38PyvFAtrJfUNcDU7rVGWs1sPnMNvAHE
         plALNQJ61XuFJH7Sl+gPfPmFKheMJGKkRWBb2MoeMGJNzRv6NTs4BLhKqWBLDF3+4z
         ZoI4kDSBMWbqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 337E4E29F44;
        Fri, 18 Nov 2022 13:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877701520.19854.17834649129969422685.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 13:10:15 +0000
References: <20221117065527.71103-1-wanghai38@huawei.com>
In-Reply-To: <20221117065527.71103-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andriy.shevchenko@linux.intel.com,
        liuhangbin@gmail.co, masa-korg@dsn.okisemi.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 14:55:27 +0800 you wrote:
> In pch_gbe_xmit_frame(), NETDEV_TX_OK will be returned whether
> pch_gbe_tx_queue() sends data successfully or not, so pch_gbe_tx_queue()
> needs to free skb before returning. But pch_gbe_tx_queue() returns without
> freeing skb in case of dma_map_single() fails. Add dev_kfree_skb_any()
> to fix it.
> 
> Fixes: 77555ee72282 ("net: Add Gigabit Ethernet driver of Topcliff PCH")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
    https://git.kernel.org/netdev/net/c/2360f9b8c4e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


