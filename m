Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3EC3C1AA0
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 22:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhGHUmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 16:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhGHUmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 16:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 222D561874;
        Thu,  8 Jul 2021 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625776804;
        bh=o9CGL4jA2hy9Gif3TsNM3caZTZUx06Xd0WueJsLQ4Mk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JsSONA+VS7/tXGIvVDG1m/TDlYiZZVbeUXko7DfrPjQxu/Tybl6zcEn1Ej9WLVqYV
         fUyjW9Aa6u8ODtztKnOtK1Pv3VeAB43ymnCcMjMCZOtVn7LQeTplDsQ/gn8PQIiB0X
         ZpiozSeeavjEZGJG4wKWiXNnxXtjTie33GDPS/QzyTQkkzuqTEYQDl/rnfjZzVCSjL
         0eUQcHcS2c8l3yFlif0TVRlaqTo2WDxymZNGwhBQqgJPM5zHRWE8OI3VD4LGWfcJbg
         5ZZymp1Umk53sLj1OFOTuaaZr87pRRC94Aa6wc8ot5nwZwzSR4J3sfUi6iiuBbZfVq
         RW33gCFAkrbiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 14F77609F6;
        Thu,  8 Jul 2021 20:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4: fix IRQ free race during driver unload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162577680408.12322.6704462031156666737.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 20:40:04 +0000
References: <20210708162156.6381-1-rajur@chelsio.com>
In-Reply-To: <20210708162156.6381-1-rajur@chelsio.com>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        shahjada@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Jul 2021 21:51:56 +0530 you wrote:
> From: Shahjada Abul Husain <shahjada@chelsio.com>
> 
> IRQs are requested during driver's ndo_open() and then later
> freed up in disable_interrupts() during driver unload.
> A race exists where driver can set the CXGB4_FULL_INIT_DONE
> flag in ndo_open() after the disable_interrupts() in driver
> unload path checks it, and hence misses calling free_irq().
> 
> [...]

Here is the summary with links:
  - [net] cxgb4: fix IRQ free race during driver unload
    https://git.kernel.org/netdev/net/c/015fe6fd29c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


