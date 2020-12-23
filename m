Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3D72E2134
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgLWUUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbgLWUUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FADF223E4;
        Wed, 23 Dec 2020 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608754806;
        bh=r/O1ooKlIVHJ6l8iqc+ICu3Ee1NqxeuVzbHKVzdecKw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dv4KMS6t3x7aP9mmYDXYIAzIDyxQxBEBO3rZyriKn8HIuuZHFrZER0mmobK0SKQ+G
         LoFLf9w2MAu8MO7O+HMufm1tWtPWv4H5IYkLmAAxzLK6cFA0YObHegbPvaWs351kRh
         ehe6KvI0CF4wf0RV33S8CVRkcW+t9H9pQt5DOTm/NX3MAvhYHAMzypcSLdmvCreIIx
         uhodNpbCySSW2/En2PHKeWG+v/LJ6n3I102BlRnOzW2+unJVx91DURBrge5IfgSg4E
         q2JT4rhrZVgV0bRyG9IUAw2dhfZ36wZFpx/TnDlg0uKUOV1aFiEBZg00joWHoH++F9
         HruEcU4CYB7rQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 86ED060591;
        Wed, 23 Dec 2020 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net: ipa: GSI interrupt handling fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160875480654.17264.8645397184317449328.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 20:20:06 +0000
References: <20201222180012.22489-1-elder@linaro.org>
In-Reply-To: <20201222180012.22489-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 22 Dec 2020 12:00:09 -0600 you wrote:
> This series implements fixes for some issues related to handling
> interrupts when GSI channel and event ring commands complete.
> 
> The first issue is that the completion condition for an event ring
> or channel command could occur while the associated interrupt is
> disabled.  This would cause the interrupt to fire when it is
> subsequently enabled, even if the condition it signals had already
> been handled.  The fix is to clear any pending interrupt conditions
> before re-enabling the interrupt.
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: ipa: clear pending interrupts before enabling
    https://git.kernel.org/netdev/net/c/94ad8f3ac6af
  - [net,2/3] net: ipa: use state to determine channel command success
    https://git.kernel.org/netdev/net/c/6ffddf3b3d18
  - [net,3/3] net: ipa: use state to determine event ring command success
    https://git.kernel.org/netdev/net/c/428b448ee764

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


