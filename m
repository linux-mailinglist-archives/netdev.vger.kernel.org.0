Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1537F564729
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 13:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbiGCLaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 07:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiGCLaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 07:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16267A197;
        Sun,  3 Jul 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA202612F5;
        Sun,  3 Jul 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03754C341CB;
        Sun,  3 Jul 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656847813;
        bh=FPtwqI5Uih2HMOiXJ0PaT1OJgiB9Fju24lPynyXuynM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s45AgH+rDh3v6K0RhLfxgu7Ku5aXCgfriNBgcSTrxzABioXdtW3gkWofgDTGol6CJ
         vIWHp1HUwfPCxdlkG9hnsFUDcYI1CMcQkbT+HGax0oi/SVMhoBk5vtFjAdLqNhSVHp
         Re6vuRHzW2bbGj4n/YUk6hyDeinGGKsV9BWUnE3Xmoc6fC53xBBWHpJu7sIgl3P3nx
         sg1QzsfDpQr7/xpUqOx07T1OY/lLoZ4uihEl434xssOe9Usj50DeOEJ2SJFz80zLgC
         5ika+kBpysrnPM3cQ8w1sTF0jhY0gfyVnXMjGzoTz/cq4TiViwtC9uP5nmeU7QcDnE
         hAmF3D+RefGrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF698E49FA1;
        Sun,  3 Jul 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nf_tables: stricter validation of element
 data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165684781291.480.12626712312264137835.git-patchwork-notify@kernel.org>
Date:   Sun, 03 Jul 2022 11:30:12 +0000
References: <20220702191029.238563-2-pablo@netfilter.org>
In-Reply-To: <20220702191029.238563-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sat,  2 Jul 2022 21:10:27 +0200 you wrote:
> Make sure element data type and length do not mismatch the one specified
> by the set declaration.
> 
> Fixes: 7d7402642eaf ("netfilter: nf_tables: variable sized set element keys / data")
> Reported-by: Hugues ANGUELKOV <hanguelkov@randorisec.fr>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nf_tables: stricter validation of element data
    https://git.kernel.org/netdev/net/c/7e6bc1f6cabc
  - [net,2/2] netfilter: nft_set_pipapo: release elements in clone from abort path
    https://git.kernel.org/netdev/net/c/9827a0e6e23b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


