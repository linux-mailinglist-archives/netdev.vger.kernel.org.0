Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE9F2C1A37
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgKXAuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 19:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgKXAuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 19:50:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606179005;
        bh=MG3634tpot3wOXnztQo9l0bxBVfzeiy0CiyRsRLHoYI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BRHAe8iUzuo+kaBWkKkZeHMKQyqKUnblFNDVlN9JRZDF2xW18BZ8JgW2ELD59Phbq
         8AQTxC7WMnq0LpS7SVSe1dOZ0NNpshxFCLBUc6uIGgQvPScsmFDPzwkUwBC2FjT0AQ
         B2ffPOFmS1GwT7VGkxEVeZFxNXU4Y/7DD770Aprc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vsock/virtio: discard packets only when socket is really
 closed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160617900550.21796.14853445462990216218.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 00:50:05 +0000
References: <20201120104736.73749-1-sgarzare@redhat.com>
In-Reply-To: <20201120104736.73749-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, slp@redhat.com, davem@davemloft.net,
        justin.he@arm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 20 Nov 2020 11:47:36 +0100 you wrote:
> Starting from commit 8692cefc433f ("virtio_vsock: Fix race condition
> in virtio_transport_recv_pkt"), we discard packets in
> virtio_transport_recv_pkt() if the socket has been released.
> 
> When the socket is connected, we schedule a delayed work to wait the
> RST packet from the other peer, also if SHUTDOWN_MASK is set in
> sk->sk_shutdown.
> This is done to complete the virtio-vsock shutdown algorithm, releasing
> the port assigned to the socket definitively only when the other peer
> has consumed all the packets.
> 
> [...]

Here is the summary with links:
  - [net] vsock/virtio: discard packets only when socket is really closed
    https://git.kernel.org/netdev/net/c/3fe356d58efa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


