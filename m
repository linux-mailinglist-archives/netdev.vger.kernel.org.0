Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE34439A53
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhJYPWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232732AbhJYPW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 11:22:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 81D8761002;
        Mon, 25 Oct 2021 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635175207;
        bh=WM+L1dS+a4rW8Lt5WrZtY3DV1C0j4eZjE+YNZPl+PNI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IqqsIqOa4sNpaOm+nmiqIDTXTqOIcwQRyX6AoasoGwdTB/EYB/aVKAJVqBh7hTciC
         DEPsBSkUEtor3OUpoDATqciplVT+q73mtvBgaCOY7VGFnuHEJHlJ+azlfLwisgluad
         oQLWgARcvNABFwOoSdYMV8HGXIPh/AequFhAen1LVTGq0sUAvS1c/Z19ZDHzx7uDIT
         fyzSrC2UYdRdEfMshKq9Tw508iZXEsb4Sc5ka5nv7PvVgFNisw5h8QoRB9sU6e0DQE
         Wok7kpEb2GQsPncTyIndQ3Fhqdj2+EKJlMUj6CrSyz6vXQFZaTecq5upNvaJ+E3I1c
         VBfK3kHDYcesA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 75A5160A90;
        Mon, 25 Oct 2021 15:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] xen/netfront: stop tx queues during live migration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163517520747.28215.3424375634925343412.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 15:20:07 +0000
References: <20211022233139.31775-1-dongli.zhang@oracle.com>
In-Reply-To: <20211022233139.31775-1-dongli.zhang@oracle.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, davem@davemloft.net,
        kuba@kernel.org, joe.jin@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Oct 2021 16:31:39 -0700 you wrote:
> The tx queues are not stopped during the live migration. As a result, the
> ndo_start_xmit() may access netfront_info->queues which is freed by
> talk_to_netback()->xennet_destroy_queues().
> 
> This patch is to netif_device_detach() at the beginning of xen-netfront
> resuming, and netif_device_attach() at the end of resuming.
> 
> [...]

Here is the summary with links:
  - [1/1] xen/netfront: stop tx queues during live migration
    https://git.kernel.org/netdev/net/c/042b2046d0f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


