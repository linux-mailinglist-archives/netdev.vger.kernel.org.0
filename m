Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D604A315AA8
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbhBJAHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234370AbhBIXlT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 18:41:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 19F2E601FF;
        Tue,  9 Feb 2021 23:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612914019;
        bh=kbUSErCIqbQNZP6bznTc3ENEP22PQTAYqm+t2SqVG6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S6pFzKU+6eEqRN/jMgK7HDiBAxDGQhVbcmlDo8PC+FiSYx5x8Z4mQWu4YTJZ73WZl
         ghEky4BpF2UUXkf6EzI51c5508XnWV5zdFRDs19pkF06h4wk2/eG21UMg/tBInZo3X
         BXZ/tiPt52G++kANgLcIxEocYiNjrzABNkGydT/kTdQ4js5WA12dU6+qmOtCkiVAMy
         UD6RwXtQnF6dJ9sHMal1EqWidh5xXeRGPzS/43OT7Sbv6DHrBT1ee5DNYEeNh1nIzJ
         8zG0eC31cAfnQq79+VBt3qni3mY2qTVsxw+hRnkVfvswuEbmQ+9WXMvlgJ9WrhHQ9z
         AwGUtqqeBhBBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08ACB609E4;
        Tue,  9 Feb 2021 23:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] vsock: fix locking in vsock_shutdown()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161291401903.27742.9260442336714837672.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 23:40:19 +0000
References: <20210209085219.14280-1-sgarzare@redhat.com>
In-Reply-To: <20210209085219.14280-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     kuba@kernel.org, haiyangz@microsoft.com, wei.liu@kernel.org,
        kys@microsoft.com, jhansen@vmware.com, davem@davemloft.net,
        netdev@vger.kernel.org, sthemmin@microsoft.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        georgezhang@vmware.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  9 Feb 2021 09:52:19 +0100 you wrote:
> In vsock_shutdown() we touched some socket fields without holding the
> socket lock, such as 'state' and 'sk_flags'.
> 
> Also, after the introduction of multi-transport, we are accessing
> 'vsk->transport' in vsock_send_shutdown() without holding the lock
> and this call can be made while the connection is in progress, so
> the transport can change in the meantime.
> 
> [...]

Here is the summary with links:
  - [net,v2] vsock: fix locking in vsock_shutdown()
    https://git.kernel.org/netdev/net/c/1c5fae9c9a09

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


