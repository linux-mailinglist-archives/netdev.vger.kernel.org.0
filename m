Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FECA52F114
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347840AbiETQuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbiETQuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435C2340D1
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C64F561E77
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21908C34116;
        Fri, 20 May 2022 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653065412;
        bh=sd5e97BxUEp5Y75gaChUeOdcrrFRH18yLOpxbCVaxpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A1Kdx33P85OYdkHPvxsypXp0HBKHerE2ase4DXQBDdNQ/azi/m4LtNfIGjsWBMLYf
         C7B7o6TdNq/LPgU1kResSpTrx4w7UmKkpCp/jwGJxbq+lpEMknSeSAx4Uh1GGsNtNx
         o7dA1odZkh/AqSY67SCyrX6/e3D3CHcfQbGdxVBqaf1LpJH8V7sXNNANvRdCND9yH5
         LpXAFY/YIzXtehhCdC43d7Z5fj8sCHI+m7YRz29mLhkQnl6CR4sWEQJ2b+NpFj2bFJ
         hArQlGOR76TOsteGtlaUEtAeM/4bTF/acbckfR8zGLgH0fzp1r1NjptGoWh0DMGko6
         2beUMZrAtK3Rg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01FDFF0389D;
        Fri, 20 May 2022 16:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp_ipv6: set the drop_reason in the right place
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165306541200.23981.12296293606236163499.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 16:50:12 +0000
References: <20220520021347.2270207-1-kuba@kernel.org>
In-Reply-To: <20220520021347.2270207-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        flyingpeng@tencent.com, imagedong@tencent.com,
        benbjiang@tencent.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 19:13:47 -0700 you wrote:
> Looks like the IPv6 version of the patch under Fixes was
> a copy/paste of the IPv4 but hit the wrong spot.
> It is tcp_v6_rcv() which uses drop_reason as a boolean, and
> needs to be protected against reason == 0 before calling free.
> tcp_v6_do_rcv() has a pretty straightforward flow.
> 
> Fixes: f8319dfd1b3b ("net: tcp: reset 'drop_reason' to NOT_SPCIFIED in tcp_v{4,6}_rcv()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] tcp_ipv6: set the drop_reason in the right place
    https://git.kernel.org/netdev/net-next/c/dc7769244e03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


