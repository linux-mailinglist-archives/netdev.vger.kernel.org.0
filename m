Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FD8306A8F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhA1Bll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:41:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231496AbhA1Bkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:40:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 61E7E64DA1;
        Thu, 28 Jan 2021 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611798010;
        bh=Unyaqf9QBkvpmhIPGKDkblqVjbL6Rd5h7OErkPpl6GI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tZngryoH8cFZuWfOHeAZiHxnkXKcwrVcNzWFsqWqKwKUqAEOpXwASHv+kXBPxtjGT
         tfIxniKWaFeX1Rk09OmrKp9QOSPJRcKLTWvXMvuNCn+MNlsHgoHzy6RHh2CiOajZrH
         xRtEXVoG2L/07srreKqAE5NhZj7WsI2uGDmL34rD1T9lJeut1GlYRvPKqrOgeK3oLE
         2w/8bWlOdgmhHGKATub2Au3uRrXZaBRjrUlhRes32g2QzL8TSqkyZfuTMDSDVfvyWp
         rlFYKXdZ1V5ZzWd503u3XUFNvbaS+S41HZ9OTXzvX5urp4AEC0dYNb13J5kD55rfuN
         8uhRsEvuO4VFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F6D9613AE;
        Thu, 28 Jan 2021 01:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] net: decnet: fix netdev refcount leaking on error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179801031.342.5041626316042298445.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 01:40:10 +0000
References: <1611619334-20955-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1611619334-20955-1-git-send-email-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     kuba@kernel.org, andrew@lunn.ch, gaurav1086@gmail.com,
        dsahern@gmail.com, David.Laight@ACULAB.COM,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 26 Jan 2021 03:02:14 +0300 you wrote:
> On building the route there is an assumption that the destination
> could be local. In this case loopback_dev is used to get the address.
> If the address is still cannot be retrieved dn_route_output_slow
> returns EADDRNOTAVAIL with loopback_dev reference taken.
> 
> Cannot find hash for the fixes tag because this code was introduced
> long time ago. I don't think that this bug has ever fired but the
> patch is done just to have a consistent code base.
> 
> [...]

Here is the summary with links:
  - [net] net: decnet: fix netdev refcount leaking on error path
    https://git.kernel.org/netdev/net/c/3f96d6449768

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


