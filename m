Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31072488AC1
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 18:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbiAIRAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 12:00:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38602 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236070AbiAIRAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 12:00:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67BFFB80D5B;
        Sun,  9 Jan 2022 17:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1583AC36AF3;
        Sun,  9 Jan 2022 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641747614;
        bh=nvapR5clnJGT1K4ZAdKqbHki+C7Hqwj5h5H9SlYwaIU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FIWYwQBbqzCJY+ePFVlJmNwwdZK61eHDx1aeVXk+KatQt8s0PdMHBBGPvryK60Osf
         3VT7QbWJXINtaCg/O50BhtV+DiUwe1K9lx6aki23PkXp/ZA69aJfWLBELvD136xer3
         BKJm34+FqOX6mZyzNDxccxYi8urk7RhIXQyqsk0rV2C76esW+dbVdt1tarZK1/o3tw
         iYTuUfCsPLBChmb9z9k8v9ksB6sWrVIUSQ8rUpNjcSjOIYpc8+AAe50BBUgbCDA2gV
         r+dO/7vry42QowSSoGVz2HGa0LEKkeqIoGvdPkgaXG83zdrS3lS47CYap/nQ2T0Ypq
         6Du3tCG0bzDeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4E48F7940F;
        Sun,  9 Jan 2022 17:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] can: janz-ican3: initialize dlc variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164174761393.1736.14218744531602060041.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Jan 2022 17:00:13 +0000
References: <20220108143319.3986923-1-trix@redhat.com>
In-Reply-To: <20220108143319.3986923-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        mailhol.vincent@wanadoo.fr, stefan.maetje@esd.eu,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sat,  8 Jan 2022 06:33:19 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this problem
> janz-ican3.c:1311:2: warning: Undefined or garbage value returned to caller
>         return dlc;
>         ^~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - can: janz-ican3: initialize dlc variable
    https://git.kernel.org/netdev/net-next/c/c57979256283

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


