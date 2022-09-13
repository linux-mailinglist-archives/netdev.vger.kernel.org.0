Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858965B6828
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 08:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiIMGw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 02:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiIMGw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 02:52:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB7C5723B;
        Mon, 12 Sep 2022 23:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31141612F5;
        Tue, 13 Sep 2022 06:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB946C433C1;
        Tue, 13 Sep 2022 06:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663051975;
        bh=hWHxEDedf3cSC7f7f24lBb2iCboOD36DDx7oM7Ayfgw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kuaBiT/nXFq3/twgRuVpId5EVcEU2CN8EJv61qJKttfmRRkGhmWGnH8u6apvh6HGJ
         YZ2qoY5sZ89GWHIebALbxqwbIEhLVjKurcU6kWpGT1hdxcs57I4u8XzUyN2RFoCI2l
         aaWAI9V123JfmyGu3uLwCFRmy2VONgdeFkopY2v6En5cHnNx904blBn8QNikDOfRgF
         l15HBrD2TLiRwFjZSlniiVKIchdasVOawOZ+XhLdmKvvxO3fSQPRMHslYynj1ettOf
         jQD1Ij8zykfrxnkEfbVJHa+h88voJQjumbw8ZLsFzF7ZnZlUKwN8SQgfAKshqYMler
         Bp7Tp7GyzxNyg==
From:   Kalle Valo <kvalo@kernel.org>
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
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 12/12] arm64: dts: apple: Add WiFi module and antenna properties
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
        <E1oXg8I-0064vm-1C@rmk-PC.armlinux.org.uk>
Date:   Tue, 13 Sep 2022 09:52:45 +0300
In-Reply-To: <E1oXg8I-0064vm-1C@rmk-PC.armlinux.org.uk> (Russell King's
        message of "Mon, 12 Sep 2022 10:53:38 +0100")
Message-ID: <87bkrjbwaq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell King (Oracle) <rmk+kernel@armlinux.org.uk> writes:

> From: Hector Martin <marcan@marcan.st>
>
> Add the new module-instance/antenna-sku properties required to select
> WiFi firmwares properly to all board device trees.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Reviewed-by: Mark Kettenis <kettenis@openbsd.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  arch/arm64/boot/dts/apple/t8103-j274.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-j293.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-j313.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-j456.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-j457.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-jxxx.dtsi | 2 ++
>  6 files changed, 22 insertions(+)

I didn't get any reply to my question in v1 so I assume this patch 12 is
ok to take to wireless-next. ARM folks, if this is not ok please let me
know.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
