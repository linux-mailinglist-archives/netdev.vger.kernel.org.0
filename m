Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C0533494D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhCJVAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231410AbhCJVAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0F5FA64FAF;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=f66m28cdO+lq24I5Vj/jvv1p9P/xXjtcLeWQGqde1G4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rbk4ZYFe7OU6gypZSquqn0zzWLvkBDWJFzMJeilPLw8tvqVjCPggI6unGkvBXjl4K
         qqbCAJeFWk+/gGocAmTl0IiZAQUo5ny+LWkMEpyqhAukPkijfvMPa4hd9t6EWDAw0K
         HVwOfsvjvntAxv/HGf/bEq7xG6aOXwwxu+n7YtRIPPnDHIlS11Yy71iz1SHZlQRP4E
         C9Od0UzkucJUyHImOC/LeZdzBvM+l0CxTXWM+rPmiOW+ITWJZ8Xs/r2cL2Qs3vRIzd
         RxJpr9sV3VjNQTedsSC+6Do4gGyNpT6zBYBKWA+HJsA6kUlCDoE4F8gySYkTeeXObP
         093ThvGh2jvjA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0444A609D1;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: broadcom: bcm4908_enet: read MAC from OF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001301.4631.16276463068574076155.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <20210310084813.16743-1-zajec5@gmail.com>
In-Reply-To: <20210310084813.16743-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 09:48:13 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> BCM4908 devices have MAC address accessible using NVMEM so it's needed
> to use OF helper for reading it.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> [...]

Here is the summary with links:
  - [net-next] net: broadcom: bcm4908_enet: read MAC from OF
    https://git.kernel.org/netdev/net-next/c/3559c1ea4336

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


