Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E47A3A4A9E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 23:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhFKVcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 17:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhFKVcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 17:32:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1BABC613CD;
        Fri, 11 Jun 2021 21:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623447004;
        bh=QdqrnRRpWW762NamgXssaENTmH/VVQSRBuXGuetvyxw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ma2qIj03qU2dwhJrpls87gurshXcqndx1TL3oIMDER2yVdbNHfrRyfZ1+Mq3Now6t
         U58epHQl4o25erLkULNr2PUcgXJX6Ldhy0ebwEWHgwJKwoSUS4+XjrFQpnDHOof3Tw
         C3E5wUfgPywqNwbWJ8H98ElxOjRKOu30FCSrINNxF9ecHc49D6oSSAdhVo6OM5AYF0
         lWCrBaFeTg4VaMFI1wc2kdp5VKRvTJ4Vbcc1RC2NQPUzvuB8HUBf7RAtL+feH7CoaM
         4mVMeEXkld6wJr4ldEnvDIXwCVWOeToxRBmAu3s3z1mAG/VBY45cOBx3AaIx03mDzG
         J1yTOV89XRsAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D95460BFB;
        Fri, 11 Jun 2021 21:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: ipa: introduce ipa_syfs.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344700405.12221.14790386522123195495.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 21:30:04 +0000
References: <20210611203940.3171057-1-elder@linaro.org>
In-Reply-To: <20210611203940.3171057-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        aleksander@aleksander.es, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 15:39:37 -0500 you wrote:
> This series (its last patch, actually) creates a new source file,
> "ipa_syfs.c", to contain functions and data that expose to user
> space information known by the IPA driver via device attributes.
> 
> The directory containing these files on supported systems is:
>     /sys/devices/platform/soc@0/1e40000.ipa
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: ipa: make endpoint data validation unconditional
    https://git.kernel.org/netdev/net-next/c/9e8fb7bf9c80
  - [net-next,2/3] net: ipa: introduce ipa_version_valid()
    https://git.kernel.org/netdev/net-next/c/e22e8e2fae61
  - [net-next,3/3] net: ipa: introduce sysfs code
    https://git.kernel.org/netdev/net-next/c/2e3cf97f4741

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


