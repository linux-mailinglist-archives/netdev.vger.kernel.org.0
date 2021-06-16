Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4353AA4F6
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 22:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhFPUMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhFPUMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 16:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7D2DD613B9;
        Wed, 16 Jun 2021 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623874203;
        bh=ZMaIBBUk6M+gm4RQYGwmZ23VrtkipS82VYP3V7YOoXA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gBmUkMA65KVdkxKS90bTEwJFq6oprmIftFXeaeLSzRMUplL0f738tWTCh9nHqeLa6
         pSocMqjDH2a3D+6eK6n25ZqYAsemgNaup1hO95F0o7yD8AsPLs1nG6klLXNl1Bs/G4
         EJP4Vun0ts2qMktEHWjlq9MstoWAFG1ECvwQBS06iP0yAcS288OHyMmDCfTJV4DNVU
         IM6naLRA+pt27pUcHvWI+A3+0TTfmzGREKOQa5mefHnML/xm4QhYhZ061yByFlZpbJ
         UY7ZV9ScJZnKFBilEYS6Nr/6ZEOkNFujiIFuP0+2EJoAJfNcLNmgGQr8i0KQr6GXZj
         F/ZcZXAPEgt+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 70220609E7;
        Wed, 16 Jun 2021 20:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] r8169: Avoid memcpy() over-reading of ETH_SS_STATS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387420345.22643.12233311377174591672.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 20:10:03 +0000
References: <20210616195359.1231984-1-keescook@chromium.org>
In-Reply-To: <20210616195359.1231984-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        nic_swsd@realtek.com, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 12:53:59 -0700 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields.
> 
> The memcpy() is copying the entire structure, not just the first array.
> Adjust the source argument so the compiler can do appropriate bounds
> checking.
> 
> [...]

Here is the summary with links:
  - r8169: Avoid memcpy() over-reading of ETH_SS_STATS
    https://git.kernel.org/netdev/net/c/da5ac772cfe2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


