Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EED635FC5A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbhDNUKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233954AbhDNUKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A4C5161179;
        Wed, 14 Apr 2021 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618431009;
        bh=PxgfHu0LLEkHFNdLMWUR2cY0Bm/dX0esZoHrXsyk1Ms=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E9AXSGe9JbCMaAkDadlyA+UIPpx8u1r0H33xVC7IPQCWWqdXnzdItN4kMXNNCzCWo
         BEQxhtnlG6d8HotwN6jb6rPFdaRi3nOJOk2KTfQgAQzjHd4Piu5MCtGw+QMa08XPdn
         /RcXU6K2Wd0Da1Fc9Idv1Qa+3oJondk3pDJYtOGeDc8kt2ZL9T1lAMk9q6jeWdazqA
         HV0ykvK69uS4/MwtP6/Jdr/VRyTpoZco5br/P3E9v1rlDK7y6M5qohKFfesobCVxvp
         6XiDDBGUB4AFgCDUVXPhHeg4lE2aLTABa9EVHap5CUQm8celjwqD2tKHUHxsxzj71s
         QoTJXmV5qzzRQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 98C4660CD4;
        Wed, 14 Apr 2021 20:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: pause: make sure we init driver stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843100962.9720.18065768938392039888.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:10:09 +0000
References: <20210414034614.1971597-1-kuba@kernel.org>
In-Reply-To: <20210414034614.1971597-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, saeedm@nvidia.com, netdev@vger.kernel.org,
        mkubecek@suse.cz, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Apr 2021 20:46:14 -0700 you wrote:
> The intention was for pause statistics to not be reported
> when driver does not have the relevant callback (only
> report an empty netlink nest). What happens currently
> we report all 0s instead. Make sure statistics are
> initialized to "not set" (which is -1) so the dumping
> code skips them.
> 
> [...]

Here is the summary with links:
  - [net] ethtool: pause: make sure we init driver stats
    https://git.kernel.org/netdev/net/c/16756d3e77ad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


