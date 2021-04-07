Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93FE357748
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhDGWA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234399AbhDGWAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 618D061279;
        Wed,  7 Apr 2021 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617832810;
        bh=zKaayqbXFLaFNVavLJ/HyWJ5Yf1DxUBRmMLZDvgAZeg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fejfz5ZfVK3fSOuNLrYY4vtn6u7GOXINkA6W/q3zrVpDaVi5ORtm2l8dKBWHpnqNN
         OcTiEfKUD4RUodThDE6tykfMxIproW2KBQ/BWrLYxOZrukpymUmXjC/9DcgT4uVRh6
         wm9r1rhZV2A87EfJNwatvyh4WN7IJCps3IK+aVo04RarSUkFTZtxXE9ThZZZm3H22f
         IJPY0hi+8lKRDoN8qOo++fcBeBNWjlmFJYYsJh8NLgwSms8Ohd5KkdMtRQgfCwnn6s
         wIpf0OfMpxtWqCWCuJW0zDfbMsBGhCgOJ7t7MMINUdNDxDJJTSmrwHwLXGTN68hq/I
         Ma1dvGeD6vKXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 567E660ACA;
        Wed,  7 Apr 2021 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: hsr: Reset MAC header for Tx path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783281034.1764.3404366178213002996.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:00:10 +0000
References: <20210406073509.13734-1-kurt@linutronix.de>
In-Reply-To: <20210406073509.13734-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, m-karicheri2@ti.com,
        ap420073@gmail.com, olteanv@gmail.com,
        george.mccollister@gmail.com, luc.vanoostenryck@gmail.com,
        wanghai38@huawei.com, daniel@iogearbox.net, brouer@redhat.com,
        edumazet@google.com, willemdebruijn.kernel@gmail.com,
        bigeasy@linutronix.de, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  6 Apr 2021 09:35:09 +0200 you wrote:
> Reset MAC header in HSR Tx path. This is needed, because direct packet
> transmission, e.g. by specifying PACKET_QDISC_BYPASS does not reset the MAC
> header.
> 
> This has been observed using the following setup:
> 
> |$ ip link add name hsr0 type hsr slave1 lan0 slave2 lan1 supervision 45 version 1
> |$ ifconfig hsr0 up
> |$ ./test hsr0
> 
> [...]

Here is the summary with links:
  - [net,v3] net: hsr: Reset MAC header for Tx path
    https://git.kernel.org/netdev/net/c/9d6803921a16

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


