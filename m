Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8DD4C431A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239937AbiBYLKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239879AbiBYLKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:10:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC8F2399C0
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83A096183D
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAC14C340F2;
        Fri, 25 Feb 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645787413;
        bh=/ELjCV2S4Z5lC4ND0Hb861Brb0GlgSTCnSQoIPeKens=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MHmOXxUoa0bqA4Wey5FrYj31rnh1fUQx5QSmYeKWEl5jLMdIDrogD31w5o5N+RhU7
         Y9leawXDJ2JC07RqEnmF/2vn+wrVi8wpWrXbf31lsBDxOycqv4cjFsHEFrcG+t6GCB
         c9VwnMN2ANn579DPqCn7lk1Tt7kQerFdgoa+HVoX+Op9XxUktiqwap++yw0E0pnjF6
         vxBNEYjpvlD9gsCdKDNU6o1MhqFUkzzoyn7LYpijZiWZgDBcLgL21jh0OZMgw0hWuv
         BS+kKLj++qgDQ6hMHZtkArHocG++GuSxlw9ptWlF+Ldn+37KRSWQ6PB2d73AwTv8Z/
         aVWY2zNgcA+qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE94BEAC09B;
        Fri, 25 Feb 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/6] xfrm: fix MTU regression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164578741377.30964.7071000007857562653.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 11:10:13 +0000
References: <20220225074733.118664-2-steffen.klassert@secunet.com>
In-Reply-To: <20220225074733.118664-2-steffen.klassert@secunet.com>
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

This patch was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Fri, 25 Feb 2022 08:47:28 +0100 you wrote:
> From: Jiri Bohac <jbohac@suse.cz>
> 
> Commit 749439bfac6e1a2932c582e2699f91d329658196 ("ipv6: fix udpv6
> sendmsg crash caused by too small MTU") breaks PMTU for xfrm.
> 
> A Packet Too Big ICMPv6 message received in response to an ESP
> packet will prevent all further communication through the tunnel
> if the reported MTU minus the ESP overhead is smaller than 1280.
> 
> [...]

Here is the summary with links:
  - [1/6] xfrm: fix MTU regression
    https://git.kernel.org/netdev/net/c/6596a0229541

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


