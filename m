Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED6F41FC18
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhJBNL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233210AbhJBNLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 09:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 24CD261B1E;
        Sat,  2 Oct 2021 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633180209;
        bh=TD4rT1zAFJICaKJFdMN/fLj1PYhqGiZOb7Q0Wc1VC0A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qhvY8Peh2Kh6RLzmNRi4PhFeeVojRkMGkExcJ/J1iQHxcZsffRvl3O/85Zf5pDDQj
         i+sxwvYqUAM+8j/6nuFXH48deQ+mFJvO5rN7LwdbEWopNT6SRCZRR6+uVtQGJRXCXC
         sfbX4ZMx9V2p/xfUjQU2VCsxfvhHe7YPxCom0VZSZdXITMhbAKk1to9bU5VkZsqFER
         ljaHK5CTUXr6+cxcMGlYg2n/FZ0/70CU+xgFYjbsVbful/xONeUkTS3J8tlbdT0j50
         +T0ckWCR1eEHCsTw4eXysF39OkDSWp+Akr1itcnvpRLyum+rzGB5eWWlqRXsrRHpm8
         xusYuNeMG7BnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 185CC609D6;
        Sat,  2 Oct 2021 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net:dev: Change napi_gro_complete return type to void
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318020909.24030.3514310334456101990.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 13:10:09 +0000
References: <20211002081136.3754-1-hkm73560@gmail.com>
In-Reply-To: <20211002081136.3754-1-hkm73560@gmail.com>
To:     Gyumin Hwang <hkm73560@gmail.com>
Cc:     joe@perches.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, herbert@gondor.apana.org.au, daniel@iogearbox.net,
        atenart@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  2 Oct 2021 08:11:36 +0000 you wrote:
> napi_gro_complete always returned the same value, NET_RX_SUCCESS
> And the value was not used anywhere
> 
> Signed-off-by: Gyumin Hwang <hkm73560@gmail.com>
> ---
> Changes in v2:
>   - Remove unnecessary return at function end
> 
> [...]

Here is the summary with links:
  - [v2] net:dev: Change napi_gro_complete return type to void
    https://git.kernel.org/netdev/net-next/c/1643771eeb2d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


