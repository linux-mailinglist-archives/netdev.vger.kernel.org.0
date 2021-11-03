Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D90444317
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhKCOMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230527AbhKCOMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:12:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 19EA5610FD;
        Wed,  3 Nov 2021 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635948608;
        bh=BBg/FnAjGaRt92WhYyr7ILk51DRhyJHZCYUUgze85xg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iPA/TA7h5bZbeH+o6q4jXKpcXePojLy/PlS87HDrfUt0Ovf/BCQ21xVFG4mm7jCbk
         srI5W+tql+jSOlZzW3oOJgibBSpHLS9MnFf0PQQPc+EJRQR8w370+IjHQl5GEf8czJ
         JiGR0METeE7IwDrqroMKqYZmwK56yDbRcJJZdy7xV8SqiSDAm5I4oKTIVjbf/QubPx
         HXvchZ2jZJShxENTz14396YfLqCXoQZCZ+8/JXizTlx0AiiYoi3hw5X4NCbuSuCuE+
         +imG5Xlinllt8ofa0AROqasiVm6DoYsfw1f4ebB6STHnXQgJQrjRH76+MiKc9Cg6kq
         Z2KhQL6giHs9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E06C60176;
        Wed,  3 Nov 2021 14:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: udp6: replace __UDP_INC_STATS() with
 __UDP6_INC_STATS()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163594860805.30241.17271851271113294575.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 14:10:08 +0000
References: <20211103082843.521796-1-imagedong@tencent.com>
In-Reply-To: <20211103082843.521796-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     yoshfuji@linux-ipv6.org, davem@davemloft.net, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imagedong@tencent.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  3 Nov 2021 16:28:43 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> __UDP_INC_STATS() is used in udpv6_queue_rcv_one_skb() when encap_rcv()
> fails. __UDP6_INC_STATS() should be used here, so replace it with
> __UDP6_INC_STATS().
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: udp6: replace __UDP_INC_STATS() with __UDP6_INC_STATS()
    https://git.kernel.org/netdev/net/c/250962e46846

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


