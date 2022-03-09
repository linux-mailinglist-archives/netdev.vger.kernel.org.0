Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFD94D36D0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbiCIRC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236810AbiCIRBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:01:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84063161136
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 331F5B81EF7
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBE82C340F4;
        Wed,  9 Mar 2022 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646844611;
        bh=lvgQbjF8EWXOfgmBEOroZgMgg5FHw79wQrVjugLBwqU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TPuulcfxtG8OZyStifhK5isWOxC2gm0gpSc3/LTn1/LD6mwRScRylM3RNCi/1fm/5
         FElHLB2b6zSYqmK9V/vgxZB8QnzMCbN2OPBk+TtG0valORD7XywE9WpJMLrlPUO1IO
         3Xz98lJeyerTP3KR89cgTE71xe7vJTnoiXG8USSdRtzpmGx+u5O/kqYz9dFZ6rPYa3
         KowQVdmsD5waNc0V9YOPDOvBiKDYO9jxk9S4SkoixVHmZnQxdWd3Pmjth7sHcwkhPD
         b7ugINkM8gXi8mAYhXVet6B7IzVxtMBf7sWYW+olt4BVVvfzPz+zs/iIFsgEqlOYrM
         dpTQAqeSVA0BQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2678E73C2D;
        Wed,  9 Mar 2022 16:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: tcp: fix shim definition of
 tcp_inbound_md5_hash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164684461172.6176.1235664643016097248.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 16:50:11 +0000
References: <20220309122012.668986-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220309122012.668986-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, dsahern@kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Mar 2022 14:20:12 +0200 you wrote:
> When CONFIG_TCP_MD5SIG isn't enabled, there is a compilation bug due to
> the fact that the static inline definition of tcp_inbound_md5_hash() has
> an unexpected semicolon. Remove it.
> 
> Fixes: 1330b6ef3313 ("skb: make drop reason booleanable")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: tcp: fix shim definition of tcp_inbound_md5_hash
    https://git.kernel.org/netdev/net-next/c/24055bb87977

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


