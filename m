Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0485BA9DD
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 12:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiIPKAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 06:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiIPKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 06:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113564F682;
        Fri, 16 Sep 2022 03:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1730B824F9;
        Fri, 16 Sep 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B4C9C433D7;
        Fri, 16 Sep 2022 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663322415;
        bh=QuN1eFfsxYnLSx52QF1elJ0nSrhnmiSFkSaL18VzHXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XoPrHj/duaNWxUjOW9FfXrhCmmljRQt2sxjao+fcz5b1EQ5mTNrg1EJRKkBX+gQvu
         AhRNEHnxNHANgPzjuwbCOpvzQ6C8Pw2RyPXc8WdhTh5DpHOZ0g9IyfOmH1z99spmEc
         4SunBai/37v7OrpvXdXOkQ/HlIl+1BN7TjSBHBSoUIIjGLirdJlfmxqyYV6cHGzdNJ
         xOncBznbmKW7mK34U1S6b8jIlYkOPEBvrsHWZL2t3zRgBIlFIGgiwynumtOcZttWBr
         rVbjeWf2lHa82soJzHphbece8wrth2Ujwle1HJ2yw9Rl5MZf5EZKXnL/pOOB5KbAcJ
         +41hd842AUrUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36973C73FFC;
        Fri, 16 Sep 2022 10:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3] net/ieee802154: fix uninit value bug in dgram_sendmsg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166332241521.3955.11710579399956062313.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 10:00:15 +0000
References: <20220908121927.3074843-1-tcs_kernel@tencent.com>
In-Reply-To: <20220908121927.3074843-1-tcs_kernel@tencent.com>
To:     Haimin Zhang <tcs.kernel@gmail.com>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tcs_kernel@tencent.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Sep 2022 20:19:27 +0800 you wrote:
> There is uninit value bug in dgram_sendmsg function in
> net/ieee802154/socket.c when the length of valid data pointed by the
> msg->msg_name isn't verified.
> 
> We introducing a helper function ieee802154_sockaddr_check_size to
> check namelen. First we check there is addr_type in ieee802154_addr_sa.
> Then, we check namelen according to addr_type.
> 
> [...]

Here is the summary with links:
  - [V3] net/ieee802154: fix uninit value bug in dgram_sendmsg
    https://git.kernel.org/netdev/net/c/94160108a70c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


