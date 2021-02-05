Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4AB310312
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhBEDAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhBEDAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 22:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D34C64FBC;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612494008;
        bh=rn9Nv/LXFm9F9Cpm7Ldt2vwCYxVZ/gtTIi/L0ZtSTxs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jQagHEVIY2dl7W5WqH48EMEzAQUpYcCXQDpXMKGSIkg8yZWYWZRV3Z2QZJi92FGfC
         e63/UXVYIhNewupiasPtsCAKWf9LSUiYNZnbc/XeJ0FrMBss4P61BqQttL+9gshsg8
         Sn7Nd/UgLC4W1YXxuImLfYZl1wUXaqA5cfX5v69ms4ZR0Rv7ethMpordyRzKQRDulJ
         6s/yIUlqJOIQPlyomV8qQcqlxfwsZNNISNbzFnGjDrIXOEWt/fLVlfVenOZFPs/pR0
         VD3WYvafRph56s3w7zQMg14OR3PVR2sfOCqscXMpPeAoCDfdJO8zOQEaxIm59t7POO
         NTzkyoo8qFDzg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6F7D3609F5;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: pn533: Fix typo issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249400845.18283.17936808054251018779.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 03:00:08 +0000
References: <20210203093842.11180-1-samirweng1979@163.com>
In-Reply-To: <20210203093842.11180-1-samirweng1979@163.com>
To:     wengjianfeng <samirweng1979@163.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  3 Feb 2021 17:38:42 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> change 'piority' to 'priority'
> change 'succesfult' to 'successful'
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> 
> [...]

Here is the summary with links:
  - nfc: pn533: Fix typo issue
    https://git.kernel.org/netdev/net-next/c/d6adfd37e7eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


