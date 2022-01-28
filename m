Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E48A49FC7D
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349528AbiA1PKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:10:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35254 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349501AbiA1PKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:10:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC5F0B82623
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 15:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AF07C340FC;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643382617;
        bh=WklJdGQ41/XMBbomihZUdipxLyVDhbfHelu3pd+ebtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bhRXSQ1OaXAs9ETtmjthMw3IfQgA7EgixuOyy14WrCMijdyRbvxhUjeFRDlLiBFz2
         I0D1wOsD8LnQWvTPXrGSLr6jKBsR54d9hPRac/ecpLVUuyegSCcylgoyATdb1XxbxO
         uVzzma22BX/ECSjSg/mVawLtiNL50CCY/8u1m73Y4QkGYWMAjWQJX26jPW2CXDHOJT
         D5k9Cs1SDINSabIzMp2NixfgfRKsZJ7klRgxZxoklNQleK7WpfJdC9X/NWUrdH8L+x
         RWVPR230J7JI7dYLPGp+fGPnTf8WQR5NpVEHOXHGi/a06NZVqWT3Ah4OijTMHD/25Y
         9BZwiIHMhrlzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 631FAE5D098;
        Fri, 28 Jan 2022 15:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2] octeontx2-pf: Change receive buffer size using
 ethtool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338261739.2420.18366210620892685274.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:10:17 +0000
References: <1643343096-31954-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1643343096-31954-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sundeep.lkml@gmail.com, hkelam@marvell.com, gakula@marvell.com,
        sgoutham@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 09:41:36 +0530 you wrote:
> ethtool rx-buf-len is for setting receive buffer size,
> support setting it via ethtool -G parameter and getting
> it via ethtool -g parameter.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] octeontx2-pf: Change receive buffer size using ethtool
    https://git.kernel.org/netdev/net-next/c/a989eb66684d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


