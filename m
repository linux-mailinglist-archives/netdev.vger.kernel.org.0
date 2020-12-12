Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75BD2D8A2B
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 22:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407995AbgLLVkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 16:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407977AbgLLVkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 16:40:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607809207;
        bh=wiu4KNtE6kdrESsSUAOhlfO54tHSZXZBrPOWKBJo52E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fp6wzN7igMUwdCuwKm5L9aczY90FYSSFxKkzIda7jyvS9IwwDyt2GMJebpUjXwW6K
         O+iGKGAR3t62thn2Wvg/bDj7/uJ9r1u3Fwdd+2NJEU5mapFISJl3JXy6duqW6pJa/0
         OPoFhq8+LApnVTWTI/zE7Bn+YcX/EtqSdWdFAgIee0BT4TjPtpBWC3RUklEoe9mDyt
         Rzen8XsPm8Zb0JKPkhZAWAgCxaiTZwUWqwJ4khJ6mufV7fvYkRU9BTjL25g5qAHFmw
         SJkEarlAMVeTJrDQS0uz+6phk6+RdqlciPMUpeNAZONkBDNKh13iyLtpLxEhPaZZcP
         6r2ig5PdUNFjg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net-next): ipsec-next 2020-12-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160780920689.16761.7342728071813784361.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Dec 2020 21:40:06 +0000
References: <20201212085737.2101294-1-steffen.klassert@secunet.com>
In-Reply-To: <20201212085737.2101294-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Sat, 12 Dec 2020 09:57:36 +0100 you wrote:
> Just one patch this time:
> 
> 1) Redact the SA keys with kernel lockdown confidentiality.
>    If enabled, no secret keys are sent to uuserspace.
>    From Antony Antony.
> 
> Please pull or let me know if there are problems.
> 
> [...]

Here is the summary with links:
  - pull request (net-next): ipsec-next 2020-12-12
    https://git.kernel.org/netdev/net-next/c/e2437ac2f59d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


