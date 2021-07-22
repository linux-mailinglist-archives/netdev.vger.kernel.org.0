Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D4E3D1F4F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhGVHJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230284AbhGVHJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 666606127C;
        Thu, 22 Jul 2021 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626940204;
        bh=0/egDGqNuzQsdhO08uw4QmW8g3RYmw+ZbylkYSw9GqU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XwvcAUbTOmnQE/ANudnIXnbYKv6vCbgMxnsPKt3TrxvXB44zKQoaA2o1lxvwNfxsr
         kcnUhLe7NZpeWRs03qF8KdmRCEUpVwnZ2/2BAOTPhA2O2dpJwSTysZcKiJMRjBOxjg
         ykVEUCZfpbMbpg9ECk3vuAoVrMySSy0NVz1Qk5mth1NNi+ct+BsQbdg+EGJTkbzvIv
         bHkmH9CX9ore04WnhQC6cPJ/jJ1PrPAKjdtRoa04TSXZFEbdH4hI6PtZ6zQNXuwzmy
         Ak51nxRUOmTfuVilOLlWaAw+uLBQ3SkgeSMAzBX0Z35oIslDGAaLbvoid4C/jcQ/8Y
         lsEAIzrTHsG2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5D60360ACA;
        Thu, 22 Jul 2021 07:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: cls_api: Fix the the wrong parameter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162694020437.16794.8175863096822387459.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 07:50:04 +0000
References: <20210722032343.7178-1-yajun.deng@linux.dev>
In-Reply-To: <20210722032343.7178-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     jhs@mojatatu.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Jul 2021 11:23:43 +0800 you wrote:
> The 4th parameter in tc_chain_notify() should be flags rather than seq.
> Let's change it back correctly.
> 
> Fixes: 32a4f5ecd738 ("net: sched: introduce chain object to uapi")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/sched/cls_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: sched: cls_api: Fix the the wrong parameter
    https://git.kernel.org/netdev/net/c/9d85a6f44bd5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


