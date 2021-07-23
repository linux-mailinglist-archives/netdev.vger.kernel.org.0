Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127A43D3BEA
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhGWOAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235440AbhGWN7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 09:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FEA560EBC;
        Fri, 23 Jul 2021 14:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627051205;
        bh=83MnoM9+GvcoxYtPgk37UgUIINflP7VuNjFkwosb0+w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qFYRRi82EF/RxtUuclr75OHDsF7YlWWpGHVnupU8zTOJpEHT36BQ4NrWEWUy6Ickj
         t0jB0mxYfEVr3qZ7pLxfjTEOU9pirsXK7whfmaUuGv4TsRV1DIana60RqRi3pw862d
         TKpq2Zbgz05T7F6m51zH2EhI9t3ZV1EsW4wTt59J1fgBUrrwsI03xg/+reJ2Uq9MsH
         j0aopSClgOy37dUopqHDn2e/FxYCjadVqKnJtfxcE69sYtpU5T/CiOAiOewPfMsQMs
         B/isd7aBMu7jOU0OvLYBEjK0cclScjlkDrsMVLEVULdBCgUVs9FKfFQrhTWX5M5bWQ
         ovXHSOPigX8VA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 828EC60972;
        Fri, 23 Jul 2021 14:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/6] remove compat_alloc_user_space()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705120552.20178.10414947858942867479.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 14:40:05 +0000
References: <20210722142903.213084-1-arnd@kernel.org>
In-Reply-To: <20210722142903.213084-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, arnd@arndb.de, viro@zeniv.linux.org.uk,
        andrew@lunn.ch, hch@lst.de, dsahern@kernel.org,
        davem@davemloft.net, edumazet@google.com, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, keescook@chromium.org, elver@google.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Jul 2021 16:28:57 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This is the fifth version of my series, now spanning four patches
> instead of two, with a new approach for handling struct ifreq
> compatibility after I realized that my earlier approach introduces
> additional problems.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/6] compat: make linux/compat.h available everywhere
    https://git.kernel.org/netdev/net-next/c/1a33b18b3bd9
  - [net-next,v6,2/6] ethtool: improve compat ioctl handling
    https://git.kernel.org/netdev/net-next/c/dd98d2895de6
  - [net-next,v6,3/6] net: socket: rework SIOC?IFMAP ioctls
    https://git.kernel.org/netdev/net-next/c/709566d79209
  - [net-next,v6,4/6] net: socket: remove register_gifconf
    https://git.kernel.org/netdev/net-next/c/b0e99d03778b
  - [net-next,v6,5/6] net: socket: simplify dev_ifconf handling
    https://git.kernel.org/netdev/net-next/c/876f0bf9d0d5
  - [net-next,v6,6/6] net: socket: rework compat_ifreq_ioctl()
    https://git.kernel.org/netdev/net-next/c/29c4964822aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


