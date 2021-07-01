Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2233B97B2
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhGAUjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234094AbhGAUjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 16:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46A18613B1;
        Thu,  1 Jul 2021 20:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625171791;
        bh=ZE4tFtjfCQNOGPmXqOpezZROMBoZaOsgyKX+e7p+gyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=clg0q8nu9Zq7nst4nq7pDvs6W4IMtNH1Nd/NrxfAQkoEnUC2XjM8Quh9fQzgU4erO
         vqxAm9b2usf+66LM4v12vH1Ff/e+ANHaxi+Na0LKEaPBN59HuUfs00KN7kzlYHYFc1
         Byxi3MkTbuUjX1uNBrp+9QiMZxnEd4vA9+RP/Tt+osVyaDFDUDPbIj5jNZ+qNfiuzq
         rC7mT04Z1fpWaeFNXxq8ksBmI59SX+de2a038RSKIz9RtNh4kBdpUl7Bv/zACIaMxM
         ySESZSHZQT4ogucHILqtMMKZVwAHrqiFZRa1MayOKviBXhzxvAU913ZradjmMUfcCJ
         KhK6Lfv9+5Giw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A39A60A6C;
        Thu,  1 Jul 2021 20:36:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] udp: annotate data races around unix_sk(sk)->gso_size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517179123.24244.3878247862813369134.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 20:36:31 +0000
References: <20210630164244.2180977-1-eric.dumazet@gmail.com>
In-Reply-To: <20210630164244.2180977-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, willemb@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 30 Jun 2021 09:42:44 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Accesses to unix_sk(sk)->gso_size are lockless.
> Add READ_ONCE()/WRITE_ONCE() around them.
> 
> BUG: KCSAN: data-race in udp_lib_setsockopt / udpv6_sendmsg
> 
> [...]

Here is the summary with links:
  - [net] udp: annotate data races around unix_sk(sk)->gso_size
    https://git.kernel.org/netdev/net/c/18a419bad63b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


