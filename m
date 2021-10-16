Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8EC4302E1
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244324AbhJPOMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 10:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236207AbhJPOMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 10:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7BBF5611AF;
        Sat, 16 Oct 2021 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634393409;
        bh=95aZ1CM7N8b8MKSJdRpoV5eWlnvchNidhqY/V1gcn5o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hlp4sXTYFOytoYomx4rai3lUX3wX+DImLdQXePkotWN8KXjTNsDkm5HVFoqS0Lw/j
         z/Jsk89k+JvD+PLmaHBBoJah7tYuKpwaMPYlCaHyrWv849VF8mVnSDkZMl0/hFtYkr
         dvMbBwtVnSHyGHGsohLSyP3TeczLbe1x1FH5ebILP3quGSjjuyJiKA1dsl8bWtaFNQ
         SDMsM57a1uRz2TGgx93JcQ7kF+txlcbaNf/qMwpKmzepFA3rARITNo2bdUH6wKM27m
         U4frN7RQPYRtf9n1+5tTlDvtqF6c5xNWsx5eh150LGKOy24S3i0pFmZUzKAn4Mircd
         6vU4VsTGMqshQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 735E360A47;
        Sat, 16 Oct 2021 14:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/10] net/smc: introduce SMC-Rv2 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163439340946.2147.12741689734091144591.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 14:10:09 +0000
References: <20211016093752.3564615-1-kgraul@linux.ibm.com>
In-Reply-To: <20211016093752.3564615-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 16 Oct 2021 11:37:42 +0200 you wrote:
> Please apply the following patch series for smc to netdev's net-next tree.
> 
> SMC-Rv2 support (see https://www.ibm.com/support/pages/node/6326337)
> provides routable RoCE support for SMC-R, eliminating the current
> same-subnet restriction, by exploiting the UDP encapsulation feature
> of the RoCE adapter hardware.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/10] net/smc: save stack space and allocate smc_init_info
    https://git.kernel.org/netdev/net-next/c/ed990df29f5b
  - [net-next,v3,02/10] net/smc: prepare for SMC-Rv2 connection
    https://git.kernel.org/netdev/net-next/c/42042dbbc2eb
  - [net-next,v3,03/10] net/smc: add SMC-Rv2 connection establishment
    https://git.kernel.org/netdev/net-next/c/e5c4744cfb59
  - [net-next,v3,04/10] net/smc: add listen processing for SMC-Rv2
    https://git.kernel.org/netdev/net-next/c/e49300a6bf62
  - [net-next,v3,05/10] net/smc: add v2 format of CLC decline message
    https://git.kernel.org/netdev/net-next/c/8ade200c269f
  - [net-next,v3,06/10] net/smc: retrieve v2 gid from IB device
    https://git.kernel.org/netdev/net-next/c/24fb68111d45
  - [net-next,v3,07/10] net/smc: add v2 support to the work request layer
    https://git.kernel.org/netdev/net-next/c/8799e310fb3f
  - [net-next,v3,08/10] net/smc: extend LLC layer for SMC-Rv2
    https://git.kernel.org/netdev/net-next/c/b4ba4652b3f8
  - [net-next,v3,09/10] net/smc: add netlink support for SMC-Rv2
    https://git.kernel.org/netdev/net-next/c/b0539f5eddc2
  - [net-next,v3,10/10] net/smc: stop links when their GID is removed
    https://git.kernel.org/netdev/net-next/c/29397e34c76b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


