Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69140314214
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbhBHVl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236830AbhBHVks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 16:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5898264E82;
        Mon,  8 Feb 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612820407;
        bh=1M0F9qZV+MMXfddGKB4xga7xBHZctQ9KDuGS6nAUe/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cWCstqWWQgG21hROHrPR+N1uCbVBSEsqkkuhO+1/rQMYb1yMmINDFeYj0zOzzlJlt
         wP7Ey1ZbyDiTNPD8m6QbYaxI0IdgC6IfZtvNlmjneEHIw2MxKtRPt+Z6Hq+/qKAoQU
         FS3fG2hw1WVubrjUeA5OEqwu1k5SJ4k61AvRyvBhS2OGGgWdDLq7lHH5ozoIx6Y0Fq
         C14Kh1jSf/pOAJqVlbLbBD9OWUDR8ccsHB+K+s3GvJpPfNa3g54V/aP+Q43zN0aA17
         NqhHg+0KGuNpBOCBFiKyLT3mq7yOrCPVIcA62g1m+yElE4BW7ZRjquFYWEXJKeFmnS
         muGxKOEGEkp+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 457AA609D4;
        Mon,  8 Feb 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vsock/virtio: update credit only if socket is not closed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161282040728.13562.4928332686519436611.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Feb 2021 21:40:07 +0000
References: <20210208144454.84438-1-sgarzare@redhat.com>
In-Reply-To: <20210208144454.84438-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        asias@redhat.com, mst@redhat.com, imbrenda@linux.vnet.ibm.com,
        stefanha@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  8 Feb 2021 15:44:54 +0100 you wrote:
> If the socket is closed or is being released, some resources used by
> virtio_transport_space_update() such as 'vsk->trans' may be released.
> 
> To avoid a use after free bug we should only update the available credit
> when we are sure the socket is still open and we have the lock held.
> 
> Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] vsock/virtio: update credit only if socket is not closed
    https://git.kernel.org/netdev/net/c/ce7536bc7398

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


