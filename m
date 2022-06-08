Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C02543A44
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 19:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiFHRZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 13:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiFHRZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 13:25:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FE0224
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 10:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35CCBB82994
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 17:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5374C341C8;
        Wed,  8 Jun 2022 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654708813;
        bh=w/90bReDWapslpMRW+RnZ57KnFifAyVHoY7CkDVbnCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DSz4vP7CnXQebAjBzy2xY4ghxJTyblbhmgHzua+pz3rQrXJt0ncNfl4nndLtSuAyi
         +MHY9bHZ5yl6UjKtW4GGcagkt/EHOWgxWMdFrUxSsyaejzaItPMHKK7YH9Np0lkBg7
         ywVD/ARA2J7i3EQkwTuMPU92F1YE9TvOtDdkZzi5Gp9fQcT0xIvzdfVKurFGeIDp9z
         vRMDjhtE8pKEOQixjMn5QFgGlIPVdeYgwEpCF2AYgo9vOLwVQIci/FWMd1zlRRHDmP
         zW/NZY9hNxNvfe2i9LE0OuhTfY70LNu/P1/eS6zOrgtWsqa8DxPQdshVDWMe65GxsU
         DcBK93Hojy7Sg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BCEF1E737FA;
        Wed,  8 Jun 2022 17:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next repost] nfp: Remove kernel.h when not needed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165470881377.3397.3384109913987970113.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 17:20:13 +0000
References: <20220607125103.487801-1-simon.horman@corigine.com>
In-Reply-To: <20220607125103.487801-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, christophe.jaillet@wanadoo.fr
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  7 Jun 2022 14:51:03 +0200 you wrote:
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
> 
> Remove kernel.h when it is not needed.
> 
> [...]

Here is the summary with links:
  - [net-next,repost] nfp: Remove kernel.h when not needed
    https://git.kernel.org/netdev/net-next/c/17e9157c4ed0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


