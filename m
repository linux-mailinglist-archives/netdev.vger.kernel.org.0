Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9D643FC2C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhJ2MWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231561AbhJ2MWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FB1861166;
        Fri, 29 Oct 2021 12:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635510008;
        bh=+/MiXho13ttFALyUwOJ84SeSmvDVcnhe50qbDQfLPnk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yrv4KCFIY0IOhmb4TlUnHFD7MLXU6hGAaFloJ20tQDLNpc7EElB/2NOhFqMw2uISG
         fX6imeyLnBUOjrSANTbDZV8R00Ri1XZg1CFa1U+yCxB98mlekWMu7lqRml2Yo17ykh
         lroIvw8GLLpvN7Mu8YamvA7CYFNpSxUOZNYf090E9go5+89UWGPFLw1K/iPfKT1e2i
         9hYDpVEfAphBDAWjrAngNxvKvI2P7rkgNLs6aI4zaO75zxzcVP8ZHnYFArM5vrFnG7
         cMJcVBSDGejh9DzSCe25wArBNhji1gc0BQTBJJlD/cah24MwDpqOqHwyymFak1Z6mQ
         dkae/eaOeJ96Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 101D960A1B;
        Fri, 29 Oct 2021 12:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/net: update .gitignore with newly added tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551000806.18872.10622502595024109424.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:20:08 +0000
References: <20211027202846.26877-1-skhan@linuxfoundation.org>
In-Reply-To: <20211027202846.26877-1-skhan@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 14:28:46 -0600 you wrote:
> Update .gitignore with newly added tests:
> 	tools/testing/selftests/net/af_unix/test_unix_oob
> 	tools/testing/selftests/net/gro
> 	tools/testing/selftests/net/ioam6_parser
> 	tools/testing/selftests/net/toeplitz
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> [...]

Here is the summary with links:
  - selftests/net: update .gitignore with newly added tests
    https://git.kernel.org/netdev/net/c/e300a85db1f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


