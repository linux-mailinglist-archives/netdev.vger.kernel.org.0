Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE36525887
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359544AbiELXkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357968AbiELXkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453FF286FF5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3D5F6205A
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40D36C34114;
        Thu, 12 May 2022 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652398813;
        bh=FR4BGl93Ko0XfQBP9+SIGD3NAQS200IjnHLUOhWGPaI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rD7fc/rOFQvYZ/oSPxPijfg2Qwc938+MzIeLuqekoBObDPvJI0xgAX4Lgh+yQJvZd
         tauwqSIumfdpvCsR9n385GUzd3/Le/+ETGNVd65NEhzvKuKLXoT+b7yeMzyJHuMF/X
         iL2P9VuqgCTsrr3qn08RX6GPEfey++7okEd2JTs6P58JLbXBb/CwOjw5YMmuV1uuaH
         EeOsoLJD6/Eqh94lBvArwof4z0bAs5YldjVwyH/XYsw43M4A9j6qwhq0nv+2MH3ZP7
         wY5Yd8j4o73Pzko8NNemKPI64wN5caFbd8hfmUmUOFod0ffIuN1kLhGWY107drjIZW
         IWI2+6Rg5IYQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13D6DF03934;
        Thu, 12 May 2022 23:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] skbuff: replace a BUG_ON() with the new
 DEBUG_NET_WARN_ON_ONCE()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165239881307.13563.7314812134449396223.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 23:40:13 +0000
References: <20220511172305.1382810-1-kuba@kernel.org>
In-Reply-To: <20220511172305.1382810-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, imagedong@tencent.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 May 2022 10:23:05 -0700 you wrote:
> Very few drivers actually have Kconfig knobs for adding
> -DDEBUG. 8 according to a quick grep, while there are
> 93 users of skb_checksum_none_assert(). Switch to the
> new DEBUG_NET_WARN_ON_ONCE() to catch bad skbs.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] skbuff: replace a BUG_ON() with the new DEBUG_NET_WARN_ON_ONCE()
    https://git.kernel.org/netdev/net-next/c/0df65743537d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


