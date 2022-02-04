Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A254A92B5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356774AbiBDDUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343822AbiBDDUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:20:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40AAC061714;
        Thu,  3 Feb 2022 19:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E88061AD8;
        Fri,  4 Feb 2022 03:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81934C340EC;
        Fri,  4 Feb 2022 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643944809;
        bh=WWzQmXVnOyl3tGRyO6u60MTpIs80TRjBnmFz8JwSyRE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WZXyRL/mjpnE8FmPbAfXQXH3CKmNLwGtzs6LEDcxexn6q2X6RxHB4GvGpKimMzB7O
         0HnNglii7Jcv9Q0q+2z6sXhifuR5czL+I/yGRVuRScER5ixIELi/npJy/rLvaxOhhi
         eL8cYcB81hZMtAfOyDOb+6M/lUK7gASaXyOfjWmwQb273wRZ8zslrKEscWhyk7H9H5
         8w2t5YTuV1Oe0+wwzU0fJuPB2qqmh3wOl90j9B+k5K/LkENwZXHorWtru2H0+ilWxa
         xQzKb0c9JUp/0ttDFq7VhQ64whuir+9rRQL3A8BrAmReHPqsH7nNokIlw3RVfFH4NG
         XFCchLcWRPiaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 677D2E5D09D;
        Fri,  4 Feb 2022 03:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sparx5: Fix get_stat64 crash in tcpdump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164394480941.31803.2020569874052270339.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 03:20:09 +0000
References: <20220203102900.528987-1-steen.hegelund@microchip.com>
In-Reply-To: <20220203102900.528987-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 3 Feb 2022 11:29:00 +0100 you wrote:
> This problem was found with Sparx5 when the tcpdump tool requests the
> do_get_stats64 (sparx5_get_stats64) statistic.
> 
> The portstats pointer was incorrectly incremented when fetching priority
> based statistics.
> 
> Fixes: af4b11022e2d (net: sparx5: add ethtool configuration and statistics support)
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net] net: sparx5: Fix get_stat64 crash in tcpdump
    https://git.kernel.org/netdev/net/c/ed14fc7a79ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


