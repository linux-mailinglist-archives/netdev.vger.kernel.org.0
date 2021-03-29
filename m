Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B8134C0CA
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhC2BAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhC2BAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4CADF6193F;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616979611;
        bh=bSJHnkL0Y6HWWvXB/0i91Ys2z86pDibN1bNO3jpu7g0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gfm6X4B70RVrxyZgXPVZgyBUN3LitUIBIHEUd2adt7SJNWWk3ICPEpgE4YM4N3vIr
         uX5GaYSJ1H1zfalfbChqPgXOHXgCSVzpI+zoFiM5pnHtQc6K4c2gqvROhcDWnzBvjq
         vYwM/y8kuYTb/x9ECns7SK5qkLJnXTpcvelHechjCu2NsD72F2g6OU4kp9wsZxeiaY
         wW+OmeSuR5QPe/B8e8A6PpE3D0Yw+0Rxs8A71r5gwOuJ8yQaalTaksvC9XyKfOiA+d
         MEaarF48TX4lF7pyJMdZWhgYl4AIwzq9FGawCVhQaYx8cQ9lAivHlRqRV6DfbJa+CN
         E5Q8DKyQ5QGvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D596609E8;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next 0/3] Fix some typos
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697961124.31306.16406247961568026068.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:00:11 +0000
References: <20210327022724.241376-1-luwei32@huawei.com>
In-Reply-To: <20210327022724.241376-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        jhansen@vmware.com, colin.king@canonical.com, nslusarek@gmx.net,
        andraprs@amazon.com, alex.popov@linux.com,
        santosh.shilimkar@oracle.com, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 10:27:21 +0800 you wrote:
> Lu Wei (3):
>   net: rds: Fix a typo
>   net: sctp: Fix some typos
>   net: vsock: Fix a typo
> 
>  net/rds/send.c           | 2 +-
>  net/sctp/sm_make_chunk.c | 2 +-
>  net/sctp/socket.c        | 2 +-
>  net/vmw_vsock/af_vsock.c | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [-next,1/3] net: rds: Fix a typo
    https://git.kernel.org/netdev/net-next/c/ebf893958c13
  - [-next,2/3] net: sctp: Fix some typos
    https://git.kernel.org/netdev/net-next/c/21c00a186fac
  - [-next,3/3] net: vsock: Fix a typo
    https://git.kernel.org/netdev/net-next/c/9195f06b2d0f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


