Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47D1370339
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 23:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhD3Vu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 17:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhD3Vu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 17:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 47B946105A;
        Fri, 30 Apr 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619819409;
        bh=miG+q2c09nliVQBuE8bGiLgfU/PPdRkcr8VnkO3Dbgc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KUPsi3VDWBKQASaNCGYZDkStesqGqnV9LL3iOXBdrRYESqaLHrADp2kIYzoKc0csk
         zYbQFhiCjwawvrFYSX8fLmLf90Xry2UKDFRuqkzrkM5DOkPlYGqBz+NrBGdDVlA5pE
         MLZng4wzK8gxpHSNDeHWcQOfd/a0Fi3/yucoHOCRfI0n8Q2KvtPEIYBAY6ygCkE0jy
         BbRFqbrooNXEoisme+OKUGJ3UT0apxAhgTccZKM9fw2rgcjjeTQgk8Xm7GHqDHhbFG
         TulUvvXTUXqo3Lxje1QjR4LjZjQMa71FP4BN9UINwPGhwtGYp6pfL1eTMM7NZSphZh
         5urGLKPHp4CnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 375B760A23;
        Fri, 30 Apr 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: cleared __FPE_REMOVING bit in
 stmmac_fpe_start_wq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161981940922.13877.7364921069521536310.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Apr 2021 21:50:09 +0000
References: <20210429230104.16977-1-mohammad.athari.ismail@intel.com>
In-Reply-To: <20210429230104.16977-1-mohammad.athari.ismail@intel.com>
To:     Ismail@ci.codeaurora.org,
        Mohammad Athari <mohammad.athari.ismail@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        tee.min.tan@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Apr 2021 07:01:04 +0800 you wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> An issue found when network interface is down and up again, FPE handshake
> fails to trigger. This is due to __FPE_REMOVING bit remains being set in
> stmmac_fpe_stop_wq() but not cleared in stmmac_fpe_start_wq(). This
> cause FPE workqueue task, stmmac_fpe_lp_task() not able to be executed.
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: cleared __FPE_REMOVING bit in stmmac_fpe_start_wq()
    https://git.kernel.org/netdev/net/c/db7c691d7f4d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


