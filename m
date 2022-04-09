Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A274FA211
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 05:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbiDIDmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 23:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240689AbiDIDmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 23:42:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6798D396B5;
        Fri,  8 Apr 2022 20:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFE60B82E44;
        Sat,  9 Apr 2022 03:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66268C385A8;
        Sat,  9 Apr 2022 03:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649475612;
        bh=8kserIye4m8EF3lKwMWswBu7wmC8MlTlE3QbY7tqttA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=llow6ZpYh/T0S9ps7b0Wr48TZOn6KEHLCg2tf1SGfKOmI3b97Laj6YE+353i222dx
         ipjn9dMGNG9sz0vuA9O5mAQS9tUUfOr9SW3GULact6hG/lNS2ohLaujBYgiMC/26cQ
         jSEBruoogIwiRHAuOFrdFQhGY4uiSM+QINctNd0r2CjY6Hz5o1AlvezBsoePNEYeoV
         qyLRI23rjHQzRUbfNdeQDi13Z/IGqEJC6dbQBZ6Jng3G8RtWwy0tefQn3ArDO36eOP
         iik3pD3yaxMJFmxJFTNK1J3y2x1I0vTijxuVAE1xSLuJR28BMNKn8iTJZMa/CPM42D
         XdQinanswzN0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C38AE8DBDA;
        Sat,  9 Apr 2022 03:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: atlantic: Avoid out-of-bounds indexing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164947561230.6004.8819802230994446904.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Apr 2022 03:40:12 +0000
References: <20220408022204.16815-1-kai.heng.feng@canonical.com>
In-Reply-To: <20220408022204.16815-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org,
        mario.limonciello@amd.com, pabeni@redhat.com,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Apr 2022 10:22:04 +0800 you wrote:
> UBSAN warnings are observed on atlantic driver:
> [ 294.432996] UBSAN: array-index-out-of-bounds in /build/linux-Qow4fL/linux-5.15.0/drivers/net/ethernet/aquantia/atlantic/aq_nic.c:484:48
> [ 294.433695] index 8 is out of range for type 'aq_vec_s *[8]'
> 
> The ring is dereferenced right before breaking out the loop, to prevent
> that from happening, only use the index in the loop to fix the issue.
> 
> [...]

Here is the summary with links:
  - [v2] net: atlantic: Avoid out-of-bounds indexing
    https://git.kernel.org/netdev/net/c/8d3a6c37d50d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


