Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC0B3A6ECA
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhFNTWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234219AbhFNTWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:22:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F10D6128B;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623698404;
        bh=FH44q+jSBXoQPtZsGHrEjML0T0pl+SO3w1ARqoXG7qY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DJsDPK7srse1+V5ig0eveYA6awZJhBx5umFa20rlCoZmPEXPi1IBxZg1BZT6t0fsE
         tbbk3IBx9R9uqhKRUyfR3oGaznsZI4S86uTpm7g9EDDdl5KumMzBflssqcoIOvlPLR
         +/f4dSEJLhZNNDEpmPpJzK1g2mlfKfqzntoPlYJE95YpMjvRmHtldD1BvZ9hnjZk7+
         dnfftxfX+N3IQkryZ7rwdCrwL4WjPwEURNwmnvOh1afLNDq6lg1Z2BHKSLkguXllrX
         DwwQlD6+pkssloRR2xz46EHNxeFfQeGnqyaLIUpn8ZA/HHqdK3PT3EPDJOgDRC8YEA
         Frz2o60/1z0oQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 417F160BE1;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: strset: fix message length calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369840426.27454.8205552139743602182.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:20:04 +0000
References: <20210612014948.211817-1-kuba@kernel.org>
In-Reply-To: <20210612014948.211817-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        f.fainelli@gmail.com,
        syzbot+59aa77b92d06cd5a54f2@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 11 Jun 2021 18:49:48 -0700 you wrote:
> Outer nest for ETHTOOL_A_STRSET_STRINGSETS is not accounted for.
> This may result in ETHTOOL_MSG_STRSET_GET producing a warning like:
> 
>     calculated message payload length (684) not sufficient
>     WARNING: CPU: 0 PID: 30967 at net/ethtool/netlink.c:369 ethnl_default_doit+0x87a/0xa20
> 
> and a splat.
> 
> [...]

Here is the summary with links:
  - [net] ethtool: strset: fix message length calculation
    https://git.kernel.org/netdev/net/c/e175aef90269

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


