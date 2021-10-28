Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77ADF43D913
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhJ1CCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhJ1CCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 22:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE989610F8;
        Thu, 28 Oct 2021 02:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635386408;
        bh=WzmX1fORfNIrUomeylO88sqhcuWjm6RhxlvJ6xR1q0E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jw4kqWjH0FS2JO15bgGhatHfVZij4YmBddQU+Vx73WJruegKL03RbSu43ZEnd/aWk
         +Kz6qzIxDS0IdJG6VoN4SXvRPXIptMF2mKeTUFMRIgrZCmxB9+8kblq4BSC8A8mo/K
         /67EpPIpC16FbbaQS6E7e66+jrn4qQ4PEw/9AG0xs8GdYmfzw96ydXgJ5QK7lXYSMu
         wOuMSRcHYQlDfWrmhMcy0UgPol9A1RVvd6kQFBtYoI39NvOJqPBTuxMvA0vjS2E48m
         MQp2KFgoi+TIQUUepD69FpNPo0Pp57prvkszgPCmKZoJDGG5+ajf/XU48PST0gbRwS
         5nmFVV52QbJ3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E24F8609B4;
        Thu, 28 Oct 2021 02:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] xdp: Remove redundant warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163538640792.25351.9681213096543722152.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 02:00:07 +0000
References: <20211027013856.1866-1-yajun.deng@linux.dev>
In-Reply-To: <20211027013856.1866-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Oct 2021 09:38:56 +0800 you wrote:
> There is a warning in xdp_rxq_info_unreg_mem_model() when reg_state isn't
> equal to REG_STATE_REGISTERED, so the warning in xdp_rxq_info_unreg() is
> redundant.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/xdp.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] xdp: Remove redundant warning
    https://git.kernel.org/netdev/net-next/c/b859a360d88d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


