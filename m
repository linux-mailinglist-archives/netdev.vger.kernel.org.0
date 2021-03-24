Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03B134856E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239059AbhCXXkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232266AbhCXXkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 19:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6195F61974;
        Wed, 24 Mar 2021 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616629213;
        bh=He7JTL5JuRKo4q9Iv0gbhETvNQS124dETLza+ELfPlg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=quSxQv7SPUaai0W4mw3N2AYdmV6D0m8aIu35pxLz+XZtBKSQA3G4M+zy5+Ksgwxhz
         2l1mINGbBgNqjaMpuCdMocOEe/WQEM1BTjmjIakCdUMK7JDxmn53mrEX9ZDgx3rYq+
         xDcKMOhG2+ggc1Fd+iPAA/002/faYESGg7tD6kXBJsU3DhOC3h1GY3ub8/GZ3921Lc
         766RK6JYgpsQPGkXWg9uRLKPZeV6xP08N0ghZXvnvCy9Tjmw2PrhvwjKZZFhsau6Kv
         +31TjCrjJGRP99r60Lsgu8lh70FblAKdQSavf9Gc7rn7lGb/T7SMoK4hB0Wk5McT37
         Ja5Gzf6KM6uHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 51F2F60A0E;
        Wed, 24 Mar 2021 23:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: enetc: don't depend on system endianness in
 enetc_set_vlan_ht_filter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161662921333.21919.5916407619212331056.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 23:40:13 +0000
References: <20210324154455.1899941-1-olteanv@gmail.com>
In-Reply-To: <20210324154455.1899941-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 17:44:54 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ENETC has a 64-entry hash table for VLAN RX filtering per Station
> Interface, which is accessed through two 32-bit registers: VHFR0 holding
> the low portion, and VHFR1 holding the high portion.
> 
> The enetc_set_vlan_ht_filter function looks at the pf->vlan_ht_filter
> bitmap, which is fundamentally an unsigned long variable, and casts it
> to a u32 array of two elements. It puts the first u32 element into VHFR0
> and the second u32 element into VHFR1.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: enetc: don't depend on system endianness in enetc_set_vlan_ht_filter
    https://git.kernel.org/netdev/net-next/c/110eccdb2469
  - [net-next,2/2] net: enetc: don't depend on system endianness in enetc_set_mac_ht_flt
    https://git.kernel.org/netdev/net-next/c/e366a39208e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


