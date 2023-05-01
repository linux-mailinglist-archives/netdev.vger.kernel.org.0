Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C366F2EC3
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 08:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjEAGk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 02:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjEAGkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 02:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44779E72;
        Sun, 30 Apr 2023 23:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8698861AC2;
        Mon,  1 May 2023 06:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA6B7C433D2;
        Mon,  1 May 2023 06:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682923220;
        bh=+kp7Zc0nbZpMcZEMGDgEaR3CxcsWsrfmBcJF7m8AJrM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OkYj2XxqUw0VQ3pGRc45AksA6DTKi28kGr4UbqQDi+VyMgzEU2Nn//55DdYXefDp8
         VK1mGKFNSzx9+lT2618vkYVhsE5qLR9lZ9h2IX3mPRoYUT33FE6dGYiDiZRebmxArq
         u7TZIsTOOzPD8EhZ0DPtdTVFyezAzoNa/tHcfX4GmG7QGXR6XCrPcV4sSK83DJ8lYx
         iarfH5Jcd9diiS+n6dj4ZSrdViw3qoYsEp7kePRJYBRMKFv25kaPr9p1OD/IvnOMr8
         l4yh6Ub3jbtmMrV5qOktZSffNIueCKnZ+sCI/0t4ltsDmtYoZgiSg2X2mM/DU1Dkyd
         yN0OYo4pG+2GQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AABF2C43158;
        Mon,  1 May 2023 06:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3] r8152: fix 2.5G devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168292322069.19130.7182582489809893129.git-patchwork-notify@kernel.org>
Date:   Mon, 01 May 2023 06:40:20 +0000
References: <20230428085331.34550-409-nic_swsd@realtek.com>
In-Reply-To: <20230428085331.34550-409-nic_swsd@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Apr 2023 16:53:28 +0800 you wrote:
> v3:
> For patch #2, modify the comment.
> 
> v2:
> For patch #1, Remove inline for fc_pause_on_auto() and fc_pause_off_auto(),
> and update the commit message.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] r8152: fix flow control issue of RTL8156A
    https://git.kernel.org/netdev/net/c/8ceda6d5a1e5
  - [net,v3,2/3] r8152: fix the poor throughput for 2.5G devices
    https://git.kernel.org/netdev/net/c/61b0ad6f58e2
  - [net,v3,3/3] r8152: move setting r8153b_rx_agg_chg_indicate()
    https://git.kernel.org/netdev/net/c/cce8334f4aac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


