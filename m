Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FFC326A82
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhBZXuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhBZXus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 77ED964F0E;
        Fri, 26 Feb 2021 23:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614383408;
        bh=PSDWdYYOyJ2l0Zb+/vu+P3Jcjxk0SCsUiHh2IbxBvSk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fynFp58yV4Bx5OTanqtQwDqVrVXOuBnMg4k60h7SoJuvmCwk85CeurWyg7Fer2ZGu
         NLiZO+UEgr/eot2Q5x5hiq3BuCZT16os9ZIp6Eg0T1oK1jC7c6kKzagE/WNBt2u1du
         Efbmjr+y/zKvTJ54U7eB/5fSw0AE79ZYKyhxnQWkoPSCqQxdOI+pucdcpDGTD80IWt
         NJEmH0Sh/ct6nugTLOzR6n1eHqZQJczZYctsH1Tl98QQQOVsZvK5ERnfvYVfoL19nW
         0XCTndvxYKYLncMTheCY1Z/JzG4mCC/xkozRZEBMl9xOaa+kzGVSnjrZEpQb/8dc/T
         /8NnQWGWvo2UA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C40860A23;
        Fri, 26 Feb 2021 23:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] tcp: Fix sign comparison bug in
 getsockopt(TCP_ZEROCOPY_RECEIVE)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161438340843.31866.11887686015275071765.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Feb 2021 23:50:08 +0000
References: <20210225232628.4033281-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20210225232628.4033281-1-arjunroy.kdev@gmail.com>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com, lkp@intel.com,
        dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Feb 2021 15:26:28 -0800 you wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> getsockopt(TCP_ZEROCOPY_RECEIVE) has a bug where we read a
> user-provided "len" field of type signed int, and then compare the
> value to the result of an "offsetofend" operation, which is unsigned.
> 
> Negative values provided by the user will be promoted to large
> positive numbers; thus checking that len < offsetofend() will return
> false when the intention was that it return true.
> 
> [...]

Here is the summary with links:
  - [net] tcp: Fix sign comparison bug in getsockopt(TCP_ZEROCOPY_RECEIVE)
    https://git.kernel.org/netdev/net/c/2107d45f17be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


