Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20857310423
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhBEEkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:40:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbhBEEks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9206664FBF;
        Fri,  5 Feb 2021 04:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612500007;
        bh=nhrKPEu6vHyKEhDVtPmarEbewnIXzip7XxWxfwCwnG8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MKL6MyLbNoDahXK/r3Ai8QZAhD8KjxnhMZZCHFxbLybcskrHDbxV8oRyFI9F5KTuw
         G6/U9dhaaUTWy5MR7eQKBK4bgiKKrZi4HO6b3WJg/rjtiu/V6+4V4EmIDcGxQPwv5T
         gIenMxZMwxvXCRqsfuxas9qFxtarjiSCqpDNWLWrtmMH6pzPR0OMKgPyLE5WaOoRe5
         tVDrYGjTR5Ppw1iVYRo+3+SRpErtc9l8/JKCi9zw4FQzVshjUrxneMH1oLCH+CYGFw
         IDn0FFz6KB8jObR/8EX0E34Hw96xq2YzRhHA9yf+Cjn/igEZ83Fg4y9s5hMbUdRoyG
         zs8A3nYFA+QiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 808B5609F3;
        Fri,  5 Feb 2021 04:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v4] selftests: txtimestamp: fix compilation issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161250000752.27819.13164862274576764733.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 04:40:07 +0000
References: <1612461034-24524-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1612461034-24524-1-git-send-email-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     kuba@kernel.org, jianyang@google.com,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Feb 2021 20:50:34 +0300 you wrote:
> PACKET_TX_TIMESTAMP is defined in if_packet.h but it is not included in
> test. Include it instead of <netpacket/packet.h> otherwise the error of
> redefinition arrives.
> Also fix the compiler warning about ambiguous control flow by adding
> explicit braces.
> 
> Fixes: 8fe2f761cae9 ("net-timestamp: expand documentation")
> Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> 
> [...]

Here is the summary with links:
  - [net,v4] selftests: txtimestamp: fix compilation issue
    https://git.kernel.org/netdev/net/c/647b8dd51846

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


