Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C3E6BDD9D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCQAaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCQAaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7467B3590
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 17:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D0D76215A
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 00:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60BD5C433A0;
        Fri, 17 Mar 2023 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013020;
        bh=WWQ1Ts91WrRYxCKSoigbNn1BZzQfI0NS0MnVK4kK5Y4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DMCJ+Dat4vJXlZY/EtKznxYbVwp1quSSW9C5EitTOg0+f/Hqyg2xDBB2keXcexHfl
         rKd/gZ+N5A/j2+3+rpaG3I53UZ2Dqya9vmFA75j99bknt2d7Zh59j/mG7EtyrrC3Qt
         FgipLKOjZznKU+r//HvB0fTIQKnFJC9JDtMD70G/rkw2GGHhR96Cnjgte6kGTPYMl7
         /g+Nv7dH/gkok+5OtbxpUJzMz8GYejtACZsGiGSE9o4QWY9mdrrw01YbkhMrQTCNHS
         7EJKKV+LrlZzO/E8mGU/HnDSvI0l+NRtc3TePRfCZQkDrl+4pahEi0tv0oBgwsRz1g
         wdQolcmJwPfQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41BD2E66CBB;
        Fri, 17 Mar 2023 00:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] xfrm: Zero padding when dumping algos and encap
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901302026.26766.12687306895805388724.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:30:20 +0000
References: <20230315105623.1396491-2-steffen.klassert@secunet.com>
In-Reply-To: <20230315105623.1396491-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 15 Mar 2023 11:56:22 +0100 you wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
> When copying data to user-space we should ensure that only valid
> data is copied over.  Padding in structures may be filled with
> random (possibly sensitve) data and should never be given directly
> to user-space.
> 
> [...]

Here is the summary with links:
  - [1/2] xfrm: Zero padding when dumping algos and encap
    https://git.kernel.org/netdev/net/c/8222d5910dae
  - [2/2] xfrm: Allow transport-mode states with AF_UNSPEC selector
    https://git.kernel.org/netdev/net/c/c276a706ea1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


