Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F556BE396
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCQIcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjCQIc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:32:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71341CA36
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 01:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E95A62213
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0764C4339E;
        Fri, 17 Mar 2023 08:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679041821;
        bh=8uRuPMn/9aC2D9lJloy3zb0GOx8nNEkio5RxPrX4+HY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oDPPyvxZMKtXBEDfx8S3bwyjZdF5AeRBnm39PHbys/L+G6X7B8pDtaRAP+oKeqLPc
         W+AXjVuEQ8+TFn3TBP2BGS9+vvpNowR9IlUiUo1OzOa6S8QiW4w3XEY/C+Rg6MKWSi
         +AI+7RfQewDe+/nw01u11H/Ak+XT2Ba/1/xO5YfkX33RVZDuyek2BeZLfErA/1opoK
         n3q1kpKAwVvnXUfdu0kSOaqF7D8XEuNuf2Rwt278T9lC6nmbbPFQ0Sx2YlBf78JR+V
         dnkisJikxqU9yzAViG4EZ2BClNdX4v7bI07tjDTdWI/SKNPh+LUtJii7Mn4vCQ3NXh
         XxSnWSr5X1FLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84459E2A03B;
        Fri, 17 Mar 2023 08:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vlan: partially enable SIOCSHWTSTAMP in container
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904182153.13932.7880766457355444729.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:30:21 +0000
References: <20230315153302.1472902-1-vadfed@meta.com>
In-Reply-To: <20230315153302.1472902-1-vadfed@meta.com>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     kuba@kernel.org, liuhangbin@gmail.com, richardcochran@gmail.com,
        pabeni@redhat.com, edumazet@google.com, vadim.fedorenko@linux.dev,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 08:33:02 -0700 you wrote:
> From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
> 
> Setting timestamp filter was explicitly disabled on vlan devices in
> containers because it might affect other processes on the host. But it's
> absolutely legit in case when real device is in the same namespace.
> 
> Fixes: 873017af7784 ("vlan: disable SIOCSHWTSTAMP in container")
> Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
> 
> [...]

Here is the summary with links:
  - [net] vlan: partially enable SIOCSHWTSTAMP in container
    https://git.kernel.org/netdev/net-next/c/731b73dba359

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


