Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869A435D1DE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbhDLUU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237498AbhDLUU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E48AD61358;
        Mon, 12 Apr 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618258809;
        bh=2gGAtFIQ0MAgGy4DzQXHbX0k2e1cSitVuMJ/HPaJCe4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Awh9FP9uoMpAAlm27B2np+20+ZUfucofkBo/XeDmaEIc9Q7zBYSPglDd4Dw/dQXVo
         FgQKfpwI4eI4u6ApaSQk1+MFmzfrX9swDO2V/S2BzTgvAcMYTK+BpGBVIQg+EN1wQW
         OlvAhDvUkKfpPYFxw7azk6cYK0oQUXvRc8TEWUGekbanLyewMp3SbiI93iPbNbqKUf
         b/1iOK3YfdYUyevDgQ8HaUEU6o7ii/v4l+fyqCrYGxY71MhFEfKbt7NkqE8/cJl92U
         zzHsF7MJayOv3YTKV7rblcx0wHxiDmy+vhi2gZB4vykfDPnuQI+HETM8TSY35HUFGw
         5bhR2AaxgAlcg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7C5560CD0;
        Mon, 12 Apr 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: thunderx: Fix unintentional sign extension issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161825880887.1346.11596655945494608028.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 20:20:08 +0000
References: <20210409130726.665490-1-colin.king@canonical.com>
In-Reply-To: <20210409130726.665490-1-colin.king@canonical.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        ganapatrao.kulkarni@caviumnetworks.com, david.daney@cavium.com,
        svangala@cavium.com, tsrinivasulu@caviumnetworks.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  9 Apr 2021 14:07:26 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The shifting of the u8 integers rq->caching by 26 bits to
> the left will be promoted to a 32 bit signed int and then
> sign-extended to a u64. In the event that rq->caching is
> greater than 0x1f then all then all the upper 32 bits of
> the u64 end up as also being set because of the int
> sign-extension. Fix this by casting the u8 values to a
> u64 before the 26 bit left shift.
> 
> [...]

Here is the summary with links:
  - net: thunderx: Fix unintentional sign extension issue
    https://git.kernel.org/netdev/net-next/c/e701a2584036

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


