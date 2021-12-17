Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF52D4788EB
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 11:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhLQKaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 05:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbhLQKaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 05:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44001C061747;
        Fri, 17 Dec 2021 02:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D2C9B8279B;
        Fri, 17 Dec 2021 10:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBC05C36AF0;
        Fri, 17 Dec 2021 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639737010;
        bh=JGG/5b4xfabd5m11mQqXSOTQJgvcVfZngAdFfzawOuk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hNzJe4+zxB5y7zss4MFKkVIxIyDi2keuTzY5M28zstWinZ6jDRFXCv/o8NH6XbrNw
         Gk8Pago3JxSh1O3rRLT2TqqVNRt9DIYSy7wsgD/0rCon3Z4vJxjqFL0T9igApUpOyU
         nuSYEpdD1S5Y8ud8/6tFuLl6Yhev6bHTEjogtTK/7u5OENMStpggG5vzDWBo+KjZSl
         FDGF2ApuqMtS+AIkAOPcwie9EB1ukYla9OgLSenCpdEBSAAgu0y+W8ePLgorjzxait
         P96/Fo8vXaumZ8yweicN98lctTIRLWVkDgrnGFP+QxmgjdXf4BaiYHcWrQ2cizgreL
         Hhd1zJGVRLWeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A875260A39;
        Fri, 17 Dec 2021 10:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: microchip: remove unneeded variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163973701068.8885.11332790789818470442.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 10:30:10 +0000
References: <20211216091339.449609-1-deng.changcheng@zte.com.cn>
In-Reply-To: <20211216091339.449609-1-deng.changcheng@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        deng.changcheng@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Dec 2021 09:13:39 +0000 you wrote:
> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> Remove unneeded variable used to store return value.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net: dsa: microchip: remove unneeded variable
    https://git.kernel.org/netdev/net-next/c/86df8be67f6c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


