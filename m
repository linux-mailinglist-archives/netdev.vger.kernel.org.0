Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D0C4C5D0
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 05:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfFTDfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 23:35:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46411 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfFTDfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 23:35:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id 81so811804pfy.13
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 20:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=HOSCj25pO6a386fSVkhPsk9edlxIx4b0dfihdZfuotE=;
        b=R24VUbUFz5qZKeynsTUrq4c3dB1nc/QoAc5x5U+zHBRKmgP4irX+Qd/uz+TvIn9Dde
         8hzyvekv6Gzm2FKO8q3HSyEgq8Vud578ah6rtzQ3QyhfF5il00SiTGRbeo9J2kI61H8l
         DMJK9uVuztUlxcdwCN4uQbImQDCa4vCH+p4Ik6/xlqe2I/Xw/gE2bLIDTnJTSR+Y4tqu
         8gHa8kqfrF68JmH/Ra/8/AFn7cJw4OyG1GD5rh5Ao3DrXQ12KqDFI/Zb0oyBe3+S23fW
         A9aA+b8dH+CO2S4ymvs047VKJGaK3Gxqu0jofHWcLZ38fOEqvft10X5TfRunYq1TrEN+
         lZKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HOSCj25pO6a386fSVkhPsk9edlxIx4b0dfihdZfuotE=;
        b=p17H9w2aI4vKEkYPUVFKrkJl76uJNLOiFuvTuUQCKcVeiGorayV4Jjax7yA0WiVXEe
         O62F+d1NukvsqZ3xs9Qoea0ZayA3yJbN5uhnr2a8U152Xi3f2OCSU52MxHnLk09weGKD
         DQOL5AxNW3sFQlgHyd2rYC3mlCnCsidbEjIrbtrlN4H9FKAwyfsTJkx+U6R6OSu20YYr
         CVjkwEIZf1qg0VMbPMxLgpTXnfrrNl/55bbNI0Y2oiSZe7dNGK6Ce7KiAWttkpw8ZR9i
         Im7eEH5kcMVb8Yvp6kBwyPQVOCOrhoHGZW75RG7R6cCSO14r3Ykh7iKcDS7WkSQQJM7I
         BooA==
X-Gm-Message-State: APjAAAX3WmNegokwdX3QaFea+ry7+Me+k0E7y+9JQdDUWSLJw366lBQt
        C2fevXtqqdju8nEZH4VSV3RvEwncUn68dg==
X-Google-Smtp-Source: APXvYqymLvsH5Jne+eK0EsJ3Q4/Y0qf5ZzWcO17TxweQkCCIYK/LjuDERiWhe89FjMEwwQO+ynf3Mw==
X-Received: by 2002:a63:df46:: with SMTP id h6mr10696443pgj.181.1561001732439;
        Wed, 19 Jun 2019 20:35:32 -0700 (PDT)
Received: from localhost ([2601:602:9200:a1a5:ec6a:e4cb:28b2:e322])
        by smtp.googlemail.com with ESMTPSA id 133sm23896859pfa.92.2019.06.19.20.35.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 20:35:31 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        robin.murphy@arm.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH v3 0/4] Ethernet PHY reset GPIO updates for Amlogic SoCs
In-Reply-To: <20190615103832.5126-1-martin.blumenstingl@googlemail.com>
References: <20190615103832.5126-1-martin.blumenstingl@googlemail.com>
Date:   Wed, 19 Jun 2019 20:35:27 -0700
Message-ID: <7hh88lhqtc.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> While trying to add the Ethernet PHY interrupt on the X96 Max I found
> that the current reset line definition is incorrect. Patch #1 fixes
> this.
>
> Since the fix requires moving from the deprecated "snps,reset-gpio"
> property to the generic Ethernet PHY reset bindings I decided to move
> all Amlogic boards over to the non-deprecated bindings. That's what
> patches #2 and #3 do.
>
> Finally I found that Odroid-N2 doesn't define the Ethernet PHY's reset
> GPIO yet. I don't have that board so I can't test whether it really
> works but based on the schematics it should. 
>
> This series is a partial successor to "stmmac: honor the GPIO flags
> for the PHY reset GPIO" from [0]. I decided not to take Linus W.'s
> Reviewed-by from patch #4 of that series because I had to change the
> wording and I want to be sure that he's happy with that now.
>
> One quick note regarding patches #1 and #4: I decided to violate the
> "max 80 characters per line" (by 4 characters) limit because I find
> that the result is easier to read then it would be if I split the
> line.
>
>
> Changes since v1 at [1]:
> - fixed the reset deassert delay for RTL8211F PHYs - spotted by Robin
>   Murphy (thank you). according to the public RTL8211E datasheet the
>   correct values seem to be: 10ms assert, 30ms deassert
> - fixed the reset assert and deassert delays for IP101GR PHYs. There
>   are two values given in the public datasheet, use the higher one
>   (10ms instead of 2.5)
> - update the patch descriptions to quote the datasheets (the RTL8211F
>   quotes are taken from the public RTL8211E datasheet because as far
>   as I can tell the reset sequence is identical on both PHYs)
>
> Changes since v2 at [2]:
> - add Neil's Reviewed/Acked/Tested-by's (thank you!)
> - rebased on top of "arm64: dts: meson-g12a-x96-max: add sound card"
>
>
> [0] https://patchwork.kernel.org/cover/10983801/
> [1] https://patchwork.kernel.org/cover/10985155/
> [2] https://patchwork.kernel.org/cover/10990863/

Queued for v5.3...

> Martin Blumenstingl (4):
>   arm64: dts: meson: g12a: x96-max: fix the Ethernet PHY reset line
>   ARM: dts: meson: switch to the generic Ethernet PHY reset bindings

...in branch v5.3/dt

>   arm64: dts: meson: use the generic Ethernet PHY reset GPIO bindings
>   arm64: dts: meson: g12b: odroid-n2: add the Ethernet PHY reset line

The other 3 in v5.3/dt64,

Thanks,

Kevin
