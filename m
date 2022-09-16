Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540F05BA776
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 09:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiIPH2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 03:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiIPH2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 03:28:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8590CE26;
        Fri, 16 Sep 2022 00:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2348BB823FE;
        Fri, 16 Sep 2022 07:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F874C433C1;
        Fri, 16 Sep 2022 07:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663313288;
        bh=HoYT6/8BPEBCr/YYuh4hEsi9UnwSukKSeYBcik+UtIQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZpFtLPYb5xJQiJV2B+xc/4Orpc8XkUq+4s5lcJB9c3F479bHBj5a0J0Z3q2HsT8t0
         8sEZpC+t3AZd6TRzAlGrNmQ6VDntYZD0UPnsYEZO7MPDWPketIJp/TBDkg6kwPWabz
         riqD72SuD/CTjB6SoUxAl0mhuR6VtBGJSmdQgFBYf26OI1RtWz2zvjeTwdr3YH16uS
         vByEx1ajW7NrjSMmtk9c1PspS5wTmuRvDlfrclBVbhNe+kJogGOC2ZQ7NJkKEvhSyB
         NSpRo3PVA57VrMzy7YOSjA9HkbUKaLfAjLfIUhLkr8rolPLH8xfWZcePyAGF/YjnUB
         sOAncA3TsfSRw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     "Russell King \(Oracle\)" <rmk+kernel@armlinux.org.uk>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 12/12] arm64: dts: apple: Add WiFi module and antenna properties
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
        <E1oXg8I-0064vm-1C@rmk-PC.armlinux.org.uk> <87bkrjbwaq.fsf@kernel.org>
        <7e9f12eb-7f5b-1757-cd2f-5d5f1ca9aacd@marcan.st>
Date:   Fri, 16 Sep 2022 10:28:03 +0300
In-Reply-To: <7e9f12eb-7f5b-1757-cd2f-5d5f1ca9aacd@marcan.st> (Hector Martin's
        message of "Wed, 14 Sep 2022 01:30:30 +0900")
Message-ID: <87a66zaid8.fsf@kernel.org>
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

Hector Martin <marcan@marcan.st> writes:

> On 13/09/2022 15.52, Kalle Valo wrote:
>> Russell King (Oracle) <rmk+kernel@armlinux.org.uk> writes:
>> 
>>> From: Hector Martin <marcan@marcan.st>
>>>
>>> Add the new module-instance/antenna-sku properties required to select
>>> WiFi firmwares properly to all board device trees.
>>>
>>> Signed-off-by: Hector Martin <marcan@marcan.st>
>>> Reviewed-by: Mark Kettenis <kettenis@openbsd.org>
>>> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>>> ---
>>>  arch/arm64/boot/dts/apple/t8103-j274.dts  | 4 ++++
>>>  arch/arm64/boot/dts/apple/t8103-j293.dts  | 4 ++++
>>>  arch/arm64/boot/dts/apple/t8103-j313.dts  | 4 ++++
>>>  arch/arm64/boot/dts/apple/t8103-j456.dts  | 4 ++++
>>>  arch/arm64/boot/dts/apple/t8103-j457.dts  | 4 ++++
>>>  arch/arm64/boot/dts/apple/t8103-jxxx.dtsi | 2 ++
>>>  6 files changed, 22 insertions(+)
>> 
>> I didn't get any reply to my question in v1 so I assume this patch 12 is
>> ok to take to wireless-next. ARM folks, if this is not ok please let me
>> know.
>
> Yup, this is OK to merge via wireless-next. In case you need it,
>
> Acked-by: Hector Martin <marcan@marcan.st>

Perfect, thanks.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
