Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4625BD8FA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiITBAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiITBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06D54A80A;
        Mon, 19 Sep 2022 18:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67EBC61FCC;
        Tue, 20 Sep 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDDA8C43141;
        Tue, 20 Sep 2022 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663635615;
        bh=5rlOT2MBuAONykuxvoM0F+tMTDJxeyxlWO1ncCCNQVA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MN+Sr9nd4afmF2LJNLNcV9D+dUBX9yVZPpmZb6jvRwre2f+VO7xso3tse40Vv7Wb2
         G4yVfEUNTIb86486jHVLjPwQnggQyx+VTC6GYEHJfQv66uVzC8l2xYc8DsMqYlO2bC
         KVjxssYTwZcLdgNEg1Ih235OuPBVLOSjZ+YhC1EVx6Mq9JfR1IlrcVUbTTo8+PAvTa
         K/NyrdEpseFjDd46Zy55X7fkaMClcvqSbywXyj/HrkWvecFoxcrHEPMH1Rf0iH3/uU
         yMpVddcDQpVAlN93RgeUwt2Xbm5lcJaYYxQfKX0APq8/a+bmO9n2mbiz2NTEV8Z5pk
         NbLqEXVm/dWPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0CFEE52539;
        Tue, 20 Sep 2022 01:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mana: Add rmb after checking owner bits
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363561565.18776.11288575492844926736.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:00:15 +0000
References: <1662928805-15861-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1662928805-15861-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 11 Sep 2022 13:40:05 -0700 you wrote:
> Per GDMA spec, rmb is necessary after checking owner_bits, before
> reading EQ or CQ entries.
> 
> Add rmb in these two places to comply with the specs.
> 
> Cc: stable@vger.kernel.org
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Reported-by: Sinan Kaya <Sinan.Kaya@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> [...]

Here is the summary with links:
  - [net] net: mana: Add rmb after checking owner bits
    https://git.kernel.org/netdev/net/c/6fd2c68da55c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


