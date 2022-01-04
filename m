Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452BD484192
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiADMUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:20:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34198 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiADMUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95E3BB81167;
        Tue,  4 Jan 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A387C36AF3;
        Tue,  4 Jan 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641298810;
        bh=8Xm91s3bE3nSv4cB1QLVhZb6nwlckLG5R7vuzxHXO2g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p2tHtyxAvBs9PAOT84sPe6CttPCCEYxbGcfaqfrVsEoO9U8jpGKXFY/QF3NvTrdga
         jEdk3HPYgQlV217Uy62Voii/0ex7+uCgXR0f4SGlDdyG7Fz8z704e4VjDsKrBNmdGe
         oCLFPO/YzizcG9xx9h1VUeQxh0ltTsjHsPwl5fo6gg26SoUz4KswonrDTAaDpHciS3
         P3c2ZxL+NzKFeoQk6Cj2a4/DAhggFYtQHICVNLYI/L3D0032wbPV6rWSjg3kqVFpNU
         08uaNRFMy0isnLjXJ9BU+j0F+KEVutuW0485xjc4FxbGYTm5/hiIh39NKQ/V1X8dRz
         fEesFpSP77d0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B7D5F79407;
        Tue,  4 Jan 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/1] TJA1103 perout and extts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164129881017.16438.12801597321137933657.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 12:20:10 +0000
References: <20220103160125.142782-1-radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20220103160125.142782-1-radu-nicolae.pirea@oss.nxp.com>
To:     Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  3 Jan 2022 18:01:24 +0200 you wrote:
> Hi,
> 
> This is the PEROUT and EXTTS implementation for TJA1103.
> 
> Changes in v3:
> - removed "phy: nxp-c45-tja11xx: read the tx timestamp without
>  lock" patch
> 
> [...]

Here is the summary with links:
  - [v3,1/1] phy: nxp-c45-tja11xx: add extts and perout support
    https://git.kernel.org/netdev/net-next/c/7a71c8aa0a75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


