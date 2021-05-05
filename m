Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8916B3748F8
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 22:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhEEUBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 16:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230437AbhEEUBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 16:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DDF18610A7;
        Wed,  5 May 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620244809;
        bh=pRllSkb6uSl77UvIi38OoXYnTNu0vihf10ORAfWEcXE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eGrS1yICrE+Dyixbaq7djYDRGfqCS4VE33NWNgwmayPcfmZvEm/YwIl2/oV047LU9
         Gur2e7VxtZTWTQ+zCSq0dnldvdaVjZNPg+G8+QRdyy4fNQCiy17Xx8iPrEijdUj4FK
         tkj8qYlbkQcmRD2nvi+1Ww6H1pTBCSDLua9KGB2iEiTyzNSLTIYgXlJF//sDkSzobA
         /+36nGaiTGi0qg6YeCMx7/qqm+8mWHvDmalAfcrV+FYze9NzTPgvM5FVoJ2T1iGXba
         NakDm7qPIPKGCPhUpCm8s0e4HqVtpZru6CmL8iwZS3VPBqQgQKDAJm//HlMOpgBHWU
         lC9q1c06LftWw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC86D60952;
        Wed,  5 May 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v2] smc: disallow TCP_ULP in smc_setsockopt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162024480983.22987.1651655428886909235.git-patchwork-notify@kernel.org>
Date:   Wed, 05 May 2021 20:00:09 +0000
References: <20210505194048.8377-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210505194048.8377-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        cong.wang@bytedance.com,
        syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com,
        john.fastabend@gmail.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  5 May 2021 12:40:48 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> syzbot is able to setup kTLS on an SMC socket which coincidentally
> uses sk_user_data too. Later, kTLS treats it as psock so triggers a
> refcnt warning. The root cause is that smc_setsockopt() simply calls
> TCP setsockopt() which includes TCP_ULP. I do not think it makes
> sense to setup kTLS on top of SMC sockets, so we should just disallow
> this setup.
> 
> [...]

Here is the summary with links:
  - [net,v2] smc: disallow TCP_ULP in smc_setsockopt()
    https://git.kernel.org/netdev/net/c/8621436671f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


