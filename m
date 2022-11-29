Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC063CA23
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 22:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbiK2VL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 16:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiK2VLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 16:11:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E93D70469;
        Tue, 29 Nov 2022 13:10:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BBF5618DE;
        Tue, 29 Nov 2022 21:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84F9CC43142;
        Tue, 29 Nov 2022 21:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669756239;
        bh=NrCuAivPv3qzyDvI/rHbjvPlp31xALKnnxmZZ7zY+mg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WZ1Ifuyh8ehomMO7obYf7e569GVymyaRtRxEFXRnAnm0M2CiRKpxTQv0VOZn9swXY
         BctDv0FJL48NhbfZhB3pZwKFYaXEVVg9piKzDkJwBYO71DGRCUnZuyKa/VgvL1SkzW
         vEm30eKyJm6DbqQNvN8nFIWt6l79jbKoRZB1dgUHZAg3+4Cq5ewm+NbrWbgiAeDxUI
         Ngx7Wv/09xft3PbVFKkFlOT+2U352A4WwDt4zQKsc5aCHd7vboahFJAO4synbWY8uW
         gdZWktWnbf7W5a8e660xPXEAoQg8sLfvpgZe0VZEndnMA3YuhA9rxoYMuaLZRZIwPB
         pIgsNpm/Yji6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 600D4C395EC;
        Tue, 29 Nov 2022 21:10:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dt-bindings: net: realtek-bluetooth: Add RTL8723DS
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166975623937.18742.13348891788442486147.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 21:10:39 +0000
References: <20221125040956.18648-1-samuel@sholland.org>
In-Reply-To: <20221125040956.18648-1-samuel@sholland.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, kuba@kernel.org,
        robh@kernel.org, alistair@alistair23.me,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        anarsoul@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Thu, 24 Nov 2022 22:09:56 -0600 you wrote:
> RTL8723DS is another variant of the RTL8723 WiFi + Bluetooth chip. It is
> already supported by the hci_uart/btrtl driver. Document the compatible.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Alistair Francis <alistair@alistair23.me>
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> 
> [...]

Here is the summary with links:
  - [v2] dt-bindings: net: realtek-bluetooth: Add RTL8723DS
    https://git.kernel.org/bluetooth/bluetooth-next/c/b05684f9f99b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


