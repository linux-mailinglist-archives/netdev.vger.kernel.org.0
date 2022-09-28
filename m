Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B35ED80F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiI1In5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiI1ImF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207BAAB1A3;
        Wed, 28 Sep 2022 01:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5CE061113;
        Wed, 28 Sep 2022 08:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29453C43140;
        Wed, 28 Sep 2022 08:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664354416;
        bh=IvcUKhi+wBKuK6Y1PlZtH4s7eTYDpLyCknAC621yXTM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nA89rfmtgHIE6qEv8i5PpXt0JQ4/IvHT/sr4SHh/1uASAbnbYFj+vf3Ept7StNKlg
         6TRilHuw5CRouvEAPsUn+HNUH7J4tM94MOVLzq1a/VYApZu8O2H0KNPta31ve9BXEX
         /oUVjW2/v6yR/onCjujwMmI0U+qZNqkG8m9lyhkUFE79P5nwCOlTn+HljYYFgeO6CZ
         LYccZb4EfmiI6YDYSGpa4LZ3I0MCrbueSbTN22cK9cp2hrfOvihW+wPmtit7aBMw7d
         IRkkaHbYfjG9HvTc9wPnQwzV1ZxprMryWUGhoxYxrqPRA02Hc2YKgZPsI77NxHI6KZ
         Ju8DC2RO7UtQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11CC7E21EC5;
        Wed, 28 Sep 2022 08:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: lan966x: Add tbf, cbs, ets support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166435441606.12187.16613895904414372433.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 08:40:16 +0000
References: <20220925184633.4148143-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220925184633.4148143-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 25 Sep 2022 20:46:30 +0200 you wrote:
> Add support for offloading QoS features with tc command to lan966x.
> The offloaded Qos features are tbf, cbs and ets.
> 
> Horatiu Vultur (3):
>   net: lan966x: Add offload support for tbf
>   net: lan966x: Add offload support for cbs
>   net: lan966x: Add offload support for ets
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: lan966x: Add offload support for tbf
    https://git.kernel.org/netdev/net-next/c/94644b6d72b4
  - [net-next,2/3] net: lan966x: Add offload support for cbs
    https://git.kernel.org/netdev/net-next/c/21ce14a8e71c
  - [net-next,3/3] net: lan966x: Add offload support for ets
    https://git.kernel.org/netdev/net-next/c/29aaf3d40e01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


