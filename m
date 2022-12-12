Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60C9649B5A
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiLLJkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiLLJkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5939B2E;
        Mon, 12 Dec 2022 01:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B1A760F71;
        Mon, 12 Dec 2022 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97988C43398;
        Mon, 12 Dec 2022 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670838016;
        bh=PFRwwAEE6T0Zl3Gpsu7MnXZ3cNnwcu75+uz54iDM9NU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lH2YSrreLrANfVftDnRJLJjrB2imMpsdCvhfIzxcGwnraRqVsCetjQ4FlJ+cXswhz
         TfBw1AJlKd1oSPmAUnrJ3SxsWP+hHChgymmxoOXDRKQLQGfxiGE/GX/7EYc8KbdOdg
         li2CPXThmmbQzJSq4dBMhD/nh1GCOie1cnbhf8Bu4hI+mPdUEgbNmu1/7uenV4yhGF
         BKHOFN+PvBrrfOEzRRE4XpFzYlTfdDYa1sTIIywMOuuFTyABsd3CdGJPkrAfIVud2a
         TELxhFieMdrYuV8OhTOAR3o3AAu/B/je67ddolFSWn+Fg8oGoPCIHrTAlzTxOckQHH
         HN/J3k3PpA7ug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79901C41612;
        Mon, 12 Dec 2022 09:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: Add check for taprio basetime
 configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083801649.1612.9436710695247859393.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 09:40:16 +0000
References: <1670490195-19367-1-git-send-email-jun.ann.lai@intel.com>
In-Reply-To: <1670490195-19367-1-git-send-email-jun.ann.lai@intel.com>
To:     Lai Peter Jun Ann <jun.ann.lai@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        michael.wei.hong.sit@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Dec 2022 17:03:15 +0800 you wrote:
> From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> 
> Adds a boundary check to prevent negative basetime input from user
> while configuring taprio.
> 
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: stmmac: Add check for taprio basetime configuration
    https://git.kernel.org/netdev/net-next/c/6d534ee057b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


