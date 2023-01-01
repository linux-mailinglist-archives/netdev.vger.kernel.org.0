Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1014865AA4D
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 16:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjAAPKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 10:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjAAPKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 10:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17A83884;
        Sun,  1 Jan 2023 07:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8843FB8091A;
        Sun,  1 Jan 2023 15:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4584FC433D2;
        Sun,  1 Jan 2023 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672585815;
        bh=xHM+EfYWuye8hFZEVS6F8JdOmiY9W7NaVAL+vbJrS2U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oHLMtPxYvpHMU4A6p5YjBQjkVY25nuh1nE+Ds0zOd3ub20d0qI+0nzr8ciyxYQOPe
         ZWxSjEUh6OEqns7sYPunnRuz4EWFP0/MCQM6wL9JdqO7pdnbj4sknyLTRWMUMpcyS4
         cEjimCrWNOw08bRwkJifJHwtA93Wn/z+C6VPUjRRKOerd8Ht6u9pVRIAd9sLUAxRhN
         6jgjQRQ3xOksdSSa+n58KoBvrJ8JgYcjFL7i1dh3XbTNvXcrnWui4qfDKm0BTbK1Bm
         RVk2/QtbtgOTBeeh5MxE5VjDxr099CNL5gDnwhWKvtxgD3XHDIuyp2m5oeSsc65HiA
         YNJw76gZoOAKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AECDC395E0;
        Sun,  1 Jan 2023 15:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] dt-bindings: net: marvell,orion-mdio: Fix examples
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167258581517.15160.15216881364049554149.git-patchwork-notify@kernel.org>
Date:   Sun, 01 Jan 2023 15:10:15 +0000
References: <20221229142219.93427-1-mig@semihalf.com>
In-Reply-To: <20221229142219.93427-1-mig@semihalf.com>
To:     =?utf-8?q?Micha=C5=82_Grzelak_=3Cmig=40semihalf=2Ecom=3E?=@ci.codeaurora.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andrew@lunn.ch, chris.packham@alliedtelesis.co.nz,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        upstream@semihalf.com, mw@semihalf.com, mchl.grzlk@gmail.com
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

On Thu, 29 Dec 2022 15:22:19 +0100 you wrote:
> As stated in marvell-orion-mdio.txt deleted in commit 0781434af811f
> ("dt-bindings: net: orion-mdio: Convert to JSON schema") if
> 'interrupts' property is present, width of 'reg' should be 0x84.
> Otherwise, width of 'reg' should be 0x4. Fix 'examples:' and add
> constraints checking whether 'interrupts' property is present
> and validate it against fixed values in reg.
> 
> [...]

Here is the summary with links:
  - [v3] dt-bindings: net: marvell,orion-mdio: Fix examples
    https://git.kernel.org/netdev/net/c/91e2286160ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


