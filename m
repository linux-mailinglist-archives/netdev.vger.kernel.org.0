Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7C2431973
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhJRMmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230515AbhJRMmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BF29360FC3;
        Mon, 18 Oct 2021 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634560806;
        bh=gjqZ3TRhYfzAWUt0j34PYC6gVKhTDNAxS7IgmynFDUo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Blf2Men3p3FlZYESMxiSFKRutARItt3TWM++4mlnxrCDqBPcxUt7P/a1ZY7xHvmDK
         06/Kkwk9AH2Rm+fbvPpaZyJaFKkMFSkGoEcoeWfMUF70cTdImKBKQUCSu+r3VHeF/c
         cjQ+V85kq0wydxurhRHMpiGtugajj4zaR9iQHv1t9o6LuB/uVXd0vPb0YPC0Yk3eH3
         KDQ3u0DCR60SL1/rscsslzQ7WXOIzpVcAxk9+jgSBAT3cteMiNGyWHdltLmyWs+kMc
         /l+szQP9J8xQyLdSZbKnffMU9yyRsAQI6nGTEwUS5/+wooIBW4PNrOEfExAtvdluCb
         ix3m3IQroRB6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B0867609F7;
        Mon, 18 Oct 2021 12:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: fix register definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163456080671.22515.9929678118226387428.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:40:06 +0000
References: <20211015221020.3590-1-olek2@wp.pl>
In-Reply-To: <20211015221020.3590-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 16 Oct 2021 00:10:20 +0200 you wrote:
> I compared the register definitions with the D-Link DWR-966
> GPL sources and found that the PUAFD field definition was
> incorrect. This definition is unused and causes no issues.
> 
> Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: lantiq_gswip: fix register definition
    https://git.kernel.org/netdev/net/c/66d262804a22

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


