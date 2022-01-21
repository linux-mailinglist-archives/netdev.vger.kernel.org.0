Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D63F4959AB
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378606AbiAUGAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:00:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56006 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378591AbiAUGAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:00:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5094B81F43
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 868A7C340E1;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642744813;
        bh=3HLeWTxL1/4tqReCkCtMd/JSScjqGr/Ihohl3v7mHD8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tSc7wWm+oAYy6UPsBpeEcbX22bu6+Abm1s2y5DrQZ4pjiLe3r/ovMK+dgbsBgWzjC
         UVXKCyRs9FXtKOufr9BoiiLetmCaY/zElKgVNRquwx0IbGZsU0OGdQ8Ct2aHa8Gghp
         L/rWagGUC2gTZbxuoFZlciECyBrNIFi44VzWgjWxkVxh4QOcokcQtDW7eN8FGzGFLY
         J7snVOISfP47LTulGMtsgW2vlwjnaHn8E7Fv9j/If1zRPRsBERE3ul5oUriNYZ7bHW
         FgGRMsW4BI5wxpuSUJJ++Bi83iz+suYvKRqMR1SYPpeBmelLEYNZh9rG+RSZ/S7dO9
         ZzqKICnZwU/Xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FDB6F60798;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] phylib: fix potential use-after-free
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164274481345.1814.13604791618402169229.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Jan 2022 06:00:13 +0000
References: <20220119162748.32418-1-kabel@kernel.org>
In-Reply-To: <20220119162748.32418-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk, andrew@lunn.ch,
        sergei.shtylyov@cogentembedded.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Jan 2022 17:27:48 +0100 you wrote:
> Commit bafbdd527d56 ("phylib: Add device reset GPIO support") added call
> to phy_device_reset(phydev) after the put_device() call in phy_detach().
> 
> The comment before the put_device() call says that the phydev might go
> away with put_device().
> 
> Fix potential use-after-free by calling phy_device_reset() before
> put_device().
> 
> [...]

Here is the summary with links:
  - [net] phylib: fix potential use-after-free
    https://git.kernel.org/netdev/net/c/cbda1b166875

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


