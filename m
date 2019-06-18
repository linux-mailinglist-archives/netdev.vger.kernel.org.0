Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA2F4AC02
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbfFRUnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:43:08 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35701 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730341AbfFRUnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:43:08 -0400
Received: by mail-ot1-f68.google.com with SMTP id j19so16903607otq.2;
        Tue, 18 Jun 2019 13:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QyVmAgn2/ADZTeFvTvc5soQ9bwH2xTxtcHLwxv1lczw=;
        b=qa1wjVgI5rCT8ZKRcGF119YgCb/1p+uRb2IXiLAELUbmvypJNrkJKmdXVKbHWPNKc7
         kL5DmRPCHoXkd78jv4xuO06ZrFt5G8Kx8mvjb4CcEDPYTjQmBpCcJXtqgCJEE4pWq4sP
         1RzSc/9FHA7hI9rHoAUBNTY2wWtB+jKOubmvsByOLwOdbgyQZyyHntZjd6+8LkpXIXTi
         jZRBWRG6R6QvKIa0IGYysZ3MsX9E4eY+JZ1rrgqiAUwVOFIbZenlNkh7GgUwGO7JRuq0
         vHvHrsqZaDY9Sy8mG6vDSrudEZDKts9sd7RWptF1lO4SDVpbLuIInXC77PNaMb+9cFUT
         FUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QyVmAgn2/ADZTeFvTvc5soQ9bwH2xTxtcHLwxv1lczw=;
        b=ZjPfgHjLuyu4s6rX7QlvWNy0SzxjQoRbq/kRfR9woSZzEgqpBMuHZ1qsrHZAs2Arkp
         QOA8UpGy2dJmTZ/fCXOOeCsuuQKiFAf3FHSqzB1jE66b64AQJDobRgqWAX7/bDFUFffQ
         Ma+IzqsUbpqM03TMEjKan/KO67T+oRYlDSADAXrfLNoGGpAq3bQW5mST4JJd+khhlTTX
         wUpsaG2/dUYpBW4S1dGjlUX2g0ELNZtkCXfaNjWuBo/WhWRtYnSZyTLFbs7ve53O4D1r
         WMLG/l266HaJ9jfvl/4OOBktzWtZOr8kYH8M7jSc1AJ3EaPBXk4ah0I3qYl6aS8XdY/a
         lTrg==
X-Gm-Message-State: APjAAAVcwm8YrzpEX2uJ44H8Ec9ONbnak1UMEocAeV+3JTaFFdn+AlDW
        K4UJZm3pqrHgh4o0CN3/OZ4XzWjQx/6RnC6dZ9s=
X-Google-Smtp-Source: APXvYqx3uypgm5u60182DZP002f1pXqni8MBRmNseHSnue/Gn6NM0Z6mwoXhO4bu4UBXMRrIuhYQlNWFgrS8bSAw4yQ=
X-Received: by 2002:a9d:39a6:: with SMTP id y35mr23888615otb.81.1560890584820;
 Tue, 18 Jun 2019 13:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <5d089fb6.1c69fb81.4f92.9134@mx.google.com> <7hr27qdedo.fsf@baylibre.com>
In-Reply-To: <7hr27qdedo.fsf@baylibre.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 18 Jun 2019 22:42:53 +0200
Message-ID: <CAFBinCCrpQNU_JtL0SwEGbwWZ2Qy-b2m5rdjuE0__nDRORGTiQ@mail.gmail.com>
Subject: Re: next/master boot bisection: next-20190617 on sun8i-h2-plus-orangepi-zero
To:     Kevin Hilman <khilman@baylibre.com>
Cc:     "kernelci.org bot" <bot@kernelci.org>,
        "David S. Miller" <davem@davemloft.net>,
        tomeu.vizoso@collabora.com, guillaume.tucker@collabora.com,
        mgalka@collabora.com, broonie@kernel.org, matthew.hart@linaro.org,
        enric.balletbo@collabora.com, Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 6:53 PM Kevin Hilman <khilman@baylibre.com> wrote:
[...]
> This seems to have broken on several sunxi SoCs, but also a MIPS SoC
> (pistachio_marduk):
>
> https://storage.kernelci.org/next/master/next-20190618/mips/pistachio_defconfig/gcc-8/lab-baylibre-seattle/boot-pistachio_marduk.html
today I learned why initializing arrays on the stack is important
too bad gcc didn't warn that I was about to shoot myself (or someone
else) in the foot :/

I just sent a fix: [0]

sorry for this issue and thanks to Kernel CI for even pointing out the
offending commit (this makes things a lot easier than just yelling
that "something is broken")


Martin


[0] https://patchwork.ozlabs.org/patch/1118313/
