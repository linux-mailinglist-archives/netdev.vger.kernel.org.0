Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D950238F4EB
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhEXVbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232911AbhEXVbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C7D5610CB;
        Mon, 24 May 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621891810;
        bh=lo6EILUQ1i18nWASD97hUQMB+qwDzeRWIWWlJTKTwMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fn1HTy2g+AEVk1I+5as2OVYci8j/r8vauY+0u/dQUbqCp+Qpe/R0/6jmqDBF+31H1
         esohNzr9biTCZtmRe/VXnrRkq+u+JvwJZjmozud0G/+GFoTJgA5F/UnBX7aK6iIU5N
         OmQU6Jitx3G3BFm/k32on4D3HG3KvkwpNIEgp+1SmeCKmH1zSzwC6AVDx2oYiTdRwZ
         MwGoMeLvvgbgnQ/XfVY9OIdGBFsVsZ5sJUI5OUZmXOTiQMwwMVulBmFxcaX+gsjyDM
         a+z5fymmitOELxotwsmATyeB9LG9FzO39lRGHTediG1M6p/tmdM0++6C6znhL+NGz5
         7aF3S1YTTHf7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 20F6560A0B;
        Mon, 24 May 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: microchip: enable phy errata workaround on 9567
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162189181013.16512.8256926089205340399.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 21:30:10 +0000
References: <20210524202953.70379-1-george.mccollister@gmail.com>
In-Reply-To: <20210524202953.70379-1-george.mccollister@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 15:29:53 -0500 you wrote:
> Also enable phy errata workaround on 9567 since has the same errata as
> the 9477 according to the manufacture's documentation.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] net: dsa: microchip: enable phy errata workaround on 9567
    https://git.kernel.org/netdev/net/c/8c42a49738f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


