Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D322648D22
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 05:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLJEUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 23:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLJEUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 23:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F1DD61
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 20:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2364C60DF5
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 04:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77A44C433EF;
        Sat, 10 Dec 2022 04:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670646020;
        bh=OIYkeAnftbjc700wIyHhvNrfdqUsHcLSnjk49JVHURw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EWe9E1R9BqNLtG68Qv2jwstFhaDH4XXvZumBh7cHEJQ1maZIuyypl5G8zSCed/hxj
         Gne1jy7fkfHBIZMEW6YqHBGn7baelpxKyEg98uPgGzQAsmrfRxlAEqRXTSvQRfMv9b
         GEUkxezEMo47GF9YBj2xfIXe/dFyBKlow1l69G/SKEhqsIdRSpkMGrLZ3fQoXsAppj
         vl6gy/36FwT8e5oS2blUIXL8SFPdNXY6URLJNJXjKKB2k7/iRUYh5uq/twAMIviQ4V
         jyVHJ1dGkNwsgufgYLmaMU52qc9nBF1Q9T9Ew3UulswbBbYZqxpsclgSyfTMWoLplU
         /4o0POzZli8zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E27DC00442;
        Sat, 10 Dec 2022 04:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net-next): ipsec-next 2022-12-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167064602038.29562.11925974696567506389.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Dec 2022 04:20:20 +0000
References: <20221209093310.4018731-1-steffen.klassert@secunet.com>
In-Reply-To: <20221209093310.4018731-1-steffen.klassert@secunet.com>
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

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 9 Dec 2022 10:33:10 +0100 you wrote:
> 1) Add xfrm packet offload core API.
>    From Leon Romanovsky.
> 
> 2) Add xfrm packet offload support for mlx5.
>    From Leon Romanovsky and Raed Salem.
> 
> 3) Fix a typto in a error message.
>    From Colin Ian King.
> 
> [...]

Here is the summary with links:
  - pull request (net-next): ipsec-next 2022-12-09
    https://git.kernel.org/netdev/net-next/c/dd8b3a802b64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


