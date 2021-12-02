Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF24663AC
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346876AbhLBMdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:33:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33314 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240508AbhLBMdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:33:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4BF7CCE22B9;
        Thu,  2 Dec 2021 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76E8CC58319;
        Thu,  2 Dec 2021 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638448210;
        bh=BguHmQQgjdoMxQSfiUp0J0tE9Ux6qloTs39WCqbpDGg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JSTh3PZ+4656276TaZigBxuT90AUvsfwzDHXaPKURNupOMxyCdg3qfl79Lm9QO77c
         /sG0KB/jQoxxyR7GuiuTN0lEbunVvXSMkOXwvui+tXh3h+RfZxWMgCzKkIW/SKBJQ5
         eBqTMKGRoIH7Spe0bIBgT2ldcIeAUExwAwk6K9BRMWKkEeS5Y4dv2FV5Tyo5Hon18N
         9ECS0ZdzSPJRDutFxx2llQ/kG3J3SnoA9/w7n/VWKK8+PBbFHzCxvE6hUDg7lQao3Z
         DWSn9t0NUdNJMAfv0ML41IG9dl7ELTKXeTHcMJyhvfMj1iZuMavKZpJ8ugQ1UJjm+R
         //S0vCHbmlMOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 622F960C73;
        Thu,  2 Dec 2021 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Fix builds for lan966x driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844821039.14016.14023726408454654201.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:30:10 +0000
References: <20211202081511.409564-1-horatiu.vultur@microchip.com>
In-Reply-To: <20211202081511.409564-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 2 Dec 2021 09:15:11 +0100 you wrote:
> The lan966x is using the function 'packing' to create/extract the
> information for the IFH, that is used to be added in front of the frames
> when they are injected/extracted.
> Therefore update the Kconfig to select config option 'PACKING' whenever
> lan966x driver is enabled.
> 
> Fixes: db8bcaad539314 ("net: lan966x: add the basic lan966x driver")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: lan966x: Fix builds for lan966x driver
    https://git.kernel.org/netdev/net-next/c/cc9cf69eea48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


