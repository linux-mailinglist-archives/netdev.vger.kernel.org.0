Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AED53DF6E1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhHCVaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232180AbhHCVaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 42A9360F70;
        Tue,  3 Aug 2021 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628026206;
        bh=W/EVXLollsvrkFRDiPsMPxdPF0VursJRbdgMO8+pHYc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E/kRqC0nO8QerfDen4mjNi3AbFfflC0Qor/onjpxpna3oVNnYEmxytqmMt6V8UFm5
         yqfnlJLCo/J/E4slpGiplPQ93SAsgTQG+x8Se5jljbpg5sXtNsXu4n7tpwOjlqYgxY
         Po1AoVSU4/okQ+YfgOcu4YKz+hdNq5U7+mSRg8E2+Tj8LHjUQeGLzeN5SVI2E86Gql
         3eizcSwk/rEiDlv9Zspgy+rOBqaP6RpSlA0XAu1PThZYSGAxJoilZEWFLgjj35Xp+x
         B3TPxBZNo+Li5QRfhcilpY/XTNw3Mq5Uh6aIUnCjMIHRz/V28zK/ShMZUhd+GAZSF2
         wUhYEMHmHp4cA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3402160A6D;
        Tue,  3 Aug 2021 21:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/1] REVERT: arm64: dts: qcom: DTS updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162802620620.14199.10157855065946369228.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 21:30:06 +0000
References: <20210802233019.800250-1-elder@linaro.org>
In-Reply-To: <20210802233019.800250-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        bjorn.andersson@linaro.org, agross@kernel.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  2 Aug 2021 18:30:18 -0500 you wrote:
> David, Jakub, I'd like for three patches merged into net-next to
> be reverted.  Bjorn Andersson requested this without success a while
> back (and I followed up on his message).
>   https://lore.kernel.org/netdev/YPby3eJmDmNlESC8@yoga/
> I'm now trying it this way, hoping this is the easiest way to get it
> done.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] Revert "Merge branch 'qcom-dts-updates'"
    https://git.kernel.org/netdev/net-next/c/a0221a0f9ba5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


