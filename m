Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC90B4C4520
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 14:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiBYNAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 08:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiBYNAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 08:00:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EFE1DA007;
        Fri, 25 Feb 2022 05:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 229A8B83022;
        Fri, 25 Feb 2022 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B707EC340E8;
        Fri, 25 Feb 2022 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645794010;
        bh=drhUIkFwhZuOmzO4HyFTpZzdjlDBmOAg++AaIHs35gc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RKKrN0qlxAeIb85z4H7KLkHMECeP58LRdumLhFLfxo7IBUJE2Z9NP2M195lM9gQwp
         PdgkPH/VReuB/NJFyqDbP/ttQPD4Z7rkBzpmBnZwHmBJUof5XhBUuwDbeP5rGhLdYH
         zycg37I6bizoTe69XQFXVwiEOWNTO/V+hfGZctaLLJ1Ap+T+jE8GvlVqpLIE4IRKiJ
         9Xe4r6hTyHiRFzXkg7+BPDF1wzLkHb1E4tvyMMJ4oEcvswSoKAh6IZOcF7h7n4V03i
         s+5gwQJalFvqdv9oe53PJ7OnVlXtEmNLMSNKEk6RtaiyRCde6mQqfl0JOZHDVN6Pyz
         WZaUkxCsinTAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C3E6EAC09A;
        Fri, 25 Feb 2022 13:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: chelsio: cxgb3: check the return value of
 pci_find_capability()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164579401063.25347.4798991812587825840.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 13:00:10 +0000
References: <20220225123727.26194-1-baijiaju1990@gmail.com>
In-Reply-To: <20220225123727.26194-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 25 Feb 2022 04:37:27 -0800 you wrote:
> The function pci_find_capability() in t3_prep_adapter() can fail, so its
> return value should be checked.
> 
> Fixes: 4d22de3e6cc4 ("Add support for the latest 1G/10G Chelsio adapter, T3")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: chelsio: cxgb3: check the return value of pci_find_capability()
    https://git.kernel.org/netdev/net/c/767b9825ed17

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


