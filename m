Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581603F2D96
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 16:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240733AbhHTOAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 10:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231854AbhHTOAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 10:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 150FC61075;
        Fri, 20 Aug 2021 14:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629468006;
        bh=qyICFgMaXrUjm4JQfSHn4vnsmudS3YQTv3hTMZwySNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CeoOWXF9DCWLe0hLTQEcPoIXtbkcOsxiBIf2UNwgfIWAveZEktgi1BidgC/LYfo3V
         wJZ/qLOdG3lfaTV+T+i3Z5ok6qXsXpB+Wik0QJbVmvPtlZg9MDmMrr/5JP7XyV2qBg
         ZGnSo5dGVXpjV9JMQXIqkTGIgYqSuKUWBBi9UTyDLTxbqRLEVA2kTy6hibhU9TJ5Es
         +pNm327Xy8JNS+byf1tFZBAec6QeU/4qJDsRXNvH53+XP/aGG2malpXpIYnio2DUoR
         484WOGfYPVksPdZJNvJgxEkZZZihmxo1qeJLq454SHLvHxbvnC+LKD1wDkG8nRI4O8
         Gf/wlXWtFnRew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 042F960A6B;
        Fri, 20 Aug 2021 14:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: usb: pegasus: fixes of set_register(s) return value
 evaluation;
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946800601.1573.15633913227051100700.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 14:00:06 +0000
References: <20210820065753.1803-1-petko.manolov@konsulko.com>
In-Reply-To: <20210820065753.1803-1-petko.manolov@konsulko.com>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        paskripkin@gmail.com, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 20 Aug 2021 09:57:53 +0300 you wrote:
> - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
>     Kicinski;
>   - hurried up and removed redundant assignment in pegasus_open() before yet
>     another checker complains;
> 
> Fixes: 8a160e2e9aeb ("net: usb: pegasus: Check the return value of get_geristers() and friends;")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: usb: pegasus: fixes of set_register(s) return value evaluation;
    https://git.kernel.org/netdev/net/c/ffc9c3ebb4af

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


