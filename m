Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853E040F8DD
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240123AbhIQNLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239437AbhIQNL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A95C461244;
        Fri, 17 Sep 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631884207;
        bh=22a6frHwC5B5eVeWZSTWqj0kiBOFvgiEgv0duN1p1NQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EpuGKL2o5cZKI5SN7weHGi1nhWGA+br5/vGm6NEqQkKCVm0f/ou5jNM5p63PGp4qX
         n3mkrkU5AcOhimNWpti12Pal6FmIwT9njNpU0VZZj8nqRmIZlJdHIiUrDKv4D4tkgc
         6zd6/2TCc4kyQ2EXb8bzuXfpvo/jlfLXtzcQ9ytIhBD7ENLQMLK0xx4FLBSakLt2vl
         HZJEjetzD013oip1EvB+5C64QGJot+YsgWhL+FfUe8+1+cJ4xIDYGKSOMRGXQPhEJ5
         yUPuJdw4XHC2cKY6T1Cw9HhQl3EW0xxgEBxVoESxDa7FUsCeh+FGyJNtiQ90LBj8FC
         7UEV9tZslIVdQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92000609AD;
        Fri, 17 Sep 2021 13:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeontx2-af: Fix uninitialized variable val
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163188420759.25822.16149249786336509355.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 13:10:07 +0000
References: <20210917115747.47695-1-colin.king@canonical.com>
In-Reply-To: <20210917115747.47695-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, schalla@marvell.com,
        vvelumuri@marvell.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 12:57:47 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the case where the condition !is_rvu_otx2(rvu) is false variable
> val is not initialized and can contain a garbage value. Fix this by
> initializing val to zero and bit-wise or'ing in BIT_ULL(51) to val
> for the true condition case of !is_rvu_otx2(rvu).
> 
> [...]

Here is the summary with links:
  - [next] octeontx2-af: Fix uninitialized variable val
    https://git.kernel.org/netdev/net-next/c/d853f1d3c900

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


