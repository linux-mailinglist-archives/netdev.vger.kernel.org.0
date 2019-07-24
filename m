Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3530B72D2F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfGXLOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:14:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfGXLOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:14:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 021706058E; Wed, 24 Jul 2019 11:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563966883;
        bh=WNP4i+Xm1K+QKneKcjzQw8TLaJsuxelXCn8BDxP0KmE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Cs8P7ecjL4qJAglKJWQFu89m2H/UTaMYu6NK0Y/pMEWyAohi5PmtVKTmtT/VkkQaZ
         cPIgvBvqwG/f7duTlIPKTdWo5MhKougu1o3yCMRbcoU7d0y1FFNIhGghOZ1IaU1R//
         9CdGSZ8c0FPy0Q1qtAWghzEGJuNLuMktaIeMUDbs=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 892B46030E;
        Wed, 24 Jul 2019 11:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563966880;
        bh=WNP4i+Xm1K+QKneKcjzQw8TLaJsuxelXCn8BDxP0KmE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=nwxpTwkKRsUFRsdwd8oWca0fKhpYtNdgckvbtR5XsbOdiF791fp6/T37Y8wOjdDAQ
         Iq+bGMIQnwFIwZHVDV8dkehN/WsE3ylck1JHlxexpC/ygH0WHZdjTaOGT4ibwjkV6h
         gzgZRM7YQ1bo+fkgUchmZdLFbE5/TJdkF4HiXm5s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 892B46030E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore/wl18xx: Add invert-irq OF property for physically
 inverted IRQ
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190607172958.20745-1-erosca@de.adit-jv.com>
References: <20190607172958.20745-1-erosca@de.adit-jv.com>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Spyridon Papageorgiou <spapageorgiou@de.adit-jv.com>,
        Joshua Frkuska <joshua_frkuska@mentor.com>,
        "George G . Davis" <george_davis@mentor.com>,
        Andrey Gusakov <andrey.gusakov@cogentembedded.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724111443.021706058E@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:14:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eugeniu Rosca <erosca@de.adit-jv.com> wrote:

> The wl1837mod datasheet [1] says about the WL_IRQ pin:
> 
>  ---8<---
> SDIO available, interrupt out. Active high. [..]
> Set to rising edge (active high) on powerup.
>  ---8<---
> 
> That's the reason of seeing the interrupt configured as:
>  - IRQ_TYPE_EDGE_RISING on HiKey 960/970
>  - IRQ_TYPE_LEVEL_HIGH on a number of i.MX6 platforms
> 
> We assert that all those platforms have the WL_IRQ pin connected
> to the SoC _directly_ (confirmed on HiKey 970 [2]).
> 
> That's not the case for R-Car Kingfisher extension target, which carries
> a WL1837MODGIMOCT IC. There is an SN74LV1T04DBVR inverter present
> between the WLAN_IRQ pin of the WL18* chip and the SoC, effectively
> reversing the requirement quoted from [1]. IOW, in Kingfisher DTS
> configuration we would need to use IRQ_TYPE_EDGE_FALLING or
> IRQ_TYPE_LEVEL_LOW.
> 
> Unfortunately, v4.2-rc1 commit bd763482c82ea2 ("wl18xx: wlan_irq:
> support platform dependent interrupt types") made a special case out
> of these interrupt types. After this commit, it is impossible to provide
> an IRQ configuration via DTS which would describe an inverter present
> between the WL18* chip and the SoC, generating the need for workarounds
> like [3].
> 
> Create a boolean OF property, called "invert-irq" to specify that
> the WLAN_IRQ pin of WL18* is connected to the SoC via an inverter.
> 
> This solution has been successfully tested on R-Car H3ULCB-KF-M06 using
> the DTS configuration [4] combined with the "invert-irq" property.
> 
> [1] http://www.ti.com/lit/ds/symlink/wl1837mod.pdf
> [2] https://www.96boards.org/documentation/consumer/hikey/hikey970/hardware-docs/
> [3] https://github.com/CogentEmbedded/meta-rcar/blob/289fbd4f8354/meta-rcar-gen3-adas/recipes-kernel/linux/linux-renesas/0024-wl18xx-do-not-invert-IRQ-on-WLxxxx-side.patch
> [4] https://patchwork.kernel.org/patch/10895879/
>     ("arm64: dts: ulcb-kf: Add support for TI WL1837")
> 
> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>

Based on the discussion I'm dropping this. Please resend once there's a
conclusion.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10982491/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

