Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFA03425DC
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhCSTKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230452AbhCSTKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7406561988;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616181009;
        bh=/u5VzDqnI4bOY2gpruhdpFx6vU9k2DPhjnThbBKVxqk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UlXEP5jHPaBhA9dZxL2/dVInydUant9X7CPkTLOW0g6ZlaiJpSf/Q0OxCQ77wSk+f
         56xXZPnwzXv7BvtMa5Wz4RFKtDLI/bHUGo3sXAer77FJo5pZL7ZnEldVuyESTTOM57
         SAR2uOqSxz3AvRNRIBCONOdCKNyPzXFBCbjwEWXNRhMik8ajECcR8wyMnljKh0M6Pb
         UqUT6b6OAlxltXAxRIbC52QG4iBAvX5wumvZiEX0O9hFJv+qmAjg/DY7XwzdI1iSqR
         4vwZNL1kDtTecoN4hUFxP64SWEydG8XD+T2ctXMvCw38bHJ0BPTiKmlepkSyNFpx89
         6jqWewZKchf1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6DF3A626EB;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] atl1c: switch to napi_gro_receive
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618100944.534.2696248064241169145.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 19:10:09 +0000
References: <20210319035922.343-1-liew.s.piaw@gmail.com>
In-Reply-To: <20210319035922.343-1-liew.s.piaw@gmail.com>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 11:59:22 +0800 you wrote:
> Changing to napi_gro_receive() improves efficiency significantly. Tested
> on Intel Core2-based motherboards and iperf3.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] atl1c: switch to napi_gro_receive
    https://git.kernel.org/netdev/net-next/c/e75a2e02ec99

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


