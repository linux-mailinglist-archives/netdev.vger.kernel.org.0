Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766085B034B
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiIGLkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 07:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiIGLkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 07:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84AE5AA3C;
        Wed,  7 Sep 2022 04:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E662B81C3A;
        Wed,  7 Sep 2022 11:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38967C433B5;
        Wed,  7 Sep 2022 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662550816;
        bh=ZipAUKhkMK4uqs0aKuUhw4vWX2PNxeuRAeySr0yurBc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JWJNfIW2iECfIF7z3A2Vhj7jHsQ6yZU8wV2HQg5uNI5FP1N0+4eVCNXpsRe4eCwjy
         HZL7gZXoXOvKu0TSlCXP5R/X4Su4LOZ7HkiAOY6kE2QcfcZDV+5W3H1BHTfRTsZpcO
         OScPrU7gfEyMToVEdl/ZQTAkseV0NW/BE0CmdeqqoPjdYSdI9OMnX5i3AZQttYDElL
         UH+4lGTLx2JDfUu2gV/2yHfEa0fLaU9d7xkdWzLZjFseR1eOjqcupA+L9n3tAjujI2
         y3uF7oC/l/kw/cYmR5ylSunxpBim+QjHgIUbAmoY/o0XWxtAJharJ3vp+2x3ZzeJnQ
         JQg782x3B3OHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 205A4E1CABE;
        Wed,  7 Sep 2022 11:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] netlink: add range checks for network byte
 integers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166255081612.11275.13176862997747782016.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 11:40:16 +0000
References: <20220905100937.11459-1-fw@strlen.de>
In-Reply-To: <20220905100937.11459-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Mon,  5 Sep 2022 12:09:35 +0200 you wrote:
> NLA_POLICY_MAX() can be used to let netlink core validate that the given
> integer attribute is within the given min-max interval.
> 
> Add NLA_POLICY_MAX_BE to allow similar range check on unsigned integers
> when those are in network byte order (big endian).
> 
> First patch adds the netlink change, second patch adds one user.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] netlink: introduce NLA_POLICY_MAX_BE
    https://git.kernel.org/netdev/net-next/c/08724ef69907
  - [net-next,2/2] netfilter: nft_payload: reject out-of-range attributes via policy
    https://git.kernel.org/netdev/net-next/c/e7af210e6dd0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


