Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A0141C455
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343586AbhI2MLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245453AbhI2MLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 08:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DFCCD610A2;
        Wed, 29 Sep 2021 12:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632917406;
        bh=LbW0pN1pyKOQomSOMXZ62lmKHEzZP1r4d14PGWyNASY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RvkY90IXrBnSLb3vi8B2RWaaw5zBNp3mA3SmbwX0AuNZNd2enSutqViZfKlG2ApAn
         MZhr9AFhk1QJ8M8pbTWQsgjf7slU5wmE9TYqCRQl0LtCnqquz2yPjlIpKBX8Me5GZO
         uIvO2glLAnhiRwpCkXdVc5qZUYZrtKxxcqbCbHA+yPRfPwWOmkiIz3DBE4CpkTS9U3
         8nrJuqZh2Bc6NRh2v6G5iQqE9L/QYw7yq0ukEXKQ7a/yZfc0QQHSjoBIbNmZivo4rG
         LjTO0F6P6FP0X6erZUlH6CNXQScplHIt58rVeHNmrAutsIaQ+tVW51ANQLOxmtK4lp
         fOmiPK0auUY8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D2FE660A69;
        Wed, 29 Sep 2021 12:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] xsk: fix clang build error in __xp_alloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163291740685.32514.3463258661851595919.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 12:10:06 +0000
References: <20210929061403.8587-1-magnus.karlsson@gmail.com>
In-Reply-To: <20210929061403.8587-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        nathan@kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 29 Sep 2021 08:14:03 +0200 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a build error with clang in __xp_alloc().
> 
> net/xdp/xsk_buff_pool.c:465:15: error: variable 'xskb' is uninitialized
> when used here [-Werror,-Wuninitialized]
>                         xp_release(xskb);
>                                    ^~~~
> 
> [...]

Here is the summary with links:
  - [bpf-next] xsk: fix clang build error in __xp_alloc
    https://git.kernel.org/bpf/bpf-next/c/3103836496e7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


