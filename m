Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D64441EE6A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhJANVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231500AbhJANVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 09:21:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 872E661A51;
        Fri,  1 Oct 2021 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633094409;
        bh=BYN0nl+7sTQlhrv6Fh7jj7uMe2+EM4Q+yeOOj+4ObXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pC3mqmJz1VWxV7Yq2F8Nyf019izRWC08UWLeb9twWn4W4fk5iPbfBsR89tt3EbM6I
         8BlnoClj62xAPbCh18RTh+bFr1OLjYLIa/I/pxyUkElaxkBSq7LTZI2oxcoqKwCMvk
         siswEqR7vCFOaNbwtvHez5KS77rZNv+e9emSaCUwep+sZq2JorJdRnDmzjK9koP42p
         gtt+zdrFybc2cmwHohj+eJ/PvSSbS9wHtmK2bL46ut/5ANci5D5ooC104HOHezEdI9
         S2GQtU2IcyOzSjuBrHUuNL1yowZjfPBf15V31XpHq0WKr4Rp8c1nQ6YL7ByTfajuT4
         D6Q6sWSi+X/xw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7ABE960A4E;
        Fri,  1 Oct 2021 13:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] MCTP kunit tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163309440949.24017.15314464452259318665.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 13:20:09 +0000
References: <20211001081844.3408786-1-jk@codeconstruct.com.au>
In-Reply-To: <20211001081844.3408786-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, brendanhiggins@google.com,
        linux-kselftest@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  1 Oct 2021 16:18:39 +0800 you wrote:
> This change adds some initial kunit tests for the MCTP core. We'll
> expand the coverage in a future series, and augment with a few
> selftests, but this establishes a baseline set of tests for now.
> 
> Thanks to the kunit folks for the framework!
> 
> Cheers,
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mctp: Add initial test structure and fragmentation test
    https://git.kernel.org/netdev/net-next/c/8c02066b053d
  - [net-next,2/5] mctp: Add test utils
    https://git.kernel.org/netdev/net-next/c/077b6d52df6d
  - [net-next,3/5] mctp: Add packet rx tests
    https://git.kernel.org/netdev/net-next/c/925c01afb06a
  - [net-next,4/5] mctp: Add route input to socket tests
    https://git.kernel.org/netdev/net-next/c/d04dcc2d67ef
  - [net-next,5/5] mctp: Add input reassembly tests
    https://git.kernel.org/netdev/net-next/c/bbde430319ee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


