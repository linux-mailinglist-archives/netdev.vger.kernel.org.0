Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA01B48F8DE
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 19:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiAOSuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 13:50:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49350 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiAOSuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 13:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B2F60F2A
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 18:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A3A0C36AEC;
        Sat, 15 Jan 2022 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642272609;
        bh=010A2KH5XJa4meaBB515YIOwNs7j4BFaVeDFzvxLaKo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PEssROH9o6tK4GXIFNKM1b1fn2Hz10ii7ZE9aXuBttvHDV54+X0ndAue5/LlNIUEE
         jFGyW9Pl0C5xOkF9zoM9do9kadH8b2GvDzE0HcFGo+Md9EaJZCJiTnEeL2B4puWm7h
         doibtd/MYrqIOhD6xwtIvhhEPMwUG8MIsbxjsNnyHg+krpCYx6RPQySQRFjHsUYjuJ
         D14E6YQfEUVEStyOWzhhhDCP2CXeaZ6q155u2UfgiIxgh7Hu/93MOdNjdj9WGNpFGQ
         2Q0cNuN9wnpGM8loesquvBOu2p9/icfGnUtKCh5G74gF+WYWrV9WTL4pzK2mwK4GkR
         oUbDuJ3jYUmZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3BCEF6079A;
        Sat, 15 Jan 2022 18:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lib: fix ax25.h include for musl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164227260899.24963.5075396204137502925.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Jan 2022 18:50:08 +0000
References: <20220113081413.3522102-1-sam@gentoo.org>
In-Reply-To: <20220113081413.3522102-1-sam@gentoo.org>
To:     Sam James <sam@gentoo.org>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 13 Jan 2022 08:14:13 +0000 you wrote:
> ax25.h isn't guaranteed to be avilable in netax25/*;
> it's dependent on our choice of libc (it's not available
> on musl at least) [0].
> 
> Let's use the version from linux-headers.
> 
> [0] https://sourceware.org/glibc/wiki/Synchronizing_Headers
> Bug: https://bugs.gentoo.org/831102
> 
> [...]

Here is the summary with links:
  - lib: fix ax25.h include for musl
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=8bced38a941a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


