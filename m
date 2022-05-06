Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150A351CE13
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381616AbiEFBYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358952AbiEFBX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F50D1E9;
        Thu,  5 May 2022 18:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C74D6201C;
        Fri,  6 May 2022 01:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DEFEDC385AC;
        Fri,  6 May 2022 01:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800014;
        bh=UiQZbTLmQ8yiUxgn3Kcg51Ri8F3LHapMArUz95DJ/Gw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kGSPH6piKRxWT2TfTImDHw1LjeqHW2D/1gEFXZR+Hh/W35s1K+UpyEa3xw8hko9it
         0wYcRx6ROzNj103CSSGDBh4mkKxm3uZo4OUTNXHmIszAsVQY14wVCw/YbkRoWgatl7
         hsOOId7hMhrsGanlG6i42qN4TtLW+pzwxL+9gOEHA070+BDHPrYeia+DIZbHdK6j/1
         eG2Tn2ERnY1hIl/Me4Outkdw1KMagaEB8j90FgBIbvI9yNFUM4dZWUR/dNuB+OcLDv
         uTWcgL29uvc9MxgU5dZFqLRMd2nY2xl+sqbcm9u0ErCFYFa4yg4bVVTn31OM/YjfsI
         2oYy4lWXqpgeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8FBEF03874;
        Fri,  6 May 2022 01:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] sungem: Prepare cleanup of powerpc's asm/prom.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180001481.16316.79901815992986939.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:20:14 +0000
References: <f7a7fab3ec5edf803d934fca04df22631c2b449d.1651662885.git.christophe.leroy@csgroup.eu>
In-Reply-To: <f7a7fab3ec5edf803d934fca04df22631c2b449d.1651662885.git.christophe.leroy@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 May 2022 13:16:09 +0200 you wrote:
> powerpc's <asm/prom.h> includes some headers that it doesn't
> need itself.
> 
> In order to clean powerpc's <asm/prom.h> up in a further step,
> first clean all files that include <asm/prom.h>
> 
> sungem_phy.c doesn't use any object provided by <asm/prom.h>.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] sungem: Prepare cleanup of powerpc's asm/prom.h
    https://git.kernel.org/netdev/net-next/c/d9ccf770c7c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


