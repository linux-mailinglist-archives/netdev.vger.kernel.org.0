Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87226627C55
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiKNLae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbiKNLaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:30:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AA22BE7
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 03:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2269CE0F55
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28502C433D6;
        Mon, 14 Nov 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668425415;
        bh=D6VKvXv+z2Ztamlx8cNEZ9urvrpMAxmFggHuS6mV6jA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cL0biLhjov+rnHeo25rO6glYI1ULdIJ5aQjE7NvQplZ56vzbaqRoMjU/LlVYZ649/
         yvqsHg5le2skfD4jVKpi+dNq283YhwYTOx0eNodvn5Os/zqhrzX2WJroS8I7bi+9P4
         Oe0EMYQ5x1VWJT6216GrxWpXOs77ME6RiAm+0PPFdNAtuiWtwzY3WIdLRUjBHY0GOF
         9WYa9Yszl4qLe+ovgwJ7v85+OYtcgJYH62tPgrtlUHQDhBA9vdM79vqN+ulbnYMhsN
         3AVYUGKyUOEGNmY7eRKp1h0KSM9IWxuJxm/E3qFUgKGvKQcQbfPwoNPZfXrXvsuQw6
         aJEPpOHQzDOiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D277C395FE;
        Mon, 14 Nov 2022 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: mhi: Fix memory leak in mhi_net_dellink()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842541505.32199.10882496854360653345.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:30:15 +0000
References: <20221111092044.3170908-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20221111092044.3170908-1-weiyongjun@huaweicloud.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     loic.poulain@linaro.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, weiyongjun1@huawei.com,
        netdev@vger.kernel.org
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

On Fri, 11 Nov 2022 09:20:44 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> MHI driver registers network device without setting the
> needs_free_netdev flag, and does NOT call free_netdev() when
> unregisters network device, which causes a memory leak.
> 
> This patch calls free_netdev() to fix it since netdev_priv
> is used after unregister.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: mhi: Fix memory leak in mhi_net_dellink()
    https://git.kernel.org/netdev/net/c/f7c125bd79f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


