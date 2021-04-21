Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E073936722A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245128AbhDUSAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244987AbhDUSAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 14:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DE0EF61455;
        Wed, 21 Apr 2021 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619028009;
        bh=GwJ42hMLPs33IaF7uYQo8+5jI0y402wG5bF38sdSi+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pagvPWzT/qdG/cXCi1gk6EzMz8jUuhYdUJsMXwJp/H5aq0UR3G9DxFByGKgVu9cOa
         GlsXK3gDW6vTftVd6ORuHc4spHRYUlaj+201WUYyDrfs+2mlVYKe7CdGYxC639Wmop
         opXlm64SOd8fEoFj+MU/Mivt6blWsM1crZS6iGLyuyXO3wKl6c79jBl8k3TTRjaLTg
         Y2FLedmryYkWXaXScYFetcQ7tS/suZPhqYK97A9LrXWihaQM3yAf7nE5KYRD1wMBY4
         BvM6oWtXFwPmlOfInSEAAVjm+0Qz/+c9Qg8+DgH6jIAXYLsydQ4VgBz6JnkONb3R+B
         CFnLF2AmKdUzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D961E60A3C;
        Wed, 21 Apr 2021 18:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] stmmac: intel: set TSO/TBS TX Queues default
 settings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902800988.24373.17521808313438955421.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 18:00:09 +0000
References: <20210421084606.20851-1-boon.leong.ong@intel.com>
In-Reply-To: <20210421084606.20851-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Apr 2021 16:46:06 +0800 you wrote:
> TSO and TBS cannot coexist, for now we set Intel mGbE controller to use
> below TX Queue mapping: TxQ0 uses TSO and the rest of TXQs supports TBS.
> 
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - [net-next,1/1] stmmac: intel: set TSO/TBS TX Queues default settings
    https://git.kernel.org/netdev/net-next/c/17cb00704c21

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


