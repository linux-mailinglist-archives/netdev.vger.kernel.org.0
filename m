Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF00D3A6F0B
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbhFNTcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233048AbhFNTcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:32:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 17B88611BE;
        Mon, 14 Jun 2021 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623699004;
        bh=esmtqM/csBAB3wemoB1dlxohSdUWTlThMnapkDIwRO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p7M2oIXHVP2SZrvn82yUZwmdodOdBvFHivaVmCPEpFWVATMhNzNyQ0xyMNYkZBM4B
         OcV0lQ8L25sJrDAbGF/0FqxAiFtZwjMUU+dDdl3Fxxm31l6POLyjDjL+d+Pe+1eiBd
         TFtpeLjWj4F2h41htQ1kdSx6nno24WLj8cBcj+VybPiUX63BSbHKh8D5wQVlg0ZjPT
         6gEOyUGLGscahyvJo6cyvPxnDxzIfmh9UWcyaNMHpvUzR3Gqjz5yMXgHTCWJo8EoY6
         RyFCTwkns1V+fs7L91AaJc6svfV7urecyU7MXsUjosH8dfgfXkQ35z/hbPjyq7Kv5F
         N5Lkq4Sqly0mg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0BF3F60972;
        Mon, 14 Jun 2021 19:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: caif: fix memory leak in ldisc_open
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369900404.32080.4499446872810247187.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:30:04 +0000
References: <20210612145122.9354-1-paskripkin@gmail.com>
In-Reply-To: <20210612145122.9354-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+f303e045423e617d2cad@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 12 Jun 2021 17:51:22 +0300 you wrote:
> Syzbot reported memory leak in tty_init_dev().
> The problem was in unputted tty in ldisc_open()
> 
> static int ldisc_open(struct tty_struct *tty)
> {
> ...
> 	ser->tty = tty_kref_get(tty);
> ...
> 	result = register_netdevice(dev);
> 	if (result) {
> 		rtnl_unlock();
> 		free_netdev(dev);
> 		return -ENODEV;
> 	}
> ...
> }
> 
> [...]

Here is the summary with links:
  - net: caif: fix memory leak in ldisc_open
    https://git.kernel.org/netdev/net/c/58af3d3d54e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


