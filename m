Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE2D69758D
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbjBOEua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjBOEuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:50:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2342DE44;
        Tue, 14 Feb 2023 20:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F455B82046;
        Wed, 15 Feb 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D53DC4339E;
        Wed, 15 Feb 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676436619;
        bh=Hpm+5UfMmGIvwWNCzlutXjEPevQMb+5N7rtPRfIxSLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TnvrtkLO0BE1u51lVpU6hMEeCdhI7sN66M3Cv4STcyGEo70f+bhG2gMugWs55IxfK
         1qn3jQsO2MigZo9eORhULLegtZDd1b5v7eM7wJcmEUsxUWGMBthhpwCOKskagAb01f
         d9392bDEJhPmWXpwQBxNBsyTzDQdTuLVKjjkyTu0N2pPSPr9AubKUNwMuEOAY9fOeD
         SPNoysqrf/tdkJMxc+irsKOd93ctDA7zrO7Zipdl/JxqJDF8OUrur4bwWuARPh3RPd
         RoHq36MKzwUdOfLVUC8MPVUTkBNSl1w8kC+cgyQm3r3c91AxjBFHBoo15l3JDkH/J7
         +ItFtDdiZ1R7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 268F6C41676;
        Wed, 15 Feb 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: make kobj_type structures constant
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167643661914.17897.15068039752678209859.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 04:50:19 +0000
References: <20230211-kobj_type-net-v2-0-013b59e59bf3@weissschuh.net>
In-Reply-To: <20230211-kobj_type-net-v2-0-013b59e59bf3@weissschuh.net>
To:     =?utf-8?q?Thomas_Wei=C3=9Fschuh_=3Clinux=40weissschuh=2Enet=3E?=@ci.codeaurora.org
Cc:     roopa@nvidia.com, razor@blackwall.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Feb 2023 04:23:10 +0000 you wrote:
> Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
> the driver core allows the usage of const struct kobj_type.
> 
> Take advantage of this to constify the structure definitions to prevent
> modification at runtime.
> 
> Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: bridge: make kobj_type structure constant
    https://git.kernel.org/netdev/net-next/c/e8c6cbd7656e
  - [net-next,v2,2/2] net-sysfs: make kobj_type structures constant
    https://git.kernel.org/netdev/net-next/c/b2793517052d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


