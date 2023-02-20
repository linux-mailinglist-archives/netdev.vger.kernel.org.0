Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13AE69C5CE
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 08:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjBTHKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 02:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjBTHKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 02:10:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE34E1
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 23:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2F96B80AC3
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BB7AC433EF;
        Mon, 20 Feb 2023 07:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676877017;
        bh=bYCk7O9HUYSDtqNnwEhJLfBfu0OWccGzlIpde2Bz1Aw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Il0tuIexmV4w6inY/GKMuomPzNm+bY1Ld5V97kJjGlOykRe2Rugg60oxYCGoRYh+O
         AZ4qN4D/arshQMdwbs7vBDvkUlyHMXZDPOw34oWHWSypbo6gsmQKs5Shxur0wDB1pV
         COk1XtTpxf7DK2meV0A6UypbAhv8O3pp1y4F6fGpnqSSFNrNDG1lGMKG798TdjH8to
         CiwOOjRRU8qQiRgkzBCb5p4S8eF2OCHavfb0UBThobHkjDUb/y1KsuEeGdK9FA3hmK
         4587tEnzSc92xo5pzC5dqSazPmpbWwNxilTzxhFRvMFlx/MS+b5+JM2JCe3/Rgt/9d
         rIEiAKRUEZEMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E075E68D22;
        Mon, 20 Feb 2023 07:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dpaa2-eth: do not always set xsk support in
 xdp_features flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167687701750.19256.1338528354080702860.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 07:10:17 +0000
References: <3dba6ea42dc343a9f2d7d1a6a6a6c173235e1ebf.1676471386.git.lorenzo@kernel.org>
In-Reply-To: <3dba6ea42dc343a9f2d7d1a6a6a6c173235e1ebf.1676471386.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ioana.ciornei@nxp.com, vladimir.oltean@nxp.com,
        robert-ionut.alexa@nxp.com, radu-andrei.bulie@nxp.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 15 Feb 2023 15:32:57 +0100 you wrote:
> Do not always add NETDEV_XDP_ACT_XSK_ZEROCOPY bit in xdp_features flag
> but check if the NIC really supports it.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dpaa2-eth: do not always set xsk support in xdp_features flag
    https://git.kernel.org/netdev/net-next/c/1c93e48cc391

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


