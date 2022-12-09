Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFA264813A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLILAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiLILAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:00:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0AC4AF3B
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41611CE2938
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70FE4C43392;
        Fri,  9 Dec 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670583616;
        bh=0NWOume5v1ZpkeFfqBb0Axg7sceeXJuKJlhRzJ4rwHE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nPPrEEcJF2riSnHvi3FgSdJhg5wnqOqAE8izqKoZ4XwBwsmj4AnHTQhlIr52PM0i8
         mVtvVA10wdSs0PYlMicwvOhmUVLQ67CCxOwY/1W62k77+suVYlLsi3Fox6NTwBFzZ0
         aEZFB1LgpiG9RZxDdhaGp13HjRWepNvgwNLmgZ9XrklDxCAltuzRJKljYarje9hMsC
         Q538kvlAqswtXHorZjpWTxOmCpEGvscNw5GA8sOD7sHnuiv8o1DD+lt06R2rryuiGe
         hXj4sxg13DBPR96WPhjQVvi50lHC/FfOFAbeTx2nkc5+uNEh5ImvakGJVTZN+luWFG
         zspAhXyqw9v0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57F46C41612;
        Fri,  9 Dec 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: fix possible memory leak in
 stmmac_dvr_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167058361635.21061.2629319765403507972.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 11:00:16 +0000
References: <20221207083413.1758113-1-cuigaosheng1@huawei.com>
In-Reply-To: <20221207083413.1758113-1-cuigaosheng1@huawei.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, boon.leong.ong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
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

On Wed, 7 Dec 2022 16:34:13 +0800 you wrote:
> The bitmap_free() should be called to free priv->af_xdp_zc_qps
> when create_singlethread_workqueue() fails, otherwise there will
> be a memory leak, so we add the err path error_wq_init to fix it.
> 
> Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: fix possible memory leak in stmmac_dvr_probe()
    https://git.kernel.org/netdev/net/c/a137f3f27f92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


