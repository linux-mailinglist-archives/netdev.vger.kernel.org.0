Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182D4301882
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbhAWVU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbhAWVUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 16:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 46A4B22CAF;
        Sat, 23 Jan 2021 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611436810;
        bh=17lHtOZOZprY9WJIOivNcmGQ3BZnmW29XOtqM+i6Q6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQSo/yKwIak1RJxDwrjWsjyQXqPojFYczoJyUdEGwJ7WNICHzVpd+lN06utl0dSDC
         nxfpRsQebVX9phVvW1uoMrwqRvGR3Tom1sPe/Aud39c4gYSWBCVEvg8OjgPI/qPWiV
         W3njWS6KI1OOsslZFEOtafljMSvf4TWD5uexI1iPkpZJsKqeDV/eo7nNmf4NCSuQ+T
         g0IQ1t1c2NkWH5V1VvpPkk5G2E7e069sGVYZX8gcPeagNs0c2iQC1fnjnDXLOevHQG
         1+fxIjmBiHg20lYDbrYMjvkWp3D8iqzjS6DoiMNqNAdz3U4iKiYH0HVE1IwrhVjKo/
         XbWmgF/RUjioQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 375C7652E6;
        Sat, 23 Jan 2021 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] net: ipa: NAPI poll updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161143681022.3146.11842157448605316831.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 21:20:10 +0000
References: <20210121114821.26495-1-elder@linaro.org>
In-Reply-To: <20210121114821.26495-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 21 Jan 2021 05:48:16 -0600 you wrote:
> Version 1 of this series inadvertently dropped the "static" that
> limits the scope of gsi_channel_update().  Version 2 fixes this
> (in patch 3).
> 
> While reviewing the IPA NAPI polling code in detail I found two
> problems.  This series fixes those, and implements a few other
> improvements to this part of the code.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net: ipa: count actual work done in gsi_channel_poll()
    https://git.kernel.org/netdev/net-next/c/c80c4a1ea47f
  - [net-next,v2,2/5] net: ipa: heed napi_complete() return value
    https://git.kernel.org/netdev/net-next/c/148604e7eafb
  - [net-next,v2,3/5] net: ipa: have gsi_channel_update() return a value
    https://git.kernel.org/netdev/net-next/c/223f5b34b409
  - [net-next,v2,4/5] net: ipa: repurpose gsi_irq_ieob_disable()
    https://git.kernel.org/netdev/net-next/c/5725593e6f18
  - [net-next,v2,5/5] net: ipa: disable IEOB interrupts before clearing
    https://git.kernel.org/netdev/net-next/c/7bd9785f683a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


