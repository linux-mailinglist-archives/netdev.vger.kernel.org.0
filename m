Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A45691896
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjBJGkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjBJGkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695FC5FB6F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 22:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F14A561CC6
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DA89C4339C;
        Fri, 10 Feb 2023 06:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676011218;
        bh=f2OgMtHnn4os6aA8mrqZvhZK2Nwvf5tdEbbeCg8bLRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GkR02GxtumVDPX5dGuMEWBg7jEjZ9j4CcQmqKvvre4qxh1YtLwARS5YWwdgjgWH3M
         ZP4otpqOYswCJP24HhoIff7DrIPD52nf0szuWflncB7vUDokp4E1v5xJsOJPW55gzb
         +221KMYh3BnHzpLkP3CWnlIa/1hDGIYhMUdGSAnI5NpABRR+2KOB+oabNdGTdmB6Fh
         H75esWPZRximSCd9FpoCKLdWaDQHq5P25KwBH30TesbAr1pY7/cgCTSg3eXeqZ9a+U
         5Pw7wrCbUgGdD67PGzlMx1OHk8PGOt5QmNz2iC/bAbrWwojIhElx8zT/k6hdtE2Hfd
         3g6Va3GpmP9Gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 320FCC41677;
        Fri, 10 Feb 2023 06:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] nfp: fix schedule in atomic context when offloading
 sa
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601121820.3411.4468929497546422008.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 06:40:18 +0000
References: <20230208102258.29639-1-simon.horman@corigine.com>
In-Reply-To: <20230208102258.29639-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        leon@kernel.org, chengtian.liu@corigine.com,
        yinjun.zhang@corigine.com, niklas.soderlund@corigine.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 11:22:56 +0100 you wrote:
> Yinjun Zhang says:
> 
> IPsec offloading callbacks may be called in atomic context, sleep is
> not allowed in the implementation. Now use workqueue mechanism to
> avoid this issue.
> 
> Extend existing workqueue mechanism for multicast configuration only
> to universal use, so that all configuring through mailbox asynchoronously
> can utilize it.
> 
> [...]

Here is the summary with links:
  - [net,1/2] nfp: fix incorrect use of mbox in IPsec code
    https://git.kernel.org/netdev/net/c/7a13a2eef645
  - [net,2/2] nfp: fix schedule in atomic context when offloading sa
    https://git.kernel.org/netdev/net/c/71f814cda659

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


