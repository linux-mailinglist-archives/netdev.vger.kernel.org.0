Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B7E34DCD3
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 02:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhC3AKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 20:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhC3AKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 20:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3CC886192E;
        Tue, 30 Mar 2021 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617063009;
        bh=V+N9WKZF2XDUdlyKn4VLSN2JXQQkC8CXLE8XX8Q7M5o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=quT0yzNhMm220tt+31AoGyoO8XuEjzCzf/9dmKilM1ZzivOQRwjQIx5VNi49JkqCn
         yoHbLnNrSpG46uh3JVhgbs9lap5suawi8eEaYU09UkyQOWL/mERvmmhT7ox4jSMjCD
         VFmzZ2fHzEmxDQMb8bNE6ZYg3W5pJT28mY6kxfshoGaQZJDU2ERHVRk8HkMVlvTVoC
         W0HRtSruEkg8l4sXPgKYeGzFnowARKen+D5w8Pmw/ZXr6W9scvprkNs6inhjuCgnni
         4JlpTddT3eBidz10pO7tGg4fyLRkiSfFoIaFMSNJdGYBwiErGFaiZ4UBQ6NbH7FfI3
         XTLJ+XBzBzJBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2DDCF60A56;
        Tue, 30 Mar 2021 00:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] hv_netvsc: Add error handling while switching data
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706300918.1906.12567959956656138196.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 00:10:09 +0000
References: <1617060095-31582-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1617060095-31582-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kys@microsoft.com, sthemmin@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 16:21:35 -0700 you wrote:
> Add error handling in case of failure to send switching data path message
> to the host.
> 
> Reported-by: Shachar Raindel <shacharr@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> 
> [...]

Here is the summary with links:
  - [net-next] hv_netvsc: Add error handling while switching data path
    https://git.kernel.org/netdev/net-next/c/d0922bf79817

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


