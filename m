Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CD664AB35
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiLLXK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiLLXKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EDB6258
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 15:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1F96B80EF0
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 932BCC433F1;
        Mon, 12 Dec 2022 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670886616;
        bh=VpyLqbMl98HVzoWIWrJMPU7utrdZpdqTA2gEdIs4V2U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YDDjxjNesCops1ud5COUqcDIdqy4kRHBwrtPGAyCd5uR1WOkurW/QGmUa57SopY6N
         M8WYV79j8fIdnNiiiJa3mo+YNim0elP/qaS4grcg1LnD0k96Ya/B6E72pAMQHv1XAJ
         yvRklFM+E0TLuh2BB2PGi/+i6JN900HHRBnKMk+H2QTkjq7enbUmgIqW3onNAAozul
         OvryTGrvRJ8iC3vyM3prmxVmKl+YAMaj+2D/jbqh/gim9OsN96Gm+YgO16rvXQDzkq
         NMvPxbSPAiOwvf/TsDgHBtEZw3P4nftnqIxd3RE7RQTh87Xbqnj9qcdYfRBi9tKfKz
         sKJjX+CWNe8Mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A916C41606;
        Mon, 12 Dec 2022 23:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] Trace points for mv88e6xxx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088661649.21170.2064571178390062352.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:10:16 +0000
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221209172817.371434-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@kapio-technology.com, saeed@kernel.org
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

On Fri,  9 Dec 2022 19:28:13 +0200 you wrote:
> While testing Hans Schultz' attempt at offloading MAB on mv88e6xxx:
> https://patchwork.kernel.org/project/netdevbpf/cover/20221205185908.217520-1-netdev@kapio-technology.com/
> I noticed that he still didn't get rid of the huge log spam caused by
> ATU and VTU violations, even if we discussed about this:
> https://patchwork.kernel.org/project/netdevbpf/cover/20221112203748.68995-1-netdev@kapio-technology.com/#25091076
> 
> It seems unlikely he's going to ever do this, so here is my own stab at
> converting those messages to trace points. This is IMO an improvement
> regardless of whether Hans' work with MAB lands or not, especially the
> VTU violations which were quite annoying to me as well.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] net: dsa: mv88e6xxx: remove ATU age out violation print
    https://git.kernel.org/netdev/net-next/c/8a1786b7d441
  - [v2,net-next,2/4] net: dsa: mv88e6xxx: read FID when handling ATU violations
    https://git.kernel.org/netdev/net-next/c/4bf24ad09bc0
  - [v2,net-next,3/4] net: dsa: mv88e6xxx: replace ATU violation prints with trace points
    https://git.kernel.org/netdev/net-next/c/8646384d80f3
  - [v2,net-next,4/4] net: dsa: mv88e6xxx: replace VTU violation prints with trace points
    https://git.kernel.org/netdev/net-next/c/9e3d9ae52b56

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


