Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DBD3B7826
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhF2TCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhF2TCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 15:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2614D61DE3;
        Tue, 29 Jun 2021 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624993204;
        bh=Ig9EFN8Y5mzUuNIRgJEWKf+vtvUBLUyvz7C7ahDD+oo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BoFwq8haeTQ1Jc57HlRBjVG5LJ4vjTJjcDl4yIiaIGDwMSvGLXSFjewEPlJQ2mRn1
         HKz3Da1Du4MICVWq9ABHcfXt2Mba0JRI7pDGPRMZ7wIEm86cSO1DDQPL+XpxvWKeRZ
         zV9WL4tAdgarffxBIFaAqBAyvocOZYoYXIpEB23opMVrwjwQUDxFwz9wghJhJjT6KL
         1X9TY2QfDkWi0FBiCYE0G8/7ygzMq/8CDYfq+WHiPrbx7piB0T+PEnDfWBD3GYlnHK
         vLgCqCKI6233LI6DFxAD3BqLjE79kVy+j5phH692zlzezp+DcfLT+JIkYW1+AzJ46l
         n+b7WDqSc4zMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 17D7C609B9;
        Tue, 29 Jun 2021 19:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: change ICSK_CA_PRIV_SIZE definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162499320409.1879.1906072548580514952.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Jun 2021 19:00:04 +0000
References: <20210629135314.1070666-1-eric.dumazet@gmail.com>
In-Reply-To: <20210629135314.1070666-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 29 Jun 2021 06:53:14 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Instead of a magic number (13 currently) and having
> to change it every other year, use sizeof_field() macro.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: change ICSK_CA_PRIV_SIZE definition
    https://git.kernel.org/netdev/net-next/c/3f8ad50a9e43

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


