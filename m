Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A37B3E5620
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbhHJJAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236241AbhHJJA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 05:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3654560EC0;
        Tue, 10 Aug 2021 09:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628586007;
        bh=h91q+5Vq8yexNJudKQrBl2pOdO4KSFmZNEZypqdol8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hKuy3CxBIvwwYC+PYGbCye0kThne5jFCxMWQ2llyXGsUBQiaJNFc2yHCM5aqSxJlB
         VqtR6cxUpaGWcxV2n7cJ82m4ypsBN9Tq5yEm1Dg7It9lngwuHxKTQmPg/pHM3WURHB
         t934WZUvT0RTmHLp8LDXxfrjGyqGJT8NOvf6e7HqhS6MW/mSkgqJjPdhF7EApmlIfq
         OrOtfYevgJ3a1EeKaDyzeSuuTtWLUwOYLBvhbH1SoVWJPUMWTDXEM3zMpmOTnd5MPS
         0qtRHvYlMuCpiYaxTilA+qNkqIvipKr53n2JtmUNZW0uYdMVOO/wDg9SnW0GsGzCfF
         n85dZ2jnZl6fQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2578460A3B;
        Tue, 10 Aug 2021 09:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7] ksz8795 VLAN fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162858600714.23529.6536295951399653651.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 09:00:07 +0000
References: <20210809225753.GA17207@cephalopod>
In-Reply-To: <20210809225753.GA17207@cephalopod>
To:     Ben Hutchings <ben.hutchings@mind.be>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 10 Aug 2021 00:57:54 +0200 you wrote:
> This series fixes a number of bugs in the ksz8795 driver that affect
> VLAN filtering, tag insertion, and tag removal.
> 
> I've tested these on the KSZ8795CLXD evaluation board, and checked the
> register usage against the datasheets for the other supported chips.
> 
> Ben.
> 
> [...]

Here is the summary with links:
  - [net,1/7] net: dsa: microchip: Fix ksz_read64()
    https://git.kernel.org/netdev/net/c/c34f674c8875
  - [net,2/7] net: dsa: microchip: ksz8795: Fix PVID tag insertion
    https://git.kernel.org/netdev/net/c/ef3b02a1d79b
  - [net,3/7] net: dsa: microchip: ksz8795: Reject unsupported VLAN configuration
    https://git.kernel.org/netdev/net/c/8f4f58f88fe0
  - [net,4/7] net: dsa: microchip: ksz8795: Fix VLAN untagged flag change on deletion
    https://git.kernel.org/netdev/net/c/af01754f9e3c
  - [net,5/7] net: dsa: microchip: ksz8795: Use software untagging on CPU port
    https://git.kernel.org/netdev/net/c/9130c2d30c17
  - [net,6/7] net: dsa: microchip: ksz8795: Fix VLAN filtering
    https://git.kernel.org/netdev/net/c/164844135a3f
  - [net,7/7] net: dsa: microchip: ksz8795: Don't use phy_port_cnt in VLAN table lookup
    https://git.kernel.org/netdev/net/c/411d466d94a6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


