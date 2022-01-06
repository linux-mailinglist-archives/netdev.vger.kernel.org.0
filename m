Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92095486449
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbiAFMUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:20:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238772AbiAFMUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:20:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3134B820D1
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9709C36AED;
        Thu,  6 Jan 2022 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641471614;
        bh=Epg8W+meOnkQxOiBvsXpviVwCxEBuOV10kmt2zGa0ik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qircOMDhUNuTSwJoaaqz7I91VPL+i7NzO8aO9TSD7mePSC15cKMudP2MbAfIiZ5gN
         zYPERoPym1r0rYbZ8JqkcYZzcq9C84i1HkAlxSMYPgxB9dIMyXrLduPHZ6gNd9lJ3a
         aqr1ZefXeR4wwtZpv9h3wb2nSXybzY6KnLUJJVAeyEuaPUs6KRK450k4Vx1Ko9PAPx
         C+4LYtTg6C++kKTh2OAHSgRoJSh6zjOaeSoLbWs6KxVsEeupqs/m4LFtjqHJLOfLOu
         w7W+oV9RWgvOVMBvRJkbVFriweUJ9t7i/hAZz7g6ZRr9Zs/XUZw44RE+xAQgLAwNHR
         bsmeN/WMFtanA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A48ADF7940C;
        Thu,  6 Jan 2022 12:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/7] ipv6/esp6: Remove structure variables and alignment
 statements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147161467.27983.6972604539862625960.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:20:14 +0000
References: <20220106091350.3038869-2-steffen.klassert@secunet.com>
In-Reply-To: <20220106091350.3038869-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Thu, 6 Jan 2022 10:13:44 +0100 you wrote:
> From: luo penghao <luo.penghao@zte.com.cn>
> 
> The definition of this variable is just to find the length of the
> structure after aligning the structure. The PTR alignment function
> is to optimize the size of the structure. In fact, it doesn't seem
> to be of much use, because both members of the structure are of
> type u32.
> So I think that the definition of the variable and the
> corresponding alignment can be deleted, the value of extralen can
> be directly passed in the size of the structure.
> 
> [...]

Here is the summary with links:
  - [1/7] ipv6/esp6: Remove structure variables and alignment statements
    https://git.kernel.org/netdev/net-next/c/c6e7871894a3
  - [2/7] xfrm: Remove duplicate assignment
    https://git.kernel.org/netdev/net-next/c/2e1809208a4a
  - [3/7] net: xfrm: drop check of pols[0] for the second time
    https://git.kernel.org/netdev/net-next/c/ac1077e92825
  - [4/7] xfrm: update SA curlft.use_time
    https://git.kernel.org/netdev/net-next/c/af734a26a1a9
  - [5/7] xfrm: Add support for SM3 secure hash
    https://git.kernel.org/netdev/net-next/c/e6911affa416
  - [6/7] xfrm: Add support for SM4 symmetric cipher algorithm
    https://git.kernel.org/netdev/net-next/c/23b6a6df94c6
  - [7/7] xfrm: rate limit SA mapping change message to user space
    https://git.kernel.org/netdev/net-next/c/4e484b3e969b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


