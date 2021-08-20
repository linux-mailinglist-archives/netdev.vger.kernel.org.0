Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C3B3F2D6D
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240811AbhHTNur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240784AbhHTNuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:50:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C5F306113D;
        Fri, 20 Aug 2021 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629467406;
        bh=Px+OSxWE7cApiXcsZtP4js0rwg78v5cOHxYG3EWtYCA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BkU4tfNSFAFaSMgV36YE432KnBgmWDrg/X/G48uH42QUV+u/ugo/HCgiuOWANuVk8
         vDqLMfuBl4140/5GZ93AE4Tef7PHnPLwAMeKY3eyyzNIkl4cO9qMY1XCtN1+itb8ZC
         qgD02AlIKbzPCv5c0ONPy54D8Hp/mWf02khwi/zPeAAyyXM6krnpHzyQmnKzrEO43u
         ixM5Y5awl3rVjCXJPxa05qPevWwKTw+VGQ1mf8yUCpXjMovm80G3iaZ5jgWWq2EhOD
         vViQTJ2cUAjFS31owivKa0I4FZRuj052H6mYaQ0j11y2Od5gCsLLQdbcb/K3M0tzN4
         loixvAVOBQYUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF6FA60A89;
        Fri, 20 Aug 2021 13:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ipa: fix TX queue race
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946740677.29437.1965272809545248532.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 13:50:06 +0000
References: <20210819211228.3192173-1-elder@linaro.org>
In-Reply-To: <20210819211228.3192173-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 16:12:28 -0500 you wrote:
> Jakub Kicinski pointed out a race condition in ipa_start_xmit() in a
> recently-accepted series of patches:
>   https://lore.kernel.org/netdev/20210812195035.2816276-1-elder@linaro.org/
> We are stopping the modem TX queue in that function if the power
> state is not active.  We restart the TX queue again once hardware
> resume is complete.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ipa: fix TX queue race
    https://git.kernel.org/netdev/net-next/c/b8e36e13ea5e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


