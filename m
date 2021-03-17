Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B8233F8CF
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhCQTKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhCQTKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 15:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 333A864EC4;
        Wed, 17 Mar 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616008209;
        bh=GVu/ESRM2qGynOK7RfgL/yy6B12R+6ZanQ9WH7/Wf9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MXaxK5J8cShy4IqDXXjjKAwKPuFemzWY9azouoDzumjohoBSmn3UVxTzOYmu1r+iC
         d9Ce1px8crmPZiUeYtRojD7X6+ZqnZp7dsPhqWEgSjfg/VhCuoO2o2zvI0+VozX7Ob
         sbBDxsIOlURERvt6z/gTEX3Vmadif5AjOn+qacNDIA5t7sotXYnXSXp8x8Xpi+9Vtq
         3k3pzvxJ7aTLHVfVNAr3tfHhKxlebV4PX0oMpSzTylwET0ArezNdoO2d89nAGaLEI5
         +X6mm9xbHbOj2/UlOFzuq2r4vujVoE3JZfimoBReQFpZjDfNPfWY1tHCQIuZIckh7O
         qehe0ogCznM8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 29C9360A3D;
        Wed, 17 Mar 2021 19:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: add timestamp correction to rid CDC
 sync error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161600820916.10311.6670976012285886015.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 19:10:09 +0000
References: <20210317040904.816-1-vee.khee.wong@intel.com>
In-Reply-To: <20210317040904.816-1-vee.khee.wong@intel.com>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
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

On Wed, 17 Mar 2021 12:09:04 +0800 you wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> According to Synopsis DesignWare EQoS Databook, the Clock Domain Cross
> synchronization error is introduced tue to the clock(GMII Tx/Rx clock)
> being different at the capture as compared to the PTP
> clock(clk_ptp_ref_i) that is used to generate the time.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: stmmac: add timestamp correction to rid CDC sync error
    https://git.kernel.org/netdev/net-next/c/3600be5f58c1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


