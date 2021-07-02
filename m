Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF06F3BA426
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhGBTCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhGBTCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 15:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1232B6141C;
        Fri,  2 Jul 2021 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625252406;
        bh=mIsxhf2Wu35gIRSP3YQ9ctpYa5BLfocD942px4qzATI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RGkP5gPhrwNaGHnJoAKiUQWzvxnTQCD/quzt7tnbWaPPhUarIuThQxSJgzonXI4sa
         zCpYTp7/JsIxqy5NW4Y51iLh5Pr4HyHai3Mb7vQkdojdVNkBEf1s2RNL5PN0JrTkir
         BiPiA1xj96EVQx0qhjF/EyndVWMANY8X5m5hHqUAJBx+akQApde0Xw3lZxlj9T0DEL
         1cFDqzsoKheZc6r6/Ma34QbGbWJuif4PsgJR8qqDJeWBG01pdStyUX6P4mRZk+Jyrb
         9EXGI3rBqcIy6O6DIi42ndvDsGpweqpMY0ToFN43174fPqlLahCJHjlCG+63jp6arR
         svn7+HMmkZH0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0093960A4D;
        Fri,  2 Jul 2021 19:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: ipv6: fix return value of ip6_skb_dst_mtu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162525240599.2935.13711217412796494226.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 19:00:05 +0000
References: <20210701234700.22762-1-vfedorenko@novek.ru>
In-Reply-To: <20210701234700.22762-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        dsahern@kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  2 Jul 2021 02:47:00 +0300 you wrote:
> Commit 628a5c561890 ("[INET]: Add IP(V6)_PMTUDISC_RPOBE") introduced
> ip6_skb_dst_mtu with return value of signed int which is inconsistent
> with actually returned values. Also 2 users of this function actually
> assign its value to unsigned int variable and only __xfrm6_output
> assigns result of this function to signed variable but actually uses
> as unsigned in further comparisons and calls. Change this function
> to return unsigned int value.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ipv6: fix return value of ip6_skb_dst_mtu
    https://git.kernel.org/netdev/net/c/40fc3054b458

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


