Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CFF57D789
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 02:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiGVAAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 20:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGVAAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 20:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90B211C09
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 17:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E7C661F07
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B396EC341C6;
        Fri, 22 Jul 2022 00:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658448013;
        bh=i7hrl4l/2/dj5BWDZ2GInrYkPMU7Qk5GE5Abhzbcw6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r4TyCqT1vDxNGPh1FYDH6TPsJFcoMgB61i0cn2YHsHrdKfZ245wcVLjUPXMZ8e5BM
         ts/2uSD9ArtDUQ66th52zDy3w2/s851SDwuwF6MDs68dZsRvIFYl1887Sz+mtPbKvO
         CzMCeCqdXGpcUlwm4+Zesdno0zggVSFEqLnsN6kSJyOvxmIQTNRK76cVIY2zt37BRs
         TY8y4FTKJkyqu0DfWNzcoeGlXdBqRxnlH3bEKjoZWWMjPytQnSHdQFRYHPQM+mLvEk
         nHAPVYGMIZJHCwz54fL0FC76GO85GoI9ozvnZBf9Qv508wqUL/5WUc0IQPmobBo/al
         eWWZIWYP+ZeGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 922CED9DDDD;
        Fri, 22 Jul 2022 00:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: fix build
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165844801359.12879.16220088468595179378.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 00:00:13 +0000
References: <7105112c38cfe0642a2d9e1779bf784a7aa63d16.1658411666.git.pabeni@redhat.com>
In-Reply-To: <7105112c38cfe0642a2d9e1779bf784a7aa63d16.1658411666.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, elder@kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Jul 2022 15:55:14 +0200 you wrote:
> After commit 2c7b9b936bdc ("net: ipa: move configuration data files
> into a subdirectory"), build of the ipa driver fails with the
> following error:
> 
> drivers/net/ipa/data/ipa_data-v3.1.c:9:10: fatal error: gsi.h: No such file or directory
> 
> After the mentioned commit, all the file included by the configuration
> are in the parent directory. Fix the issue updating the include path.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: fix build
    https://git.kernel.org/netdev/net-next/c/32d00f62db4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


