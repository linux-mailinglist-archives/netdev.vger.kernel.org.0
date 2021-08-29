Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203403FAA82
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 11:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhH2Ju6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 05:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234917AbhH2Ju5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 05:50:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B7C7B60C51;
        Sun, 29 Aug 2021 09:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630230605;
        bh=L+9icyATu8ZxIWa177sRc8SmY2uswlhs26EVU/M/v1Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t5db1X57QbrWjESIQ3DG+VEwdws3wcL/YBxz/ZxCm/93L+n04szq6Txf7nGkQzaJR
         2pl2eeJWXte43Uu9sNK3EURg5HHSqpXZZIKIR/RKodDDTT93Yrw880aS8cPj6U4+RE
         i56gvxuomZY49tEIEvk8eqbL7FVsXAF1jiImGhRATVSlh3+OqPtdBrZMFkAtdLg6pF
         8dkTJWzsXOOOO/D0GQpN4VZPnSxCP+y00fsw1lF8O9mq4krgiP204mZ4/sCt7S6NTz
         04HaOBRrFMHw8pPp1g0LCcy4072shfshQDOUyi4pe8VPnv7gzItWKFEQaIL52geg0e
         S8oco2Z7toAEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB13260A3C;
        Sun, 29 Aug 2021 09:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] atlantic: Fix driver resume flow.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163023060569.19070.12053681496203016461.git-patchwork-notify@kernel.org>
Date:   Sun, 29 Aug 2021 09:50:05 +0000
References: <20210827115225.6964-1-skalluru@marvell.com>
In-Reply-To: <20210827115225.6964-1-skalluru@marvell.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, irusskikh@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 27 Aug 2021 04:52:25 -0700 you wrote:
> Driver crashes when restoring from the Hibernate. In the resume flow,
> driver need to clean up the older nic/vec objects and re-initialize them.
> 
> Fixes: 8aaa112a57c1d ("net: atlantic: refactoring pm logic")
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net,1/1] atlantic: Fix driver resume flow.
    https://git.kernel.org/netdev/net/c/57f780f1c433

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


