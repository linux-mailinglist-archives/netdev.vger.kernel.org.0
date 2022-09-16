Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A4C5BAC02
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 13:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiIPLHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 07:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiIPLHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 07:07:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD065E671;
        Fri, 16 Sep 2022 04:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2C3CB82639;
        Fri, 16 Sep 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 872A0C4314F;
        Fri, 16 Sep 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663326016;
        bh=nk5yklr3jPccgNUVNeA0VXjKEX7hoAxrbtYlOy99m3I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JAtvywTOiAGCOOvc5lrvKhQtAysC6WOTGm18K6B/H+ZZiQeQCsIegFkcxDLV7yHG4
         kKbO1ydMnHbPglOl48VwDyUe4sIlnE2lKHIvmPtpkSi9/oozlySWzxQ30C0fjT2dJx
         ATfWFx1C/SM0Ad492xusC0ChYLbKI8XGTe4WkVHlsXF2R3qLitlTzGYfq+NdcNqsNh
         9f0GUZJVqioZQKlpt3y+Hyccp7oVVdDaOIx6pUcflujOg/I3pMAtbJj52k7XWO5Soq
         JHtP4/KbBXEiOf2X0U0QwSrfi7s2Lj4D6EZ1REZ6c1D+PWJCbjfSxs4pphfd6rBhDL
         fBFqZD+6FmsfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 644EDC59A58;
        Fri, 16 Sep 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net] net: marvell: prestera: add support for for Aldrin2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166332601639.3119.9338617448070258895.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 11:00:16 +0000
References: <20220908131446.12978-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20220908131446.12978-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, tchornyi@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, taras.chornyi@plvision.eu
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

On Thu,  8 Sep 2022 16:14:46 +0300 you wrote:
> Aldrin2 (98DX8525) is a Marvell Prestera PP, with 100G support.
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> 
> V2:
>   - retarget to net tree instead of net-next;
>   - fix missed colon in patch subject ('net marvell' vs 'net: mavell');
> 
> [...]

Here is the summary with links:
  - [V2,net] net: marvell: prestera: add support for for Aldrin2
    https://git.kernel.org/netdev/net/c/9124dbcc2dd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


