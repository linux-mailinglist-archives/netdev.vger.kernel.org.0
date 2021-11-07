Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3327844754E
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 20:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhKGTmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 14:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233578AbhKGTmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 14:42:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 226B261265;
        Sun,  7 Nov 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636314008;
        bh=IRUCVWRed4jolBeSzyLEhMzJk8JPJsIBESOG/kEdXNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JMhXoz59OVmWCM/svmqjgHKUG8HulaXNPzSWlk5HASFTi2c2+MZ29ps/vzfkEBABG
         QJWcF6j3fr+aZr562Nsb/F6o2ob0rkQgtjOx1srGJAVZMAtnSfif61w3rEaNoNAZK5
         DyGanFzPq8TFKFLvXJ+fzNrrm18tTIzNfJhOJ1TMkBy+1VucJnxVYAh8yEAxuKcHyT
         ipeZuaySboZ859q2u5lBv/wQILWwgUzgPU3j4pEEjfgIo+yKXGOEFmNs3yWJjcJq+H
         o2e5dZqP7kjs6R0ifUc3vpGg0dMiOmM+wroZCoGAzxdXzypKXOpwfdbeKavyhZF8X4
         YRxrxmJ+6jdqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0345A60AA2;
        Sun,  7 Nov 2021 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: tls: remove unused variable and code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163631400800.18215.15713746586440850883.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Nov 2021 19:40:08 +0000
References: <20211105164511.3360473-1-anders.roxell@linaro.org>
In-Reply-To: <20211105164511.3360473-1-anders.roxell@linaro.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 17:45:11 +0100 you wrote:
> When building selftests/net with clang, the compiler warn about the
> function abs() see below:
> 
> tls.c:657:15: warning: variable 'len_compared' set but not used [-Wunused-but-set-variable]
>         unsigned int len_compared = 0;
>                      ^
> 
> [...]

Here is the summary with links:
  - selftests: net: tls: remove unused variable and code
    https://git.kernel.org/netdev/net/c/62b12ab5dff0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


