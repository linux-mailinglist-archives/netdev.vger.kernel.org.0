Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551B53F1832
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 13:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbhHSLao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 07:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236881AbhHSLam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 07:30:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7079D61152;
        Thu, 19 Aug 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629372606;
        bh=zkEAY0d5T2Xe8robTlfKSB6Ja91bwRsmQM/HAy/VRKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ak9bBoL8COJ9VYFi4d7aTzI1s4PDuv7DKb4zJIBv9BPttp1NNWPC3LDUIbagsXnU4
         YNjly24bPQ9jnmW6GjPeUEXiofyGFvdNUmeWZs1s7MKWb/pqOmfXvHmHX5Gg/F3IWe
         7av0zb/5CnjeNS1W+ANBXvAIHXV0l+hKBkRGQZH/Fye3DwM4KeW4UbqdFBudiLStMG
         FulXbpD1gGQek3eGYoc6JL5/QZc6TuLCFx5Q2SeXQZ5IU2XQJdSt9itqkbKS12q3/U
         cDUsiqIJyHrWSQvHNxwC62za1H17qf2XNW3o9SBF68ZBXxiSUvS/txbl1BJOPLCROR
         Y/BleqaAtH86A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 661EA60A89;
        Thu, 19 Aug 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] r8152: fix bp settings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162937260641.19400.8398331212911418806.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Aug 2021 11:30:06 +0000
References: <20210819030537.3730-377-nic_swsd@realtek.com>
In-Reply-To: <20210819030537.3730-377-nic_swsd@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 19 Aug 2021 11:05:35 +0800 you wrote:
> Fix the wrong bp settings of the firmware.
> 
> Hayes Wang (2):
>   r8152: fix writing USB_BP2_EN
>   r8152: fix the maximum number of PLA bp for RTL8153C
> 
>  drivers/net/usb/r8152.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net,1/2] r8152: fix writing USB_BP2_EN
    https://git.kernel.org/netdev/net/c/a876a33d2a11
  - [net,2/2] r8152: fix the maximum number of PLA bp for RTL8153C
    https://git.kernel.org/netdev/net/c/6633fb83f1fa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


