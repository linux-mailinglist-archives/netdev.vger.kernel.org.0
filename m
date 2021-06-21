Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189B73AF670
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhFUTwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhFUTwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 273C461108;
        Mon, 21 Jun 2021 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624305004;
        bh=9+MN0Q/dxWPYVOCi1+nP1UOLdwkE2fdXf44uJ9Vn+Lw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l+U8ABulMT6Bn3gM4DWGQ5a/K6cE7S1pAv1FUZDxf8vmzbUc4CfAQGGq3FtQM199X
         LFG4/i1xwYaBNOSQP2xVbFr0sRI4qvPJ17bkQ0E4aqyAMV0Qc8pNqAwOubyXiDK2Kx
         KCyPKUWSVHt+Lptgw57LGjXxdZjDm0IxLo4Z9Kgg4MlBkPgrt+GCDuTSJa6ad5rVQA
         t05v3AeQl1BSl5A5IJ7gDXfv7cGnq9XKsCsCjrwV6xGEkZxpcjHExo/2HXNkIT8+xm
         L5mTKtepePWvG5OBP445sU4vFUvx25Tu1BtxKvDOhi37jaF9ffBhvjIupzx3DB45UJ
         1PnpGrNrD6Vqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1EA8560A02;
        Mon, 21 Jun 2021 19:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-06-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430500412.22375.10749525556148932583.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:50:04 +0000
References: <20210619220115.2830761-1-mkl@pengutronix.de>
In-Reply-To: <20210619220115.2830761-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Sun, 20 Jun 2021 00:01:10 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 5 patches for net/master.
> 
> The first patch is by Thadeu Lima de Souza Cascardo and fixes a
> potential use-after-free in the CAN broadcast manager socket, by
> delaying the release of struct bcm_op after synchronize_rcu().
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-06-19
    https://git.kernel.org/netdev/net/c/d52f9b22d56f
  - [net,2/5] can: gw: synchronize rcu operations before removing gw job entry
    https://git.kernel.org/netdev/net/c/fb8696ab14ad
  - [net,3/5] can: isotp: isotp_release(): omit unintended hrtimer restart on socket release
    https://git.kernel.org/netdev/net/c/14a4696bc311
  - [net,4/5] can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() after RCU is done
    https://git.kernel.org/netdev/net/c/22c696fed25c
  - [net,5/5] net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
    https://git.kernel.org/netdev/net/c/ab4a0b8fcb9a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


