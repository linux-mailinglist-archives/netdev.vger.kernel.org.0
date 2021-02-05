Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3B6310406
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBEEUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhBEEUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 54AD764FBF;
        Fri,  5 Feb 2021 04:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612498807;
        bh=uBJWM7wgOzcUmXnF8pJlh8LtIEX/VQMOCZ4zoymwumM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qbe/IMBeCllPBJlVo8u+1K9ttlapIpKwBqrLSeKbcRxKI4/Y7XbWIc9+BntyFcHe2
         CVWus60fpGCPZ9kExaTECADTz75miNECCxvq6fA2bLB7GY29/nEGChKm/eEucX0/GP
         Te/7TJ7FAlL7KIYqxqcbYnjk9ATIAK0UVVnpkU0ZfZhEfeFdKLYUPDsX85DPuHJDw4
         Jz5ui4bus1cnboi/1wb4LxSA1YViNpl4g1opveJMwsVp6rzV3Ul3Velj6+n+4byVdB
         1HllG9aXF7/cqmbRlpasjWWg19z8w81NPCxlrXEcxYpDuKAMnKp3FxZChOWywt+8qA
         WxWKbHzbKLXww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 46A08609F6;
        Fri,  5 Feb 2021 04:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: ipa: set error code in gsi_channel_setup()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249880728.20393.13663452975147850936.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 04:20:07 +0000
References: <20210204010655.15619-1-elder@linaro.org>
In-Reply-To: <20210204010655.15619-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, dan.carpenter@oracle.com,
        elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  3 Feb 2021 19:06:55 -0600 you wrote:
> In gsi_channel_setup(), we check to see if the configuration data
> contains any information about channels that are not supported by
> the hardware.  If one is found, we abort the setup process, but
> the error code (ret) is not set in this case.  Fix this bug.
> 
> Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ipa: set error code in gsi_channel_setup()
    https://git.kernel.org/netdev/net/c/1d23a56b0296

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


