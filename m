Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D8A39AE18
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhFCWcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231200AbhFCWbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 05FEC6141B;
        Thu,  3 Jun 2021 22:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622759408;
        bh=J9wf8zkw1dW/Mu1ya+LKho5I1K9UfTmXpSZ9P1yt9jA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h2ktKrqVCKHFlHRBAaQkukWAaQ9684BSH+7Ja0791rldEYBdTAQp8cj9+y7QvErvN
         SsUG7n9/TJICLOpNv27zEaYRlfxhKNXjxWLBzEx/s+qJYsCa6Mqe+CI/1gBvqA1vIP
         ef7VXO43GLWrytyfYNfVJvAwrc9xS9lVOv/vMo5vnGVLO++61MHXxDboclXthpOFdW
         ofkBr0mkgcID4rKIG/QobkbmbEf7PNtrCc/vv+AM4Q/xxsrSZAYWnKOigft17pO2VV
         N/1ZGO9p3OUmaDF3K2lvOW6KmjZWlkCH3agy2pmAqmdw/9lysr33A0c8icmdIvHLJk
         Ue5hKAeYbSyPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E97CA60CD2;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: ipa: support inline checksum offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275940795.8870.3183008297597746085.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:30:07 +0000
References: <20210602124131.298325-1-elder@linaro.org>
In-Reply-To: <20210602124131.298325-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, sharathv@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 07:41:29 -0500 you wrote:
> Inline offload--required for checksum offload support on IPA version
> 4.5 and above--is now supported by the RMNet driver:
>   https://lore.kernel.org/netdev/162259440606.2786.10278242816453240434.git-patchwork-notify@kernel.org/
> 
> Add support for it in the IPA driver, and revert the commit that
> disabled it pending acceptance of the RMNet code.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: ipa: add support for inline checksum offload
    https://git.kernel.org/netdev/net-next/c/5567d4d9e738
  - [net-next,2/2] Revert "net: ipa: disable checksum offload for IPA v4.5+"
    https://git.kernel.org/netdev/net-next/c/d15ec1933309

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


