Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315D13662E3
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbhDUAKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233925AbhDUAKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 02485613AB;
        Wed, 21 Apr 2021 00:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618963810;
        bh=aEFN1j86mjrs+AI3p0w/G35OcT0kIvgBU/+Q6X+dcCU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IUPM+tdYkdrd+P+jNL+T3vGsq+OROeDHPOOJ6YF0M4/PfUSuTKwPiS0qZ6zBEBEeg
         GpP6tiRciRfgg7XWyK4eCZGGGobz06il2lwWVyd5eM1bugzvOkFl26jYMEYcm9AZHV
         3wpegrUy0GCoRr7B4lecAFi7mE0W8gbS4vLj/A6l8cbMbwTAJh24I2wgHX9V9CrAol
         3UZnUOaHowmGUo+Fsd8MHFAmTqzY6UJZY++PNyN5EghrUkuZOF3r2EpvHCNbSuE9WW
         jYYrMu2hapiyClj7ZFykKRgea3SdEBLtWIdASgAWrE73UCr5+7kRhMRxPtPXAXzQTl
         LE2gwfqLW+pPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EBCB360A0B;
        Wed, 21 Apr 2021 00:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vsock/virtio: free queued packets when closing socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896380996.7038.17484390718444445248.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:10:09 +0000
References: <20210420110727.139945-1-sgarzare@redhat.com>
In-Reply-To: <20210420110727.139945-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, stefanha@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Apr 2021 13:07:27 +0200 you wrote:
> As reported by syzbot [1], there is a memory leak while closing the
> socket. We partially solved this issue with commit ac03046ece2b
> ("vsock/virtio: free packets during the socket release"), but we
> forgot to drain the RX queue when the socket is definitely closed by
> the scheduled work.
> 
> To avoid future issues, let's use the new virtio_transport_remove_sock()
> to drain the RX queue before removing the socket from the af_vsock lists
> calling vsock_remove_sock().
> 
> [...]

Here is the summary with links:
  - [net] vsock/virtio: free queued packets when closing socket
    https://git.kernel.org/netdev/net/c/8432b8114957

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


