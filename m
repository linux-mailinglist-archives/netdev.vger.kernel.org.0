Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5FF290F97
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436548AbgJQFrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410845AbgJQFrV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 01:47:21 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602892803;
        bh=N6sGLQTL3I8PG+AghEG4usEUqToaBVskk1UZA3JOcfs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d923Az5MBeFQOwshPimDFkt2pchsSg1q/PGG3GmxqjXXsR50+dcIlYeEpvAoYz7z0
         XajvqLGILq8brKrP/y1GoqHQRV72DA4R/X1j/VqX0oYos32IFWQdJY5pke7iiiwtqF
         7m/xs7iwCz/YKUXXAPR5kXX5BwtqHvNB7nJ7eTVI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] icmp: randomize the global rate limiter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160289280320.7840.14344252019735666760.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Oct 2020 00:00:03 +0000
References: <20201015184200.2179938-1-eric.dumazet@gmail.com>
In-Reply-To: <20201015184200.2179938-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, kman001@ucr.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 15 Oct 2020 11:42:00 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Keyu Man reported that the ICMP rate limiter could be used
> by attackers to get useful signal. Details will be provided
> in an upcoming academic publication.
> 
> Our solution is to add some noise, so that the attackers
> no longer can get help from the predictable token bucket limiter.
> 
> [...]

Here is the summary with links:
  - [net] icmp: randomize the global rate limiter
    https://git.kernel.org/netdev/net/c/b38e7819cae9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


