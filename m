Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5F0654A9F
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 03:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbiLWCAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 21:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLWCAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 21:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AAEC75E;
        Thu, 22 Dec 2022 18:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A45E661E08;
        Fri, 23 Dec 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0939AC433F0;
        Fri, 23 Dec 2022 02:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671760816;
        bh=fwvSWB2s9SlQYbz2JB6wiQ2msaLPGTMWu5lU92DYC+E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=btHwIS4z9bWPNKT/itvQrcnefxYcnYFFv9qBBqDBUODtO65DqipfHJY3Ju8IxftQf
         qOOUE6EgQamu+0KE+UM0z+UuK9L8ODhufAiGUYnv59Y4NJsIXYCSGSsxo3q+brqQWh
         vE2ECsxds1R2GvYQoOwL+lk0IiqoUrwpDCOXAclbrIC8M676lhpH+eg/TVKiD2XqBG
         Lujz/0WF5VAsmJV5ujV9wtJQP0ygb03OAz5csnAGpjMCO4fd/yeK8R7KMU61N5x3IY
         wBoFnzbOnqjDyft7f+DxUC7nIz9BJmQ/TcLE+PepokxANS3S3pfYvdCJIKQbP4d/uV
         n/ZPNDYKmrOrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E05A9C5C7C4;
        Fri, 23 Dec 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167176081591.4251.11693761416005779690.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Dec 2022 02:00:15 +0000
References: <20221216172937.2960054-1-sean.anderson@seco.com>
In-Reply-To: <20221216172937.2960054-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        christophe.leroy@csgroup.eu, npiggin@gmail.com, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org, krzysztof.kozlowski+dt@linaro.org,
        linux-kernel@vger.kernel.org, camelia.groza@nxp.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 16 Dec 2022 12:29:37 -0500 you wrote:
> There aren't enough resources to run these ports at 10G speeds. Disable
> 10G for these ports, reverting to the previous speed.
> 
> Fixes: 36926a7d70c2 ("powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G")
> Reported-by: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
    https://git.kernel.org/netdev/net/c/8d8bee13ae9e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


