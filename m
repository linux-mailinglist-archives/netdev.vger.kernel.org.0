Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929C6486480
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiAFMkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:40:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33198 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiAFMkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:40:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E151DB8210B;
        Thu,  6 Jan 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91035C36AF2;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641472811;
        bh=g5qPUNlF2KbEQXUeZXuENsmjDqniLSj6mAbuf6RQC0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UxsDR9X5054tODdUAwM7nC1VRlsMseqTR6P9pOSbkUWeb1fwD87wqXzM3Srcl70OI
         Ee61ZMjN01HncCmrktmTfd9SC0N7BXEXY3wx9ZwFBWev4e66wDgnNEmOVIwMYAySga
         UIFerY00PjyiBPtzzojbreOELBkal7zl7vM9kOVk1vX7qDfw3dgTMImPznKO38ZoWF
         h8RDBfFD5LatHT74FwF3ACOQo61aSZ3yKVc/bYNeqegc0gstnH/uvg/7a2ddthjoSh
         sZg2C8QuvBz392iHPGWBBnaAkSse23F0baPcf4IM9z5QBELjFf1y5dQRq7hT3yY3vL
         IJCOwOlfGdCQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A5F5F7940D;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethtool: use phydev variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147281149.4515.13906193774405058931.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:40:11 +0000
References: <20220105141020.3793409-1-trix@redhat.com>
In-Reply-To: <20220105141020.3793409-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        arnd@arndb.de, danieller@nvidia.com, gustavoars@kernel.org,
        hkallweit1@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Jan 2022 06:10:20 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> In ethtool_get_phy_stats(), the phydev varaible is set to
> dev->phydev but dev->phydev is still used.  Replace
> dev->phydev uses with phydev.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> 
> [...]

Here is the summary with links:
  - ethtool: use phydev variable
    https://git.kernel.org/netdev/net-next/c/ccd21ec5b8dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


