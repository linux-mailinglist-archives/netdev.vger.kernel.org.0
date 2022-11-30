Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E51563CE84
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiK3FAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiK3FAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD4F6F820
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 221E1619EF
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 652D0C433D7;
        Wed, 30 Nov 2022 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669784419;
        bh=pE2eu4dCrbW1HTyM2tl1eDYSBHr1kHDDQfd4lQjWmLA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y6WxVFJSBQQg+O4rmaBgvcktCUNSaRnQl3ZLqb4us23SEK2UnfilywQG7A8jz3nbk
         Pv56rWZpZCjS29WxHNVhC90qGnKjIglsApu3Vb5iER4eqUk1NWbCx3erQ8o1mWvGBz
         t0lfavx0A1SYuduuFSK3EVbAQ5riWoAIg2Rf2Peg2scpAPlp6ieZqyPsCVJoN90FYs
         w7Js4iVRnCKafHsU1rLuIvB5aQkeAL+6RJ2+aNYdiBqY0D2goGs3kd+dBJND6/QNiT
         kIuGqydRsYK+CI51NjrDIwcGdOG8O0/25LttMpRkhitIZtfwzMV/Z2ApoMXxWVuA8c
         o4gs+gLV6GWvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 478D8E21EF7;
        Wed, 30 Nov 2022 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/10] esp6: remove redundant variable err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166978441928.10298.7878882652751520450.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Nov 2022 05:00:19 +0000
References: <20221126110303.1859238-2-steffen.klassert@secunet.com>
In-Reply-To: <20221126110303.1859238-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
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
by Steffen Klassert <steffen.klassert@secunet.com>:

On Sat, 26 Nov 2022 12:02:54 +0100 you wrote:
> From: Colin Ian King <colin.i.king@gmail.com>
> 
> Variable err is being assigned a value that is not read, the assignment
> is redundant and so is the variable. Remove it.
> 
> Cleans up clang scan warning:
> net/ipv6/esp6_offload.c:64:7: warning: Although the value stored to 'err'
> is used in the enclosing expression, the value is never actually read
> from 'err' [deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - [01/10] esp6: remove redundant variable err
    https://git.kernel.org/netdev/net-next/c/e91001bae0d1
  - [02/10] xfrm: update x->lastused for every packet
    https://git.kernel.org/netdev/net-next/c/f7fe25a6f005
  - [03/10] xfrm: Remove not-used total variable
    https://git.kernel.org/netdev/net-next/c/cc2bbbfd9a50
  - [04/10] xfrm: a few coding style clean ups
    https://git.kernel.org/netdev/net-next/c/f157c416c51a
  - [05/10] xfrm: add extack to xfrm_add_sa_expire
    https://git.kernel.org/netdev/net-next/c/a25b19f36f92
  - [06/10] xfrm: add extack to xfrm_del_sa
    https://git.kernel.org/netdev/net-next/c/880e475d2b0b
  - [07/10] xfrm: add extack to xfrm_new_ae and xfrm_replay_verify_len
    https://git.kernel.org/netdev/net-next/c/643bc1a2ee30
  - [08/10] xfrm: add extack to xfrm_do_migrate
    https://git.kernel.org/netdev/net-next/c/bd12240337f4
  - [09/10] xfrm: add extack to xfrm_alloc_userspi
    https://git.kernel.org/netdev/net-next/c/c2dad11e0466
  - [10/10] xfrm: add extack to xfrm_set_spdinfo
    https://git.kernel.org/netdev/net-next/c/a74172168009

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


