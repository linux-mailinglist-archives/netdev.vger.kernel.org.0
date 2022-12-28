Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4884657638
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 13:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbiL1MAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 07:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiL1MAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 07:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092071180F
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 04:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 992C9614A7
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05532C433F1;
        Wed, 28 Dec 2022 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672228817;
        bh=IUqHLJmLPddAkfdYnWTPhU2TGL3O4Yy9p3YXfd9pZCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q5h5lzmsNNveH+L28XewqwBsivrPEMN0wO5MCnVP/J2v4mfn6aT6fXzX6jmQtPHEh
         WnmN9ZaLaAs4CzOZMizSUbvuNVL7j2D4R5WYjHBvb5OphPgT0kKZSrsqXCT+Dih/5n
         Ty/OdPLP/upCSMCnPeyTlwuV1HEFCp9KE3flgmFGK71sdG26wCyjEMOmbLwv/xARnh
         XX4MYQi6PiUGLyNqeDrWzQaW7imsdSLxs7NdK8nHAINBC//J6zaFlr8FU/1KqnCxLd
         otV8v/SAbMbJT0W5M/HdOkO3vTrQfrZM9fCksRsWikfD/IaYEip50NpuiApvqEWGH1
         iHbmOcOylds2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB213C395DF;
        Wed, 28 Dec 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] fix dmar pte write access is not set error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167222881688.20935.5501049497552622674.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 12:00:16 +0000
References: <20221226123153.4406-1-hau@realtek.com>
In-Reply-To: <20221226123153.4406-1-hau@realtek.com>
To:     Chunhao Lin <hau@realtek.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, nic_swsd@realtek.com
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
by David S. Miller <davem@davemloft.net>:

On Mon, 26 Dec 2022 20:31:51 +0800 you wrote:
> This series fixes dmar pte write access is not set error.
> 
> Chunhao Lin (2):
>   r8169: move rtl_wol_enable_rx() and rtl_prepare_power_down()
>   r8169: fix dmar pte write access is not set error
> 
> v2:
> -update commit message
> -adjust the code according to current kernel code
> v3:
> -update title and commit message
> -split the patch
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] r8169: move rtl_wol_enable_rx() and rtl_prepare_power_down()
    https://git.kernel.org/netdev/net/c/ad425666a1f0
  - [net,v3,2/2] r8169: fix dmar pte write access is not set error
    https://git.kernel.org/netdev/net/c/bb41c13c05c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


