Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7925E5633AF
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 14:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbiGAMuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 08:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiGAMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 08:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA5030F42
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 05:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 107EDB82F52
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 12:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B201CC341C8;
        Fri,  1 Jul 2022 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656679813;
        bh=lIwVPddMyns+bFbZt1MM04f26HFvOAaXMd+xZ6wJs4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EGpF+O437RCDj0tN/tuMoz0tJoH6gLmKbMrboOwzkaf/TqkYlYpIS6dwHs9b5tidM
         n/zTD4wznsLU7AP3qdgObi9TnMiX8UdSqk+XK9TCHdQ7n7RdgqiLqLQyUDzeEORVc5
         EM/M97zaGTdevJWeuA0Hiqn7HG+qfgc6rNZTrP+50d2qGYMLwEIWJ/tjpj/aRGDH9l
         KHAR5zas/PV387n1I9USxh/MWwAC0Bub2MrIVZZq0tJyH4x4wsCNsM8K1CCf/v0Xuh
         bG1fYLijAv1ruJWhDqwwBoW69MuTXRB6eKuX6v/I6GnT2Eo7PVVSxI4SPFZm44HKnf
         prCb2aaO503LA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 977CBE49BBC;
        Fri,  1 Jul 2022 12:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: support VF rate limit with NFDK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165667981361.24862.15157733863629642229.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 12:50:13 +0000
References: <20220630112155.1735394-1-simon.horman@corigine.com>
In-Reply-To: <20220630112155.1735394-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        bin.chen@corigine.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Jun 2022 13:21:55 +0200 you wrote:
> From: Bin Chen <bin.chen@corigine.com>
> 
> Support VF rate limiting with NFDK by adding ndo_set_vf_rate to the NFDK
> ops structure.
> 
> NFDK is used to communicate via PCIE to NFP-3800 based NICs
> while NFD3 is used for other NICs supported by the NFP driver.
> The VF rate limit feature is already supported by the driver for NFD3.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: support VF rate limit with NFDK
    https://git.kernel.org/netdev/net-next/c/c7b1267b1c64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


