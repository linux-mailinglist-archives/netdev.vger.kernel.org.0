Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5E62D89BA
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501926AbgLLTax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501920AbgLLTas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 14:30:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607801408;
        bh=bEKcDKNnbKQZsqWkcKJXyz2bDG6o4QsNZwfXEEpfdw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YbzdwH/f1x6rb+DywEUEk9/ugS4ItwLUNa+lJPnkkeKNnbsVcBs/MMFEQN54EW8EN
         itHrRWR8QtA+gZNW6iKGhgdQbFsU1BH/lgDcoY1Xn80NG3bsOKj/7yI/9v/L6JhNGd
         zeJ0BOeKqp8H+9SVsjv4xgOS5wKEUglMWv3FzlVRwIRwkpz14lO1ZYZU8TEZzA/zjk
         MeJIRHDcCAOSwuZMJZv7te0QeweWVY8PUzKhU2kKKDbNflnIERxZ0uM4GtuFViy+NX
         TnyMUMgLX8btDGB23XafZkAkzgT1kTQQ7u7/TTNtP4J72MdTFOkQ2Xrf6Z+nIY38/T
         UNgs2w0miqJ5w==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2020-12-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160780140804.26330.6754652244167866760.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Dec 2020 19:30:08 +0000
References: <20201211142552.209018-1-johannes@sipsolutions.net>
In-Reply-To: <20201211142552.209018-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Dec 2020 15:25:51 +0100 you wrote:
> Hi Dave,
> 
> Welcome back!
> 
> I'm a bit late with this, I guess, but I hope you can still
> pull it into net-next for 5.11. Nothing really stands out,
> we have some 6 GHz fixes, and various small things all over.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2020-12-11
    https://git.kernel.org/netdev/net-next/c/00f7763a26cb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


