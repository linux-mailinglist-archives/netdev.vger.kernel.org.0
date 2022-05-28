Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFA0536D4B
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 16:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbiE1OaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 10:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiE1OaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 10:30:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A0118E09
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 07:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37B5160E77
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 14:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CFBFC34117;
        Sat, 28 May 2022 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653748211;
        bh=0n3pzcCq0bSELDO2vctcbS2m6S4r78iPdsJWJhIRR7g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dFkxc5ENq1/6P1TG1TAIShDn8sB6TyQjwa8832B+YVjZ3YC76KQqzcFPdOqnTLqXP
         JR/GMEN7X8olhcLFqli0eV6+eyPOxSI9KfnJ2ETyriwWfiAAB6udN/NH4VIaRCM1Wo
         u4U1FW1cIkR55sx/8IeWOvmlLw87cJfb6mpWe5nwRj4JipSiV9Xt1ao5mCnDF3A//t
         XJV5kQCurcZLVhNYqPKM4zYXa6VdjYDab7sTW+OimPhEHSj698YfxrbeoIOai24cFk
         HBJh+BxjRx0v99l5P07qL8jIFqpEfniQjNgNfRYwbQsoexP1zjJG1Z9MkoVMmKMa4/
         HmdwKTepp1sjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64514F03942;
        Sat, 28 May 2022 14:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: only report pause frame configuration for physical
 device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165374821140.9964.13031827104109225961.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 14:30:11 +0000
References: <20220527182424.621275-1-simon.horman@corigine.com>
In-Reply-To: <20220527182424.621275-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, yu.xiao@corigine.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 27 May 2022 20:24:24 +0200 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Only report pause frame configuration for physical device. Logical
> port of both PCI PF and PCI VF do not support it.
> 
> Fixes: 9fdc5d85a8fe ("nfp: update ethtool reporting of pauseframe control")
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net] nfp: only report pause frame configuration for physical device
    https://git.kernel.org/netdev/net/c/0649e4d63420

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


