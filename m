Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025792F42DD
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbhAMEKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbhAMEKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5FEEB2312F;
        Wed, 13 Jan 2021 04:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610511009;
        bh=v7phT4X59Bu6AoYtWPBcARr+sE8JGlZCTndTtUs8B50=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i8waka54362mW5OgFa/jipI1oWYaDpQWpmBqoWnmpPHhmbtqyVsfdVcH8EUluIYLO
         wJSji3tCp+laiKgndr9Wy65zKudMRrkdCl6Cqtez2xHyZjxCUjFN7zO5FPE9ZNSdPx
         30aJToU1ynR344oExz7D+8riH15hiLk0lB4XN58a/hAh1E/YF7UPSTafRJRQECZoUl
         ocMH3S3EarmoS3kA18Kj1boLunzVy9hVY1QoJSw8guXHnJHoJmlXStPdhJ4ewIEfLN
         NmuthpUeLT4R9Fre2XxoRJMnr37kh1I8xZLP0Su/wlmfb+SgDTa8y9N7iyRQmvdzUJ
         ckrLNzsNuzhvw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 5390F604FD;
        Wed, 13 Jan 2021 04:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bnxt_en: Bug fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051100933.28597.18293528730543737329.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:10:09 +0000
References: <1610357200-30755-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1610357200-30755-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 11 Jan 2021 04:26:38 -0500 you wrote:
> This series has 2 fixes.  The first one fixes a resource accounting error
> with the RDMA driver loaded and the second one fixes the firmware
> flashing sequence after defragmentation.
> 
> Please queue the 1st one for -stable.  Thanks.
> 
> Michael Chan (1):
>   bnxt_en: Improve stats context resource accounting with RDMA driver
>     loaded.
> 
> [...]

Here is the summary with links:
  - [net,1/2] bnxt_en: Improve stats context resource accounting with RDMA driver loaded.
    https://git.kernel.org/netdev/net/c/869c4d5eb1e6
  - [net,2/2] bnxt_en: Clear DEFRAG flag in firmware message when retry flashing.
    https://git.kernel.org/netdev/net/c/687487751814

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


