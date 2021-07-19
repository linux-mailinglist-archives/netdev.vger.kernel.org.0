Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0963CE7A7
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347401AbhGSQah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350375AbhGSQ3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD6FD60FE9;
        Mon, 19 Jul 2021 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626714604;
        bh=GZtJsPrF+jQTX2G8yfKWETBi6sSFwjtIG4rwUJNRpOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h2CQLL0f95/i+gYB7ebzy2PXCwnEuvzmnPAI7YxYliyCPYi1ffGe0Zv105N5+TLRN
         uXrbNPdOUAYa7MX1FIhw8/uFSTwXqpRXI/wraUEwSWBsN3xPJov8o1hAw/nZVv97nE
         fAlIr4sCWwvrPMeb4uffPfG0OLpheF1YYpENc+YBByvgbFZBSgzryIon6mQwgvDBLT
         g5hmtyUDjMLUau67wP/jkg7TTF1tDYm2ASNvw79kG5hdUeVWNa//uOw+cajErZbAOy
         m9igx12XlbWZvgkGYJyqAOgxKN6snzbM0KzutceRDZFCuGXfI6bGFl1i5ZibbvbsYh
         /Phd5sHESykVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE3E860C09;
        Mon, 19 Jul 2021 17:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hisilicon: rename CACHE_LINE_MASK to avoid redefinition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162671460484.9576.14353409421854124905.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Jul 2021 17:10:04 +0000
References: <20210718203834.11297-1-rdunlap@infradead.org>
In-Reply-To: <20210718203834.11297-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, vgupta@synopsys.com,
        xiaojiangfeng@huawei.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 18 Jul 2021 13:38:34 -0700 you wrote:
> Building on ARCH=arc causes a "redefined" warning, so rename this
> driver's CACHE_LINE_MASK to avoid the warning.
> 
> ../drivers/net/ethernet/hisilicon/hip04_eth.c:134: warning: "CACHE_LINE_MASK" redefined
>   134 | #define CACHE_LINE_MASK   0x3F
> In file included from ../include/linux/cache.h:6,
>                  from ../include/linux/printk.h:9,
>                  from ../include/linux/kernel.h:19,
>                  from ../include/linux/list.h:9,
>                  from ../include/linux/module.h:12,
>                  from ../drivers/net/ethernet/hisilicon/hip04_eth.c:7:
> ../arch/arc/include/asm/cache.h:17: note: this is the location of the previous definition
>    17 | #define CACHE_LINE_MASK  (~(L1_CACHE_BYTES - 1))
> 
> [...]

Here is the summary with links:
  - net: hisilicon: rename CACHE_LINE_MASK to avoid redefinition
    https://git.kernel.org/netdev/net/c/b16f3299ae1a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


