Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3926749E3FF
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241675AbiA0OAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbiA0OAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AE6C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 06:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D541B82282
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BCAC5C340EB;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643292010;
        bh=gwwmdm3Nmp3/9siL3urLfjJEsZ7LvoOT3R5BO2cII58=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=etPo1D+H4xPcMeFd3VZUHsCGMJl+M7fnO0MeqnkkPAcJG+iiKO/6G6Iqpftq5kbdy
         ubCm83cXlrpTUBadE9S/YlcZ5AJe1SkRVAvSewjExBqgIXx8XjSXZmeE3XEO9V6VM/
         6PzzezYq/71wuEJm7soZ89qmle1oukKwbM2/aGjmw4tsZodPzUXBxX+yBHmdqMha0s
         0Vl9QXDTgd3uWq5dqMLJfvEk6ZP+Q9yrqoS0ik4IPVyYyRfzAnOHhFwAC1VKHcHjMY
         nNRPGMi0+6+4C8XCuzEfdBYqVzQqeA9R6N0m6xaRXg+Q8vOV0ISVJMXqgzSusZL38F
         FWnSUGmpEAkXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9700E5D087;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: add more files to eth PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329201068.13469.8713922059287973954.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:00:10 +0000
References: <20220126202424.2982084-1-kuba@kernel.org>
In-Reply-To: <20220126202424.2982084-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, inux@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 12:24:24 -0800 you wrote:
> include/linux/linkmode.h and include/linux/mii.h
> do not match anything in MAINTAINERS. Looks like
> they should be under Ethernet PHY.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net] MAINTAINERS: add more files to eth PHY
    https://git.kernel.org/netdev/net/c/492fefbaafb9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


