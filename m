Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46325BD8FE
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiITBAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiITBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCA84AD6B
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB58461FCE
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25A68C433D6;
        Tue, 20 Sep 2022 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663635618;
        bh=hIXqlk5VsWa2r9994lVa6QK50i7HBezX+LDj7FH0+mw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aYalCU3CL8s8/FU+A4C3dA5NUnwIYWTGIpFWdJDDIZPxdmzWiNcUsiRZ8uTCjcUVy
         c1+XnsvJtZrb4YUF5RexFLb4yJhm4n//AdzyiJtS6n89w1gDsveMouXHNl9M6db9to
         brkYUnptc9N7SjCARltDoRgFCCFxFb3fA+gwkmLiGd6/xCSlfsKAtML6DxewxH8Wjx
         DfBaCuiRvgoLLu0bc9Y/aCt+MyD37oVdmrfU5EXRnzKl/IjHos0JN/iLNidV1U5G51
         p5iMMDcl4k9a6VuST7ZJStbhEvZaP0aRAWtOQYheNzi50bht/XQQQPDDAiF7fyVnsU
         4j6HX1zYXshbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1259DE52536;
        Tue, 20 Sep 2022 01:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [lee@kernel.org: [GIT PULL] Immutable branch between MFD, Net and
 Pinctrl due for the v6.0 merge window]
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363561806.18776.2602660694314353327.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:00:18 +0000
References: <YyHy53kHEMIhaoFb@euler>
In-Reply-To: <YyHy53kHEMIhaoFb@euler>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Sep 2022 08:27:35 -0700 you wrote:
> Hi Jakub, David, netdev maintainers,
> 
> Could you kindly pull in this branch to net-next? If this set and a
> quick Documentation patch Vladimir sent both get brought in, I can
> actually submit the networking portion for v6.1.
> 
> Thanks!
> 
> [...]

Here is the summary with links:
  - [lee@kernel.org:,[GIT,PULL] Immutable branch between MFD, Net and Pinctrl due for the v6.0 merge window]
    https://git.kernel.org/netdev/net-next/c/2bd178c5ea73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


