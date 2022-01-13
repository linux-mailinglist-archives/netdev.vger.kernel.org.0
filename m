Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EAF48D8BC
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbiAMNUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:20:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48126 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiAMNUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C48C4B822B9
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 13:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AEF3C36AEC;
        Thu, 13 Jan 2022 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642080008;
        bh=3CFx1zei9a8PzoKPUMBLIs2Hhu4NmOL7LuYlpBmFaG0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZWTGaPhOM1+ZRhKDACUdGPpgkDKDtm/fz4ehN58g/62dAS4mmGVo0QXSBiWofJKfP
         up6hqt2w0gaAxwmzzuez0a1G2lwKcb3DvH7+tohlEKqgeaRnKVbWWpOEpapL5Rw9Cn
         6jn16YsKu0okrLbC+iFhjoeEm0kvWox5RJE9qdQ6cGGqis0OT/iOLoAoCfigLzodNC
         cnP8Doy2x/kFHHsTk7O1/RtcVhzLliuSBTmNq4aBD9OblH9tw/K6fZMrsnVHOeZxIk
         lfCwyR0Edx9+AeHzN7LhxQ8RxZnKjI6YXG4xsHHxJPkGF3t6E8u/2BKy86iACqE7FW
         /bxSSHyKcOxyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62B90F6078E;
        Thu, 13 Jan 2022 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] inet: frags: annotate races around fqdir->dead and
 fqdir->high_thresh
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164208000839.5823.11612004213235362875.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Jan 2022 13:20:08 +0000
References: <20220113092229.1231267-1-eric.dumazet@gmail.com>
In-Reply-To: <20220113092229.1231267-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Jan 2022 01:22:29 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Both fields can be read/written without synchronization,
> add proper accessors and documentation.
> 
> Fixes: d5dd88794a13 ("inet: fix various use-after-free in defrags units")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net] inet: frags: annotate races around fqdir->dead and fqdir->high_thresh
    https://git.kernel.org/netdev/net/c/91341fa0003b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


