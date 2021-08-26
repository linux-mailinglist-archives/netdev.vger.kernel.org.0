Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752F33F8625
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbhHZLK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241926AbhHZLKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 07:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 86171610A7;
        Thu, 26 Aug 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629976206;
        bh=jkU1+FIDSH/s/fL3bRrFxYtltDB4jutXMnM1dXsXk1E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PSV+XtxjBcojxP7M4BvNdqgHSNH8uBdfAxC+6BAYUMeTMUH6J123L41ZoOIfxo0yB
         4/FL5Kp83vR5fJlPOdnbudwj5nQbVQU/zy1G0kF/2kv/Lck47dE4tE4WshWvaoznd5
         nNHjwM06cKfNzMc8zwgbyAoHpd9v9BdfzOoKLXqJ9EvsjswXoyrLoNA/ayTQKkurz1
         xbTLiSpST/noYpwIQ3AKsNnTdBx6MFEAu5pt1LNn2ukiJtRid7hw7FrFBNva6md9Xl
         wbz94PC6ELQ5afvQcLKFDdLKbsPxmNrjCFq2uM3ltlgIlq9/hDrgTtHyYvpGD0sMvm
         6gQz4ouOmsUnw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A2B060A12;
        Thu, 26 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: add rtl_enable_exit_l1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997620649.12775.6664143934068820130.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 11:10:06 +0000
References: <789e3560-4c6d-6906-d6d4-2a419bab0054@gmail.com>
In-Reply-To: <789e3560-4c6d-6906-d6d4-2a419bab0054@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 18:29:48 +0200 you wrote:
> This adds a function for what has been magic register writes so far.
> It's based on recent changes to vendor drivers r8101, r8168, r8125,
> and deals with events that trigger an early ASPM L1 exit.
> Description of the bits has been kindly provided by Realtek.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: add rtl_enable_exit_l1
    https://git.kernel.org/netdev/net-next/c/4b33433ee734

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


