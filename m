Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBF4364DAA
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhDSWas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhDSWaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5AF9D61363;
        Mon, 19 Apr 2021 22:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618871416;
        bh=NPK0VEnzK7N0xDdPjhZMCqz4EE6izdgsrm+st0OxC1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dDFWKp2Q/pVj2PZJbMBhgwcNGhV7TI42bBPlbth7XBVvlk+a0X2DNY5WHGAtBozgM
         TVhCyUPuoSGa6Z6ov1hbO3heBPdvrsz0gzP70JCeud1yXruc1iNjjyDLzIJkLKMYBr
         wBzcqqOH7kH30YlMQMAaYqfVWXZTOLYeth8YeoBwUbojjrY8YhpHZ4yPxy1Kn3cljU
         F206R4X2fyGU8TY1oOSZ18qOIh1qNeYtHUYG8TtQ/onH1Pw7fHinxxEeP6d5UXCsIc
         DdZ4fiFpS6UKuozvk5HeCRVx785bIFSrAjAPWpxnVUxclHJddw98o1HTh74H7dorrM
         DS/431Y4eF1+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C9186096F;
        Mon, 19 Apr 2021 22:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] nexthop: Support large scale nexthop flushing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887141630.15331.9117921132455437371.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 22:30:16 +0000
References: <20210416155535.1694714-1-idosch@idosch.org>
In-Reply-To: <20210416155535.1694714-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, petrm@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 18:55:33 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 fixes a day-one bug in the nexthop code and allows "ip nexthop
> flush" to work correctly with large number of nexthops that do not fit
> in a single-part dump.
> 
> Patch #2 adds a test case.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] nexthop: Restart nexthop dump based on last dumped nexthop identifier
    https://git.kernel.org/netdev/net-next/c/9e46fb656fdb
  - [net-next,2/2] selftests: fib_nexthops: Test large scale nexthop flushing
    https://git.kernel.org/netdev/net-next/c/bf5eb67dc80a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


