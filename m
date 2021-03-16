Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3286E33E241
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhCPXkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhCPXkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:40:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A69EB64F10;
        Tue, 16 Mar 2021 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938007;
        bh=m4tjLEBb7mA7jcO+CjgZrhAquGSXcrZlhy3kn6TGV88=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KJwl1JIs7/gF2ep7NNHzrk0ig01F5ZD/cNDOk4wWRVO0AxpeFDPI3k4zkRtP5HtZ3
         9x+rtQbR0kInJAAa/2yegIEk8HBGXqg+9hoyAsPvCMYy7wo/cqtobcCDKXB2jhWeTC
         nDX6S2YG7zWYJpv2uzIOVJLQN0Ec+mKVG0e9VQhKv5J1JapW5+xxpoRX95ecKumiXU
         nYEXoDhsLo6I3v5EBSCuiwLqhhKdo10xH5TeS2eIueqiA8zR/9+VzP0YZshosPwrVk
         tpjNVN6zlH8mv+HvAbiciwgmz8pFA5yLwIzAjttzjsw+GTyEU8OSzh9yKgJk2M6koy
         xCXE7SwGOS+Fg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9600060965;
        Tue, 16 Mar 2021 23:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] openvswitch: Warn over-mtu packets only if iface is
 UP.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593800760.2812.11445612675963290520.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 23:40:07 +0000
References: <20210316201427.1690660-1-fbl@sysclose.org>
In-Reply-To: <20210316201427.1690660-1-fbl@sysclose.org>
To:     Flavio Leitner <fbl@sysclose.org>
Cc:     netdev@vger.kernel.org, echaudro@redhat.com, pshelar@ovn.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 17:14:27 -0300 you wrote:
> It is not unusual to have the bridge port down. Sometimes
> it has the old MTU, which is fine since it's not being used.
> 
> However, the kernel spams the log with a warning message
> when a packet is going to be sent over such port. Fix that
> by warning only if the interface is UP.
> 
> [...]

Here is the summary with links:
  - [net-next] openvswitch: Warn over-mtu packets only if iface is UP.
    https://git.kernel.org/netdev/net-next/c/ebfbc46b35cb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


