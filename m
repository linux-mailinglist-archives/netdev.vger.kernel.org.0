Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2DC487ADA
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348402AbiAGRAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:00:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39244 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiAGRAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 12:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 655B3B82673
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 17:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D1C0C36AED;
        Fri,  7 Jan 2022 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641574810;
        bh=49ke3mL1ERcUHKffD8hQG4y0Uav8law+g+lF1w7G3t8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EYQkI2EdaTUGLvrG/OFrHpILyZZ96Ir3A9PUMAnJTPza6MO0Pb58pViVp9LpPRN+p
         LsbzTVtaWn8dWrqZqcM9W+Dv9Dw/NhTi+X066bMk4Vh2hvusudh4km1hGd9NJOXN+j
         4KddHhHRmSnUZbTxZC4yO+lz9OBQ7/dy3SZmWH3pFJ5ph63I7F1Ikjm7D6Qw7ADYyg
         xldnsvP06kg6xlrHtwSKVORyvHFMVcdsg6md4ml6MeEogmsdR4F+rG2AAxfCiLRG+R
         2xbkCAAHn/stC/sZDABdgopeYwvnwfV0oBOJZVVqt9rSEFf0LdhOjdbo6aBPrURalg
         G1FwlADasvw8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00888F7940C;
        Fri,  7 Jan 2022 17:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] sch_cake: revise Diffserv docs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164157480999.3991.15415148552079424277.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 17:00:09 +0000
References: <20220106215637.3132391-1-kevin@bracey.fi>
In-Reply-To: <20220106215637.3132391-1-kevin@bracey.fi>
To:     Kevin Bracey <kevin@bracey.fi>
Cc:     toke@toke.dk, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 6 Jan 2022 23:56:37 +0200 you wrote:
> Documentation incorrectly stated that CS1 is equivalent to LE for
> diffserv8. But when LE was added to the table, CS1 was pushed into tin
> 1, leaving only LE in tin 0.
> 
> Also "TOS1" no longer exists, as that is the same codepoint as LE.
> 
> Make other tweaks properly distinguishing codepoints from classes and
> putting current Diffserve codepoints ahead of legacy ones.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] sch_cake: revise Diffserv docs
    https://git.kernel.org/netdev/net-next/c/c25af830ab26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


