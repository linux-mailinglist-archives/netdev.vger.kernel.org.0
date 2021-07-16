Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E503CBBB3
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 20:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhGPSNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 14:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhGPSM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 14:12:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D595461278;
        Fri, 16 Jul 2021 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626459004;
        bh=H80huDEXSOKkT2cua9P9hBRBP+GSsxhLwvxerfHntgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oRcAPq10yRIjsVQwjtYRKPkCOHYPbxfMjg1fJgDm9lP/13v50/BV25VwNmTqyVAcf
         pZo2d25RO43N/q4OQ/k7yIjOYwPXZW4hyjRle8+0K3BItHtqFWtCFk6Rh43B338aoi
         tVWQ27r627GN/k+lPlyeRVjF4P+223NIqwnLdtLte1aVLHEx3K0H5CLeveQN8Zdvll
         dFQHHqH4u/a/nr+JQX8y6Biu10dKwRwX6utTguXgIttZr1mQhKhE6anhjIzLK4W/gc
         JWSN9guy6sU2vilsK/GGvs++3IFqlP4E6rcGaJ44vdCM+zIKW+rWO1WoU08cxsMnjZ
         cuMy7rewG9vrw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C508A6097A;
        Fri, 16 Jul 2021 18:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] openvswitch: Introduce per-cpu upcall dispatch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162645900480.11090.2397559408489186888.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 18:10:04 +0000
References: <20210715122754.1240288-1-mark.d.gray@redhat.com>
In-Reply-To: <20210715122754.1240288-1-mark.d.gray@redhat.com>
To:     Mark Gray <mark.d.gray@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        dan.carpenter@oracle.com, pravin.ovn@gmail.com, fbl@sysclose.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Jul 2021 08:27:54 -0400 you wrote:
> The Open vSwitch kernel module uses the upcall mechanism to send
> packets from kernel space to user space when it misses in the kernel
> space flow table. The upcall sends packets via a Netlink socket.
> Currently, a Netlink socket is created for every vport. In this way,
> there is a 1:1 mapping between a vport and a Netlink socket.
> When a packet is received by a vport, if it needs to be sent to
> user space, it is sent via the corresponding Netlink socket.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] openvswitch: Introduce per-cpu upcall dispatch
    https://git.kernel.org/netdev/net-next/c/b83d23a2a38b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


