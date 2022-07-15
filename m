Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16E1575FC8
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiGOLKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiGOLKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:10:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C1686890;
        Fri, 15 Jul 2022 04:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17284CE2EA1;
        Fri, 15 Jul 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C2D6C3411E;
        Fri, 15 Jul 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657883414;
        bh=6OjJ1qdAgBKDuBgy+3gDvP8Eq67yBuAeZucLUnONSSM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fEvzptblu7MkQEOKZHK9NqSEIon7if8e4AwJp4B6NXDL7AYleI2YXFN/f3xrODjj2
         jjYb4f1f1AgsA//SjlA+58sE8FDXWgfvUL+n4oXysE49yG4Zwefsr0DDQ/EanlxSoH
         HC8JuaWDehMrp6kxCN3gDF1cCubC4mQ0Qh6SeZxUlOv3SvL1QKT/iOhsNVa0IAZBb+
         I7Yc8eqijXXwWFIe+h+77l0ccSNQ9wvci9UG+1O/o9ZfT85AOxQdpaCKxwM9Q5Ldog
         CzJJeMEYbrkDG/wyuBe8LsE1MSHr2XNa6hDHhqM3fvAGKcx0Sd5120ybOPHDFg3yeC
         p8idZtFHLf+Pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 26388E45223;
        Fri, 15 Jul 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Fixes static warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165788341415.15583.8636883844564216314.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jul 2022 11:10:14 +0000
References: <20220714042843.250537-1-rkannoth@marvell.com>
In-Reply-To: <20220714042843.250537-1-rkannoth@marvell.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kbuild-all@lists.01.org,
        dan.carpenter@oracle.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 14 Jul 2022 09:58:43 +0530 you wrote:
> Fixes smatch static tool warning reported by smatch tool.
> 
> rvu_npc_hash.c:1232 rvu_npc_exact_del_table_entry_by_id() error:
> uninitialized symbol 'drop_mcam_idx'.
> 
> rvu_npc_hash.c:1312 rvu_npc_exact_add_table_entry() error:
> uninitialized symbol 'drop_mcam_idx'.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Fixes static warnings
    https://git.kernel.org/netdev/net-next/c/da92e03c7fbf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


