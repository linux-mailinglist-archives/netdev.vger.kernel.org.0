Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC1C51B6B9
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241825AbiEEDyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241728AbiEEDxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:53:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9982E2BF0;
        Wed,  4 May 2022 20:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0851FCE2C1E;
        Thu,  5 May 2022 03:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FA95C385AC;
        Thu,  5 May 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651722614;
        bh=0aS9mq779Q1V92Me9kF1KVjfV4kZ7/eSeroZHOySwIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iL+IG2SOlztI/pnwob3zhbWACW44WqSHXE3chAsxIeEdfEbSUcLoDWl43BMR9UZ5V
         f8+jo+pveA4lIRRrf+pYvHToMGeKajFUoimkeimQebRgk5+j/zDLJF9I0DbBoJbsmV
         ERZdh/5FzmItjmx7LJs3DjqUIxKWBV7mK0tkINVRLuDUYFCze+gUxL8QsgbbZIWPrU
         fXCXUDLx79593uy9he7wu/0zUFlECVvIyySTRx+3fDxYTayfrJEJIILylXVmznLPMO
         3UejgE0x7k/YiIWr/ElC8ngY6xuChz5WXbv1AIsxzVJdhIrXkmEtyhENbuM0E5ptpA
         /3PLwiOo8vLrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE4CDF0384A;
        Thu,  5 May 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dt-bindings: net: lan966x: fix example
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165172261389.3043.395331172475309112.git-patchwork-notify@kernel.org>
Date:   Thu, 05 May 2022 03:50:13 +0000
References: <20220503132038.2714128-1-michael@walle.cc>
In-Reply-To: <20220503132038.2714128-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, horatiu.vultur@microchip.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  3 May 2022 15:20:38 +0200 you wrote:
> In commit 4fdabd509df3 ("dt-bindings: net: lan966x: remove PHY reset")
> the PHY reset was removed, but I failed to remove it from the example.
> Fix it.
> 
> Fixes: 4fdabd509df3 ("dt-bindings: net: lan966x: remove PHY reset")
> Reported-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> [...]

Here is the summary with links:
  - [net-next] dt-bindings: net: lan966x: fix example
    https://git.kernel.org/netdev/net-next/c/fa728505f3e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


