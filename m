Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEFE50C463
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiDVW4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbiDVW40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:56:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02642702E2;
        Fri, 22 Apr 2022 15:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A87262123;
        Fri, 22 Apr 2022 22:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F4EAC385AB;
        Fri, 22 Apr 2022 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650666012;
        bh=RnCJaR8E6QPF7yP+mo6mKPy5EeOanC7RAlmXwDM7E+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ktcEoBJFXbj6GJGM1SKd+C7qUjSJV7jNrzPrT6d0L83oYPyBLNEL+X40Ru63SGqTO
         1OOWYyVS8ObcbkjA0OQfyrJ9rxWW5C8H7zbqGrCTOr3mZ5aJhFClw3nm7UMXD8dydq
         /Iej83/0AsulbEpAa9Dr7ArSr32JX3jGOwu35/N1sIlhmukx/pjgaJTqpwi+7O86B4
         ubPYULSrNxwofyNW8yXw2/y46Xyj9L62BoZxYVCmxPOXmFn9FgOAy4LaOd0UDriBdQ
         n+i1hpYGVBj2da/16KhqfBxjOMJKX17LsQiIK5XKlUsWd2iyPCG1X3wkjmDkiXXYaJ
         2tNrwEpPHC9yA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82CA4E6D402;
        Fri, 22 Apr 2022 22:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] tcp: md5: incorrect tcp_header_len for incoming
 connections
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165066601253.17746.2255249203148338043.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 22:20:12 +0000
References: <20220421005026.686A45EC01F2@us226.sjc.aristanetworks.com>
In-Reply-To: <20220421005026.686A45EC01F2@us226.sjc.aristanetworks.com>
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     pabeni@redhat.com, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Apr 2022 17:50:26 -0700 you wrote:
> In tcp_create_openreq_child we adjust tcp_header_len for md5 using the
> remote address in newsk. But that address is still 0 in newsk at this
> point, and it is only set later by the callers (tcp_v[46]_syn_recv_sock).
> Use the address from the request socket instead.
> 
> v2: Added "Fixes:" line.
> 
> [...]

Here is the summary with links:
  - [v2,net] tcp: md5: incorrect tcp_header_len for incoming connections
    https://git.kernel.org/netdev/net/c/5b0b9e4c2c89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


