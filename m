Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62BC52CA10
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiESDKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiESDKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63C0DE314
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A38861923
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C70CC34115;
        Thu, 19 May 2022 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652929813;
        bh=3AHcIg+X3s40QcgBRgEI/qSS8q9QJ62UaAjakqQELps=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q2ilUZmWH3Ahoimi7suSvk8RJtrvpH0ciqSuF/jwYxMAplbCMIPOECSYZiPtAdszN
         U8Xbx3sTk1BobNIY/+EZXSWnG8yVlvp7ElyDWfyHmGp6LGhdY93pAxO7FdZZMnD0mu
         8avUuXfSyc4TAnc+qgZYrubICJsfkchWP1/jLUmSMzqZ5ZBt2LsgdD+NObm6XMiCA6
         b2dFknFkdHuI0Aas4cuU+2aGhkfnRM7N0ShRCCWC2sdP+07wvIaOMkonrZQRpHuNLO
         9ftjJztuQiID4+WsQhKQQyKoFNQL63sSql97ATrztF4VOfQDMqGdmdKrbIz5K8KvLw
         BzaYGaNwTGxQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54C8AF03939;
        Thu, 19 May 2022 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: siena: Have a unique wrapper ifndef for efx
 channels header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165292981334.2906.9363116171367934646.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 03:10:13 +0000
References: <20220518065820.131611-1-saeed@kernel.org>
In-Reply-To: <20220518065820.131611-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, saeedm@nvidia.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 May 2022 23:58:20 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Both sfc/efx_channels.h and sfc/siena/efx_channels.h used the same
> wrapper #ifndef EFX_CHANNELS_H, this patch changes the siena define to be
> EFX_SIENA_CHANNELS_H to avoid build system confusion.
> 
> This fixes the following build break:
> drivers/net/ethernet/sfc/ptp.c:2191:28:
> error: ‘efx_copy_channel’ undeclared here (not in a function); did you mean ‘efx_ptp_channel’?
>   2191 |  .copy                   = efx_copy_channel,
> 
> [...]

Here is the summary with links:
  - [net-next] sfc: siena: Have a unique wrapper ifndef for efx channels header
    https://git.kernel.org/netdev/net-next/c/309ec443079b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


