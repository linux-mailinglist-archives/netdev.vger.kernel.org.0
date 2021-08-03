Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53153DED49
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbhHCMA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235745AbhHCMAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A3E261037;
        Tue,  3 Aug 2021 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627992007;
        bh=NbB7f77PeKIcaNdG5n3p0C6Qh9XFJDztW0MNE3qf7BI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UGpaYxmTpkGVgEQXJXORW+x45XzJgDX/SKMoGE+qePWV8MzG6R0l98i+vlpym8iOF
         2wgIe1LELDhehqnjH22vAYvSxbla981RSKLXGJQYszGEo7zpLr0gCXqIYrPv/xBW/T
         GjLJ5R0VuMlkhllhTkw7b+bdsFh7Egpik37+fS5JB5VmSIuRibZhDInNyKVxfKHmXA
         eGc79wU4bV6fstJL0iEqJBK2mRs7j8i1U0KMG+dKpTvTlgygiF5qJZfXN+xaYANFzB
         t6+/ZPQIa3cxR9B85cUnWIMXgCTsvrVVne7IaRLj0Rg3iNPUebqGjdSvs8Eas3GYzi
         DnBT2Zcpv7m8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 45F0560A49;
        Tue,  3 Aug 2021 12:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] ethtool: runtime-resume netdev parent before
 ethtool ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162799200728.3942.3289937895024062853.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 12:00:07 +0000
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
In-Reply-To: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 1 Aug 2021 12:35:18 +0200 you wrote:
> If a network device is runtime-suspended then:
> - network device may be flagged as detached and all ethtool ops (even if
>   not accessing the device) will fail because netif_device_present()
>   returns false
> - ethtool ops may fail because device is not accessible (e.g. because being
>   in D3 in case of a PCI device)
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] ethtool: runtime-resume netdev parent before ethtool ioctl ops
    https://git.kernel.org/netdev/net-next/c/f32a21376573
  - [net-next,2/4] ethtool: move implementation of ethnl_ops_begin/complete to netlink.c
    https://git.kernel.org/netdev/net-next/c/c5ab51df03e2
  - [net-next,3/4] ethtool: move netif_device_present check from ethnl_parse_header_dev_get to ethnl_ops_begin
    https://git.kernel.org/netdev/net-next/c/41107ac22fcf
  - [net-next,4/4] ethtool: runtime-resume netdev parent in ethnl_ops_begin
    https://git.kernel.org/netdev/net-next/c/d43c65b05b84

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


