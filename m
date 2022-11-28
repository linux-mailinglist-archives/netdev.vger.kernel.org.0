Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A0163A6D0
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiK1LKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiK1LKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:10:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FAD193CA;
        Mon, 28 Nov 2022 03:10:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 471BCB80D4A;
        Mon, 28 Nov 2022 11:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1661C4314A;
        Mon, 28 Nov 2022 11:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669633832;
        bh=YH4bfUJjuYocG6o802Dnp3YvwH6xvqMjyW6PnmrvvYU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ltb7kB4IPYyjJTA1PHWig7c3oIb967naf7u4sRPVrwtSLTBFScy+2Ofb/Sl7xtxre
         dNVcUex6x8cWD8ijV4v+clyqwXqVzLkzt/lWWI3w2vmeUfg4P1Laq4xFmPeWk42MwH
         lYe+0O0qop8iJXbaW3Lk0ZG3uHwZKFl4eqMET0lkrQ0WedP5tt/V/psjUa6oUfE0Rf
         qsnSF3pDR/Wwab9GkAsShO8IAsTUBtb9yVPQzE9jn1e+z44UV3VGqBdpBAe0bN/D//
         290BNG1ex3FrAqd8sTbQIZrNvClZkD1pE2riYtfN5JNeVTnrB/uOgPIZ24iphSb7Aq
         7czJ9rWbs6Z/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DCBC6E270C8;
        Mon, 28 Nov 2022 11:10:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH V3] octeontx2-pf: Add support to filter packet based
 on IP fragment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166963383189.22058.8352974824019159739.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Nov 2022 11:10:31 +0000
References: <20221124063548.2831912-1-sumang@marvell.com>
In-Reply-To: <20221124063548.2831912-1-sumang@marvell.com>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com, sbhatta@marvell.com,
        jerinj@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        lcherian@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Nov 2022 12:05:48 +0530 you wrote:
> 1. Added support to filter packets based on IP fragment.
> For IPv4 packets check for ip_flag == 0x20 (more fragment bit set).
> For IPv6 packets check for next_header == 0x2c (next_header set to
> 'fragment header for IPv6')
> 2. Added configuration support from both "ethtool ntuple" and "tc flower".
> 
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V3] octeontx2-pf: Add support to filter packet based on IP fragment
    https://git.kernel.org/netdev/net-next/c/c672e3727989

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


