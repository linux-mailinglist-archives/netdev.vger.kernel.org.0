Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351E36DA787
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbjDGCLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240067AbjDGCLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:11:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18F48A42;
        Thu,  6 Apr 2023 19:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CF86643EA;
        Fri,  7 Apr 2023 02:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5CB5C4339C;
        Fri,  7 Apr 2023 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680833418;
        bh=Q3FzYDlpDI9SDYDxmpJRGF9uNLEB/6+qA4rayImiYPE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r3pXys8hH/oxX0K4bjfJykEuOXlaMf9JKb+25+IJOMoj9Gl0k7yZusCuEQDuFlBGQ
         e/7YOyhsiZ0LreTgIsoGbNy5LKn54EYyO/9tNS/MGn3gEk2TrS1dAAweMOwIpDAmQE
         v8cYmRCsIJ1N9aPKs/EEQ2Vr1m+4WFR6iG1lfd32JR8vmt7eXQIy0E+ZF5nmZbb3AS
         hpHtZY5Nc4AiCzWuDKpHExe/1Uuwt4G19VR7HPB2SRBLIVTYKUFC1Cptm5haFMLThI
         lb4MWAT37y1SyokVbcC3AeXsf4A/9u77OVn+SRo3XLdY+5GMvzQSXnxVdqHVcx/kUM
         QwuxuaqvZTWlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85091C41671;
        Fri,  7 Apr 2023 02:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sunhme: move asm includes to below linux
 includes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168083341854.14298.7477328624858057307.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Apr 2023 02:10:18 +0000
References: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
In-Reply-To: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, seanga2@gmail.com, geert@linux-m68k.org,
        lkp@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-m68k@lists.linux-m68k.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 05 Apr 2023 19:29:48 +0200 you wrote:
> A recent rearrangement of includes has lead to a problem on m68k
> as flagged by the kernel test robot.
> 
> Resolve this by moving the block asm includes to below linux includes.
> A side effect i that non-Sparc asm includes are now immediately
> before Sparc asm includes, which seems nice.
> 
> [...]

Here is the summary with links:
  - [net-next] net: sunhme: move asm includes to below linux includes
    https://git.kernel.org/netdev/net-next/c/f8b648bf6628

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


