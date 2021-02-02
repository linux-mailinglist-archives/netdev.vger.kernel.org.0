Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037C130B545
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhBBCav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhBBCas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7E4D964D90;
        Tue,  2 Feb 2021 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612233007;
        bh=S9eefTnxyXaS1Z+79gPMrINisvL97D1w0vXTUYDDt40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VEgx+gdY4A6rHQwhiepDg//xzXsKKGTJuKfQwwNbwOBkX77oOEeyW6lifRMMvE6/1
         ntHKKxLer0R9Gqn1t+kS/JkvmekX7SPmoDIjgMMR2bv9Uq0ITLqTVxAmU4GX5fYzRv
         I3AzmFcKtwd94cOUPPaC5IyKq3+lcscOaC79WQF+TVanH5Br+OGiHW5/KnjpZ9sb1r
         4VFpVa5QjcoOhU2WetcwbDttgM/KtNxJglJ0NUbuHgFlKW0x1kxTRZK6V5kCN4gSZx
         LNN3WsrLM/EZZp3NQEl/mGaEQKlQlx6ZZqA4S2XU5alE1N/PyFudQfXRqFKBbCjK5h
         /hFuUX2Xvtjmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6864B609D0;
        Tue,  2 Feb 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: override existent unicast portvec in
 port_fdb_add
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161223300742.24699.17040696529894361005.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 02:30:07 +0000
References: <20210130134334.10243-1-dqfext@gmail.com>
In-Reply-To: <20210130134334.10243-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tobias@waldekranz.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 30 Jan 2021 21:43:34 +0800 you wrote:
> Having multiple destination ports for a unicast address does not make
> sense.
> Make port_db_load_purge override existent unicast portvec instead of
> adding a new port bit.
> 
> Fixes: 884729399260 ("net: dsa: mv88e6xxx: handle multiple ports in ATU")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add
    https://git.kernel.org/netdev/net/c/f72f2fb8fb6b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


