Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E098471B93
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 17:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhLLQaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 11:30:15 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56850 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhLLQaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 11:30:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3D21CE0BA7
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 16:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C942BC341C5;
        Sun, 12 Dec 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639326609;
        bh=6YlCj+gwuHNzmFFSEsY3IZkSegOlalE2g0OzQ6BoRo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sQSkeHuIWWoLSo6a8wirDzPwVDYJiPdWTwAUDxDGytM6cNRvkaevH48JCabL2ZDUQ
         LxqkjMEx04UUNFLkOAhS1pzYi33X9nhgdx6OeAogSVjTAnzTgXJR+7Sp5KjYjioGm/
         I0W25ZHwqKDMbzGTScbGS1jHcm/Kq39F0GZf+DtBSmR4WmwTBffsAT+FTwSgLZSnlv
         wZ5Ue4EpuCdbnN4dV3Kp7mD/Spsgip5LetON6nKlLthZ8dZ2LmaM8wko/MuTWA9QTD
         5BN2xJoBaH0DneVxHzsb9Y8W+drC2WDcG5nLCx8EYiOj6CDiXGXhVCz28d6wU2UEyF
         Kf3ZeIBJeymfg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AAFB960BD0;
        Sun, 12 Dec 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: Fix raw socket bind tests with VRF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163932660969.2571.18307490990576517365.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Dec 2021 16:30:09 +0000
References: <20211211172108.74647-1-dsahern@kernel.org>
In-Reply-To: <20211211172108.74647-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, lizhijian@fujitsu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Dec 2021 10:21:08 -0700 you wrote:
> Commit referenced below added negative socket bind tests for VRF. The
> socket binds should fail since the address to bind to is in a VRF yet
> the socket is not bound to the VRF or a device within it. Update the
> expected return code to check for 1 (bind failure) so the test passes
> when the bind fails as expected. Add a 'show_hint' comment to explain
> why the bind is expected to fail.
> 
> [...]

Here is the summary with links:
  - [net] selftests: Fix raw socket bind tests with VRF
    https://git.kernel.org/netdev/net/c/0f108ae44520

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


