Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6316D5F7502
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiJGIAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiJGIAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CA5C7075;
        Fri,  7 Oct 2022 01:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5523B8227E;
        Fri,  7 Oct 2022 08:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4997BC43141;
        Fri,  7 Oct 2022 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665129615;
        bh=d44N4gqxHInmNf4boTWB0xiUI7/UpFIDhQj5jyV7+G0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UT+y7OfaBdO4Wr5C8qaC5gSa866vD7P3K6ck6z8v5A5LKg7w0+r+RpJm2HbZ6Stxj
         H1D9fFrL5RqhAoKg2gpzYMpTG2GIQxMjo93ZZK9elEuK0ih81kamM6/RA7vNuY9oGH
         PaXK9c5M8GNnoO6BfKWP/OK4HOAMpdTgsUqr3ybMWoDTGiII2g6gksTi6lDFZzEf0d
         Ii0GGwIDPhg+b/HRxr5r/El0a6UAX6ssEjQD474ax+hQ1izW2PEr4QDQHBjagVko0a
         s/PsML8iObLCFw+XnZAtyl5p1QRCcvvLZA9EEzOX36/XDVT/Rc2ctLLJa/NP4FtRE5
         q5S2/QKiSc4Lw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FF47E43EFE;
        Fri,  7 Oct 2022 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] prestera: matchall: do not rollback if rule exists
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166512961519.5723.11597634492157550445.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Oct 2022 08:00:15 +0000
References: <20221006190409.881219-1-maksym.glubokiy@plvision.eu>
In-Reply-To: <20221006190409.881219-1-maksym.glubokiy@plvision.eu>
To:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, vmytnyk@marvell.com,
        serhiy.boiko@plvision.eu, vkochan@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Oct 2022 22:04:09 +0300 you wrote:
> From: Serhiy Boiko <serhiy.boiko@plvision.eu>
> 
> If you try to create a 'mirror' ACL rule on a port that already has a
> mirror rule, prestera_span_rule_add() will fail with EEXIST error.
> 
> This forces rollback procedure which destroys existing mirror rule on
> hardware leaving it visible in linux.
> 
> [...]

Here is the summary with links:
  - [net] prestera: matchall: do not rollback if rule exists
    https://git.kernel.org/netdev/net/c/fb4a5dfca0f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


