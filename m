Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D0C481C7B
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbhL3NaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:30:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47156 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239536AbhL3NaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:30:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EE4A616F2;
        Thu, 30 Dec 2021 13:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 202BDC36AF5;
        Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871013;
        bh=meqJH54SvgL7sufkvfE/SjKDuHQtUO2qXCINJxSbhqA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mj449aUM4+1o4Wqt0X1LlnLazrQZfqfWZYG9+3suaidr9RLOxb38NxSygBSqazLoY
         goclTPEH70q9UBzuc4sFyDG/ZbalhIMZ69pWpO0n8XFFiHwN60k2caAEw9FYTvQTWV
         yK9kPSQxwwsoyThlP0UgXln2X8OtYy+G8Jud++MiSoWLmAsd7oi3K9IsfW4HkI/UEp
         FMjdTUAVIxbHH+y10Yvtq/IbYuCzKbbR4Lz40WUsisGmw8armVgf2zl9hYBzw18YyF
         msoO+DSmOLLuaVel9Z+H01rbOe0+TtYl6GTvzK3x1kiMtkX6xUZZxVaCotWcLNr8kk
         XcoMDgB7e96iA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09E16C395EB;
        Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lantiq_etop: avoid precedence issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087101303.9335.12344754417995539854.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:30:13 +0000
References: <20211229232725.4048-1-olek2@wp.pl>
In-Reply-To: <20211229232725.4048-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     davem@davemloft.net, kuba@kernel.org, jgg@ziepe.ca,
        rdunlap@infradead.org, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 00:27:25 +0100 you wrote:
> Add () around macro argument to avoid precedence issues
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/net/ethernet/lantiq_etop.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: lantiq_etop: avoid precedence issues
    https://git.kernel.org/netdev/net-next/c/b1cb12a27134

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


