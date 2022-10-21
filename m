Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63D36076CF
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJUMU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJUMUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:20:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4AF156256;
        Fri, 21 Oct 2022 05:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1BD1B82B1D;
        Fri, 21 Oct 2022 12:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 782B9C4314A;
        Fri, 21 Oct 2022 12:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666354817;
        bh=9pNkSkMMCnf1Zj3uCFEWZgDnzpKGb6MzKEJOnVtIXFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h0Y0IR2ShKUBpWs5TtyeT6FMRynpAN81rI8/XYBMSigqrZrrz990KWlOvGqL2ytzU
         Z42Y78Ei0TVldtInyip+OofBGggmAHb9tZbb5WRkBTeP2WF6mWxVzLGEVN3m3YVc1L
         f6a+VspzOg2AfXWTYYb2RkbpUG+flMz09tsQsbfqMmKVC50kZU1E2aJzKxpin9j5Ye
         qnmrs3y+fw6aROkM/zKP/GE8v+ymW2CrSSldrA3joGMyMfS3ZidgsnbGtrYShvwcDO
         eHR8pMzcAQ6617tmTyRJXGvw6234Tgi0rY+YpqNa71hmkG9+eGtZ5IQ6mT/ISlJMG+
         f6ZUBxau5NoEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56B40E270E2;
        Fri, 21 Oct 2022 12:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 1/2] net: ethernet: adi: adin1110: add reset GPIO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166635481734.23176.5663242061307242113.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 12:20:17 +0000
References: <20221019171314.86325-1-alexandru.tachici@analog.com>
In-Reply-To: <20221019171314.86325-1-alexandru.tachici@analog.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Oct 2022 20:13:13 +0300 you wrote:
> Add an optional GPIO to be used for a hardware reset of the IC.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  drivers/net/ethernet/adi/adin1110.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)

Here is the summary with links:
  - [net-next,1/2] net: ethernet: adi: adin1110: add reset GPIO
    https://git.kernel.org/netdev/net-next/c/36934cac7aaf
  - [net-next,2/2] dt-bindings: net: adin1110: Document reset
    https://git.kernel.org/netdev/net-next/c/3bd5549bd479

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


