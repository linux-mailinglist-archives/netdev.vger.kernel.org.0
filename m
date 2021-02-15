Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8026831B4FF
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 06:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhBOFUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 00:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhBOFUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 00:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B06464E6A;
        Mon, 15 Feb 2021 05:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613366407;
        bh=KySY0827Ymdz+190/ThhLawtuV5u1o5gaXQG0v/uRbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bVuU7gpKkvKC++OFG7DnXkiuk2LC3KoQNv7Gxy/qVMPT5l8i65A8cN7Y2VFzd22kb
         m1aBqVOwYRk0I3gyMf93qSoIqsloO8ipsQVMGMI3Il9GIweiDNPg79sEhYt8xSc4KV
         5MbEQk4HvKADp10WoErfIX6targ40wLBcQLEbjO7xuE/svcJbWmDIjOjdDj7pMVLDr
         XSYbslQ+V2TjYFaoQKgGJfwONKdfjQ3n01qDaBjWZKxRtmSzJrflHyowPSbdGRgX4Q
         61JAT1w73skh2aTybRTXi7ZmHxLYI0SfBTETOqvG6O+OKXTE3LhxCaFkS0i/3+sbNR
         dn3EDzhaOdayw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7999360977;
        Mon, 15 Feb 2021 05:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ss: Make leading ":" always optional for sport and dport
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161336640749.32200.2731615186585665830.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 05:20:07 +0000
References: <20210214080913.8651-1-astrothayne@gmail.com>
In-Reply-To: <20210214080913.8651-1-astrothayne@gmail.com>
To:     Thayne McCombs <astrothayne@gmail.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (refs/heads/main):

On Sun, 14 Feb 2021 01:09:13 -0700 you wrote:
> Doh! Sorry about that, here it is with the sign-off.
> 
> -- >8 --
> 
> The sport and dport conditions in expressions were inconsistent on
> whether there should be a ":" at the beginning of the port when only a
> port was provided depending on the family. The link and netlink
> families required a ":" to work. The vsock family required the ":"
> to be absent. The inet and inet6 families work with or without a leading
> ":".
> 
> [...]

Here is the summary with links:
  - ss: Make leading ":" always optional for sport and dport
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c7897ec2a68b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


