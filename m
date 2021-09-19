Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E8F410B87
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhISMVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhISMVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD80061244;
        Sun, 19 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632054007;
        bh=uGLpunTH8J/q0phcSslz+22SrYggmT5KqhgSg6Q0V4o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VsF0theuRC87H+ye7ESXPrYPgyKk/dKgGfiH4ePImJV7HsOVkHAvFFDroNYL620yx
         Jzhb2WZr+pOMtCopOp18zISzp9opw3nzNsTi1ukUsu90apJaqtvU1qvN/KWn8stF2Y
         H9ky+zck+2ihRr+UzZGtvk1gWJ9x1tePPsBNRx9gLgPJ3Ar5YYFRKMTydZScdDjc0H
         IqfnZDH/9ojZu3UjXzFowV3e0OUWXLWrqRMZhzEQy/hCKQsKZzv6ns92RKFdmcTysQ
         VDG7tohVB8a1yHJ4RfTPfEgpq+BEobdw2tQJ/kwYAQtvGQAcNfzxS6yNwKNNudsfVl
         VOy27AR0t4wdQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A0BC060A37;
        Sun, 19 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: bgmac-bcma: handle deferred probe error due to
 mac-address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205400765.8407.16517970098611627389.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 12:20:07 +0000
References: <20210919115725.29064-1-chunkeey@gmail.com>
In-Reply-To: <20210919115725.29064-1-chunkeey@gmail.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, kuba@kernel.org, davem@davemloft.net,
        rafal@milecki.pl, ynezz@true.cz, michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 19 Sep 2021 13:57:25 +0200 you wrote:
> Due to the inclusion of nvmem handling into the mac-address getter
> function of_get_mac_address() by
> commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> it is now possible to get a -EPROBE_DEFER return code. Which did cause
> bgmac to assign a random ethernet address.
> 
> This exact issue happened on my Meraki MR32. The nvmem provider is
> an EEPROM (at24c64) which gets instantiated once the module
> driver is loaded... This happens once the filesystem becomes available.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: bgmac-bcma: handle deferred probe error due to mac-address
    https://git.kernel.org/netdev/net/c/029497e66bdc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


