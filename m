Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC285BA773
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 09:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiIPH1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 03:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiIPH1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 03:27:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E232ACC;
        Fri, 16 Sep 2022 00:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 560A4628CB;
        Fri, 16 Sep 2022 07:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D51CC433D6;
        Fri, 16 Sep 2022 07:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663313256;
        bh=2WqayeGnpq9LSlXKGZr91PvrT3313VfKYLAgW4Oxn7E=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GOMH1U1yysGahJvuCohw4unZCtzL6fWPSCwN9QJUNaioNQHLiTUIqvlgXLuQo2iO4
         22cLwZ3dWZGwom8NwMqZBr4JKU3CZ9wCqJaH5M32eF+mXDsfMPfP7MvYWirue+AJmy
         V+G8dSXisy5RFmpsl3TLj1QhL2zprt59yEmBPCQgQHssceqaZapkOg+4W6srX8+G5Y
         65xDYMYLRKw8VkDZmneWIPxg1elIbEKHgnKS5uJ+c3WPA2ybndouQ5H0K7JApu8OAq
         BmzGJDJ0tv9Uu9eL8AiQ/EpY5i76xzLRgdnDIHD8WfKd0sSi3+eatvqZ7JyxVNrw4i
         +0IXM5lYPeYrA==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Russell King \(Oracle\)" <linux@armlinux.org.uk>
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
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH net-next 12/12] arm64: dts: apple: Add WiFi module and antenna properties
References: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
        <E1oVpne-005LCR-RJ@rmk-PC.armlinux.org.uk> <87zgfb8uqx.fsf@kernel.org>
        <YyCvkrDgsFLYNZ9t@shell.armlinux.org.uk>
Date:   Fri, 16 Sep 2022 10:27:31 +0300
In-Reply-To: <YyCvkrDgsFLYNZ9t@shell.armlinux.org.uk> (Russell King's message
        of "Tue, 13 Sep 2022 17:28:02 +0100")
Message-ID: <87edwbaie4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Russell King (Oracle)" <linux@armlinux.org.uk> writes:

> On Wed, Sep 07, 2022 at 11:16:22AM +0300, Kalle Valo wrote:
>> Russell King (Oracle) <rmk+kernel@armlinux.org.uk> writes:
>> 
>> > From: Hector Martin <marcan@marcan.st>
>> >
>> > Add the new module-instance/antenna-sku properties required to select
>> > WiFi firmwares properly to all board device trees.
>> >
>> > Signed-off-by: Hector Martin <marcan@marcan.st>
>> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> > ---
>> >  arch/arm64/boot/dts/apple/t8103-j274.dts  | 4 ++++
>> >  arch/arm64/boot/dts/apple/t8103-j293.dts  | 4 ++++
>> >  arch/arm64/boot/dts/apple/t8103-j313.dts  | 4 ++++
>> >  arch/arm64/boot/dts/apple/t8103-j456.dts  | 4 ++++
>> >  arch/arm64/boot/dts/apple/t8103-j457.dts  | 4 ++++
>> >  arch/arm64/boot/dts/apple/t8103-jxxx.dtsi | 2 ++
>> >  6 files changed, 22 insertions(+)
>> 
>> Is it ok to take this via wireless-next? Can I get an ack from the
>> maintainers of these files?
>
> I'm not sure who you're expecting to get an ack from.

The problem is that I don't know how .dts files are merged, that's why
I'm extra careful that I'm not breaking the normal flow for them.

> If it's the maintainers of these files, that'll be Hector himself, and
> as he authored the change, there seems to be little point in also
> having an Acked-by from him too.
>
> I just asked Hector on #asahi-dev:
> 17:21 < rmk> also, I think Kalle Valo is waiting on an answer on the arm64 DTS
>              changes for brcmfmac:
> 17:21 < rmk> Is it ok to take this via wireless-next? Can I get an ack from the
> 17:21 < rmk> maintainers of these files?
> 17:21 <@marcan> ah yeah, merging via wireless-next is fine, let me give you an
>                 ack

That sounds good to me, thanks!

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
