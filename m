Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020176CF3AD
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjC2TvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjC2TvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:51:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9856A74;
        Wed, 29 Mar 2023 12:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62A2261E26;
        Wed, 29 Mar 2023 19:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1450C4339B;
        Wed, 29 Mar 2023 19:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680119423;
        bh=2BMeM8dD3hziGXEFErJyFqPV9onZ6X8OoaehGvFbk7A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JuSOEnsguHz56oDMcKCeWXRXqi1iFmbhRiTkod5lT612eIYeRuQNdVanAEaMzRcEd
         9w4M873hYQHRAbtb2gizEuAqh6NezpgtvXW6wlEO7yaLTrQENpEmk63uzuLkcbRvAZ
         0aHX0i4stFuPY8Y2hfxfeFtkT5qZPEjkw/h64tOT6RrGE/QpHT5hpCtBRi6gbmrdKh
         E5zCdZu2yhToBrliNxgX9GbxrJcr74A0eDrS3m6RMG/dziwLgma9/IWovNiqW4d3cy
         y37QjRtBE6ImwpBOGzkkARsno9mJtMX96GfZMls2eZONNgX0G+VbALY2etnBZ00Ydt
         GjYAMfKey+4sQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93217E50D75;
        Wed, 29 Mar 2023 19:50:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8 0/4] Add WCN6855 Bluetooth support
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <168011942359.31352.12230106748890164488.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 19:50:23 +0000
References: <20230326233812.28058-1-steev@kali.org>
In-Reply-To: <20230326233812.28058-1-steev@kali.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        sven@svenpeter.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        markpearson@lenovo.com, quic_tjiang@quicinc.com, johan@kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Sun, 26 Mar 2023 18:38:08 -0500 you wrote:
> First things first, I do not have access to the specs nor the schematics, so a
> lot of this was done via guess work, looking at the acpi tables, and looking at
> how a similar device (wcn6750) was added.
> 
> This patchset has 2 patchsets that it depends on, for the bindings so that they
> pass dtbs_check, as well as adding in the needed regulators to make bluetooth
> work.
> 
> [...]

Here is the summary with links:
  - [v8,1/4] dt-bindings: net: Add WCN6855 Bluetooth
    https://git.kernel.org/bluetooth/bluetooth-next/c/5c63b28b9107
  - [v8,2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
    https://git.kernel.org/bluetooth/bluetooth-next/c/e5a3f2af0036
  - [v8,3/4] arm64: dts: qcom: sc8280xp: Define uart2
    (no matching commit)
  - [v8,4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


