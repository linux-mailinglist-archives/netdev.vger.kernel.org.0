Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C455FEA5E
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 10:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJNIU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 04:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiJNIUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 04:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0896EA0261;
        Fri, 14 Oct 2022 01:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06F7FB82270;
        Fri, 14 Oct 2022 08:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9553EC433D7;
        Fri, 14 Oct 2022 08:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665735614;
        bh=J76X/xI3ZYRL0g1Sf6dnSW0VX7I1/KbcYZPfBHuDpR4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E0neJOuChOHOotuezF455eXfujedVs53rYTFBaS5UWfHiDDdOQrhWXRXzuNnIJyfv
         N1ivPbRNzvNviyt7QW3bLuoBtkaOe//Qg+ZiqTMTjnUQizPAbSZjpWqI559OZqrehH
         zozkIZ/25KlVqNNGNOybLPP7XPxc/VJ6rovTdj/DH5ggk0RYlR8FLorqKWZf7es9pp
         15N3ZsFKwLdYQl2nwBGpoiUlY5Mox7I5TG0W+NAkwqfvk6aBcCKgfNn+ofFIV97r/C
         DO9Olp+raYc0Sc0v0FSjA3VGh8GYEE9a1N8m+YNtWCSRaNSLVDACKghHqZDQjZNo4A
         Vr0/tRVs9ml8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78D2AE4D00B;
        Fri, 14 Oct 2022 08:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: nfc: s3fwrn5: Drop Krzysztof Opasiak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166573561449.14465.9269645235996945251.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Oct 2022 08:20:14 +0000
References: <20221013234205.132630-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221013234205.132630-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Oct 2022 19:42:05 -0400 you wrote:
> Emails to Krzysztof Opasiak bounce ("Recipient address rejected: User
> unknown") so drop his email from maintainers of s3fwrn5 NFC bindings and
> driver.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml | 1 -
>  MAINTAINERS                                                    | 1 -
>  2 files changed, 2 deletions(-)

Here is the summary with links:
  - MAINTAINERS: nfc: s3fwrn5: Drop Krzysztof Opasiak
    https://git.kernel.org/netdev/net/c/0c9341179551

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


