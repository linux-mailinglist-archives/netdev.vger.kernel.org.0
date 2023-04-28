Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283F56F13C5
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 11:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345518AbjD1JAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 05:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345383AbjD1JAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 05:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF512273E
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 02:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F3D064221
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B4F4C433A0;
        Fri, 28 Apr 2023 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682672421;
        bh=ojXxi/Ox2Ij46TDSqcm/EPsKKl4hz/bNNi8X3cjdcyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H43C86fFaP/uriKDqUajIqvDFeL0kxy0TJbxgFhBZVfo0oBYsjFolDNVo3NUYPabM
         xTXkSqPtrkP2trDJGOfUDixNq7PsfEDJEOnKtdnYfoeNE0yxTjL3YtSB56uR0z/4Qi
         tX/Avo4xFb1gHN01koWV9f52Vor0iydvvkz7NMma/jnTYekxC3/QN6MB4LpYN1CaSL
         DIxE/TVlUe8ckDr0xynEfdmp08NSRGX7m0V6ygtwFvQ68wdDpA2i6v8juF8YeWf2KP
         OEBGMJ/wvOvUdN9JLwVNWr1dZQUEVbkTImGpZCsDzL/xYgpsRqL5N6chNeJlHVrd33
         UsUFJTaSjlsVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60E18C73FF3;
        Fri, 28 Apr 2023 09:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: add mv88e6321 rsvd2cpu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168267242139.9185.10007731941977130235.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Apr 2023 09:00:21 +0000
References: <20230426202815.2991822-1-angelo@kernel-space.org>
In-Reply-To: <20230426202815.2991822-1-angelo@kernel-space.org>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, angelo.dureghello@timesys.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Apr 2023 22:28:15 +0200 you wrote:
> From: Angelo Dureghello <angelo.dureghello@timesys.com>
> 
> Add rsvd2cpu capability for mv88e6321 model, to allow proper bpdu
> processing.
> 
> Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
> Fixes: 51c901a775621 ("net: dsa: mv88e6xxx: distinguish Global 2 Rsvd2CPU")
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: mv88e6xxx: add mv88e6321 rsvd2cpu
    https://git.kernel.org/netdev/net/c/6686317855c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


