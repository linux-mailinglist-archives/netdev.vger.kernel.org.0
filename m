Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060CA4711F0
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 06:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhLKFdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 00:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhLKFdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 00:33:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044A3C061714
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 21:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 34D64CE2F2C
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 05:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A1A9C004DD;
        Sat, 11 Dec 2021 05:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639200609;
        bh=RknxXW1OUShLnGoMtfoPfjOltZmHA7XMobFHUlaN/CI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LRe9szkvWp+M0cBUR2A5bf6o+hp7FXS2UDACAhsBvTD1uFAQKU/C0MyY1Pi7UaI5d
         QowGuLpsn+qTqmWtgl2y0VP+9FpD2IDsBPTWDpJTrAmWEZSwhAzy+qZ6Vo2qERiMZU
         dp+hnzdoZeER862gyfU0RBY9FkPR7byoFKxzVPk5Dw7vBzS+G5tHT3TdI/3ZbFacVI
         7K+/usb0mcrmrX6LvDsYXF0N0q3cvNNMn6lMvnWmxbVV5W6Jm2KF1lgZ+Mbli8O5DL
         UD7LW1A2UZ8tbThnfOPVC3x+MDZtkcKJG3i1gZsXFyvThxGIh4SZnFxdl7H915/ch2
         pqiJzOq8r7PxA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3CD0C60A4F;
        Sat, 11 Dec 2021 05:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netdevsim: don't overwrite read only ethtool parms
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163920060924.12590.10152114278479876688.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 05:30:09 +0000
References: <20211210175032.411872-1-fpokryvk@redhat.com>
In-Reply-To: <20211210175032.411872-1-fpokryvk@redhat.com>
To:     Filip Pokryvka <fpokryvk@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        acardace@redhat.com, mkubecek@suse.cz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Dec 2021 18:50:32 +0100 you wrote:
> Ethtool ring feature has _max_pending attributes read-only.
> Set only read-write attributes in nsim_set_ringparam.
> 
> This patch is useful, if netdevsim device is set-up using NetworkManager,
> because NetworkManager sends 0 as MAX values, as it is pointless to
> retrieve them in extra call, because they should be read-only. Then,
> the device is left in incosistent state (value > MAX).
> 
> [...]

Here is the summary with links:
  - [net] netdevsim: don't overwrite read only ethtool parms
    https://git.kernel.org/netdev/net/c/ee60e626d536

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


