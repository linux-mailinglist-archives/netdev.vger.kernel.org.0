Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F27455C12
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhKRNEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:04:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244494AbhKRNDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:03:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8E3DC61ABA;
        Thu, 18 Nov 2021 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637240412;
        bh=ayjZHim+e9QU29Xl7vV381ibUl8p6SFJ/1trFfe9UcE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JN1zlSh+m6lM+AwS7UwosFxWZixGwTrswVbhyoRS1NJ+IP0i53wFEIgEHvtzVRMfk
         hX27o70HanIRaC2L3RowUYQEhKzKihxN51s/DS3UJnthdktRtY3iDdjk2rrf3sxFEF
         fXnK075yiDkqRyOKDDn+uSzTl8qgMTDNJG7zDDdzlbl8N3RgVQaC1YENWRuw1TRoib
         A+v8dlUODSZJyqaH7KVDNYROvf7xq+s0zwQPIOpfgxswpdyenlEZw3DwOPaS33ESlg
         jWuz3c02SyX7TxKpvhEFFk5q/xYkNbBXsogdw/n5SMlXZrIU6hQObLjlHgFPXnpyDD
         dmMIxg9HDRJ2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7C004609CD;
        Thu, 18 Nov 2021 13:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] lan78xx NAPI Performance Improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163724041250.16944.12206284082430153808.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 13:00:12 +0000
References: <20211118110139.7321-1-john.efstathiades@pebblebay.com>
In-Reply-To: <20211118110139.7321-1-john.efstathiades@pebblebay.com>
To:     John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 11:01:33 +0000 you wrote:
> This patch set introduces a set of changes to the lan78xx driver
> that were originally developed as part of an investigation into
> the performance of TCP and UDP transfers on an Android system.
> The changes increase the throughput of both UDP and TCP transfers
> and reduce the overall CPU load.
> 
> These improvements are also seen on a standard Linux kernel. Typical
> results are included at the end of this document.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] lan78xx: Fix memory allocation bug
    https://git.kernel.org/netdev/net-next/c/a6df95cae40b
  - [net-next,2/6] lan78xx: Introduce Tx URB processing improvements
    https://git.kernel.org/netdev/net-next/c/d383216a7efe
  - [net-next,3/6] lan78xx: Introduce Rx URB processing improvements
    https://git.kernel.org/netdev/net-next/c/c450a8eb187a
  - [net-next,4/6] lan78xx: Re-order rx_submit() to remove forward declaration
    https://git.kernel.org/netdev/net-next/c/9d2da72189a8
  - [net-next,5/6] lan78xx: Remove hardware-specific header update
    https://git.kernel.org/netdev/net-next/c/0dd87266c133
  - [net-next,6/6] lan78xx: Introduce NAPI polling support
    https://git.kernel.org/netdev/net-next/c/ec4c7e12396b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


