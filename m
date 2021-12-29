Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C42481739
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 23:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhL2WUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 17:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbhL2WUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 17:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1969C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 14:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BC77615AE
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 22:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB38AC36AF4;
        Wed, 29 Dec 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640816410;
        bh=WErMmzBjc5fqOl0TaSD0nWHOPsGTHmrzdVpoIxCtC0I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r+dESA883hcKcypgf4RzN4UjiKPnoXJ4X12vvQJww87btZh7WCFKgKNvjOU9DPMX5
         6LThefSpizl6gA7wotvJZUasmneA2WobnKI3IPaqBlSIlZimiDhAA4vlAfukyCmZYo
         Fxg/Q+Z18aNSNZ7+WxrHoHpCP9o5pplgOiOVoGPFn6+YbKzCCV84PbiLKvwuvFhN59
         Kn26vYpgBj6Rt6TVJFrtsVCJK3xkOJ9L1AWtPrPyhT8bv/ugDaKUuwBIjfqnFGGCBI
         mckBFJOmh8omWdDs4FHoD4FlsgYO8jVGMA1/NX5RltiFygurrs6beABmMMAbh6zhZC
         cmBZDDkcZAmkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7066C395DD;
        Wed, 29 Dec 2021 22:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: define new hwtstamp flag and return it to
 userspace
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164081641067.5072.17344318123889600722.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 22:20:10 +0000
References: <20211229080938.231324-1-liuhangbin@gmail.com>
In-Reply-To: <20211229080938.231324-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, hkallweit1@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Dec 2021 16:09:36 +0800 you wrote:
> This patchset defined the new hwtstamp flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
> to make userspace program build pass with old kernel header by settting ifdef.
> 
> Let's also return the flag when do SIOC[G/S]HWTSTAMP to let userspace know
> that it's necessary for a given netdev.
> 
> Hangbin Liu (2):
>   net_tstamp: define new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
>   Bonding: return HWTSTAMP_FLAG_BONDED_PHC_INDEX to notify user space
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net_tstamp: define new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
    https://git.kernel.org/netdev/net-next/c/1bb412d46ca9
  - [net-next,2/2] Bonding: return HWTSTAMP_FLAG_BONDED_PHC_INDEX to notify user space
    https://git.kernel.org/netdev/net-next/c/cfe355c56e3a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


