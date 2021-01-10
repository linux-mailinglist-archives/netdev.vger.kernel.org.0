Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4B42F04C5
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 03:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbhAJCKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 21:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbhAJCKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 21:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2CB7322838;
        Sun, 10 Jan 2021 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610244609;
        bh=86xw+mwdrlNRpJP9bGH8qWjLiGgDtoUvAjy+Nz6/WkY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bc24/xgLWatlRludaUkSw7OiKq3fgd9u9LaEq7qAdxMHvwDixFxJAU/+q2ArMxDp8
         i6inJXDnPTx2uV8JxPF2QdhEijkSbZct1lr3nySqTzpxFiAjKqIUZK4aewguNv3q8b
         R1h1208s+melMUT+J57GNetSeS7POnJdkyOvc5OETdrM6GrlTmWU1RPC5Kark1sD3+
         M3tDIhgMdQJmkt6E539oZ8+0j0K7u/x6f9BujUicpaNbYDX1Y0PTI88YkXv/Jj4Vgu
         kLZIK0f/i2YRYn7B3Y0FH0PViKp2TzRdOs0claZirBprq5JhNlF6JKwwe610VnBW7y
         Tkxj0rw3BkLlA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 1EFD160508;
        Sun, 10 Jan 2021 02:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: dsa_legacy_fdb_{add,del} can be static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161024460912.25502.8823237079899822223.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Jan 2021 02:10:09 +0000
References: <20210108233054.1222278-1-olteanv@gmail.com>
In-Reply-To: <20210108233054.1222278-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  9 Jan 2021 01:30:54 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Introduced in commit 37b8da1a3c68 ("net: dsa: Move FDB add/del
> implementation inside DSA") in net/dsa/legacy.c, these functions were
> moved again to slave.c as part of commit 2a93c1a3651f ("net: dsa: Allow
> compiling out legacy support"), before actually deleting net/dsa/slave.c
> in 93e86b3bc842 ("net: dsa: Remove legacy probing support"). Along with
> that movement there should have been a deletion of the prototypes from
> dsa_priv.h, they are not useful.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: dsa_legacy_fdb_{add,del} can be static
    https://git.kernel.org/netdev/net-next/c/4b9c935898dd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


