Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E11455ACD
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbhKRLov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:44:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344141AbhKRLnn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 06:43:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1E86861BCF;
        Thu, 18 Nov 2021 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637235612;
        bh=z75Sd0PO1i42YMnBmU5hptoHe8TRz3K51r91cbRFcmU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AvQSUoog1hkEKuJtUlojJk/8OAoJY5q0d18AHpHl/AQsYdM3y+1dKatTwdY5dcvF2
         uEVM14vnfi413Xy/Kq3MxraPywR9aG+JSBP4GQKKA/3koI1fM1AqOVygh7Z4hPeH/z
         ZOWpvZScNJZo7Ax9YD8jZrqxo3CD5W1G+/u745+u1s70/kurVXu2MaMS/y2lctRJWz
         JxjlKfcYdkTqYoQFT+DWrnrriE8TN9xGhZ8KPEQJ4Joe65bnEBjQQ/ghRVgAkU2L2D
         X+B+0AKceOtAGJECFvaOlInksAkuUKLuJYmiNEp2besfQqEBjgQRLfmw/ksC+Aohoe
         TlzJSFLAJ/Wig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18626609CD;
        Thu, 18 Nov 2021 11:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: dwmac-qcom-ethqos: add platform level
 clocks management
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723561209.11739.17599978487412465889.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 11:40:12 +0000
References: <20211117110538.204948-1-bhupesh.sharma@linaro.org>
In-Reply-To: <20211117110538.204948-1-bhupesh.sharma@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     netdev@vger.kernel.org, vkoul@kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 16:35:38 +0530 you wrote:
> Split clocks settings from init callback into clks_config callback,
> which could support platform level clock management.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 26 ++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: stmmac: dwmac-qcom-ethqos: add platform level clocks management
    https://git.kernel.org/netdev/net-next/c/6c950ca7c11c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


