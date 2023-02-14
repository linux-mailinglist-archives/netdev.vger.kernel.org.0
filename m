Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3027695CC5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbjBNIUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjBNIUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501B9211D0;
        Tue, 14 Feb 2023 00:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E455E6148B;
        Tue, 14 Feb 2023 08:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A35DC4339C;
        Tue, 14 Feb 2023 08:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676362818;
        bh=KEg8Sfi9xjY1oiL55ZN8vK2MuOgVIXXa+WnRoJyLrRk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MsVhSEe6AaUyfI1Wld4oBuWf1WNIQsW2UqboOUga4WDgOX4eHGq65AuciZJqXqPAJ
         jR9hV2odzRBsR3OMJe2Cz81nHUHJKXOI2rodg8yUmWtWoQekVtzuaxN4MURn8xDsc1
         XF4A7ZTI2nTrce6efUrfb0uZWB8vbCMd5VYWsRnzgL6hef/y23sd87NGQrXmpHYTKS
         RMouvE8GQqDFkTV5jrNYfwi2tHzGaGLbw7bt/W6d364fEWMtIM0fP8w+fbhifewiuN
         XNR6LOKcGSk3EPARJbF7XJDRwiduBVRslrpWuMNQF7l0S37OveKBCBd3kb+/Zx+Pmt
         MyjFZEs1cu7aA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D883C4166F;
        Tue, 14 Feb 2023 08:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: stmmac: Restrict warning on disabling DMA store and
 fwd mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167636281818.8537.7827873287858808714.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 08:20:18 +0000
References: <20230210202126.877548-1-cristian.ciocaltea@collabora.com>
In-Reply-To: <20230210202126.877548-1-cristian.ciocaltea@collabora.com>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        sonic.zhang@analog.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 10 Feb 2023 22:21:26 +0200 you wrote:
> When setting 'snps,force_thresh_dma_mode' DT property, the following
> warning is always emitted, regardless the status of force_sf_dma_mode:
> 
> dwmac-starfive 10020000.ethernet: force_sf_dma_mode is ignored if force_thresh_dma_mode is set.
> 
> Do not print the rather misleading message when DMA store and forward
> mode is already disabled.
> 
> [...]

Here is the summary with links:
  - [1/1] net: stmmac: Restrict warning on disabling DMA store and fwd mode
    https://git.kernel.org/netdev/net/c/05d7623a892a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


