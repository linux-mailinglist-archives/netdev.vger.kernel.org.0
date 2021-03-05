Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD54732F52B
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCEVKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:10:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhCEVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6A076650B0;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614978609;
        bh=HImJ3ds2JUI8CXhpIYg07+5NVQogfm4xzRM1yFy+rfw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ed1kD4Syj4zMhtynJl5nJFqbxeG8Tvt8YNTgd1GHJ7d8e/KMTMg7xC5T2eHDXdTCq
         3xKlMsrO+7DAr2k1V2yHye/TN8hMjn3L2GlUZd4pDniCQYuWuslNUXaRHoj9qzILak
         W/sz7vVHBlJTAslgzzi99i8spcQVOoOr7EC+jEQgPIGKMqykni3Ygz/kwFAfEhaW0A
         BjiPcSP73msvfeBsqLz2Bj/VxmY52xiAIhQGa2QT7CMSldHljK/ZE511/4DX6OTrZp
         xjwhqCiRIuO6LC0VijIBkjl7XCQofzFb31fChjePunQgOm3VB5SFuepRZ352uvYgii
         yLUoX9ZWa1tug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 60844609EA;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftest/net/ipsec.c: Remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497860938.24588.3460986732299054232.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:10:09 +0000
References: <20210305093306.1403-1-vulab@iscas.ac.cn>
In-Reply-To: <20210305093306.1403-1-vulab@iscas.ac.cn>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Mar 2021 09:33:06 +0000 you wrote:
> fix semicolon.cocci warning:
> tools/testing/selftests/net/ipsec.c:1788:2-3: Unneeded semicolon
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  tools/testing/selftests/net/ipsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - selftest/net/ipsec.c: Remove unneeded semicolon
    https://git.kernel.org/netdev/net/c/0a7e0c3b5702

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


