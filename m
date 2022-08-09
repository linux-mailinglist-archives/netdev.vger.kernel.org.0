Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5044058E017
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245250AbiHITVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346269AbiHITUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:20:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80ABB78
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 12:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DCEC6132A
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 19:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8406C433C1;
        Tue,  9 Aug 2022 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660072814;
        bh=vVB1R6uKrGthBGd984UxlwGXeA4RIpfz2d49XqqjsII=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k5YvWzm4kCK+DC0xHHZBIZpR2xBsUOdqaea1jx2x5Iz8+vRF0q7un31sCIX6qlxR1
         GDy19tAiZV3mVTYZhYcwunP42QDOGGZvI/8ysOdn3/Q90NXfsxZ9FZ84o6s97uQX/A
         ki7lzQlvs8DlX3I+zhbzo8mD0dfPUPYH3cnTD6pIVLOF4S2RoVHrmTAyuKcRTOjw6z
         2ZKUrgtJo2YCKSSDYQ/Jmok9DU45k44TdlCuMb5yrpeiS8TdfVoFEWCX+1YE5StSc3
         Ocho+S9WAvoVRVALZBiLz0XARPhA/0FvDhnngVz4C+35scCY+deGtigGDnsxjH/rWI
         bpY/QZdbsxVrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1668C43144;
        Tue,  9 Aug 2022 19:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: felix: suppress non-changes to the tagging
 protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166007281478.26938.18198013386230045190.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 19:20:14 +0000
References: <20220808125127.3344094-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220808125127.3344094-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  8 Aug 2022 15:51:27 +0300 you wrote:
> The way in which dsa_tree_change_tag_proto() works is that when
> dsa_tree_notify() fails, it doesn't know whether the operation failed
> mid way in a multi-switch tree, or it failed for a single-switch tree.
> So even though drivers need to fail cleanly in
> ds->ops->change_tag_protocol(), DSA will still call dsa_tree_notify()
> again, to restore the old tag protocol for potential switches in the
> tree where the change did succeeed (before failing for others).
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: felix: suppress non-changes to the tagging protocol
    https://git.kernel.org/netdev/net/c/4c46bb49460e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


