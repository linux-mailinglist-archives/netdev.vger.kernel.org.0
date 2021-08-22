Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604BE3F3EC8
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 11:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhHVJAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 05:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232251AbhHVJAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 05:00:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA66F6120A;
        Sun, 22 Aug 2021 09:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629622806;
        bh=aW2l6mDJnLdvsvbDmlu1nT7dbTCoEBT3y+dqQnsNedg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kn5BCLla2JEGLdo+7/5MNjv67Ho9pKMsSKrJP7W0KJcepb/9QQ5XTUxl93iLtzIL5
         XomJSWy6u9UHvDcfv2w8pzGk6ft6PIR+PAW/eimWkNlqNAmhtUpw00rbiQ/xHjq71L
         KgekkxrOtvvcJDjBr3D6hiNbigl3/GahcaeMOiJM71uARcF6H6J3/U3ARDRxbEujHS
         PqQWJaU0JHQtGxd1vJRrxwxQKluf5xdfTbjz5AGVqttZvdyKSEHppoePmK6/4x6zN/
         w4bLshpr6ffPVjO035zu7mkH2Htv6jdkLA0SfZ+UFJwjUISdxHlRfINDAu/zg4HEjh
         SFI2C8CKvkjTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9DFCD60AA1;
        Sun, 22 Aug 2021 09:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: ipa: enable automatic suspend
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162962280664.32226.3617074437572155257.git-patchwork-notify@kernel.org>
Date:   Sun, 22 Aug 2021 09:00:06 +0000
References: <20210820160129.3473253-1-elder@linaro.org>
In-Reply-To: <20210820160129.3473253-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 20 Aug 2021 11:01:26 -0500 you wrote:
> At long last, the first patch in this series enables automatic
> suspend managed by the power management core.  The remaining two
> just rename things to be "power" oriented rather than "clock"
> oriented.
> 
> 					-Alex
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: ipa: use autosuspend
    https://git.kernel.org/netdev/net-next/c/1aac309d3207
  - [net-next,2/3] net: ipa: rename ipa_clock_* symbols
    https://git.kernel.org/netdev/net-next/c/7aa0e8b8bd5b
  - [net-next,3/3] net: ipa: rename "ipa_clock.c"
    https://git.kernel.org/netdev/net-next/c/2775cbc5afeb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


