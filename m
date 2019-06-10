Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA533AF37
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 09:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387791AbfFJHBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 03:01:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387582AbfFJHBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 03:01:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 06F6360867; Mon, 10 Jun 2019 07:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560150071;
        bh=a6pX4FZYFU7XLFLEDRMvNOAtnygOukRcVj56PNv7Q+Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kKhPtWRjkWGG0Ywp9i0Fs5eczlJ2bFdCLcuIpHABPfyUToOCDm1kYoJPBABqXpA3c
         LVodgomkO6z7gfRQv1NR+mIFHeNg+CQmeQH8XN9F500eHPeZTlyQLKIrw2anOWPqOc
         xVNJeJsj0R3oXDH7MhQg1X19ziWiwFqqY32Y8gsw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7B3C760261;
        Mon, 10 Jun 2019 07:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560150069;
        bh=a6pX4FZYFU7XLFLEDRMvNOAtnygOukRcVj56PNv7Q+Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oYlI9Fp/f805fO/brFLieU4EaN76YQ++wFVSyJoK4LZqYfrNcmANENdeUYiPKuAJu
         cWU9SxSZVLSd2Q8NKeB+S2pSef4qNaRSwIq8CuwYHfcshwGQ4WrcxLBN7jSat+zN2h
         rqIoaU+f7PL6+ZFuwCGZzug4wTVHUoAFUNTNPd2w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7B3C760261
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
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
        Eugeniu Rosca <roscaeugeniu@gmail.com>, eyalr@ti.com
Subject: Re: [PATCH] wlcore/wl18xx: Add invert-irq OF property for physically inverted IRQ
References: <20190607172958.20745-1-erosca@de.adit-jv.com>
Date:   Mon, 10 Jun 2019 10:01:01 +0300
In-Reply-To: <20190607172958.20745-1-erosca@de.adit-jv.com> (Eugeniu Rosca's
        message of "Fri, 7 Jun 2019 19:29:58 +0200")
Message-ID: <87tvcxncuq.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eugeniu Rosca <erosca@de.adit-jv.com> writes:

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

Tony&Eyal, do you agree with this?

-- 
Kalle Valo
