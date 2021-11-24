Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9D745B30D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhKXEXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhKXEXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 23:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D406B60FE8;
        Wed, 24 Nov 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637727609;
        bh=Q5v1MeU6DlYweF8CqkYLXI1ffnzcKqa2LZjTsPgP5t0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cEG9q9SpXkRNfOpH1roOC60nQUqumPjKWB79CaQHJm4lzLHoXMhVBxXSSMMb8iVC/
         c7Axmp4S4FOo0dv73R4CiNM2R7FKJCRqstBkLW8rzMCNaeZWBpNNHx3QBPMkMtZnwq
         ap1aJ6cpk5FDgmNVyxgmrtP8w80lufKDO3h+Pvcbv+OAN3KWRxmkxm8xY3i13+Ms04
         m2ESzyS+wkBHdCiCoYw7GPzTC2aZ7DK3G9TSyCcDnc3DhIiCp20KFHo+qj9aoLzGor
         5HZmKV8M0X+N2zg84bUEfB3C4g0e0QcIEQtRrt7JWwrnYyM89/9EHI5ijf896Eju59
         ZSn2rOMCTM3eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC64F60BC9;
        Wed, 24 Nov 2021 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: stmmac: Caclucate CDC error only once
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163772760983.14808.10753248852142083725.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Nov 2021 04:20:09 +0000
References: <20211122111931.135135-1-kurt@linutronix.de>
In-Reply-To: <20211122111931.135135-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, vee.khee.wong@linux.intel.com,
        tee.min.tan@intel.com, vee.khee.wong@intel.com,
        xiaoliang.yang_1@nxp.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, b.spranger@linutronix.de,
        tglx@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Nov 2021 12:19:31 +0100 you wrote:
> The clock domain crossing error (CDC) is calculated at every fetch of Tx or Rx
> timestamps. It includes a division. Especially on arm32 based systems it is
> expensive. It also requires two conditionals in the hotpath.
> 
> Add a compensation value cache to struct plat_stmmacenet_data and subtract it
> unconditionally in the RX/TX functions which spares the conditionals.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: stmmac: Caclucate CDC error only once
    https://git.kernel.org/netdev/net-next/c/c6d5f1933085

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


