Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A9630E7AC
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhBCXlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:41:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233816AbhBCXks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DAE8B64F4E;
        Wed,  3 Feb 2021 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612395607;
        bh=argkP1v6LOnbSuUD1U3oXeDnJ5DDm88LErh73maHflA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CxeycV3eQqwAm93gSfagsSMtkvL+UhVVXhyT+ChyTFxOo4gDSHiPaZGBAIZ9nfI79
         DHjXOqb0SsZ+LAZyoi9GdAitGHrdgemg/OYYCh0TyHuvQ4OMLb7WKornqT7V8G43Cd
         izIV1GdJFJoCEwOvhaql0aZ/8cS0rVsSQEvwGQndBO57gdqegtHp4yg3oLiY6vTVed
         QceO+SWKH8EYHLXoVXJ2jWpeBtwXQuQgfdSjTzVmnFOQUCRPZYn9WSn4DmtQiMqUej
         fJbjtj8+GBBHLYK2kx8gFnSasY9hjrD7jJ6asqGgmqXCV56OYUaFdwDi4weAsoDGFE
         6/GgJ5cO9UQKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D5CFD609E5;
        Wed,  3 Feb 2021 23:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: use INDIRECT_CALL in some dst_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161239560787.28685.15190031417920139357.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 23:40:07 +0000
References: <20210201174132.3534118-1-brianvv@google.com>
In-Reply-To: <20210201174132.3534118-1-brianvv@google.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     brianvv.kernel@gmail.com, edumazet@google.com, lrizzo@google.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  1 Feb 2021 17:41:28 +0000 you wrote:
> This patch series uses the INDIRECT_CALL wrappers in some dst_ops
> functions to mitigate retpoline costs. Benefits depend on the
> platform as described below.
> 
> Background: The kernel rewrites the retpoline code at
> __x86_indirect_thunk_r11 depending on the CPU's requirements.
> The INDIRECT_CALL wrappers provide hints on possible targets and
> save the retpoline overhead using a direct call in case the
> target matches one of the hints.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] net: use indirect call helpers for dst_input
    https://git.kernel.org/netdev/net-next/c/e43b21906439
  - [net-next,v3,2/4] net: use indirect call helpers for dst_output
    https://git.kernel.org/netdev/net-next/c/6585d7dc491d
  - [net-next,v3,3/4] net: use indirect call helpers for dst_mtu
    https://git.kernel.org/netdev/net-next/c/f67fbeaebdc0
  - [net-next,v3,4/4] net: indirect call helpers for ipv4/ipv6 dst_check functions
    https://git.kernel.org/netdev/net-next/c/bbd807dfbf20

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


