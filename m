Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43661306C41
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhA1Eay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhA1Eaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 23:30:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D99ED64DD9;
        Thu, 28 Jan 2021 04:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611808211;
        bh=JNryH6PdNFkPPVm9LDLy2dvohHlknmSH5mEH1PxEfdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SmnY/48n3fEJFfPtQOYB7ROKVTMK5gL9I7RyTPXg8oIjnF7TrBOOHMtlcpfVbIW4I
         FcpRSHjdGt/tHQsB+TmeP02uMD6c9LybKZuG2c86PDM2QRCJOMEwx+xVMo7O0ZSLnR
         zd/U74TYk7EBMEmTf7YiMLuIZn7V02wQJx/nqSLsmsph+2RLDxj1CGhYZfFrRPO9Dm
         4c/FUMY7rnbV1k/Q8NYArGr5RRlS69xGOVwD4GSALEr/81yvpRY9Kv4faMGMm4JNbM
         QBSt9musPtHt99EaBIRmkVXecDf5Q9MGFTITTkR2ketm4BFjCz94Mev5Jkz1+zcsc5
         M+MFLYYWAMDZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC4DC61E3B;
        Thu, 28 Jan 2021 04:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 0/1] net: dsa: rtl8366rb: change type of jam tables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180821183.32652.1072996748549501874.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 04:30:11 +0000
References: <20210127010632.23790-1-lorenzo.carletti98@gmail.com>
In-Reply-To: <20210127010632.23790-1-lorenzo.carletti98@gmail.com>
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 02:06:31 +0100 you wrote:
> I was trying to see if there were some Intel 8051 instructions in the
> jam tables with Linus Walleij, when I noticed some oddities.
> This patch's aim is to make the code more consistent and more similar
> to the vendor's original source.
> Link to the Realtek code the actual patch is based on:
> https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl8366rb_api.c
> 
> [...]

Here is the summary with links:
  - [V2,1/1] net: dsa: rtl8366rb: standardize init jam tables
    https://git.kernel.org/netdev/net-next/c/d1f3bdd4eaae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


