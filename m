Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88DA36AA5E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 03:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhDZBbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 21:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231655AbhDZBa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 21:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 182EC61354;
        Mon, 26 Apr 2021 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619400616;
        bh=HSjejELuLAnios+2Vt6fh6poFSknYMXQcK5WMIfv1UU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fAozgIdBiU7Uc22IZ+UwQXQBAxPCcfrp1eIl71ahG2whJB8qy4GNF5KOEYxwfe5c2
         EATPBG4deNLAul4Iq4/awq6WkgL8ODZjafBqLKBAZ43adQFiymJDxnrL4BkJ16k+dS
         D5TPhUrSyvMRyZepvMA6Ee9KrMnA8l+mDOKVcSRK/IMzb+Syv1rHnQv317juumS/rZ
         eIGeL8Tj2Nnt5S7gmSRo7HBcKpzjXQftwsdThF7oEtT07zkfsQNzh+KntLz2C2TtWV
         HShpgI061pj+j0PLVx0JOr1v+YJsTIHc0SOzUwXwC3ccaJlO0l1O+yH5LvWwuIqAcL
         51PjwMv3q9ZEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D0B160CE2;
        Mon, 26 Apr 2021 01:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next][REPOST] hv_netvsc: Make netvsc/VF binding check both
 MAC and serial number
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161940061604.7794.9498613769256285295.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 01:30:16 +0000
References: <20210424011235.18721-1-decui@microsoft.com>
In-Reply-To: <20210424011235.18721-1-decui@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, Joseph.Salisbury@microsoft.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 18:12:35 -0700 you wrote:
> Currently the netvsc/VF binding logic only checks the PCI serial number.
> 
> The Microsoft Azure Network Adapter (MANA) supports multiple net_device
> interfaces (each such interface is called a "vPort", and has its unique
> MAC address) which are backed by the same VF PCI device, so the binding
> logic should check both the MAC address and the PCI serial number.
> 
> [...]

Here is the summary with links:
  - [net-next,REPOST] hv_netvsc: Make netvsc/VF binding check both MAC and serial number
    https://git.kernel.org/netdev/net-next/c/64ff412ad41f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


