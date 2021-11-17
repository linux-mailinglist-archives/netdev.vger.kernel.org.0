Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8D6453EDA
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhKQDXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230396AbhKQDXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 86EAE63215;
        Wed, 17 Nov 2021 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637119210;
        bh=sSUfABLQdF9YDwRa9Pk7YixVLtmEZSIaePeKomiJ1Hk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V3mAQcxJgnSMZZHKraU88DO036frGNLJP134vNpXo8LCu9V1Gh7QEXJcc0YmPUbmR
         cZkzbEEpcPhQl0KSngreuHBpy0SmhOzCRSSxqyRfaTueNHtBwLtSTkDOBwxnIjJrCF
         z6RCLxeSFyL7ZkuOxDZiwzSVzR0Vk2qvkouCMxrhuVyTGmXiymUi+nEzX5mGyR2Pbh
         WJZywGknYlRSnf/JKnFrAY8lmmg+NhMM3c+RlburyQvGtNrp/3FZRIFVMQBbknAidX
         3c4B7e5qp6FuwpTKiNH1i+cK1SjSYGI6y3RdAVcbbkquc49LOcCOXeutFPvSpXNvfH
         PHsiBzJTBmGRg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 73E2A609EB;
        Wed, 17 Nov 2021 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] r8169: disable detection of further chip
 versions that didn't make it to the mass market
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711921047.1664.5258002640578887021.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:20:10 +0000
References: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
In-Reply-To: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Nov 2021 21:50:11 +0100 you wrote:
> There's no sign of life from further chip versions. Seems they didn't
> make it to the mass market. Let's disable detection and if nobody
> complains remove support a few kernel versions later.
> 
> Heiner Kallweit (3):
>   r8169: disable detection of chip versions 49 and 50
>   r8169: disable detection of chip version 45
>   r8169: disable detection of chip version 41
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] r8169: disable detection of chip versions 49 and 50
    https://git.kernel.org/netdev/net-next/c/2d6600c754f8
  - [net-next,2/3] r8169: disable detection of chip version 45
    https://git.kernel.org/netdev/net-next/c/6c8a5cf97c3f
  - [net-next,3/3] r8169: disable detection of chip version 41
    https://git.kernel.org/netdev/net-next/c/364ef1f37857

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


