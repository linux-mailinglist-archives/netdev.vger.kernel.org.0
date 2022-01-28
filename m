Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6E54A03D6
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351756AbiA1WkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiA1WkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:40:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4D6C061714;
        Fri, 28 Jan 2022 14:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC376B8270F;
        Fri, 28 Jan 2022 22:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84DFFC340E8;
        Fri, 28 Jan 2022 22:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643409611;
        bh=7snEu6LNJs7WphEt2f/kDPq5YS+Nstd+e3ncyiqANqw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IYOqtih/RSjrKujYz//Q6NZM/gRnKN4ItB88pA4gPw4Afx/NLHDQe/lGE0xuxI23N
         JUtaGVLMD8nXMTpcdGkxFDg7hnfynXQz3BE0JGwrJJRiqHyE8uZj9Ar+XO+mzeIqxR
         9EvD6VB1uoMrghlrIULsLHnv0xFPeAqqLBNI4g9DHQbyfKEzAHvP6crLi3sg/ze0jA
         2FRJ8/SzeWHI9JiNiF1tMrX+uv9y0QoceIiVcLLr/0z+PH1lwF3TnN5AUWBpneMeiG
         oIJOfY+aH5JK3qLUXbaW9jwa1ookoYMpvv6ig2jWezSPYnssyB+vvWtmdo3kpUq7qP
         Dmu5qUPf/pRhg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65980F60799;
        Fri, 28 Jan 2022 22:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-01-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164340961141.28814.8348334518671221460.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 22:40:11 +0000
References: <20220128205915.3995760-1-luiz.dentz@gmail.com>
In-Reply-To: <20220128205915.3995760-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 28 Jan 2022 12:59:15 -0800 you wrote:
> The following changes since commit 8aaaf2f3af2ae212428f4db1af34214225f5cec3:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-09 17:00:17 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-01-28
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-01-28
    https://git.kernel.org/netdev/net-next/c/0a78117213c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


