Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFA634D8FE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhC2UUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231747AbhC2UUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D32806195D;
        Mon, 29 Mar 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617049209;
        bh=oH7xCFX56wvUEUsreOxH9B3g1wuS6/1ZH0q7GA83rtY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NAmfUJnVAJDgj6rh7rRQJpKZm1Bkfei9lbQWin9OFzLWlvKq2eZPZoqebJgtnYRdz
         h1tANJqMkcvnaeMqlTpBWjjHF/Qz8FoT1ySs2iG/KUsM5S5exLi4QnVLBc7pQXJBky
         j6kB+wqLrmB+p8vV4Zve/b02V+V9hPhuKIw3itMkV3hzZ4DWfW9j63v9omegrXIRU4
         /FIHDZlqhq5+3GSSxXJocgfgxP+VipTX9bx75TtxU0lDmXpoZXSiGvmolwYHL5OJAf
         RgTvcrVDQ/d0+gBmdorl5Juo/KgggscnCU6mdw7UrDjesUMKsEOct4rCkU/O149UgT
         HFR5w8Ye/ZG6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C358860A3B;
        Mon, 29 Mar 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: axienet: Remove redundant dev_err call in
 axienet_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161704920979.7047.6333680784944638343.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:20:09 +0000
References: <1616982313-14119-1-git-send-email-huangguobin4@huawei.com>
In-Reply-To: <1616982313-14119-1-git-send-email-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 09:45:13 +0800 you wrote:
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
  - [net-next,v2] net: axienet: Remove redundant dev_err call in axienet_probe()
    https://git.kernel.org/netdev/net-next/c/a956b21596f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


