Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C23B44D613
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhKKLxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230358AbhKKLw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 06:52:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EB58D61078;
        Thu, 11 Nov 2021 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636631407;
        bh=96vEwOVaB1i9byrzviv2CjaAtmOlMkuNN1/XhA/uhH0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=owrzPA6MI1VTIR+dise/CYW8hjMBBP03oCWQO7ZS+SiOQeqZCeFb4hrzpJiML0hIk
         N9pzZY1duSPf+Dcy7St7Gmw1nu6DF5BNzclOpQa71CJPftHFmjlVsLXJLFjpzEfOWp
         lM0UjNtmiMt3xwC5nT+hj8ca675c6AQJRr5z03SYhvZ6nryr3jnTQX88kAg0+zTaWD
         FpIa6QEeJRecttI6uQbJxnklKUWrruGk3K3P/sbuzgQL3SX83UZc4iW74NbGLfXVlJ
         YXfZeUaBSjvsZMSRQUgAK/qVzquUsfWpaOkA4+1FK4npiNAhWNvwF6oGBEq/lsbWf0
         iXmQDINM8puOQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF95660A88;
        Thu, 11 Nov 2021 11:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: iosm: fix compilation warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163663140691.22701.10885269387258432309.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Nov 2021 11:50:06 +0000
References: <20211110162036.256158-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211110162036.256158-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 Nov 2021 21:50:36 +0530 you wrote:
> curr_phase is unused. Removed the dead code.
> 
> Fixes: 8d9be0634181 ("net: wwan: iosm: transport layer support for fw flashing/cd")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - net: wwan: iosm: fix compilation warning
    https://git.kernel.org/netdev/net/c/29cd38675041

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


