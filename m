Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9DA5BC5EC
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 12:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiISKAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 06:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiISKAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 06:00:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFE810D;
        Mon, 19 Sep 2022 03:00:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4609F61828;
        Mon, 19 Sep 2022 10:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3AFC433B5;
        Mon, 19 Sep 2022 10:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663581647;
        bh=+17s6Wtbdo4L7stYi4UorDpOJxEGDGV29FM19sqxEbs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bX04CSGo0ee0hnFdJp+TMvEDLAKINbbX05Mg+qSjcOZ/sNT5zqzNbuP8okLs8NFqq
         vYcb5e/UFd5k73NSEMDy/7LSaRf6aDaCkfuJCayU+8RZwGECoYw8L92tIGOzA+XDaE
         W3yJmBOixQjwfsSuXj1Jxcld0DFgD6boIjo35PkoikQxFoswnYk0JxoIfqKJ/lQObQ
         W+becfcJWP/kffx8skuE14osfd1Z/VciUue9rtEW6tMxRHOjsrSV7Vjkh8YTvKLISk
         o/pUU2RweAGV/B8hVM9By7v/5WEVMBCa3y7hRtzqPC7S1QGvuA4+HpYw4Ub7junJJ/
         DDisqcNS1BGRQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH wireless-next v3 01/12] dt-bindings: net: bcm4329-fmac:
 Add
 Apple properties & chips
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <E1oZDnO-0077Zy-18@rmk-PC.armlinux.org.uk>
References: <E1oZDnO-0077Zy-18@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafa__ Mi__ecki" <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>,
        van Spriel <arend@broadcom.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166358162603.24821.1105605322984506505.kvalo@kernel.org>
Date:   Mon, 19 Sep 2022 10:00:42 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell King (Oracle) <rmk+kernel@armlinux.org.uk> wrote:

> From: Hector Martin <marcan@marcan.st>
> 
> This binding is currently used for SDIO devices, but these chips are
> also used as PCIe devices on DT platforms and may be represented in the
> DT. Re-use the existing binding and add chip compatibles used by Apple
> T2 and M1 platforms (the T2 ones are not known to be used in DT
> platforms, but we might as well document them).
> 
> Then, add properties required for firmware selection and calibration on
> M1 machines.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Reviewed-by: Mark Kettenis <kettenis@openbsd.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

12 patches applied to wireless-next.git, thanks.

e2e37224e8b3 dt-bindings: net: bcm4329-fmac: Add Apple properties & chips
e263d7229411 wifi: brcmfmac: firmware: Handle per-board clm_blob files
a1b5a9022436 wifi: brcmfmac: pcie/sdio/usb: Get CLM blob via standard firmware mechanism
7cb46e721417 wifi: brcmfmac: firmware: Support passing in multiple board_types
e63efbcaba7d wifi: brcmfmac: pcie: Read Apple OTP information
7682de8b3351 wifi: brcmfmac: of: Fetch Apple properties
6bad3eeab6d3 wifi: brcmfmac: pcie: Perform firmware selection for Apple platforms
687f767d6fab wifi: brcmfmac: firmware: Allow platform to override macaddr
f48476780ce3 wifi: brcmfmac: msgbuf: Increase RX ring sizes to 1024
e01d7a546981 wifi: brcmfmac: pcie: Support PCIe core revisions >= 64
e8b80bf2fbd7 wifi: brcmfmac: pcie: Add IDs/properties for BCM4378
4302b3fba12a arm64: dts: apple: Add WiFi module and antenna properties

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/E1oZDnO-0077Zy-18@rmk-PC.armlinux.org.uk/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

