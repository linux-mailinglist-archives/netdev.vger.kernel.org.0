Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0D1401DE9
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243586AbhIFQBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 12:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243493AbhIFQBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 12:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA1EC60ED8;
        Mon,  6 Sep 2021 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630944006;
        bh=oSHEvD7VzntICJNmc1hic4KcSf8HhuxH6mVwdVDeso4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hlr6TBOep81WiJwvRVaN9hdkx03ShavtEBdfTIR9eGPCDLSHTvTTTI0UKEpiQiT4D
         969doVNTGsHamiAhTrWajtW3vcO4wrTe3MWgsZOXtj3jAZib3uSp8rDrPReFhv2yM+
         qwWyEe1a6IbG/CWDlbCk1p/X5nyEfreOTCBoECIJeSWHUTenJfKX/0YhdPUMB+1bXY
         L2Q07bKd/P7fk3AhENhLRaTN30cG6BT8dSNe5osZum2svVwYEZkl7LPC+yd8vVzLHK
         dYK6r66Z8otgSVSvO3vQPChn3Zb1/scQOyyFv09VbOm5/+iB7NEA2xsFGYwgCBKje4
         ZoFrhVwBkGTCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DEA1A60A37;
        Mon,  6 Sep 2021 16:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next 1/2] net: wwan: iosm: Replace io.*64_lo_hi() with
 regular accessors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163094400590.4713.10843179790386866340.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Sep 2021 16:00:05 +0000
References: <20210906124449.20742-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210906124449.20742-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     m.chetan.kumar@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  6 Sep 2021 15:44:48 +0300 you wrote:
> The io.*_lo_hi() variants are not strictly needed on the x86 hardware
> and especially the PCI bus. Replace them with regular accessors, but
> leave headers in place in case of 32-bit build.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_mmio.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [v1,net-next,1/2] net: wwan: iosm: Replace io.*64_lo_hi() with regular accessors
    https://git.kernel.org/netdev/net/c/1d99411fe701
  - [v1,net-next,2/2] net: wwan: iosm: Unify IO accessors used in the driver
    https://git.kernel.org/netdev/net/c/b539c44df067

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


