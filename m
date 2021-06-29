Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6964A3B7827
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbhF2TCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232416AbhF2TCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 15:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A5B061DE4;
        Tue, 29 Jun 2021 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624993204;
        bh=9X64JC5kNE3ywZHK3jW9Lc6RM6gL2IFBCy46yZ2ZPb0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FCktYluo5MUVPerER64mPFN7saaHfJHZ+mRB3UYgnEv0MvylWenToG8ISjGOWSd72
         jtV9Lqfkh+uMN/VudiEwJeNwirOmEZULnZzNkSitRv8KQTlcoz3QItznMCfHhf2pLF
         19Ih/BvRZy4QXw12uBKXVQoXatJ/iAGGHhDuwLp+tKnL9OwUUU/zD/c6PgGfEDD/OH
         3FKaBsQCyTcWOsi0z93R32prduLiYxDY7Iwx3FYOTwS0BwmcgsINpkaBZK+14ttEAa
         u64vhwCKbk+5HQk8cyL9MYbaKqy/lAq/YUkj66Cd82gcnqRTRoTZDW3hjK2GDPSIg2
         iBwGw9lxoGmbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3094360ACA;
        Tue, 29 Jun 2021 19:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp_yeah: check struct yeah size at compile time
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162499320419.1879.12302858565962420716.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Jun 2021 19:00:04 +0000
References: <20210629135213.1070529-1-eric.dumazet@gmail.com>
In-Reply-To: <20210629135213.1070529-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 29 Jun 2021 06:52:13 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Compiler can perform the sanity check instead of waiting
> to load the module and crash the host.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] tcp_yeah: check struct yeah size at compile time
    https://git.kernel.org/netdev/net-next/c/6706721d82f8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


