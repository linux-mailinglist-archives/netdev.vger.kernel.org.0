Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBE949FC80
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349552AbiA1PK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349515AbiA1PKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:10:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0C0C061714;
        Fri, 28 Jan 2022 07:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 451BFCE26C5;
        Fri, 28 Jan 2022 15:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D9B3C340FB;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643382617;
        bh=nipkNEoH6Mja+s9jacsh/RcfBRBf+rzMqDt8ej2XCcE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rh2yJEZcuJ9veKtKflcjBS8au5YUVaNpVK0FeOQJrkZCfbCRGMxQcv1WWlXJ7/wbs
         EYHZybR782DnBHulOQJ9RD8P+QsHENcuKuYmUAsn9MeWrnIgB3p84cfPeRiSLtdG7f
         8TPdxHvYiREykc8w4f6pHlXSiYz69vL17D8T5Vb9Bi29Sgmk6HGPK0UvivwVdD6ROZ
         AVS1SMdorpN90UIMxkt2Zb7rbAGhVwqut8DcEKjCnIuZ4hEpQZ0uxN3i8POk0e6sEl
         4Khz/VD4uU18YVOLKc9hauEw0HFVqNHU+nmfly8q+4NvsLvWxJgTw3RRZm6Cg4bcQk
         CO274hf6cTr3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57F1CF60799;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] ethtool: add header/data split indication
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338261734.2420.245861558495547207.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:10:17 +0000
References: <20220127184300.490747-1-kuba@kernel.org>
In-Reply-To: <20220127184300.490747-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, chenhao288@hisilicon.com,
        huangguangbin2@huawei.com, idosch@nvidia.com, corbet@lwn.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 10:42:58 -0800 you wrote:
> TCP ZC Rx requires data to be placed neatly into pages, separate
> from the networking headers. This is not supported by most devices
> so to make deployment easy this set adds a way for the driver to
> report support for this feature thru ethtool.
> 
> The larger scope of configuring splitting headers and data, or DMA
> scatter seems dauntingly broad, so this set focuses specifically
> on the question "is this device usable with TCP ZC Rx?".
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ethtool: add header/data split indication
    https://git.kernel.org/netdev/net-next/c/9690ae604290
  - [net-next,2/2] bnxt: report header-data split state
    https://git.kernel.org/netdev/net-next/c/b370517e5233

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


