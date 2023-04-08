Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD78E6DB880
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjDHDKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjDHDKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:10:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5862EC67E
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 20:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5A4165382
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25DCAC4339B;
        Sat,  8 Apr 2023 03:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680923420;
        bh=YBtVoqpiPjbHhPkFj6QCPUj4gofvmL8e4YE0hO8/MW0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Swq456aEeSY1WaGnfWFXzQPsS3roqEwY35Elsr2aQiWuZdqhiGWOby9Tw2SpiF1g/
         CzNMXVGTEOun+1cs3pTja2xMnn3uia/FvE5xN1qdtf6jRGpnH9qpVtsDg7DT/OP6WM
         sS6hO5twn7G2rXkQwU7plla+V0pVo6wiv3/fql8M64+m6rkD5P4tFj5RbuQYHO+z4+
         jcHWPbuRSgyXrSWHnqgtUBCiDal91qBt7m9jxHaCUh0MXvZQLATEJlB5VwwOHBI5dT
         B495uPwjUSjfDx+W/hNXAobj/kfjeZips+xpfDBtNWtmr5nABNTHZFRVmR64FXgcC1
         A5UKqdn6d59rg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05BC3E4F0D0;
        Sat,  8 Apr 2023 03:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL v1] Improve IPsec limits, ESN and replay window
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168092342002.22423.485223944189178908.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Apr 2023 03:10:20 +0000
References: <20230406071902.712388-1-leon@kernel.org>
In-Reply-To: <20230406071902.712388-1-leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        saeedm@nvidia.com, raeds@nvidia.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Apr 2023 10:19:02 +0300 you wrote:
> This series overcomes existing hardware limitations in Mellanox ConnectX
> devices around handling IPsec soft and hard limits.
> 
> In addition, the ESN logic is tied and added an interface to configure
> replay window sequence numbers through existing iproute2 interface.
> 
>   ip xfrm state ... [ replay-seq SEQ ] [ replay-oseq SEQ ]
>                     [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]
> 
> [...]

Here is the summary with links:
  - [GIT,PULL,v1] Improve IPsec limits, ESN and replay window
    https://git.kernel.org/netdev/net-next/c/4bcdfc3ab217

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


