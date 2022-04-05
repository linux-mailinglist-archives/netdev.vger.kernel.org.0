Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AD84F5414
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1851073AbiDFEYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588495AbiDFAQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 20:16:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D89E170DBB
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 15:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 473A6619B9
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 22:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A360C385A0;
        Tue,  5 Apr 2022 22:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649198412;
        bh=6jwwjVm2m0DmhnBdvrUZ+JD2hUGSFUVgVkzl4Vdxr8A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YAVqcKzObXnqMDDPMpBhmGYfq6ztFLRfx0gy+8WD5QReAQWYsIy+ahrcb+Fk2i7eW
         gczPVEOZi9Y5jHB3W8g4HdBY50sT9HI+5/muQl3SjDnmvEIpSkJJ3D6Tr2ml2No+31
         rYt+GaWM1dd6oObdXz6cxJx8U1mxjrBOOPiXgdLpwKekMjo5K7PyKcFy1v6tHoIcp9
         gbpZ8Hk6ytGTePDG2z5dtMTBsvk/9mmWhXs3oRorHpBBav2q5pJyO3VIhjBakS8cj9
         vrRq1bUrtIAGMeW+4ANp4HVkfdXHn8tuIsff5sk5T0gHp+ZPuSKnIGDq3/DHROC/hA
         q1HWnEmrbW2vw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B565E6D402;
        Tue,  5 Apr 2022 22:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ensure net_todo_list is processed quickly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164919841250.28038.9580727063459863984.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Apr 2022 22:40:12 +0000
References: <20220404113847.0ee02e4a70da.Ic73d206e217db20fd22dcec14fe5442ca732804b@changeid>
In-Reply-To: <20220404113847.0ee02e4a70da.Ic73d206e217db20fd22dcec14fe5442ca732804b@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com
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

On Mon,  4 Apr 2022 11:38:47 +0200 you wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In [1], Will raised a potential issue that the cfg80211 code,
> which does (from a locking perspective)
> 
>   rtnl_lock()
>   wiphy_lock()
>   rtnl_unlock()
> 
> [...]

Here is the summary with links:
  - [net-next] net: ensure net_todo_list is processed quickly
    https://git.kernel.org/netdev/net-next/c/0b5c21bbc01e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


