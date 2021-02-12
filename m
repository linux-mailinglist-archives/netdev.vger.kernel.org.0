Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482CE3198A2
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhBLDKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhBLDKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 22:10:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 13BD464E2A;
        Fri, 12 Feb 2021 03:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613099407;
        bh=AM6QWpH8OijPmAm6t5mSuRZUOIv8mGaI+yGBHnGdRMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pXVyx/HaqxmpRSlAA2uT5LAnwaUlUPV3dBhowcRdbvfmUPWYcJTdqTe6m49N0ZO8y
         o6q14APuWEbIXKtoGD/LbjBWGQDgJiuODtX3slufA0TOIDfqMk7l+tq2lMBkYfdyCA
         DjEP/YkJnQ4DD2AkPmyDU8WQ03dxd7BC7kljzCG1HjFv+KhA3TFj0R9FG2ir3zdCaZ
         RNvZCt6o25JLhImTnBne257LKdJ2gJBJa7tckXOq2Y8SpGNph6N9AAoK06qcmXpzE9
         OMtEkt5wHuEcfn2VpDHsC54358bEknW0C4aLTC+hqK2w5QtJmQ5IFmIspkMm+iZ0yE
         ipcFxU0ydeK2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 033AA60A2B;
        Fri, 12 Feb 2021 03:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] tcp: Sanitize CMSG flags and reserved args in
 tcp_zerocopy_receive.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161309940700.759.4270372520568459860.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 03:10:07 +0000
References: <20210211212107.662291-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20210211212107.662291-1-arjunroy.kdev@gmail.com>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com, dsahern@gmail.com,
        leon@kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 13:21:07 -0800 you wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> Explicitly define reserved field and require it and any subsequent
> fields to be zero-valued for now. Additionally, limit the valid CMSG
> flags that tcp_zerocopy_receive accepts.
> 
> Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Suggested-by: David Ahern <dsahern@gmail.com>
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: Sanitize CMSG flags and reserved args in tcp_zerocopy_receive.
    https://git.kernel.org/netdev/net-next/c/3c5a2fd042d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


