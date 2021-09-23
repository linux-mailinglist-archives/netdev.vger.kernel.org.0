Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031C1415D0E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbhIWLvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240696AbhIWLvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 07:51:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9F9616115A;
        Thu, 23 Sep 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632397807;
        bh=Aja2XqP5Xd0oobqp6woEtyOn/9VfCvif+ZJ/TsVyYDo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WXOmPIoypQyhdpZ2zO9OF/EA91Nhri2IeHnAW4v1ohAX5KKhCXHEW5TrrTkDI8VTt
         ed8zhSTM3tH9qJjQzFN8zV4wt49pp7RHa2GFfSxl15Xd6oAZsz4JsSPWy96Y0MC+7R
         trPD9LNX9zUEFS+iuMZXGL36dyIgyy7FZKUHpYMDYoblZQDu2wagv15Eltv2AqdwRW
         mRJxwgxGPOVfHiEVq+BXprJaudGlSBenIi/70WVK3RcIrkYDgBPpJ1xnMSzxnfu8+R
         /q+Rz2XkxoMdJbQkbUNi6P8gkf75hK81+zjUDT5UF/vJ4KucemBw5YbJhwmopn7Ktt
         lc+4YT+KpcryA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9360C60A5B;
        Thu, 23 Sep 2021 11:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: remove sp->dp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239780759.29089.11848880880770483836.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 11:50:07 +0000
References: <20210922135703.2381376-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210922135703.2381376-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 22 Sep 2021 16:57:03 +0300 you wrote:
> It looks like this field was never used since its introduction in commit
> 227d07a07ef1 ("net: dsa: sja1105: Add support for traffic through
> standalone ports") remove it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 1 -
>  include/linux/dsa/sja1105.h            | 1 -
>  2 files changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] net: dsa: sja1105: remove sp->dp
    https://git.kernel.org/netdev/net-next/c/68a81bb2eebd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


