Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDDB50286B
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245413AbiDOKnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352383AbiDOKmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:42:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5479F2E681
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 03:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E259E62251
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 10:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F5F2C385AB;
        Fri, 15 Apr 2022 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650019212;
        bh=SRwvCL6UowX5HAAc7tDgknCt7yUXWndPofu+xXACWp4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i2XJu7h5Rl+yVeWVwF0r9KyJX3IaX7bHohWKq070e0hNVr7GAdI7KuegvOvwZ3amk
         TC4YFVK+/FkYzQzLOu3CIC6O8VxYDKF5Y8EmtN0ZwZ4hpPvWfmudpCInya5f8VU1VO
         bcOG6KbIH4xKkjBR6mVNmAWs45GlM2nVta86b63emmtFdIPmLiwFWuB0+Xo6rpnDAn
         zqDvlZWKrVaCsDIPa03NfAy2DSQbaGN5J9i60HzA5JtRoNLbbGd7RutG4i+9O6QW2e
         8jYKQxCpYSOqlrdRcCZ6BaGZabqAVcNZJVccMajdat9ZUSeJftwfBoSzEK2PkQPTW1
         NXj4OTBPWxcIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C66EE8DBD4;
        Fri, 15 Apr 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] xfrm: Pass flowi_oif or l3mdev as oif to xfrm_dst_lookup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001921211.21438.3895777895644676310.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:40:12 +0000
References: <20220414091943.3000372-2-steffen.klassert@secunet.com>
In-Reply-To: <20220414091943.3000372-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Thu, 14 Apr 2022 11:19:42 +0200 you wrote:
> From: David Ahern <dsahern@kernel.org>
> 
> The commit referenced in the Fixes tag no longer changes the
> flow oif to the l3mdev ifindex. A xfrm use case was expecting
> the flowi_oif to be the VRF if relevant and the change broke
> that test. Update xfrm_bundle_create to pass oif if set and any
> potential flowi_l3mdev if oif is not set.
> 
> [...]

Here is the summary with links:
  - [1/2] xfrm: Pass flowi_oif or l3mdev as oif to xfrm_dst_lookup
    https://git.kernel.org/netdev/net/c/748b82c23e25
  - [2/2] esp: limit skb_page_frag_refill use to a single page
    https://git.kernel.org/netdev/net/c/5bd8baab087d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


