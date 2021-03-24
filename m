Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749F7348480
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhCXWUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232531AbhCXWUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 18:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 480C961A1E;
        Wed, 24 Mar 2021 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616624409;
        bh=gJ1PPArMw5fS2CP20SG1uAqkL+e+zCYT9MIaZZmYLos=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OFq1wA/wVFzvhhhD7C34xUDEPdUzVXYoSzJs7zTrirSYFqRjp1DbKMRgr+YXnYzr4
         WcF3MyZyGdiF9q49jbKTRwRh2Wz/yY8vGM4cK0o691A8NuKHSQBG+yEnvf+/86fETv
         WJHb1bGSFfLAt5ShfL2X1BJ/MQGz+7OAlDNA2zilwrK7nUTigQMKJjtWMW3sKBUxKt
         aXEgq1Nv5JRXUHcxPEgZV0UTiZ5kBFiGod2160Qgz0dQBWgv5LXoa2iyskMg1slS2e
         Iv0JMH6l7Wzu+1kY4CBVsC2y5PsYTQYO5erDq9Fkqr2xPLr12NMFyzOmr+IT1jTkyS
         GgRGG0dE3BDxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D1E260A6A;
        Wed, 24 Mar 2021 22:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: Add hardware supported
 cross-timestamp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161662440924.20293.18389068518220557834.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 22:20:09 +0000
References: <20210323110734.3800-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210323110734.3800-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 19:07:34 +0800 you wrote:
> From: Tan Tee Min <tee.min.tan@intel.com>
> 
> Cross timestamping is supported on Integrated Ethernet Controller in
> Intel SoC such as EHL and TGL with Always Running Timer.
> 
> The hardware cross-timestamp result is made available to
> applications through the PTP_SYS_OFFSET_PRECISE ioctl which calls
> stmmac_getcrosststamp().
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: stmmac: Add hardware supported cross-timestamp
    https://git.kernel.org/netdev/net-next/c/341f67e424e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


