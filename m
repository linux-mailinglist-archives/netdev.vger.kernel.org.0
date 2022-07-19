Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1F457916A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiGSDkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbiGSDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135CC62C8;
        Mon, 18 Jul 2022 20:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B198AB81901;
        Tue, 19 Jul 2022 03:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B797C341D3;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202014;
        bh=Ha+G7/QZOBlSIVc+THxNSr3mjDzy4K0v97LH89eHzqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ctj02x3oBaDnFmMd+kKobIerGKxk0/SGRgEQq3YQDp3RzOOg5DBiPZS/2GHZ+MhlO
         243812RrjLPHgwtOS5EuzXPAj15bPOrFnDeQdt8ZXCRar1fBfrFEG62JMdALNYrbW6
         Fr6505jakd4QjY0n28/ppisuhCdGysLfyviJh7lqZlQBLWSd4BaKxaCwJmUVMa40RP
         hKGHgd7jLGct8I4oySBoxueDIfTDlWVFVOx8FRmCzSeumNGxekDH5ipQ08rX4evxD/
         Ln8ZUtE7cJCH2uEYuivLFf62dyFts7oUTz7Ic7ARJ8EmIc92iWoFTwFFUMVGDlsEL4
         R7GDF3niYREWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32ADBE451BD;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: remove redunctant disable xPCS EEE call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820201420.29134.3465900880511304469.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:40:14 +0000
References: <20220715122402.1017470-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20220715122402.1017470-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 15 Jul 2022 20:24:02 +0800 you wrote:
> Disable is done in stmmac_init_eee() on the event of MAC link down.
> Since setting enable/disable EEE via ethtool will eventually trigger
> a MAC down, removing this redunctant call in stmmac_ethtool.c to avoid
> calling xpcs_config_eee() twice.
> 
> Fixes: d4aeaed80b0e ("net: stmmac: trigger PCS to turn off on link down")
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: remove redunctant disable xPCS EEE call
    https://git.kernel.org/netdev/net/c/da791bac104a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


