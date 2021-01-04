Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FC52E9F8C
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbhADVau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbhADVat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A87FE2245C;
        Mon,  4 Jan 2021 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609795808;
        bh=bA0K2CBfSSWpMVi9OLaKRVAiOrryjHf9VDU09Xr3MuY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kot+PZi7UKsRL0dHm1p52XXqiMjnHjPKaCbT1qQV5ctHxQjn7gY3D28hpZA/P9MsO
         bESnFpe3HZ8c+RJ5mWnhyZqwa4ZkArvyHy+C/XEM/w/PscXUHOVi1x4rwsO8t2BlOh
         MYNWfevvxiCX14dOKoiJBayRDscpTw9EikDq+sfWDyFyl7Bj97YCGpa5Kuz6kAz9jY
         qFzSAaATS1REeB+PE+9vxei0C4HpMXaJ4+ac6v0BPbEHaavzkmYxmcEAjBbl0VfIz9
         dNZ+ZcN/eHb+xYyJq2UkgJhbBNTEi6in846RDCnqZC1sPvNpr8fLOewgfRrAKBNfaf
         Nf1XQ4L1URp2g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 9C415603F8;
        Mon,  4 Jan 2021 21:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v6] vhost_net: fix ubuf refcount incorrectly when sendmsg
 fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160979580863.407.3102826648114498407.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jan 2021 21:30:08 +0000
References: <1609207308-20544-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1609207308-20544-1-git-send-email-wangyunjian@huawei.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 29 Dec 2020 10:01:48 +0800 you wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the vhost_zerocopy_callback() maybe be called to decrease
> the refcount when sendmsg fails in tun. The error handling in vhost
> handle_tx_zerocopy() will try to decrease the same refcount again.
> This is wrong. To fix this issue, we only call vhost_net_ubuf_put()
> when vq->heads[nvq->desc].len == VHOST_DMA_IN_PROGRESS.
> 
> [...]

Here is the summary with links:
  - [net,v6] vhost_net: fix ubuf refcount incorrectly when sendmsg fails
    https://git.kernel.org/netdev/net/c/01e31bea7e62

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


