Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66BA471A40
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 14:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhLLNAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 08:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhLLNAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 08:00:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC76C061714;
        Sun, 12 Dec 2021 05:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 50506CE0B53;
        Sun, 12 Dec 2021 13:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70EC5C341CA;
        Sun, 12 Dec 2021 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639314008;
        bh=H2l+xf2WeTwJXBbO9SZOz0IoqXaav2fWOq4Wutvwjek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SA7iwLgW36Yr5tI+gDE/hkdzXECmcQgyFIUKd2wMcR9jlfZBxtL6O/xoVHPCNbMcT
         d7+iIFDtPrXrjpTLDyoQNmTimw64ntwY7LskdWmRofeWAL+Q7vFJrJx3SPWz55Nurx
         v8x9DeagZJojjAmyjJANOAfbIDzj+iqG1FU8mQJnFf6VtVz7KQR3K4P2+DhKBylQxY
         Ck2++zEQkwMbQz44AE/f9I4udVoIGMQ63vK/V5U5jEuMn5CNDKuVt8u7LN774ds1i0
         Z9apXVO2bYiv5y6PoypwQy55VKNFKEEG1qXH9tXCfrP6YF3ieZCqNF5tcBJCIFomNd
         XZZ/ZF/RCPk7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 507DC60BD0;
        Sun, 12 Dec 2021 13:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2] selftests: icmp_redirect: pass xfail=0 to log_test()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163931400832.17396.4075834071106906036.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Dec 2021 13:00:08 +0000
References: <20211210072523.38886-1-po-hsu.lin@canonical.com>
In-Reply-To: <20211210072523.38886-1-po-hsu.lin@canonical.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        skhan@linuxfoundation.org, andrea.righi@canonical.com,
        dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 15:25:23 +0800 you wrote:
> If any sub-test in this icmp_redirect.sh is failing but not expected
> to fail. The script will complain:
>     ./icmp_redirect.sh: line 72: [: 1: unary operator expected
> 
> This is because when the sub-test is not expected to fail, we won't
> pass any value for the xfail local variable in log_test() and thus
> it's empty. Fix this by passing 0 as the 4th variable to log_test()
> for non-xfail cases.
> 
> [...]

Here is the summary with links:
  - [PATCHv2] selftests: icmp_redirect: pass xfail=0 to log_test()
    https://git.kernel.org/netdev/net/c/3748939bce3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


