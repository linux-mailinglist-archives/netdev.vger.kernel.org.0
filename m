Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8423B0B95
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhFVRm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231352AbhFVRmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CCB5060720;
        Tue, 22 Jun 2021 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624383604;
        bh=CavWTndz4Jp0tS/jAL9jEliiWUOR1kQIIQ+0vRqwPo0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t5UVwjbzOhNoXHoRunKvU53VG0//W7RhC1vnnF+U9OW74NwUuwIHgxlhauOHfDjhK
         PxkAJLnA2efexTA+ICJj36N425wEFl3GI//yuPs+JCFG7lHACSbNeWRs0lxZeffxXa
         wZ8rAAqac4vomFy541+yk9BQzdd6NJOfUoL3EuZg/4hoDBU79l0QkzuE+TCBjVH8D4
         CejIYMME5t107uot9ljE1rxfLaqV0rBva4DiH4NN/GzbfRpY6iK22BUTGAQQCUuEwi
         9p9E6QhEiFEacIcl1mDxVera7rCbh5Hh91SdiQgyM4i54DBUV/sYEcc5C2g53AbAVM
         Ns/rY9dRgILzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD6D260ACA;
        Tue, 22 Jun 2021 17:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bonding: avoid adding slave device with IFF_MASTER flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438360477.26881.9652190993547040264.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:40:04 +0000
References: <20210622030929.51295-1-zhudi21@huawei.com>
In-Reply-To: <20210622030929.51295-1-zhudi21@huawei.com>
To:     zhudi <zhudi21@huawei.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, rose.chen@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 22 Jun 2021 11:09:29 +0800 you wrote:
> From: Di Zhu <zhudi21@huawei.com>
> 
> The following steps will definitely cause the kernel to crash:
> 	ip link add vrf1 type vrf table 1
> 	modprobe bonding.ko max_bonds=1
> 	echo "+vrf1" >/sys/class/net/bond0/bonding/slaves
> 	rmmod bonding
> 
> [...]

Here is the summary with links:
  - bonding: avoid adding slave device with IFF_MASTER flag
    https://git.kernel.org/netdev/net/c/3c9ef511b9fa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


