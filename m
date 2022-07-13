Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491945736BF
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 15:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiGMNAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 09:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiGMNAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 09:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D91E0E7
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 06:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BD0561C12
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5FBDBC341CA;
        Wed, 13 Jul 2022 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657717215;
        bh=uMgihuTxXwjvVm907p2/ofAgtNwetgXKzCS7Y8loDXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WHoAzEh7bJ0q6Fzl7XkZVGWbhfeF8AGeZTnA5kkYPYUJX3GRD5mDgbWP7bbRzxGTp
         qcF94HaN/EHs1mIvZ38zvm+LeeT4IX6PPKBM45ZjapFdTh4Gu6tdSmPCJur+FcxM07
         /RZPZ/nYf9D69unCThj8LWX8ljaWVJwLyU7W28Pp7d99SygscPMdTJZvOQsA6Y/rDB
         LkKrR4b1p7TWsG2GALET4jWd93Fzm/5tLxYH9eeTjoeQcc/+Kk6VGnQqd+GHSI0di2
         N7M7HbQYiQaFvzw9dPNApwDgoXa9CKuqksZGa4VyKJdk6bg9TVahrSq+k9I1X6zYtc
         ekK/1C+fJ3CqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3EB08E4522E;
        Wed, 13 Jul 2022 13:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6] net: ip6mr: add RTM_GETROUTE netlink op
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165771721525.13289.3138175388413517716.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 13:00:15 +0000
References: <20220712121002.262794-1-equinox@diac24.net>
In-Reply-To: <20220712121002.262794-1-equinox@diac24.net>
To:     David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        razor@blackwall.org, dsahern@kernel.org, kuba@kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Jul 2022 14:10:02 +0200 you wrote:
> The IPv6 multicast routing code previously implemented only the dump
> variant of RTM_GETROUTE.  Implement single MFC item retrieval by copying
> and adapting the respective IPv4 code.
> 
> Tested against FRRouting's IPv6 PIM stack.
> 
> Signed-off-by: David Lamparter <equinox@diac24.net>
> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v6] net: ip6mr: add RTM_GETROUTE netlink op
    https://git.kernel.org/netdev/net-next/c/d7c31cbde4bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


