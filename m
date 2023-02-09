Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0DA690008
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBIFuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBIFuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:50:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5DF38E8C
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E589B8164F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A98FAC433EF;
        Thu,  9 Feb 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675921818;
        bh=Jw87IvrvlS8zKRYyoUWGCmDWxdLn/A4qd7dTlmaeAmw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DogOZ2duWtdI8orV4EWnTMKdFBwfaGFoW2n8ccaJBKwxTbV78jlEIynP83wetsj1T
         3Hr/omM0Ip3cWFsWax7akk09R4xHkMjSlOYJofA/CQlKeKmurVoJSajT0JumECGYoZ
         BrHaTgyLR3gL2xMj2fWs/GdJJs1gIH15Zzp069hD6VxKC24NqtKtfjFRTdvBeibL9w
         mVqblL+aRIC24Nc2nxR9/bShWjHW3eexjk7f1dtgBgUHRud4lx47R39JbfOFSVhYJ+
         wRy2aRHg9NhTJ+X2Bf/CH30l0YNNbaQj96YJAKWPktpNNEqiJx0Dkeu8TtbiLLZeoa
         TdZXDt281NCIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 950A5E49FB0;
        Thu,  9 Feb 2023 05:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/6] Fix XFRM-I support for nested ESP tunnels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167592181860.20076.14239959787944760543.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 05:50:18 +0000
References: <20230208114322.266510-2-steffen.klassert@secunet.com>
In-Reply-To: <20230208114322.266510-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
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

This series was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 8 Feb 2023 12:43:17 +0100 you wrote:
> From: Benedict Wong <benedictwong@google.com>
> 
> This change adds support for nested IPsec tunnels by ensuring that
> XFRM-I verifies existing policies before decapsulating a subsequent
> policies. Addtionally, this clears the secpath entries after policies
> are verified, ensuring that previous tunnels with no-longer-valid
> do not pollute subsequent policy checks.
> 
> [...]

Here is the summary with links:
  - [1/6] Fix XFRM-I support for nested ESP tunnels
    https://git.kernel.org/netdev/net/c/b0355dbbf13c
  - [2/6] xfrm: compat: change expression for switch in xfrm_xlate64
    https://git.kernel.org/netdev/net/c/eb6c59b735aa
  - [3/6] xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()
    https://git.kernel.org/netdev/net/c/b6ee89638538
  - [4/6] xfrm: consistently use time64_t in xfrm_timer_handler()
    https://git.kernel.org/netdev/net/c/195e4aac74ce
  - [5/6] xfrm: annotate data-race around use_time
    https://git.kernel.org/netdev/net/c/0a9e5794b21e
  - [6/6] xfrm: fix bug with DSCP copy to v6 from v4 tunnel
    https://git.kernel.org/netdev/net/c/6028da3f125f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


