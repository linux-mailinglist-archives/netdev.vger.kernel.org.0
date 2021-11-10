Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C2644BA97
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 04:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhKJDWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 22:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhKJDWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 22:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6344D611BF;
        Wed, 10 Nov 2021 03:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636514407;
        bh=EHiyNQImKUpv/Jm2c+pNEpLFgWjOUDsyP9FvphzfTXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ow3Yqr34dXMUG6AOlOOUwf9nOSbW88stl27TTi23yCMTdM/SRHnebFkM7TwSoUZsg
         F4AgMPf6OcoqItxj62qHC2qFBDhdwbCH5QpiQZsj811ld7NXzMU0bh289qbomZAPzl
         ueEvZHMY06AGX1QEcu60S/okWaMkzqiPjJptIo6+IvrtxquACAPZEwPn3fqRtmhX8/
         BR0M6e8LQ1trDw8W+9eC56+hac6Sc05EEPSwfcwj+ZRTtNjaxfrrVH98AP63Rs0dJy
         5/Bw+pMHZJ/D0quhtnJVw2PvkkjsRVqKpnfn75so+BlZWBZeUkXBm9VyJC+mgUafe4
         7zo9L/usVbleA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4E25A60AA3;
        Wed, 10 Nov 2021 03:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: sch_taprio: fix undefined behavior in
 ktime_mono_to_any
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163651440731.9008.16174434008121646100.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 03:20:07 +0000
References: <20211108180815.1822479-1-eric.dumazet@gmail.com>
In-Reply-To: <20211108180815.1822479-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, vinicius.gomes@intel.com,
        vedang.patel@intel.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  8 Nov 2021 10:08:15 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> 1) if q->tk_offset == TK_OFFS_MAX, then get_tcp_tstamp() calls
>    ktime_mono_to_any() with out-of-bound value.
> 
> 2) if q->tk_offset is changed in taprio_parse_clockid(),
>    taprio_get_time() might also call ktime_mono_to_any()
>    with out-of-bound value as sysbot found:
> 
> [...]

Here is the summary with links:
  - [net] net/sched: sch_taprio: fix undefined behavior in ktime_mono_to_any
    https://git.kernel.org/netdev/net/c/6dc25401cba4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


