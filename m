Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C70D3BA4BD
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 22:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhGBUmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 16:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231179AbhGBUmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 16:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B4F2961410;
        Fri,  2 Jul 2021 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625258404;
        bh=lAkRQ5usyVEp6kumtIgnVP7z3vQLnIxPSNfHfHlE7yA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CdRdjE9a3W/T+LHcrwQOUtnY6jRdk5/CbubEuGSR4IT5Pi+ADTl/z3MZVJWnfiBEZ
         bEQPV4fjoO7Opg2bE0nAIp+feCufsILSW7Kuu2d5tCJMn9gxYmO9Vl9FFcLOrqMK6E
         jamrp0I6O2HLXuO7vVuNjUlvN6msjOOz2XPESntSKjXsbp1djWPJUnvVWaORTyu4Mo
         uGk5qlixMlQR4lH9aFJ8q1S8cPA22HRbUC+GSZOySPROfk3iA6QMJ5YHcRaIsOd4CM
         betLw6NfbZieNUqGt0CoriPf1pQkbajxDiCggX7mMmTabfT1p99a6B1iLFuQ+Snpw4
         GeHln756Qsp/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A43D360A6C;
        Fri,  2 Jul 2021 20:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: annotate data races around tp->mtu_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162525840466.26489.12938719023143907145.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 20:40:04 +0000
References: <20210702200903.4088572-1-eric.dumazet@gmail.com>
In-Reply-To: <20210702200903.4088572-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  2 Jul 2021 13:09:03 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While tp->mtu_info is read while socket is owned, the write
> sides happen from err handlers (tcp_v[46]_mtu_reduced)
> which only own the socket spinlock.
> 
> Fixes: 563d34d05786 ("tcp: dont drop MTU reduction indications")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net] tcp: annotate data races around tp->mtu_info
    https://git.kernel.org/netdev/net/c/561022acb1ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


