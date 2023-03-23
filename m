Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D8A6C5F2B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjCWFuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjCWFuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B55E234D1;
        Wed, 22 Mar 2023 22:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F1D162320;
        Thu, 23 Mar 2023 05:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0884EC4339B;
        Thu, 23 Mar 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679550622;
        bh=g8YfKuqBr+gfcRZSKEMhE11ZmpKWMUe+oYkc78dERWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GOxTnqt4+bjMiQrhfpM829yQnU5RmDLLP3gWd519iOjFVvvKNd8VlltH1uh7a/cpU
         23YboJPY4OdAQ+7B/STiQu3qYKaIqy9rnTbjkx2CE/o9RYbNggUyDP0w8n21FpQtng
         WcQbwfRVpz0VvLZ+XeSRnvNgFatLS18nPV4AUGEnBF6wFu3pYCI8+YBC/3l1KiZkwt
         XcR0MgIfv7tNc3vg7POSeZyjqkSOjcz2DhqXrfULFKKH3XU2zF3Yamo7e7x4riZtCz
         IQ+QBfGEJcDlMvT7CriGv5F9epVaFWxAXN9qcxlxMvXyoB0Z3RET3FM8pl/SAb79ji
         NF6nM/ExyyLDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6BF9E61B87;
        Thu, 23 Mar 2023 05:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: ipa: fully support IPA v5.0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167955062194.14332.15377053379096666266.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:50:21 +0000
References: <20230321182644.2143990-1-elder@linaro.org>
In-Reply-To: <20230321182644.2143990-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 13:26:41 -0500 you wrote:
> At long last, add the IPA and GSI register definitions, and the
> configuration data required to support IPA v5.0.  This enables IPA
> support for the Qualcomm SDX65 SoC.
> 
> The first version of this series had build errors due to a
> non-existent source file being required.  This version addresses
> that by changing how required files are specified in the Makefile.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: ipa: add IPA v5.0 register definitions
    https://git.kernel.org/netdev/net-next/c/ed4c7d616289
  - [net-next,v2,2/3] net: ipa: add IPA v5.0 GSI register definitions
    https://git.kernel.org/netdev/net-next/c/faf0678ec8a0
  - [net-next,v2,3/3] net: ipa: add IPA v5.0 configuration data
    https://git.kernel.org/netdev/net-next/c/cb7550b44383

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


