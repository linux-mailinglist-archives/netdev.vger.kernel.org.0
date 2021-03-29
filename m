Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3BC34D8FB
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhC2UUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231844AbhC2UUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EAB6061990;
        Mon, 29 Mar 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617049210;
        bh=jlCwWmeXYijmJcPJaPtCi0cFsmSyEb1quFTEDPF8e5w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s4+ATsuFkqEuE3JTQV0OwV2cppEZFIJ3aWs+gmKxQvpnCHDtbeElsEZ9Jl+REjxwD
         MzuXd9zwvZ/8RggS/6jtyF79UEjHUXwNeIebx0Gb9yRt7TM0ptE/TGmGrZdW70jWMr
         Vle34UXLIzEtDWYMOHHs4HllyKGwRf/2bWqZvL9IRNcrxSsze5M6zSHiNC6QoYFuET
         blTp45p1dKP3Orq7gu4t9zY0vIjd4s4WfPPkHI0gc8OOD9152zLuxxOuLMUMLNNZ40
         M4KN4c4eLt3ooDN+nVprU+z+xIoy1nhj6iJ5gdhytwPTgtGjfRyBFzE9wuHCXdF45G
         WOH31nbB6KNjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0A7960A5B;
        Mon, 29 Mar 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: stmmac: remove redundant dev_err call in
 qcom_ethqos_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161704920991.7047.8155983568330471416.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:20:09 +0000
References: <1616982572-14473-1-git-send-email-huangguobin4@huawei.com>
In-Reply-To: <1616982572-14473-1-git-send-email-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     vkoul@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 09:49:32 +0800 you wrote:
> From: Guobin Huang <huangguobin4@huawei.com>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: stmmac: remove redundant dev_err call in qcom_ethqos_probe()
    https://git.kernel.org/netdev/net-next/c/3d0dbd546345

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


