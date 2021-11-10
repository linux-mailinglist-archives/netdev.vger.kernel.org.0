Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CBA44C332
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhKJOpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:45:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232260AbhKJOnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:43:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9893861261;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555208;
        bh=OqFMe+nG0ebDVROXo1imztodhqjMRNdfUdOrUUGb6D8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lGLaotzEbxflTTOLAiGPU5qFdU8bVmyjyLorYHntjnFA6G59IraG0+KoNIl03prLF
         G6ZuGIwqyeTdgj1G7BFCgVbXVoiO6e1izTKd9NKl6ywgzjpppRUVoUQ2zD+rn+c2Ez
         BwX4ni6hX0qDTSHnsbtHTJK0MdLfNYLGsPArNxXVmpr1UtTNLd42IJJRi2FAnHf6Aj
         /cSMBl8DgQY/APDFAvjczO81O14UxoqFgUjsoqkdCsBC6hFuaI7mNMXcElHljaRFKL
         mUwobfQQKt2RKmvfOU8CrhDa7IyjMoPOITNa44H+oZ9MZcQnIKs/N95Y9RitKzFa0H
         QGEE/YV2+QUYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8C38460C18;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: mvpp2: Fix wrong SerDes reconfiguration
 order
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655520856.19242.9463402203348510885.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:40:08 +0000
References: <20211108214918.25222-1-kabel@kernel.org>
In-Reply-To: <20211108214918.25222-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        rmk+kernel@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  8 Nov 2021 22:49:18 +0100 you wrote:
> Commit bfe301ebbc94 ("net: mvpp2: convert to use
> mac_prepare()/mac_finish()") introduced a bug wherein it leaves the MAC
> RESET register asserted after mac_finish(), due to wrong order of
> function calls.
> 
> Before it was:
>   .mac_config()
>     mvpp22_mode_reconfigure()
>       assert reset
>     mvpp2_xlg_config()
>       deassert reset
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: mvpp2: Fix wrong SerDes reconfiguration order
    https://git.kernel.org/netdev/net/c/bb7bbb6e3647

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


