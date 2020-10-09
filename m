Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77839289C07
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733087AbgJIXKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730943AbgJIXKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 19:10:03 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602285002;
        bh=aWcAjHlnZb2/Uu1ttjQy4dxQFGY2MJoEX677i3Lbt10=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hCjhra6IKq+9tbF9zHR3dPzLUV0UVmVL+0qU82QeqmAX6w9zafry+RSxV/lBTREUN
         gyZVtRqtQTGM0yk2fzHL+UVcj7qeK3is53U6+t+fEuBBCnBU58uHrHWyztJXJXpyfG
         f4ngQVFG34HtCxdWkwCPyZTr8nQT0VJLHpWJLmpQ=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: ipa: skip suspend/resume activities if not set up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160228500274.1347.12667651984060010319.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Oct 2020 23:10:02 +0000
References: <20201009202848.29341-1-elder@linaro.org>
In-Reply-To: <20201009202848.29341-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, mka@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Oct 2020 15:28:48 -0500 you wrote:
> When processing a system suspend request we suspend modem endpoints
> if they are enabled, and call ipa_cmd_tag_process() (which issues
> IPA commands) to ensure the IPA pipeline is cleared.  It is an error
> to attempt to issue an IPA command before setup is complete, so this
> is clearly a bug.  But we also shouldn't suspend or resume any
> endpoints that have not been set up.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ipa: skip suspend/resume activities if not set up
    https://git.kernel.org/netdev/net/c/d17043828210

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


