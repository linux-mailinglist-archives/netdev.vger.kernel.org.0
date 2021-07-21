Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34863D12D1
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbhGUPJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232494AbhGUPJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6289261244;
        Wed, 21 Jul 2021 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626882604;
        bh=81Q6hrTZ9lUpnJZF3r3PL59vWz0XaDmEG7Hackf9dLY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ck77Chgex5ZJ3x5jL+PQppFZmswFWz/ykC5ovPuh1wawZQHKp7nW4w/q5fw3uYCqp
         BV7x569NbpTYOXEtYozovbeCzHwgXnQiaCBBunBAA8FH8tFUb89SipU1BZrrNQPWHF
         k1sd/pP2wfmBPaePgX/GhabXQ7XF/hHwOa8OzBjkPdDIYWZeKYRgupc1hQwDvS3Bbr
         9xd6T4LQKJdtY3aAknvTNfd/Dm3Xg0KSkY9QBMVhLqXJS9CmtWMQ+SY7+eLmtiT0LL
         w6jF9ZjTRkGm2/p7yKL2DWE0eUMZMWTsr0du9CV1ZzBihMx6N+ACh6tEZmT500RVgh
         JYUTt+6WVoIPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5570960CCF;
        Wed, 21 Jul 2021 15:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: update active_key for asoc when old key is being
 replaced
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688260434.19956.7821872857113679.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 15:50:04 +0000
References: <a1e260329384a040f11f0f393327e25cf909da2e.1626811621.git.lucien.xin@gmail.com>
In-Reply-To: <a1e260329384a040f11f0f393327e25cf909da2e.1626811621.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Jul 2021 16:07:01 -0400 you wrote:
> syzbot reported a call trace:
> 
>   BUG: KASAN: use-after-free in sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
>   Call Trace:
>    sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
>    sctp_set_owner_w net/sctp/socket.c:131 [inline]
>    sctp_sendmsg_to_asoc+0x152e/0x2180 net/sctp/socket.c:1865
>    sctp_sendmsg+0x103b/0x1d30 net/sctp/socket.c:2027
>    inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
>    sock_sendmsg_nosec net/socket.c:703 [inline]
>    sock_sendmsg+0xcf/0x120 net/socket.c:723
> 
> [...]

Here is the summary with links:
  - [net] sctp: update active_key for asoc when old key is being replaced
    https://git.kernel.org/netdev/net/c/58acd1009226

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


