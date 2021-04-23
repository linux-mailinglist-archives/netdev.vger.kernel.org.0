Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3F0369BBA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhDWVBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243960AbhDWVAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A87E61450;
        Fri, 23 Apr 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619211613;
        bh=Wwj722kpypRTw1VSKLLy2oLoQxs5Jj6sh0GOzqUplxY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AjuAyaexcYL8bUAZmGS90I9HKOWXU8n9js0yELoRDdy5xmzkDLlM6a34MyZ7AgfKl
         2GqR91SuQm7p4vH2Wzaps68MFrv8jiDCY1DjmWINh8Bu19JGs6GV26JbfxsSWIANae
         iH2BeMZ2VrwnzpHtwE+/r5nSDb9kiXe6m+/zccVe+619HWrAbRAGATpe/rcxqM6fI2
         BgZVpVyO9kIZTXL37yMp1QXxKs+zBUWMKIWQD/qhqtenDuRGwiZgm1fIyb48DMLXRm
         7tPlbeiwa/Q/JaZhNlhnA1jvXTlQ+yV6JPyZhGMaj4YtBUuBRP4VsVfBCZt079ZCTm
         icTyBT6gmsydA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E57260A53;
        Fri, 23 Apr 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] r8152: adjust REALTEK_USB_DEVICE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921161318.19917.10661114469230346337.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:00:13 +0000
References: <1394712342-15778-359-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-359-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 17:44:53 +0800 you wrote:
> Modify REALTEK_USB_DEVICE macro.
> 
> Hayes Wang (2):
>   r8152: remove NCM mode from REALTEK_USB_DEVICE macro
>   r8152: redefine REALTEK_USB_DEVICE macro
> 
>  drivers/net/usb/r8152.c | 71 ++++++++++++++++-------------------------
>  1 file changed, 27 insertions(+), 44 deletions(-)

Here is the summary with links:
  - [net-next,1/2] r8152: remove NCM mode from REALTEK_USB_DEVICE macro
    https://git.kernel.org/netdev/net-next/c/e7865ea51b0b
  - [net-next,2/2] r8152: redefine REALTEK_USB_DEVICE macro
    https://git.kernel.org/netdev/net-next/c/55319eeb5bbc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


