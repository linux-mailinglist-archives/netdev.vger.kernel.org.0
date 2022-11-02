Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBBC615C08
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 07:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKBGAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 02:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiKBGAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 02:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6636370
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 23:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6E07B82065
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 06:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E349C433D6;
        Wed,  2 Nov 2022 06:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667368815;
        bh=Tet1KI3pJj9kR5RQ83jJmRfccPKKtnGKL70goz3Dprk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=th+eVyKzQvBQvVg7jc/PkSPScgZPXSyEz/CpR01+M+H4+cmVQmSkVmSM6AQkU8Lk3
         5x6fECjGTmfFGlYGsol59c5l7+G21jgcqNG/GRhy685njyZY5G/rW2EOCcJ1PXdnSj
         0ZgE4t+UoUv38JVqhWxdHi4k7aSdgttd0UWn1wBWNcJKWf7okCnInC7FyObnZ5shey
         DEeta12mZ0IoAD9sIyQ036CbFVNqRmXZGeHY3/cTSXZmg/XZFCSXAOoV2cY8Io3P6i
         WdGwC95B4ZWuRvb/d58mr4gfTxYVKjxvvmBCvm/kBEKkeEjjrF0H06y9sLbmZa0Pz+
         n9Vv1brCaIZ8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4EB4AC41620;
        Wed,  2 Nov 2022 06:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: introduce bigendian integer types
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166736881531.1992.9191018497619049271.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 06:00:15 +0000
References: <20221031123407.9158-1-fw@strlen.de>
In-Reply-To: <20221031123407.9158-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, johannes@sipsolutions.net
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 31 Oct 2022 13:34:07 +0100 you wrote:
> Jakub reported that the addition of the "network_byte_order"
> member in struct nla_policy increases size of 32bit platforms.
> 
> Instead of scraping the bit from elsewhere Johannes suggested
> to add explicit NLA_BE types instead, so do this here.
> 
> NLA_POLICY_MAX_BE() macro is removed again, there is no need
> for it: NLA_POLICY_MAX(NLA_BE.., ..) will do the right thing.
> 
> [...]

Here is the summary with links:
  - [net] netlink: introduce bigendian integer types
    https://git.kernel.org/netdev/net/c/ecaf75ffd5f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


