Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC38458B353
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 04:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbiHFCA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 22:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241596AbiHFCAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 22:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC345F59;
        Fri,  5 Aug 2022 19:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DD83B82B03;
        Sat,  6 Aug 2022 02:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3EC3C4347C;
        Sat,  6 Aug 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659751216;
        bh=86mZJ+nMM5Cyh2OyQ/06wcGAfFxbTlsvFCZrJRFt/Ik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pok0Wae6JkFda1WsLE64WXBhdbcHJcclALA2UOUkkTr1Jb1kFzgh94o/bfXl5rrAD
         YBks03UETYRZSXC3rX9MtwueylbsJmU5p/9xkXUCtbVFxrZY6U+6IfcABvWrbt3/WS
         lr0q3+cKNN2QJLJyL84v7E77QJ0F5wMlAyMOggGOSGD1ym26FJr3GrmBhQsTvJVS9w
         EOS6j0vAczxx7+6Nop17o5Uo1H4cGMpqJF+7W8vyXs+vYtIWMkZMVke3PyaA5RT68X
         t6pBQFdQXX/XfHCDAajcYHrf1Y06KzTvM3q9WW5j/Nw+eBaOg73htzvcrMU45CHHaq
         7PmUe9jKxcuaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA60BC43146;
        Sat,  6 Aug 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v3] octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG register
 configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165975121582.22545.7917773898664631780.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Aug 2022 02:00:15 +0000
References: <20220802142813.25031-1-naveenm@marvell.com>
In-Reply-To: <20220802142813.25031-1-naveenm@marvell.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com
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

On Tue, 2 Aug 2022 19:58:13 +0530 you wrote:
> For packets scheduled to RPM and LBK, NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL]
> selects the TL3 or TL2 scheduling level as the one used for link/channel
> selection and backpressure. For each scheduling queue at the selected
> level: Setting NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG[ENA] = 1 allows
> the TL3/TL2 queue to schedule packets to a specified RPM or LBK link
> and channel.
> 
> [...]

Here is the summary with links:
  - [net,v3] octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG register configuration
    https://git.kernel.org/netdev/net/c/13c9f4dc102f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


