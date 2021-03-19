Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC88B3425D6
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhCSTK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230391AbhCSTKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6C6F561981;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616181009;
        bh=0AKFf2FIkewWcAEebDVCMaQDwjgI/Dg2NxDvt8jYL4I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oVp5Zl/5vDfZQehIn1LJEGyyhZb2UHi7DoXIs5weQooZ7d/4Bm4vMEyqvPik7xo/Z
         NnHDU+mrJY8s3wURqquJjf/pOKlEamWagDu7mgGKOxu96P+tvt3mFkkaA2KmyOxSh+
         hN4/Gne8S90w33KB9ZYBiuonDBXGmYoF4LKfqQDBHv/Y84qMnVeAC6Ptms8tUVHtHe
         7NP1MDJ6GesMePTDgDOUyLxwmi88IWBWEXJUE3IG0g3nb56OxJI8Zv7wLwV5xyWbpf
         gQKsWmLVfMkt6dhNfB1e6HHFn3b3TVCAfa1DAX3mwt9A/oGHQ1wTyR1pRi1ugT36PE
         YDFs0+YBoEBbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 65228609DB;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: use lower_32_bits/upper_32_bits macros
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618100941.534.4220626933395606716.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 19:10:09 +0000
References: <9a7cfc5a-c4e2-f2a9-e256-856d0a69e4de@gmail.com>
In-Reply-To: <9a7cfc5a-c4e2-f2a9-e256-856d0a69e4de@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 09:58:36 +0100 you wrote:
> Use the lower_32_bits/upper_32_bits macros to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] r8169: use lower_32_bits/upper_32_bits macros
    https://git.kernel.org/netdev/net-next/c/b498ee3f7613

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


