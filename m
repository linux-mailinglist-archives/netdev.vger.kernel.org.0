Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BCF33E133
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCPWKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhCPWKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:10:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 92DAA64E64;
        Tue, 16 Mar 2021 22:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615932607;
        bh=Ckolgmhb6UynbvPOOk6wjY/cS1qKkoU9r5GuQSyKnRA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sBJmqPFKdvQEQfjC53kyjom3KolzMEDtMJUdb2ph9653fOiQAx6FaiW2N3jCpDHu7
         UqXO1ctXTNUJwDPm8xk4W7ccfLex0BuCEjbrhLdzoEjJJrZwVYtFMpqQFoHVDCWSDo
         uXnSUXNkYQn8XfF3tCePWMTZkVTE1KVQyyUQh/m/lRubqxNSWTo1w4c8/l/rmEyUqS
         RtvR7iwx/hAaOG2EIsh0STj+++VYo27dHfaq+q7xkAhsfPnYJ5YSyGjbQmntJ1TIUH
         /ZzVIsNkaniqKELIDAobX7JRXVpFNkxH9PCETLyPuFMUjExKS+JhZUCd7Y8InyDys6
         uTDTvmfodb/lw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8371760965;
        Tue, 16 Mar 2021 22:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/net: fix warnings on reuseaddr_ports_exhausted
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593260753.31300.9732699152920059278.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:10:07 +0000
References: <20210316010429.624223-1-cmllamas@google.com>
In-Reply-To: <20210316010429.624223-1-cmllamas@google.com>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     willemb@google.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 16 Mar 2021 01:04:29 +0000 you wrote:
> Fix multiple warnings seen with gcc 10.2.1:
> reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializer [-Wmissing-braces]
>    32 | struct reuse_opts unreusable_opts[12] = {
>       |                                         ^
>    33 |  {0, 0, 0, 0},
>       |   {   } {   }
> 
> [...]

Here is the summary with links:
  - selftests/net: fix warnings on reuseaddr_ports_exhausted
    https://git.kernel.org/netdev/net/c/81f711d67a97

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


