Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94A23ED451
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhHPMun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhHPMuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D75F63284;
        Mon, 16 Aug 2021 12:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629118206;
        bh=c7ZFtzH6Mc72jNZYOrzmCuWao+Zj9ly03lg/CvEWra4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LCVInPQ7N/DSmGhQaKyWgvutzB75xFVN/YCuT+fRlrm0eNrZ/j+9yL+6D09UfSMHC
         MiVC1pD7FF98iglR3SJRsD9aKWHtLg5wPekH50yS+IVgko8YwAwREa2RqYNGwEepNj
         V6LVNTjpjFlGY7dc9539I4HM8mfRUHF1AEvU9obrajePzGfUSzYIUX5wdBENQjL53E
         jBuXury7LQb3eloRL+F/vlMS7WPzNmbM6kRmDo4kf/MLFsI7BayKI0PdTxzoNBcZzF
         /B4/1fXabRjYcMIC3opCo8597DKS5WtH0Uv86Tb2x8w01QqFwOQ5as1Muvux8pLgl9
         +yMD/jPHfsl3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 45EAD604EB;
        Mon, 16 Aug 2021 12:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 0/3] net: stmmac: Add ethtool per-queue statistic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162911820628.2793.5855796807565496042.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 12:50:06 +0000
References: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
In-Reply-To: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
To:     Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, vee.khee.wong@intel.com,
        weifeng.voon@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Aug 2021 14:15:57 +0800 you wrote:
> Adding generic ethtool per-queue statistic framework to display the
> statistics for each rx/tx queue. In future, users can avail it to add
> more per-queue specific counters. Number of rx/tx queues displayed is
> depending on the available rx/tx queues in that particular MAC config
> and this number is limited up to the MTL_MAX_{RX|TX}_QUEUES defined
> in the driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/3] net: stmmac: fix INTR TBU status affecting irq count statistic
    https://git.kernel.org/netdev/net-next/c/1975df880b95
  - [net-next,v1,2/3] net: stmmac: add ethtool per-queue statistic framework
    https://git.kernel.org/netdev/net-next/c/68e9c5dee1cf
  - [net-next,v1,3/3] net: stmmac: add ethtool per-queue irq statistic support
    https://git.kernel.org/netdev/net-next/c/af9bf70154eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


