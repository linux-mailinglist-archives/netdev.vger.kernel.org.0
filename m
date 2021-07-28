Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7693D8E3E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 14:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhG1MuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 08:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233315AbhG1MuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 08:50:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3EDEF60F9C;
        Wed, 28 Jul 2021 12:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627476605;
        bh=otFsd64mcPBm4E/UZFn3xu7/+bCx3ZLV79AtPVuRgUs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lRWq6kT7RaGslJrZOctQvlgI0RZF+JO281UDbWNY4AFLQ5zSQavUqy7UDgmV/m+zT
         UJXjPf4TtOb8T0pPNhTGfuL7x/PQc9FuUNrr7/jbHJ4wWFIDLRZJSxN2CWVdLlsY2X
         QyeuNUmyt4zt20uMRxfLMIcMHBoHoufqdV6gqrrG/oNk1HSYP1p96m24WR/8iqXljC
         1vJePby4iqmeskLAx9kDJuZtuYRdFmW5RF+hr/VwZGDI+qQ1agMC9pBpl7ZoC9+sI2
         PYuOOffH+NDI79Z8d08p4JdAVhGV9kBiQKebNQoEvtya6ByhEVP21haP2adx3hd6cn
         OjWMad454imxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 324F3609E8;
        Wed, 28 Jul 2021 12:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sis900: Fix missing pci_disable_device() in probe and
 remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162747660520.5429.773740304663396316.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 12:50:05 +0000
References: <20210728121107.273717-1-wanghai38@huawei.com>
In-Reply-To: <20210728121107.273717-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, venza@brownhat.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 28 Jul 2021 20:11:07 +0800 you wrote:
> Replace pci_enable_device() with pcim_enable_device(),
> pci_disable_device() and pci_release_regions() will be
> called in release automatically.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] sis900: Fix missing pci_disable_device() in probe and remove
    https://git.kernel.org/netdev/net/c/89fb62fde3b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


