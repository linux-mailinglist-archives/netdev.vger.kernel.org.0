Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958E15ABD07
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 06:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiICEaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 00:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiICEaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 00:30:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECB45143C
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 21:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62464B82E4D
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 04:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3D18C4347C;
        Sat,  3 Sep 2022 04:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662179421;
        bh=DO+Qh5ggNYHZPVXOd3dbr3H6dYkqYck2klXC11tLfx4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s/ZhWdp4AZ3PTWM6uR0Ya+m1a588hSxnWKYzQBNY4tc3sAx070s92VOF910T6ZKTT
         3cS+K4aCdTlVsB+ESJ0o1a7Ax1CmMoFceV0XdauX5/bXYo7L+hlGI2ISE0basgneul
         wkoYkcZLCMYH00i819SHfZX48fGwiVq/p6iKbe8CLHIzeMIUfAQDgQKt/nKUlkxeO3
         QB0cJ6TnQBhPAebVUXKk4HDtzM64N5sEXTS6nFyZXwlOyosln2wt3mdocrBO5eFdln
         eTCP7X8KPIw8BFKhEsigV/ddjYs/z9PimfykbBp2Gr2d+PcBX52n0399Cn6ZdqtsDm
         UfZ/DN7SCmP5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6A55C73FE1;
        Sat,  3 Sep 2022 04:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] net: xscale: Fix return type for implementation of
 ndo_start_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166217942087.8630.15322887773567713403.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 04:30:20 +0000
References: <20220902081612.60405-1-guozihua@huawei.com>
In-Reply-To: <20220902081612.60405-1-guozihua@huawei.com>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     netdev@vger.kernel.org, khalasa@piap.pl
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 2 Sep 2022 16:16:12 +0800 you wrote:
> Since Linux now supports CFI, it will be a good idea to fix mismatched
> return type for implementation of hooks. Otherwise this might get
> cought out by CFI and cause a panic.
> 
> eth_xmit() would return either NETDEV_TX_BUSY or NETDEV_TX_OK, so
> change the return type to netdev_tx_t directly.
> 
> [...]

Here is the summary with links:
  - [RESEND] net: xscale: Fix return type for implementation of ndo_start_xmit
    https://git.kernel.org/netdev/net-next/c/0dbaf0fa6232

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


