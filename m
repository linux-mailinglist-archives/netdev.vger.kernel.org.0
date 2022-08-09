Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BCD58E019
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245432AbiHITVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346251AbiHITUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:20:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8026B6B;
        Tue,  9 Aug 2022 12:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C4ED61326;
        Tue,  9 Aug 2022 19:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC600C433B5;
        Tue,  9 Aug 2022 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660072814;
        bh=81XeKBIOTuViOXzOT+xKcRsK1UYPVU/Cp4BxSy5DYWM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R0KHcgYDNmNEGZQ1AOLZIS0k2iQxvRXpal+2Vre18QuI/mM0fFfFYSgPvjUhu0Lrh
         ofu+yVlIKsKbnQJ3ZjNNTAWRMan22qxxXgTtidkBBojQQTecd5779I28Q1tXy5uqsg
         wjZmJZJple/3r77jxYefwskElBtYHbbnQfzlZEizlTfwKQbPbhs3xZ3KT2jjcUGYDg
         TIPn6D+nRMLiq54HlsNd/2DjBwS/EplAmljqQcO9MidYG/grapa5OIMZzOpdzAKH4N
         Jh3GGq7getfPocYmDD4TOX18iP9drZSUgGS2wM+zWOAPF6j/1Jm6FaCjPZl+awPyMD
         Zr8ovfbF29nIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8B6FC43142;
        Tue,  9 Aug 2022 19:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-08-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166007281475.26938.13151240188198368050.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 19:20:14 +0000
References: <20220809164756.B1DAEC433D6@smtp.kernel.org>
In-Reply-To: <20220809164756.B1DAEC433D6@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 Aug 2022 16:47:56 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-08-09
    https://git.kernel.org/netdev/net/c/7ba0fa7f32f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


