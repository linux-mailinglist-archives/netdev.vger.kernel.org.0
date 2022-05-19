Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5E52CFB8
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 11:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbiESJuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 05:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbiESJuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 05:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AFF6A437;
        Thu, 19 May 2022 02:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D01961993;
        Thu, 19 May 2022 09:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2608C34100;
        Thu, 19 May 2022 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652953814;
        bh=wl+btPd/yaK+eQnzl0vZBorWKiSajxGxDTfU7swwIgo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X06+xhuRbE1Pe4qWH7tE8xZR5lENxFJSzmmM5MXYwxZ/inDypHTAjtiqqG3YKREtF
         9khSGv46r2XcV/gBWru66cTcv63d/BD1s/UiXDZY+XLIxPG73NedfO/0oF0KfrWA1s
         IPDjdjrBRwyVamQrrZu2uR2cwhVaENu4vQoSUxh27ctp2Z3qkL41dQU+3VPjCpP9UL
         czBDHXxKaYDR82zEoHwxR3ln7Vyp1afJ6iPlldoNiEmZl1QJMVS3pIi4Etuhzby3OB
         bdm5ilGYOMF6ti0VA5far2ia5rUHlbeE9cdpsN87DOu6gpDL6X8w43MIG/p+8RmDYD
         Js38a5boTVaQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE008F03935;
        Thu, 19 May 2022 09:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fec: Avoid allocating rx buffer using ATOMIC in ndo_open
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165295381377.24101.2904952826223814220.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 09:50:13 +0000
References: <20220518062007.10056-1-michael@amarulasolutions.com>
In-Reply-To: <20220518062007.10056-1-michael@amarulasolutions.com>
To:     Michael Trimarchi <michael@amarulasolutions.com>
Cc:     qiangqing.zhang@nxp.com, lgirdwood@gmail.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 18 May 2022 08:20:07 +0200 you wrote:
> Make ndo_open less sensitive to memory pressure.
> 
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> ---
> Change:
> 	- Adjust the commit message addressing the comments in RFC version
> 
> [...]

Here is the summary with links:
  - net: fec: Avoid allocating rx buffer using ATOMIC in ndo_open
    https://git.kernel.org/netdev/net-next/c/b885aab3d39d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


