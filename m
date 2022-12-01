Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067BA63E972
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiLAFuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLAFuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716582B600;
        Wed, 30 Nov 2022 21:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 328E4B81E16;
        Thu,  1 Dec 2022 05:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA959C433B5;
        Thu,  1 Dec 2022 05:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669873818;
        bh=NicyHNdLoMjWw7794rJYZ/c5bc0bt9UuucYf6UezqNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vll7k69+Ca941t8BJJxprybBpQJNPShVigyvcjfYa2lNDrPzSVm82s1yfB6w/GhMI
         A2iQVwqpU4oS/ElPdjJG4c32g0HbVf0fkHBOWFGDtgKZpMw2MDRRkTB0j8WWVTZwo7
         wix5ou5rI4wAQV6fGr5v+jNOJI1GJbnDF0+jIjS6+WfHNqwN747DhZ4+vmA29QXteS
         a1hnrWFsYKpqv1aeW/D8aEWUnhw36fCuE4hGrHoCoE+xlYkhrsKl2dsDCsnpNpppPb
         UwLq/8cpOYODhRSDT3KKejUKX6bljaa423P/N2XnFm9JsWGAZYY3jFrj51gsQL48m2
         QjHchbnCpcjfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF296E52538;
        Thu,  1 Dec 2022 05:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH 1/2] dt-bindings: nfc: nxp,nci: Document NQ310
 compatible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987381777.9213.2696769329913369073.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 05:50:17 +0000
References: <20221128173744.833018-1-luca@z3ntu.xyz>
In-Reply-To: <20221128173744.833018-1-luca@z3ntu.xyz>
To:     Luca Weiss <luca@z3ntu.xyz>
Cc:     linux-arm-msm@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Nov 2022 18:37:43 +0100 you wrote:
> The NQ310 is another NFC chip from NXP, document the compatible in the
> bindings.
> 
> Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
> ---
> RESEND to fix Cc
> 
> [...]

Here is the summary with links:
  - [RESEND,1/2] dt-bindings: nfc: nxp,nci: Document NQ310 compatible
    https://git.kernel.org/netdev/net-next/c/a933e7f05bd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


