Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE4833E16C
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhCPWai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231261AbhCPWaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 669B764F2A;
        Tue, 16 Mar 2021 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615933809;
        bh=W/k5FcLCYKPZx1Zb3DpzNEThLvAVizrjCCR70WGgNsA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I9U+UiRnKwg++uteQZcoxjd1IH/Q2LQYOrO2lxDGjp2k+gzPGdQdSFVVK3Q4oU4bS
         7WQsULWUBdokrLyTDJuPpOjG3CadKPTN9pBCkir8aZEbVX9xmzm4xcMWBT032QLcEE
         /t0hKz/wliKIBqpe+qrEQ9be2kAmuetLnUeA+d0T34X1qtbVmAR/DiCGyuF/YCcUM0
         INUpC38w1VZWWoFAP9JWlqHuvb7okMEHKkirRrJRhgprkGwRVeHK7Q6QilnxL1d7D5
         UBWkxoWZG7Fxo1RD1JaCjKJ/esLHAtQh4AhksLUMp2cJBmHRQl/C8T64/BhMMS20E/
         7wXdB7j32p10w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 563D060A45;
        Tue, 16 Mar 2021 22:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipa: Remove useless error message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593380934.7400.11172171509698068863.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:30:09 +0000
References: <1615887666-15064-1-git-send-email-f.fangjian@huawei.com>
In-Reply-To: <1615887666-15064-1-git-send-email-f.fangjian@huawei.com>
To:     Jay Fang <f.fangjian@huawei.com>
Cc:     elder@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 17:41:06 +0800 you wrote:
> From: Zihao Tang <tangzihao1@hisilicon.com>
> 
> Fix the following coccicheck report:
> 
> drivers/net/ipa/gsi.c:1341:2-9:
> line 1341 is redundant because platform_get_irq() already prints an error
> 
> [...]

Here is the summary with links:
  - net: ipa: Remove useless error message
    https://git.kernel.org/netdev/net-next/c/91306d1d131e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


