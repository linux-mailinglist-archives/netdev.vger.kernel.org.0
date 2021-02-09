Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B90331571D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhBITqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233454AbhBITkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:40:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B78B64EAC;
        Tue,  9 Feb 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612899608;
        bh=+BiWEz0/MRm1nNM6jNrws/upLmRN1VWfx/V/e9kR1Zk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BF+khOGwrBp+KtyBDCvF8oqWFFCI97ff/7X2QYPPeCOGnI7yB7u9aaSk74efcfjsI
         uKsD+R3l7F4BiylyIX1hZcXWTBI7ecOVLvrHbaaLQzU3kfxK20xoOdDyDmsu3J2kCA
         lVmNlS0QwcAslCJrYAR5m6MHFB9WyklDcXT0Dx9LAFCZTZ6INwTJ2kwifb+Y71H16X
         U38ZFMia10z7yHv1FCvDHHrZnbm+E5Pq9ceLS5nWkKLiMiycCfunvZvkhvZi82OfnY
         /CDQpuIWAvHcPfXIqk0Qk7pOvs7AyOguhykM6/988qrwcJCgd0rCAE6fPUBlnNfz3J
         pOtTZGQdEVnrw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69CD2609E8;
        Tue,  9 Feb 2021 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net-next): ipsec-next 2021-02-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161289960842.17865.3224028441931456422.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 19:40:08 +0000
References: <20210209094305.3529418-1-steffen.klassert@secunet.com>
In-Reply-To: <20210209094305.3529418-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 9 Feb 2021 10:43:01 +0100 you wrote:
> 1) Support TSO on xfrm interfaces.
>    From Eyal Birger.
> 
> 2) Variable calculation simplifications in esp4/esp6.
>    From Jiapeng Chong / Jiapeng Zhong.
> 
> 3) Fix a return code in xfrm_do_migrate.
>    From Zheng Yongjun.
> 
> [...]

Here is the summary with links:
  - pull request (net-next): ipsec-next 2021-02-09
    https://git.kernel.org/netdev/net-next/c/fc1a8db3d560

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


