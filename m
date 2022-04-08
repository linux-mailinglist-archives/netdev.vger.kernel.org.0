Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6414F9626
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 14:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbiDHMwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 08:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiDHMwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 08:52:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007B3F70D0
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 05:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8047C6215C
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD709C385A8;
        Fri,  8 Apr 2022 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649422216;
        bh=ATz4/VyBPgODhdjPoEVcdME0lZV2zIwgR4YDoFg53E8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eAgSzQAHkvTpwNz2kejjXEnBjQCS/3b/xGXLlj1SGetjYch92DP1/v3YWF1zR1zVD
         KHMCRgRPIBayykFpLvGMfl/pTlK3hUKpWEv/MGTvtlkC9wSA0l7RRlX26hr2Ag+2Sx
         cPUBbptNRsux1jhKh6/y714jjQZEzxiL1PSsBYV2pYbVuwmTcRvpSoiCXXYS5nCeb5
         kJoX0o94qdhIbqDwuUU/rP3qBert7aEt3UdcYEoEZtvQGhQL17Kb9nylvYeW9LD5ZX
         OZVcwPECX3BtHxE135Hd1kU3I7QsU4W+BeEphV0iuo9rmZhofqDV3ur3KfASW+r8Mq
         pz0x0VnVl0d2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2EBCE8DBDA;
        Fri,  8 Apr 2022 12:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-04-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164942221679.10804.13640090690808474480.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 12:50:16 +0000
References: <20220407165247.1817188-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220407165247.1817188-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, alexandr.lobakin@intel.com
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  7 Apr 2022 09:52:42 -0700 you wrote:
> Alexander Lobakin says:
> 
> This hunts down several places around packet templates/dummies for
> switch rules which are either repetitive, fragile or just not
> really readable code.
> It's a common need to add new packet templates and to review such
> changes as well, try to simplify both with the help of a pair
> macros and aliases.
> ice_find_dummy_packet() became very complex at this point with tons
> of nested if-elses. It clearly showed this approach does not scale,
> so convert its logics to the simple mask-match + static const array.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: switch: add and use u16[] aliases to ice_adv_lkup_elem::{h, m}_u
    https://git.kernel.org/netdev/net-next/c/135a161a5ea9
  - [net-next,2/5] ice: switch: unobscurify bitops loop in ice_fill_adv_dummy_packet()
    https://git.kernel.org/netdev/net-next/c/27ffa273a040
  - [net-next,3/5] ice: switch: use a struct to pass packet template params
    https://git.kernel.org/netdev/net-next/c/1b699f81dba7
  - [net-next,4/5] ice: switch: use convenience macros to declare dummy pkt templates
    https://git.kernel.org/netdev/net-next/c/07a28842bb4f
  - [net-next,5/5] ice: switch: convert packet template match code to rodata
    https://git.kernel.org/netdev/net-next/c/e33163a40d1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


