Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230BE5F2FF7
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 14:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJCMAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 08:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiJCMAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 08:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EA7356E4
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 05:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3FC6B81094
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 12:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 944B0C433C1;
        Mon,  3 Oct 2022 12:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664798418;
        bh=sW+ADY8UxqbVJr2ksgWu+Ggrc2eaJdtKRcLlJg2vNWg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kY8gwCQJXbmrQyHDFvr4spu69rzbAwVC1c4qr4eLTvJsN59hH6+TGmw3bzDuT4IEU
         0BZa7Y68aVwHZgX+xynxoo7NHYgV1p08FwNrFSJAAtRW0skCV2rKI8qH2PxsSLGXr6
         rY1EMZPEQOvHbHUaZIh8zBFirUkV8eDLS2i5JrqSxefkePfYjP5aMTvRV0XHTRyRH2
         tACRKZfLNESkzxQ+wa+wtgbtlxGDmvNaVIICZI8Q7lctUrpcI8NbjljkmdNCJPhUbE
         HBGgapp8BVKTUeB8kUKBnPJmEKu4Wlbhr/U6dnVzSgt5+V+iYtJL7RdtZSAytmXopD
         HLjwzlErIY03Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 788F4E49FA3;
        Mon,  3 Oct 2022 12:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3 0/8] Introduce macsec hardware offload for cn10k
 platform
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479841848.31360.5516687430787370216.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 12:00:18 +0000
References: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org, sgoutham@marvell.com,
        naveenm@marvell.com
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

On Sat, 1 Oct 2022 10:29:41 +0530 you wrote:
> CN10K-B and CNF10K-B variaints of CN10K silicon has macsec block(MCS)
> to encrypt and decrypt packets at MAC/hardware level. This block is a
> global resource with hardware resources like SecYs, SCs and SAs
> and is in between NIX block and RPM LMAC. CN10K-B silicon has only
> one MCS block which receives packets from all LMACS whereas
> CNF10K-B has seven MCS blocks for seven LMACs. Both MCS blocks are
> similar in operation except for few register offsets and some
> configurations require writing to different registers. This patchset
> introduces macsec hardware offloading support. AF driver manages hardware
> resources and PF driver consumes them when macsec hardware offloading
> is needed.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/8] octeontx2-af: cn10k: Introduce driver for macsec block.
    https://git.kernel.org/netdev/net-next/c/ca7f49ff8846
  - [net-next,v3,2/8] octeontx2-af: cn10k: mcs: Add mailboxes for port related operations
    https://git.kernel.org/netdev/net-next/c/080bbd19c9dd
  - [net-next,v3,3/8] octeontx2-af: cn10k: mcs: Manage the MCS block hardware resources
    https://git.kernel.org/netdev/net-next/c/cfc14181d497
  - [net-next,v3,4/8] octeontx2-af: cn10k: mcs: Install a default TCAM for normal traffic
    https://git.kernel.org/netdev/net-next/c/bd69476e86fc
  - [net-next,v3,5/8] octeontx2-af: cn10k: mcs: Support for stats collection
    https://git.kernel.org/netdev/net-next/c/9312150af8da
  - [net-next,v3,6/8] octeontx2-af: cn10k: mcs: Handle MCS block interrupts
    https://git.kernel.org/netdev/net-next/c/6c635f78c474
  - [net-next,v3,7/8] octeontx2-af: cn10k: mcs: Add debugfs support
    https://git.kernel.org/netdev/net-next/c/d06c2aba5163
  - [net-next,v3,8/8] octeontx2-pf: mcs: Introduce MACSEC hardware offloading
    https://git.kernel.org/netdev/net-next/c/c54ffc73601c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


