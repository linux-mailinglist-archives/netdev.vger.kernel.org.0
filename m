Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3B834C0A1
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 02:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhC2Ak3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 20:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhC2AkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 20:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C717A61941;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616978409;
        bh=xddtzXQTHujYyVHVapyzp8XsjgXUnQaUdjPF77WKXWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GDIYGPnk18U/HMWP6x1quSgGJXNoLGIRiLJjrr2jyIn8uLNpFic8H4sNT3/9jEJu2
         QnqbWvbxyJnyEbIcGet17aR+1iP517raDpON7noK9iOArISh2LXi97QrTWr9xLBlDl
         ejZJWYsm8Omu/tsaZ666dWxDsF+LSyO1AIcFFMctTiMvz8WDiUfr5nTpERbsEwnn7s
         5FzuX9jcWY/DGjbTO1m4BTLCchLxj9JndKUbCRgSK/lNV76ytEPgMASNVrQ2bGFGOX
         kJv0icKevk74NzWCagsj4ghyLkC56ZBTMR/SjoSvzmeLftUJ/+4nOCkmrLeV/ERijF
         QNWy6AAhm5OfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA06160A57;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bearer.h: Spellos fixed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697840975.22621.1717021936102605107.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 00:40:09 +0000
References: <20210326231608.24407-2-unixbhaskar@gmail.com>
In-Reply-To: <20210326231608.24407-2-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 04:42:37 +0530 you wrote:
> s/initalized/initialized/ ...three different places
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  net/tipc/bearer.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> [...]

Here is the summary with links:
  - bearer.h: Spellos fixed
    https://git.kernel.org/netdev/net-next/c/e919ee389c18

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


