Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEE233F930
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhCQTaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhCQTaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 15:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 953CD64F30;
        Wed, 17 Mar 2021 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616009410;
        bh=XIDIX8hleO2XmtznvxMJkV3OKqK5AJIn9QoSirrGRGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PefDD9iXCyrNBPxxrpfdZzv/RaIf6bxCG6xHJ08skI6cdxXnYRcf5wrkR3MDnXIwR
         CgURPBnFUvK0BulbBAWOtdzRxPswJXr5NT5RTY/x60YVIm6frgZ60PJB57VQXcNT4g
         9ROn6xQU4tHRLlAvHIw/EWJoAko+ngpJ4Q991VpOV1eHtC8cG9BDB15gbgfIkcpNpN
         bO5Mi3zrav45Yicoq2LM8sB9F8itG5epBV72UAGS6omnWP50ajPOVhfXe3SfJLenk2
         +zQO+LLvNdgGDVaMCQqlQpUaZVTGrtMIzzjCJdiz4W4HIYTErq5PPX42oqNnB+0akT
         g7rBjrDEogM/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8AF0860A71;
        Wed, 17 Mar 2021 19:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next resend] net: dsa: b53: relax is63xx() condition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161600941056.18835.18340629368217459433.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 19:30:10 +0000
References: <20210317084201.32279-1-noltari@gmail.com>
In-Reply-To: <20210317084201.32279-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 09:42:01 +0100 you wrote:
> BCM63xx switches are present on bcm63xx and bmips devices.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_priv.h | 4 ----
>  1 file changed, 4 deletions(-)

Here is the summary with links:
  - [net-next,resend] net: dsa: b53: relax is63xx() condition
    https://git.kernel.org/netdev/net-next/c/ad426d7d966b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


