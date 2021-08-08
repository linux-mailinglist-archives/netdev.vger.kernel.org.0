Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB273E3A11
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhHHMAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhHHMAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 08:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 856236101E;
        Sun,  8 Aug 2021 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628424005;
        bh=6UyyP4W5cjwD/xwGsnE6Dw4lFo702REXGRF1OheBYjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OFXFrkM4kr4S23OlkIE7hAMI9OZQF48EOUv68a3uSrd7//kKRzAHDBW5w3HLPb4NL
         J0mkkKY5GyUvcfXouFnHGd0ItoQWDygevWL2ZtDpgKdwLewVaDfuWxNcCKSaT5i9FT
         kLK1bVN6bo85XpwCSHuCM2DBLsMXB3SlNnYzT8onHs9Z7yelIYAOHj5wjTAfIUWsq3
         sWoyl+Bn2jjebiYfn8YQsHJhvHMBbyj740U8/kzbsgQ3GYSlyLbnSiiq72RCihF9sz
         jSAXxZ5cfMwZZnz+bP0u7iiioEo6vRyHZTOX65fwu8knV9HUQxaXpsz/nnnpwDVSbb
         7qWihStiZ9/sw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7C48060985;
        Sun,  8 Aug 2021 12:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] ptp: Fix possible memory leak caused by invalid cast
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162842400550.17847.15907069345700834038.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 12:00:05 +0000
References: <20210807011546.1400747-1-vinicius.gomes@intel.com>
In-Reply-To: <20210807011546.1400747-1-vinicius.gomes@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, yangbo.lu@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  6 Aug 2021 18:15:46 -0700 you wrote:
> Fixes possible leak of PTP virtual clocks.
> 
> The number of PTP virtual clocks to be unregistered is passed as
> 'u32', but the function that unregister the devices handles that as
> 'u8'.
> 
> Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> 
> [...]

Here is the summary with links:
  - [net,v1] ptp: Fix possible memory leak caused by invalid cast
    https://git.kernel.org/netdev/net/c/d329e41a08f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


