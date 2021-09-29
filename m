Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242E841C255
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245369AbhI2KLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245360AbhI2KLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2AD006140D;
        Wed, 29 Sep 2021 10:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632910210;
        bh=y3ryAy/K3TvK0XaS1GnnAplYU0Z2tLrllxsrHjGYp5M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AjHYcqNtAVF1b/aKUo4TUpR1qi8KXUe07hAjTB5e+WHOBbZz132j036F0UXG1DXAy
         5ZmpBPEAoeNT3p9dDsXOmUwl5N0P24vqN0SN+dgolM/12z08Lgp9iVTewI/2S1nVac
         EA5LHRXNwRLrgJUYSzJ2G1fwZVKCSRJvEbb6plkOcsO6O4lLRMFsvZ3Xscqp+YdYMy
         SvT52V2iWO/e38pBTJC6YYwRB/ShkhZfUyisKX2jyDmekOKpw7Ivw8safu4RtSjdGc
         F/pfbcruTtoT2WKGGvYn0gZVuVH9bofLHR2AL+xPGsOGGbEUIGwFgfjlMBGDt0gjl7
         HlZHPFY7ai9oA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 247F160A7E;
        Wed, 29 Sep 2021 10:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] Updates to MCTP core
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163291021014.13642.1540278409896573490.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 10:10:10 +0000
References: <20210929072614.854015-1-matt@codeconstruct.com.au>
In-Reply-To: <20210929072614.854015-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jk@codeconstruct.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 15:26:04 +0800 you wrote:
> Hi,
> 
> This series adds timeouts for MCTP tags (a limited resource), and a few
> other improvements to the MCTP core.
> 
> Cheers,
> Matt
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mctp: Allow MCTP on tun devices
    https://git.kernel.org/netdev/net-next/c/f364dd71d92f
  - [net-next,02/10] mctp: Allow local delivery to the null EID
    https://git.kernel.org/netdev/net-next/c/1f6c77ac9e6e
  - [net-next,03/10] mctp: locking, lifetime and validity changes for sk_keys
    https://git.kernel.org/netdev/net-next/c/73c618456dc5
  - [net-next,04/10] mctp: Add refcounts to mctp_dev
    https://git.kernel.org/netdev/net-next/c/43f55f23f708
  - [net-next,05/10] mctp: Implement a timeout for tags
    https://git.kernel.org/netdev/net-next/c/7b14e15ae6f4
  - [net-next,06/10] mctp: Add tracepoints for tag/key handling
    https://git.kernel.org/netdev/net-next/c/4f9e1ba6de45
  - [net-next,07/10] mctp: Do inits as a subsys_initcall
    https://git.kernel.org/netdev/net-next/c/97f09abffcb9
  - [net-next,08/10] doc/mctp: Add a little detail about kernel internals
    https://git.kernel.org/netdev/net-next/c/f4d41c59135d
  - [net-next,09/10] mctp: Set route MTU via netlink
    https://git.kernel.org/netdev/net-next/c/6183569db80e
  - [net-next,10/10] mctp: Warn if pointer is set for a wrong dev type
    https://git.kernel.org/netdev/net-next/c/7b1871af75f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


