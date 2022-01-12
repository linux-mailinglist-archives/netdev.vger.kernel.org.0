Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E58948BDEB
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 05:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345471AbiALEkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 23:40:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52270 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237114AbiALEkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 23:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4D8B61853;
        Wed, 12 Jan 2022 04:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35467C36AEB;
        Wed, 12 Jan 2022 04:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641962410;
        bh=/iDc1vP9qu3HWgfZynaF0lDCyHogMu8of6i6IbAG/IE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PHPlxTEoW/VxMmVrsrYCuzSv65M5btggJuDD/KiUSE5csyxY1vkvFmrbKNmw+9A/a
         7NsMSm/moBjcUp+0R8QWKS1BVMVUDAyrUnuo2qQ2oKIsta+kLOi5NFeC4UUX+ktGMv
         hL8xt4fHDzzWqIGW9xLermkwsdyCMjFNIslBuNJk8zE37UrBoMv7OYW8Bp2ewTXm0t
         HMMl4Z43Y27WtlQX1iEaOSp5RChs4g5gbbr7ykeML5jrWZuUjYeWRw/jztopwCwOST
         VKFMDQZJFWMqReRtzsmHk1Mp+z4n3DHNJ0hDfXCYW7VWX7Jc/5KUtwXUp0uLyqSV/q
         3phJASE8/Erkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D7CCF6078B;
        Wed, 12 Jan 2022 04:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: ethernet: sun4i-emac: replace magic number with macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164196241011.16336.16287095642350727734.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 04:40:10 +0000
References: <tencent_71466C2135CD1780B19D7844BE3F167C940A@qq.com>
In-Reply-To: <tencent_71466C2135CD1780B19D7844BE3F167C940A@qq.com>
To:     Conley Lee <conleylee@foxmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, clabbe.montjoie@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Jan 2022 11:05:53 +0800 you wrote:
> This patch remove magic numbers in sun4i-emac.c and replace with macros
> defined in sun4i-emac.h
> 
> Signed-off-by: Conley Lee <conleylee@foxmail.com>
> ---
> Change since v2.
> - fix some code style issues
> 
> [...]

Here is the summary with links:
  - [v3] net: ethernet: sun4i-emac: replace magic number with macro
    https://git.kernel.org/netdev/net/c/274c224062ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


