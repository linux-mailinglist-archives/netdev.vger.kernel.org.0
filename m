Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D743DE230
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 00:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhHBWKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 18:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232164AbhHBWKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 18:10:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B0D8F61038;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627942206;
        bh=7Zobgdu8H+pRVzPBJTTYr02jgO5p6AzjuT070XbfWNU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kiuv9buDVmrsmcoPIua26Ahc2moO+IPaYY8B9RNpOdrFJ2Pf0KF+/m5X4k791KeZP
         3IBsIC1wD4WiPLrsxLJlxBVzglK8GZsjtseFNjucXxQnq4HT27sSuZnnKyDAwA7Hm+
         v0fI7DWmpvDqNyuNww6S8HtU9FjFR4qIOO0SWNoPk43WzVHizePC3XK5SGxtkdREhy
         z16tIMdJZUbui2qg1aPT8rZL7CcM0eirhMQH2J/c1REm2sznTAYy3YcSV4iqUcHZAc
         UoT+FeWS2KaUQMc3D9S19JFn6tZB+Y/vWTyxq+vH/aIC3coB4xYtCRfOWWAT4UfmT2
         ixLEX3mkLnQaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A2E6C60A45;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: 3c509: make the array if_names static const,
 makes object smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162794220666.7989.3587377271310503245.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 22:10:06 +0000
References: <20210801152650.146572-1-colin.king@canonical.com>
In-Reply-To: <20210801152650.146572-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Aug 2021 16:26:50 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array if_names on the stack but instead it
> static const. Makes the object code smaller by 99 bytes.
> 
> Before:
>    text    data     bss     dec     hex filename
>   27886   10752     672   39310    998e ./drivers/net/ethernet/3com/3c509.o
> 
> [...]

Here is the summary with links:
  - net: 3c509: make the array if_names static const, makes object smaller
    https://git.kernel.org/netdev/net-next/c/771edeabcb95

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


