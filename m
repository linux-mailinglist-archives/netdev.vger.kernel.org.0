Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA2434F26E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhC3Uua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231951AbhC3UuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 272A4619CB;
        Tue, 30 Mar 2021 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617137411;
        bh=TjQ32H0qXeic7zjq3zL8aV+Xw0d3aKBeRMFZjdpMGso=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pj33cRb4PhM0ov+FEZdufJbQUoHoXNFX7bEV0LYfFiKmRsFRSCP+pNuqN8N8PJtEq
         4Jqs0p+i5SSk6foX2TRTU5pC53Z5WapqnLzBM/IWoLPgIvtT6WXotxORXjUGFh3igI
         U0WfD5IUhbXfaJFji61dCfDwondS+Q2LRt278eN6oANhnokBeFh9qKvz0QVMgSsYcv
         xEbgVQNg5Pc+NVjViKB418Locz5FdzFn9074NGY4ev55Cu+ZB3mkC+0nEeLRkTnPsB
         Rug7rRxXQhsB63MmVUwGEEcmALzhP9//FAA0kpV4IQao141Zr98ALozI7Piq+Y9xgl
         xrwLN28dppX4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E99360A72;
        Tue, 30 Mar 2021 20:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] stmmac: intel: add cross time-stamping freq
 difference adjustment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713741112.14455.12714100818749005935.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:50:11 +0000
References: <20210330024653.11062-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210330024653.11062-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vee.khee.wong@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 10:46:53 +0800 you wrote:
> Cross time-stamping mechanism used in certain instance of Intel mGbE
> may run at different clock frequency in comparison to the clock
> frequency used by processor, so we introduce cross T/S frequency
> adjustment to ensure TSC calculation is correct when processor got the
> cross time-stamps.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] stmmac: intel: add cross time-stamping freq difference adjustment
    https://git.kernel.org/netdev/net-next/c/1c137d4777b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


