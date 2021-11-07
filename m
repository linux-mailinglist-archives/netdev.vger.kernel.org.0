Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2151A447550
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 20:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhKGTmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 14:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhKGTmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 14:42:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id ED71B61215;
        Sun,  7 Nov 2021 19:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636314008;
        bh=VAso2nZ4kaYiTYlW3IlpWNWHmUI5hVgybCBBN4rfgnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hXMmM2x9c9jFx1U07PLnPot/1ksyEIB1dJhAr962AwIsxoOQGFkaJXfXWdgZgj6nU
         BkVYMUmQGDmOwTbfmnF0UgS+ksZLCJvgOIr2XqSf1nYB73Lvkk7YgdDPtqhf+44ugL
         D3vJKceMz31kZcTc2QmB4Lnp9hNj0V8j9miBxsAeo5rMZvsW1ojgWHdb1DIhe5he9F
         KpB96Rna+kPA9wlb+1h6JL/QIBf0CS2G/jGSpAuF+2aB2gbLgc9WbPXOPUSk8u8KT4
         3fKUWuSTk8PlvqWv2+RE50MIKB2ChRde1NMBCeWB5osms3MiQ90f9CMqZk8a+q0Lst
         /ndlXqmGwFsSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E083B60A2E;
        Sun,  7 Nov 2021 19:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sctp: remove unreachable code from sctp_sf_violation_chunk()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163631400791.18215.13246547902490470871.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Nov 2021 19:40:07 +0000
References: <1636133427-3990-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1636133427-3990-1-git-send-email-khoroshilov@ispras.ru>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     lucien.xin@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 20:30:27 +0300 you wrote:
> sctp_sf_violation_chunk() is not called with asoc argument equal to NULL,
> but if that happens it would lead to NULL pointer dereference
> in sctp_vtag_verify().
> 
> The patch removes code that handles NULL asoc in sctp_sf_violation_chunk().
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - sctp: remove unreachable code from sctp_sf_violation_chunk()
    https://git.kernel.org/netdev/net/c/e7ea51cd879c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


