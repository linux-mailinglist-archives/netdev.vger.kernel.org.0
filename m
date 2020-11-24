Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D362C1A3A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgKXAuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 19:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbgKXAuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 19:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606179005;
        bh=mWX3o2qk17+bUiTKO3iifC0P95QFgx2k/HjFARfBBtw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bwqx9Yon0gMS6DU3XIKkfppC0HMTNwxUJz1cyryrcQjl/906zhOkWazZ9x29BYge4
         VM9lTUsYcgmMUit73vR2TSf8uDr897KmuF3GklXB5+4eE/qNFLX4U/9tpa2+pWwoPt
         jrXR2M7m24biCLQjnAxjqBOdpimS3IlsC0IEvTyA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8] tcp: fix race condition when creating child sockets from
 syncookies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160617900545.21796.10520657211346805305.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 00:50:05 +0000
References: <20201120111133.GA67501@rdias-suse-pc.lan>
In-Reply-To: <20201120111133.GA67501@rdias-suse-pc.lan>
To:     Ricardo Dias <rdias@singlestore.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 20 Nov 2020 11:11:33 +0000 you wrote:
> When the TCP stack is in SYN flood mode, the server child socket is
> created from the SYN cookie received in a TCP packet with the ACK flag
> set.
> 
> The child socket is created when the server receives the first TCP
> packet with a valid SYN cookie from the client. Usually, this packet
> corresponds to the final step of the TCP 3-way handshake, the ACK
> packet. But is also possible to receive a valid SYN cookie from the
> first TCP data packet sent by the client, and thus create a child socket
> from that SYN cookie.
> 
> [...]

Here is the summary with links:
  - [v8] tcp: fix race condition when creating child sockets from syncookies
    https://git.kernel.org/netdev/net/c/01770a166165

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


