Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CBC322459
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 04:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhBWDAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 22:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230493AbhBWDAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 22:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1809F64E4A;
        Tue, 23 Feb 2021 03:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049207;
        bh=lE94WBGufQ3rWBfI9ZTwHbJxV8dzj872oxE5E6o9gPs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NKW1GJmLJ/gL+gliOJclEMyRH9sSU3U+/oMMo3lS1yWy9OPDsoxJ0VR5mK4qrCReG
         kkhX45DkE1yWFHGbwxJwT3M3dVMq9zbe/ZdKqgX0o+kIa3d4YDGZuWEqH28yDLLpLy
         6GOIpuImseFND7gphDhTefIuolEatwdrGwIcGrtpXJ97F/pm9U7FdisqPYXJfJmi/S
         hQ7UprYQxTble8c8BNfdUaCNlg/WQb9ZYRLJtOgfwcxoMw0KmhdstoLhlqhAG8iEEf
         af4bgu6RhYMGzY7swM2XKL1cJT9IPONl464G9o9m/ywt6vo8r5m0Mi+cdjJkmCmHvP
         T4luB05UbezSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D965609DB;
        Tue, 23 Feb 2021 03:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: Fix dependencies with HSR
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161404920705.2731.13470053147725557917.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 03:00:07 +0000
References: <20210220051222.15672-1-f.fainelli@gmail.com>
In-Reply-To: <20210220051222.15672-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, lkp@intel.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, george.mccollister@gmail.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Feb 2021 21:12:21 -0800 you wrote:
> The core DSA framework uses hsr_is_master() which would not resolve to a
> valid symbol if HSR is built-into the kernel and DSA is a module.
> 
> Fixes: 18596f504a3e ("net: dsa: add support for offloading HSR")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: Fix dependencies with HSR
    https://git.kernel.org/netdev/net/c/94ead4caa061

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


