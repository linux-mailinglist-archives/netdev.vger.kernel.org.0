Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E1F57E0E5
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiGVLkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiGVLkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8C611A3B;
        Fri, 22 Jul 2022 04:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 142BEB82828;
        Fri, 22 Jul 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB2A3C341C7;
        Fri, 22 Jul 2022 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658490013;
        bh=mWuXaUFCyZ8S7SFsDa0lXapudXQH3v0ZuiZrRzxtxJ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ApUgJkR0rrRWizwu+AuKRCGqFy7sIIkzoDWE+4mih/19YzpV7kajPs2+2b37O/xwe
         uMTMT6PdgbNLF9Dd3EjPtEKPHyR/EDcyVMlb5OY+I66pF0Qw9HVqfCBkckuLg2EH98
         Nv0Mf7OZ4i+u373FQ/6QrAu4wPa9h+wPb2VAOoHWWWrKA+/9bR0CMZhv01hwW5NszB
         V8HBRyaEl0gRswmNJsfS+a/5x9EU2Znm6QnMkqH9LAKSzCls0vjQYtLj2FQvCLsMz3
         Q4Xoiu8QLNXnSWzEnxz1mBzoW4z2OeBcCgp1yH0wBVRgDMsrOfuc3ytHpy1Qn1AEay
         ATf82f9wJck1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 904F2E451B3;
        Fri, 22 Jul 2022 11:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: fsl,fec: Add missing types to phy-reset-*
 properties
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165849001358.931.2978469816946290159.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 11:40:13 +0000
References: <20220719215109.1876788-1-robh@kernel.org>
In-Reply-To: <20220719215109.1876788-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 19 Jul 2022 15:51:08 -0600 you wrote:
> The phy-reset-* properties are missing type definitions and are not common
> properties. Even though they are deprecated, a type is needed.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - dt-bindings: net: fsl,fec: Add missing types to phy-reset-* properties
    https://git.kernel.org/netdev/net/c/030f21ba2ab1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


