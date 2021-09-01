Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F963FE61A
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbhIAXbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 19:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231777AbhIAXbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 19:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D2D76108B;
        Wed,  1 Sep 2021 23:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630539005;
        bh=/nKDBlGgSg3odaXYMw+tA6joQb3aKEF4Zpg5KPoWemc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HMY33FANshCRVuEq+UABBNhIAn1xGoPRjC8aTd6XDY8Lk8997n6vzmZTTZDihSYSD
         jwZgSUfjrvcjcU4QnPVYPW9HRg3WJdsjqyahwAN6lrAr6fz7S4NEqezGnauX0/fnBV
         j12wnwbBs/PvLVwbcaPoG+7vIJzF2ttYGevVr1Z6IIvouatccUG1rUm9/C1A8AwOvj
         +4pCo1QHfD8Q93GNZzYMgIdoWZbqHSMFjmhdFxGyUAGY8LSfom8WSL3pQUet8gekKP
         42FnHmuonLKo9lqhaly+rvYoGQ0F1nAn8vmXTvj1dl/uFxk+0dNmTS3cdWtBlATB0S
         ku9rwrc/P1c6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 820DB609CF;
        Wed,  1 Sep 2021 23:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: fix kernel doc warnings in bnxt_hwrm.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163053900552.29321.15666000539403610570.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Sep 2021 23:30:05 +0000
References: <20210901185315.57137-1-edwin.peer@broadcom.com>
In-Reply-To: <20210901185315.57137-1-edwin.peer@broadcom.com>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        andrew.gospodarek@broadcom.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  1 Sep 2021 11:53:15 -0700 you wrote:
> Parameter names in the comments did not match the function arguments.
> 
> Fixes: 213808170840 ("bnxt_en: add support for HWRM request slices")
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: fix kernel doc warnings in bnxt_hwrm.c
    https://git.kernel.org/netdev/net/c/5240118f08a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


