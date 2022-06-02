Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3552A53BDFA
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 20:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbiFBSU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 14:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237991AbiFBSUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 14:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B171E5DD32;
        Thu,  2 Jun 2022 11:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A1B1616F9;
        Thu,  2 Jun 2022 18:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E11DC34114;
        Thu,  2 Jun 2022 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654194014;
        bh=aKofY/xii58Ay5t+eF5YX3hdOSJaq5bVkJH0FJWL58I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=McC1kwoOT0LAQdbQKyEAsr3Ke8BjvnMABZ8Xjgo4oInbmx0HniAiD4t6/m2tMG4es
         V/dilRUwGPXB2VL6hyim0nKfiKpkvmbq1EF8WumWDN6SOber7M9awdrb+4FP9YiWMO
         6xbEFNRkqQSITEmJUbcQLaKlmVvE2fC3+djA3okXre5krYMc+bvrEzktXfDxw3t0fX
         5aJtuy2YsP19+ARXPauDi9Iyu22tAlNlhQtxMTS3ZEVSOse8vXV9Bt3eAckwHQrGlw
         +heeqB97twnrEmv7pxj/Y36K64wKm3tUMlirYYRFcCuCmP8N4X2aVxh7sUiZGU66cY
         KrpC2YTrsS9Kw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 712DFF03953;
        Thu,  2 Jun 2022 18:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 1/1] stmmac: intel: Add RPL-P PCI ID
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165419401446.24492.827425543522994299.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 18:20:14 +0000
References: <20220602073507.3955721-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20220602073507.3955721-1-michael.wei.hong.sit@intel.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        vee.khee.wong@linux.intel.com, weifeng.voon@intel.com,
        tee.min.tan@intel.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  2 Jun 2022 15:35:07 +0800 you wrote:
> Add PCI ID for Ethernet TSN Controller on RPL-P.
> 
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next,1/1] stmmac: intel: Add RPL-P PCI ID
    https://git.kernel.org/netdev/net/c/83450bbafebd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


