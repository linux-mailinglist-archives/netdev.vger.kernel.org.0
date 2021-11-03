Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311D544431B
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhKCOMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhKCOMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:12:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3686E61175;
        Wed,  3 Nov 2021 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635948608;
        bh=rbTVyHS8EVYIVgPrll+0qcMk7ofRPEu9mdb2Nkpu80M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FzVmtPnQvnm0KkrhZvlGg8h8zXIvVh7cplIvssy6px+OC/9Q0gwQZJeRdtumt062w
         k69MDKnya1LakXSLykiulBlHiAieRrXroQISfr9rP59Qx4AlVcwN/M2LjGUM2R//qH
         b9rr871dNm/AXJ69XeqEWBipq8jDPzOimjqIUASbobdfS70ztQKeVrviu1mDfzIYp6
         9ljAHD1YrxcS+ooGjGw4c6it4ZCbgtI07xuNM1mvEIPgoYI6xoiWb6N53NaLQ/L8YJ
         jUKHw3J4qD/xQJRb6g7B4CQVZ9XnN5OWbjk0Ebc+Nq4ukrHaNbSMoeAN+hYJ5nTs00
         yN27kB2sNDLhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 273C7609CF;
        Wed,  3 Nov 2021 14:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: avoid double accounting for pure zerocopy
 skbs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163594860815.30241.9867591652285399304.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 14:10:08 +0000
References: <20211103025844.2579722-1-mailtalalahmad@gmail.com>
In-Reply-To: <20211103025844.2579722-1-mailtalalahmad@gmail.com>
To:     Talal Ahmad <mailtalalahmad@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com, willemb@google.com,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        cong.wang@bytedance.com, haokexin@gmail.com,
        jonathan.lemon@gmail.com, alobakin@pm.me, pabeni@redhat.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com, elver@google.com,
        nogikh@google.com, vvs@virtuozzo.com, talalahmad@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  2 Nov 2021 22:58:44 -0400 you wrote:
> From: Talal Ahmad <talalahmad@google.com>
> 
> Track skbs containing only zerocopy data and avoid charging them to
> kernel memory to correctly account the memory utilization for
> msg_zerocopy. All of the data in such skbs is held in user pages which
> are already accounted to user. Before this change, they are charged
> again in kernel in __zerocopy_sg_from_iter. The charging in kernel is
> excessive because data is not being copied into skb frags. This
> excessive charging can lead to kernel going into memory pressure
> state which impacts all sockets in the system adversely. Mark pure
> zerocopy skbs with a SKBFL_PURE_ZEROCOPY flag and remove
> charge/uncharge for data in such skbs.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: avoid double accounting for pure zerocopy skbs
    https://git.kernel.org/netdev/net/c/9b65b17db723

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


