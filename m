Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92D3F5B46
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhHXJuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235658AbhHXJuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 05:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 307B9613A7;
        Tue, 24 Aug 2021 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629798606;
        bh=0bfRbjA0kaGCmLNmPTBDd6HW1cvahIwbZ8DnUEMuYyQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kMCRSHSOEOR1I+80LSWurqCnL4jiNk7KyEWjInfWcizdBYgpz4YuKhNxP+SsB7gI7
         vmZUvLSs2H4mVCDOATqzSYFLidGJyJcqHTNxZwfLCpdtJrPzvoAW3QBYUXI7r9no5J
         gjbhW1YnftllpeGTVTTSkHSjJrPNsnamfV/inbDWBusUq3SngPaLcFvaVkrMcqIWBg
         otYrWOIupsOJjngJkYTm/iTA+zJy2HhuHYFob9tl20ZBR5X9ZMOzqfrUDNwG076Ivj
         T1kD+g+7P0py7Smc3JK4KQ7BvsKyHgxOD/sVP8eVY0jeBIyddzmhz/CVAA5Z9jJDJn
         CywBaTb6nV86A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2699B60978;
        Tue, 24 Aug 2021 09:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Update mv88e6393x serdes errata
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162979860615.15454.78279080536175684.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 09:50:06 +0000
References: <20210824064413.95675-1-nathan@nathanrossi.com>
In-Reply-To: <20210824064413.95675-1-nathan@nathanrossi.com>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, nathan.rossi@digi.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 24 Aug 2021 06:44:13 +0000 you wrote:
> From: Nathan Rossi <nathan.rossi@digi.com>
> 
> In early erratas this issue only covered port 0 when changing from
> [x]MII (rev A 3.6). In subsequent errata versions this errata changed to
> cover the additional "Hardware reset in CPU managed mode" condition, and
> removed the note specifying that it only applied to port 0.
> 
> [...]

Here is the summary with links:
  - net: dsa: mv88e6xxx: Update mv88e6393x serdes errata
    https://git.kernel.org/netdev/net/c/3b0720ba00a7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


