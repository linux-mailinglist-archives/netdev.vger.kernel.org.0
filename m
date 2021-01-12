Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729152F2587
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbhALBat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbhALBat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 20:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 730AD22EBF;
        Tue, 12 Jan 2021 01:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610415008;
        bh=VXfvYV9b8JE6n3MITz8TzbmIp/mPIMgfgxVg1bRDpGY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GCx8u8HOtDUc783TgA3Fs/Xq5wRxnQpAO0T3F2EedVIfZVCwh5+WA5CrhUKHneKTj
         yFCA1t5PvQstrxijdoaH3Rq8q4B5lztg56021/tLBp+DsCMfkEbU7NpPyOhNrc43hT
         /LFkI11TaoyZXFf94qZWUOqGAGgQwSVV2LgCVdfMFHdUxJGTONeJT/hpVIV4wgqqv9
         Kq6CFvPU2FdOhw24XyHA5e10paihhWJX/F/GMkVF7SPxA/BGQhDOjFv2IBpwzYIz1z
         VSZiqDey3Xz2QVGMRWOwLBeSetixxkO27DSNtJrGZwCn10G4WK56fitIwxtGyS/aqZ
         76pCXUXlORErg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 637096025A;
        Tue, 12 Jan 2021 01:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Fix whitespace in uapi/linux/tcp.h.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161041500840.28019.13898057789131046264.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 01:30:08 +0000
References: <20210108222104.2079472-1-doak@google.com>
In-Reply-To: <20210108222104.2079472-1-doak@google.com>
To:     Danilo Martins <doak@google.com>
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  8 Jan 2021 22:21:04 +0000 you wrote:
> From: Danilo Carvalho <doak@google.com>
> 
> List of things fixed:
>   - Two of the socket options were idented with spaces instead of tabs.
>   - Trailing whitespace in some lines.
>   - Improper spacing around parenthesis caught by checkpatch.pl.
>   - Mix of space and tabs in tcp_word_hdr union.
> 
> [...]

Here is the summary with links:
  - Fix whitespace in uapi/linux/tcp.h.
    https://git.kernel.org/netdev/net-next/c/ad0bfc233ae2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


