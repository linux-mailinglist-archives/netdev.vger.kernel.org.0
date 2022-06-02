Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B255053BBDB
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbiFBPuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 11:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiFBPuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D79A2ED7B;
        Thu,  2 Jun 2022 08:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C862B81FB7;
        Thu,  2 Jun 2022 15:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F74CC34114;
        Thu,  2 Jun 2022 15:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654185013;
        bh=Tr5NsmZ75wsMcr/rnTwmOZKbA/bD5/3grGU5g8/DvUQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PpOfKD+19naoj8FeQ5/iScsD1rVCMffgti9q7Zl6YyJFXTIftAglva0da7tfY5vFZ
         9byaEXld5PMtzOS4YQoTmceKRApPcnTyJuE7ZLfLymi29I0xt2SNHgQ/pMW5ppz0Nk
         gVpiZHVLK5aJcQeLmQYulHL4RcHoEMAur4/a3B+T1PmM/6WCoUXz6Y7jziMwqIri1e
         L8vbVeruojNVpsmZpXPqHoH+WIoAZ6Cp6wyeRimooXAkH3b72glBHwhtRdpa8WKHJd
         RVSj7+7l1KD0zWEQxbDFNVAXo9lhTUIPNZL8lW/sB4bqMS8SSI7qY6KER6e980IM0R
         nmqJdC/4fbiyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5421EAC09C;
        Thu,  2 Jun 2022 15:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/2] Bluetooth: hci_bcm: Autobaud mode support
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165418501293.10758.7339216786088070363.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 15:50:12 +0000
References: <cover.1653916330.git.hakan.jansson@infineon.com>
In-Reply-To: <cover.1653916330.git.hakan.jansson@infineon.com>
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linus.walleij@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org
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

This series was applied to bluetooth/bluetooth-next.git (master)
by Marcel Holtmann <marcel@holtmann.org>:

On Mon, 30 May 2022 17:02:16 +0200 you wrote:
> Some devices (e.g. CYW5557x) require autobaud mode to enable FW loading.
> Autobaud mode can also be required on some boards where the controller
> device is using a non-standard baud rate when first powered on.
> 
> Only a limited subset of HCI commands are supported in autobaud mode.
> 
> These patches add a DT property, "brcm,requires-autobaud-mode", to control
> autobaud mode selection.
> 
> [...]

Here is the summary with links:
  - [v3,1/2] dt-bindings: net: broadcom-bluetooth: Add property for autobaud mode
    https://git.kernel.org/bluetooth/bluetooth-next/c/6d912cc3c21f
  - [v3,2/2] Bluetooth: hci_bcm: Add support for FW loading in autobaud mode
    https://git.kernel.org/bluetooth/bluetooth-next/c/3f125894bed7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


