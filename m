Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8444C5B9939
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 13:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiIOLAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 07:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIOLAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 07:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B214A79A5D;
        Thu, 15 Sep 2022 04:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECC0EB81D67;
        Thu, 15 Sep 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 981FAC433C1;
        Thu, 15 Sep 2022 11:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663239617;
        bh=acLkAUMk8BizKu7cs/NDP4722gLa3JtenovpxYO3Tr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gmgro/xCWfp0Ze/EGnC+VKSQMF6UT+HP8vRhQUthN2sRBWRbOqsBoQpALOJGiJ/10
         cUwOVAMciz0g0KcBweDX2hfDVvb+hIGPGdJgXG3P0rcXtkpRPyodGlXfN9iefDrCpY
         aNs+hiXkrgySSxOm7bL8H+BQMw8vmcs9u1omb+criFevg9Sm4arCrtBNm9tcu6+slD
         DvcdT3mzYo8UJpcBLcdFz7HDk2eCI46Ux2Ze/mBS9ZW85U/3Da2X5qxyxhAN3mEagX
         U+kjBGC0sf47cgTi4PtAbDI4CmsRt1WxBbYue8Vc5Y115JdCxcZyLB2CqYsv0MoxPq
         sJXDx1FtsgnKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73AF2C73FFC;
        Thu, 15 Sep 2022 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] net: ftgmac100: support fixed link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166323961746.5581.16008979446604456337.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Sep 2022 11:00:17 +0000
References: <20220907054453.20016-1-rentao.bupt@gmail.com>
In-Reply-To: <20220907054453.20016-1-rentao.bupt@gmail.com>
To:     Tao Ren <rentao.bupt@gmail.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, guoheyi@linux.alibaba.com,
        dylan_hung@aspeedtech.com, huangguangbin2@huawei.com,
        windhl@126.com, chenhao288@hisilicon.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, joel@jms.id.au, andrew@aj.id.au,
        taoren@fb.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  6 Sep 2022 22:44:51 -0700 you wrote:
> From: Tao Ren <rentao.bupt@gmail.com>
> 
> The patch series adds fixed link support to ftgmac100 driver.
> 
> Patch #1 adds fixed link logic into ftgmac100 driver.
> 
> Patch #2 enables mac3 controller in Elbert dts: Elbert mac3 is connected
> to the onboard switch BCM53134P's IMP_RGMII port directly (no PHY
> between BMC MAC and BCM53134P).
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: ftgmac100: support fixed link
    https://git.kernel.org/netdev/net-next/c/38561ded50d0
  - [net-next,v3,2/2] ARM: dts: aspeed: elbert: Enable mac3 controller
    https://git.kernel.org/netdev/net-next/c/ce6ce9176975

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


