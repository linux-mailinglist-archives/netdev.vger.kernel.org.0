Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E0346C31D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240738AbhLGSxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240730AbhLGSxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:53:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995B1C061748
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 10:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DCB2ECE1DCA
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 18:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13DE0C341CD;
        Tue,  7 Dec 2021 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638903009;
        bh=SAPHEg+pMrvHXjutpEiIC6bsgmppRZPlwyv4b/RsruE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J1t5XIrGKBZeCpzCjS6MNDmXPv9lZTwPVG3f1ptaUoQVfhVZCaBtsxGSPC6XvQCvl
         dhroEKuI4YmsYKXcG7MsrAgbyjA+Xkngl1te3RhY/b9mxC9N788Yf9rjiZPepSHii1
         0GtD11uUXjxHuSLTEyERumDMcFsxJG6MgbPSSjvGWO5MnurBUJHNZXVZ09DPFgCd43
         2Vo1QIwTMg0H72jUNG7gwppLtLUR7rBAgg7uPihUTT11X4wwELiB8vfYjvoaTbdA92
         zsxZ+QqqekwN8tINYo4ZMEaogtLcKkQcLB/5lLeyx49+JQnxzV0moA2cMiU41lFKjs
         vreSVgt/3jBow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01F3060973;
        Tue,  7 Dec 2021 18:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] vrf: use dev_replace_track() for better tracking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163890300900.2839.12838248750139664703.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 18:50:09 +0000
References: <20211207055603.1926372-1-eric.dumazet@gmail.com>
In-Reply-To: <20211207055603.1926372-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 21:56:03 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> vrf_rt6_release() and vrf_rtable_release() changes dst->dev
> 
> Instead of
> 
> dev_hold(ndev);
> dev_put(odev);
> 
> [...]

Here is the summary with links:
  - [net-next] vrf: use dev_replace_track() for better tracking
    https://git.kernel.org/netdev/net-next/c/c0e5e11af12b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


