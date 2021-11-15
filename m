Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EA14504D8
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhKONDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231508AbhKONDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:03:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8428661B97;
        Mon, 15 Nov 2021 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636981208;
        bh=BU9Hg+rVhcgBEZtCNFQRfrKQDndbf8SCThYxLL/P4Qs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z6CpsbIXPRxAGAD/Eo7qR6NdxAT1HQo4zhyrzof3z+RRG9Uxxc3Psk/JbQBg4VIpI
         2RNnqS6W1NLRoyCKFt/ovBomc2WAs+ArWiVH79tGLeDGerhqC86AnAxM1294wEts2b
         9mQKOt1xOeQ+HG/PbU15xm7NnTHVaZFONgaAyTN7i7/JJ9KEamY/FnwTsD8JTcv99b
         X3+rbaKgHZL1OQbQbOeQlcuZOPzznMF6rYwLwPUE0tFxGBMNxMFlnbhmiODR2aiISE
         QuVxLv+/GGsXTOaYqGWO4M4VX0fzAc7HMj1MmZUpemr5TQ4gtDQnIyWvHJYZNZoWRw
         8fIUnWQSOAthQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7238A60A4E;
        Mon, 15 Nov 2021 13:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tipc: use consistent GFP flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698120846.10163.14371622974741533436.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 13:00:08 +0000
References: <20211111205916.37899-2-tadeusz.struk@linaro.org>
In-Reply-To: <20211111205916.37899-2-tadeusz.struk@linaro.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 Nov 2021 12:59:16 -0800 you wrote:
> Some functions, like tipc_crypto_start use inconsisten GFP flags
> when allocating memory. The mentioned function use GFP_ATOMIC to
> to alloc a crypto instance, and then calls alloc_ordered_workqueue()
> which allocates memory with GFP_KERNEL. tipc_aead_init() function
> even uses GFP_KERNEL and GFP_ATOMIC interchangeably.
> No doc comment specifies what context a function is designed to
> work in, but the flags should at least be consistent within a function.
> 
> [...]

Here is the summary with links:
  - tipc: use consistent GFP flags
    https://git.kernel.org/netdev/net/c/86c3a3e964d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


