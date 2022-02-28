Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E0C4C791D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 20:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiB1TwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 14:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiB1Tvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 14:51:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC4E111091
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 11:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B152E615B8
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 19:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B14BC340F3;
        Mon, 28 Feb 2022 19:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646077811;
        bh=g0O02oeJEKZPR+bjXdQOapeLVx70Z+8vik1kJHi4ZvU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g9YfFB6oYSgN2WxjlKBIjiFnYGeIBlMAk3Tstt/6W/ekc+fLgP45ywSccp1dy8vWk
         t26t+RbxsMzufwSAJRSpKNbIajLXJuKFsbgRtGQlXDQ6f42pt9Vngil53SIMoqh55x
         8TQNefMTjKIIF67TuNEZOP/HFjikSazitAgGe+fY+m5oqOdi28TRqC2SX5+0UBcrIy
         QJbT3U+TTybYAE8aqZx2nk6yrK0Z7OCM7KtizfQT18f7f7LQ5vo0lpfRciCSlKIlJb
         wbnaJrkQi+kMYGvJsgV7ZVRGeEzmz2Gy2wk27eHlC0aRNzEk30K1PwImJDt6glgyDq
         4a8T5A756547g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2009E5D087;
        Mon, 28 Feb 2022 19:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dm9051: Make remove() callback a void function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164607781098.24939.18404906830426011997.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 19:50:10 +0000
References: <20220228173957.1262628-2-broonie@kernel.org>
In-Reply-To: <20220228173957.1262628-2-broonie@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, yang.lee@linux.alibaba.com,
        josright123@gmail.com, netdev@vger.kernel.org, sfr@canb.auug.org.au
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 28 Feb 2022 17:39:57 +0000 you wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Changes introduced since the merge window in the spi subsystem and
> available at:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-remove-void
> 
> [...]

Here is the summary with links:
  - net: dm9051: Make remove() callback a void function
    https://git.kernel.org/netdev/net-next/c/0b9e69e1a1e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


