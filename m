Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C9B6387D5
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiKYKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiKYKuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D7348420
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7528C62382
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 10:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7C92C43148;
        Fri, 25 Nov 2022 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669373419;
        bh=enZHl6rl6k1Gfzgsvl6x55el2eELXXEs9nUlKRnsOnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nLAIIP4m1LhRtNS4FGpOOFJuTtZkzDz7CfUCA/LMqxhZqCNP+CEHn4qoJfO/IbDj2
         MoxFalaWZtM3aHsotwmic1myHh/9CgB6b89/3ztDER2R8fALnSVYednsHOYVTh7ml0
         jbApU8LiTmn4Byw7SaMGmO3zddLhv1N+dP0U2jw4aSiUDJAraHDDWIXs87UpLpLO2c
         uJBpcZW/OAqvL1WPz79NDx/JwiSm+v8N3lBUYzNuSTtVMOGnRcYJ8i4tpcaARz6Wtw
         yorBYB20DhFwibPLB117DsES0iJ0wXmLUMubviV+nCKckVs3at82BzKzZADvEEj0ox
         OjKnrp1zbrrfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68B04E29F3D;
        Fri, 25 Nov 2022 10:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/6] Remove uses of kmap_atomic()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166937341942.11224.18160018080625949336.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 10:50:19 +0000
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
In-Reply-To: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     netdev@vger.kernel.org, ira.weiny@intel.com,
        fmdefrancesco@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 12:52:13 -0800 you wrote:
> kmap_atomic() is being deprecated. This little series replaces the last
> few uses of kmap_atomic() in the networking subsystem.
> 
> This series triggered a suggestion [1] that perhaps the Sun Cassini,
> LDOM Virtual Switch Driver and the LDOM virtual network drivers should be
> removed completely. I plan to do this in a follow up patchset. For
> completeness, this series still includes kmap_atomic() conversions that
> apply to the above referenced drivers. If for some reason we choose to not
> remove these drivers, at least they won't be using kmap_atomic() anymore.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/6] ch_ktls: Use memcpy_from_page() instead of k[un]map_atomic()
    https://git.kernel.org/netdev/net-next/c/51337ef07a40
  - [v2,net-next,2/6] sfc: Use kmap_local_page() instead of kmap_atomic()
    https://git.kernel.org/netdev/net-next/c/f61e6d3ca4da
  - [v2,net-next,3/6] cassini: Use page_address() instead of kmap_atomic()
    https://git.kernel.org/netdev/net-next/c/c191445874bb
  - [v2,net-next,4/6] cassini: Use memcpy_from_page() instead of k[un]map_atomic()
    https://git.kernel.org/netdev/net-next/c/e3128591b55a
  - [v2,net-next,5/6] sunvnet: Use kmap_local_page() instead of kmap_atomic()
    https://git.kernel.org/netdev/net-next/c/350d351389e9
  - [v2,net-next,6/6] net: thunderbolt: Use kmap_local_page() instead of kmap_atomic()
    https://git.kernel.org/netdev/net-next/c/c3a8d375f3b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


