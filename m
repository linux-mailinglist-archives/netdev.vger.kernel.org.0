Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBABC6DC077
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 16:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDIOuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 10:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDIOuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 10:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C51D35AC
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 07:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1337761545
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 688F0C4339B;
        Sun,  9 Apr 2023 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681051817;
        bh=6aBgIJmFvQijWm5/1Nn7TBNsHxnLpUXfq5AKDjmqcaw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ST5njXqy6eUllXlSsGtACFCxHt+uhLDxPIxhzdQYCPRwnplB0pWNjVLxUV7ORi0ry
         yCT0jjMXRCPyGSoJHCqTyfOI53m5fQIbhwND6ThFnr673vF+IT7CtJLdmXw/thTxfb
         v9sv4c/+Z4LW4oj6F4/ysDfImZYTgylR2opSuK2sosTsjCa07TPKvrBwAhbCfLMzTK
         fh4B01wUWUhwHhEvcSrrTdJe1jdWuPhdsASUbHNnJyHyeVQsietXqFyaC4xX8mX192
         R79ZRGdOn4gM93/Z59DPDjkuIuMSXbgPwscS9TqozZT50umJ1FcIn2Z0ubflbzLCjk
         8/CMgbNTwGUxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FF36E21EEE;
        Sun,  9 Apr 2023 14:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: dsa: replace NETDEV_PRE_CHANGE_HWTSTAMP
 notifier with a stub
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168105181732.22045.17539374795782779920.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Apr 2023 14:50:17 +0000
References: <20230406114246.33150-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230406114246.33150-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, andrew@lunn.ch,
        f.fainelli@gmail.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Apr 2023 14:42:46 +0300 you wrote:
> There was a sort of rush surrounding commit 88c0a6b503b7 ("net: create a
> netdev notifier for DSA to reject PTP on DSA master"), due to a desire
> to convert DSA's attempt to deny TX timestamping on a DSA master to
> something that doesn't block the kernel-wide API conversion from
> ndo_eth_ioctl() to ndo_hwtstamp_set().
> 
> What was required was a mechanism that did not depend on ndo_eth_ioctl(),
> and what was provided was a mechanism that did not depend on
> ndo_eth_ioctl(), while at the same time introducing something that
> wasn't absolutely necessary - a new netdev notifier.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: dsa: replace NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
    https://git.kernel.org/netdev/net-next/c/5a17818682cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


