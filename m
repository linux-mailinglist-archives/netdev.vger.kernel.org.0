Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56F845E6B3
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 05:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358031AbhKZEFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 23:05:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358286AbhKZEDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 23:03:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E0C0A610F7;
        Fri, 26 Nov 2021 04:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637899209;
        bh=qC6g1Pe57cQcsG249ibONML9vzzHpNol9zjBgrEhat4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iCc1P+wAoJDUhSpX1/g1AODOq5lP3RLGJ5N6lcrQ9+T0oJoVKK0xgvNcWDarpI9Er
         8MCYlSwk7U3W9iuGpeQWwPxFqUrJj2V04jZZ/OUTkPT/Xnt02uADKugOc1dy1OB/Qh
         LQjLLTCq+2cjcNlZZzAmOWGWVo8k0yYuMVmmtjPomHnygHfI0SxToV/6VUzMU7VIVi
         JNA5QzBXJcd5uUhJfa2jTI94U7csq2CGScmXai2EXUj76XgxHwi+7WmFfKC4ua63bZ
         //txLw/tcEqOkRfZc+8aDP3bAUr4lnV9YsvggL+IU0OskLAdbXoI1bL9yIa+SK6Xj0
         9zLAG2XuxgqkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D028860A50;
        Fri, 26 Nov 2021 04:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] mctp serial minor fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789920984.20279.447644906278144793.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 04:00:09 +0000
References: <20211125060739.3023442-1-jk@codeconstruct.com.au>
In-Reply-To: <20211125060739.3023442-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        jirislaby@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Nov 2021 14:07:36 +0800 you wrote:
> We had a few minor fixes queued for a v4 of the original series, so
> they're sent here as separate changes.
> 
> Cheers,
> 
> 
> Jeremy
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] mctp: serial: cancel tx work on ldisc close
    https://git.kernel.org/netdev/net-next/c/7bd9890f3d74
  - [net-next,v2,2/3] mctp: serial: enforce fixed MTU
    https://git.kernel.org/netdev/net-next/c/d154cd078ac2
  - [net-next,v2,3/3] mctp: serial: remove unnecessary ldisc data check
    https://git.kernel.org/netdev/net-next/c/d1c99f365a1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


