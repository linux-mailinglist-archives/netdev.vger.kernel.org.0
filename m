Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226F362ED99
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 07:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbiKRGa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 01:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKRGa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 01:30:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74EB97A98;
        Thu, 17 Nov 2022 22:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 720276233C;
        Fri, 18 Nov 2022 06:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8ECAC433B5;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668753024;
        bh=D66kuk5DJuqXcsWWWvKnPBwW4ueok11OWIebIp7ZWmk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MfFvyYmRVldKmbZlF+84SBLrxse4k1t4UzvVLdC7WzsReIaM+L3Rwsr+PdypjITHz
         ztD0tuTP5nXBhQGrJWbJo3fBrlvqo07B1HSLN7CN8IWo6dHpwhgPs8uXgLg0myDh/Y
         TeRH5pgn4rtNy/fQxLbEUOXVTmbNIiaXmin6cbcEVcBZStossFWMrjTBr8qmqpX0ql
         fDNizNBfMt3a35MrJh+VwuBVtIuxfuq4dnifCBB6OmyzN7AnXdDlsfy+4fETthrWq4
         74nh+ZVEz3sbYf/JVMZftg6CbTBzp0odTQuqjbRtUzrH73HQpFjRpnPS+oFZno/b1d
         kIiQERzPOq4LQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A8F3E29F46;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/5] net: ipa: change GSI firmware load
 specification
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166875302462.3603.16365158346185465889.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 06:30:24 +0000
References: <20221116073257.34010-1-elder@linaro.org>
In-Reply-To: <20221116073257.34010-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andersson@kernel.org, konrad.dybcio@linaro.org,
        agross@kernel.org, elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Nov 2022 01:32:51 -0600 you wrote:
> Version 3 just adds reviewed-by tags for Krzysztof Kozlowski.
> 
> Version 2 of this series modifies the first patch only.  One section
> in the description is reworded, and the example now consistenly
> describes the SC7180 SoC, both as suggested by Krzysztof.
> 
> Currently, GSI firmware must be loaded for IPA before it can be
> used--either by the modem, or by the AP.  New hardware supports a
> third option, with the bootloader taking responsibility for loading
> GSI firmware.  In that case, neither the AP nor the modem needs to
> do that.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/5] dt-bindings: net: qcom,ipa: deprecate modem-init
    https://git.kernel.org/netdev/net-next/c/4ca0c6474f71
  - [net-next,v3,2/5] net: ipa: encapsulate decision about firmware load
    https://git.kernel.org/netdev/net-next/c/50f803d4aa71
  - [net-next,v3,3/5] net: ipa: introduce "qcom,gsi-loader" property
    https://git.kernel.org/netdev/net-next/c/07f2f8e1b747
  - [net-next,v3,4/5] dt-bindings: net: qcom,ipa: support skipping GSI firmware load
    https://git.kernel.org/netdev/net-next/c/a49c3ab7d75f
  - [net-next,v3,5/5] net: ipa: permit GSI firmware loading to be skipped
    https://git.kernel.org/netdev/net-next/c/7569805ec26e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


