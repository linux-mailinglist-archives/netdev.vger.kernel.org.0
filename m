Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EA4349DCE
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhCZAaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhCZAaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A032761A42;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718610;
        bh=PuOi5jv1ie5YlhMf7yLMEVApxUq8VnjQAMuUq/PifD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i/ee8cHailseT9cbQiluiQwyCyDGR4JgRPmBrR1lr0TazEvtdEPv1JkVfnhiFTXa3
         TsFiCRivqk1L5wdelTEbHfg4wIRRFS/S0xbvVScu1UpfF23WYTxyGXJFu/picDTMOC
         n9uEkSbx5WaDgvZBvGaEk8sf+WBMKTtXNzfZvuuCu4ynItZnFG+8OXQXJwW/9zQwvv
         K76cBAJ/qmtXza6uBZ29dSeGt7nx7+KNmQ+rV3PJ6u2xcpovJxoMlXxg4XO+SRxmjV
         oSNo0J7f2wogIITqhPZF3dgfYqO06ODcVSsM1dzIpxiAMg9RVQlFFozCf6viM83z7Z
         Fv+2MEaQYn67w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 93994625C1;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: micrel-ksz90x1.txt: correct documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671861060.2256.1453248702632302849.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:30:10 +0000
References: <20210324135219.2951959-1-dinguyen@kernel.org>
In-Reply-To: <20210324135219.2951959-1-dinguyen@kernel.org>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 24 Mar 2021 08:52:19 -0500 you wrote:
> Correct the Micrel phy documentation for the ksz9021 and ksz9031 phys
> for how the phy skews are set.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---
>  .../bindings/net/micrel-ksz90x1.txt           | 96 ++++++++++++++++++-
>  1 file changed, 94 insertions(+), 2 deletions(-)

Here is the summary with links:
  - dt-bindings: net: micrel-ksz90x1.txt: correct documentation
    https://git.kernel.org/netdev/net/c/3ed14d8d47bf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


