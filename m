Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F2F49379A
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 10:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353176AbiASJnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 04:43:23 -0500
Received: from mail-vk1-f170.google.com ([209.85.221.170]:37799 "EHLO
        mail-vk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353101AbiASJnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 04:43:07 -0500
Received: by mail-vk1-f170.google.com with SMTP id v192so1145095vkv.4;
        Wed, 19 Jan 2022 01:43:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dbd6K2EXZQ3nddK61UlQKh6WscvPVU8DNsk9wwBVt84=;
        b=CdpmIfi33wXFvj6oI3MxXGL+FxzZpJx2O4Bh8b/I7vQz6YBlG8hQaoseqpSUd+xhyh
         51nHp3MgcAGh4ksYKj30x2uNkAu0AllR81Jn+csdOnbVYGC5khg9AJnalqS7TRmpP1WV
         lKhCucCe6AeWWhtzK7WP25kUyZLLHTzL7qydbVfk87NxFvCtugyPiCTVex26eICglrqP
         j/GpB0Bij8gYXbleMIaabYXNuqyEAtZ3xdxTluPsvNp0ltL8IRuUIqE/YWbOPEAayFyZ
         v73XzUgP2YnS6q2vlHtuK16hbq67OhkwaQK4T1is6aboUqssGVKNQty1o7yaJx4UU+Xr
         +dvg==
X-Gm-Message-State: AOAM532k5oVd8oHrFJ1+dbjpDdCU95yB0aP4bv7xHhDKx87u9sE/MDPq
        JQGejnSYa0EoKItvHxK55VobS+Vv9SdsGdeh
X-Google-Smtp-Source: ABdhPJzCPMW4zH5y1Y5cNilAV02ZCJKMDBENeXiX1EkWR3rcLe9IH033mhRn+oDaSuzTE3AAm5il8g==
X-Received: by 2002:a1f:a6d7:: with SMTP id p206mr11805978vke.31.1642585386061;
        Wed, 19 Jan 2022 01:43:06 -0800 (PST)
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com. [209.85.221.178])
        by smtp.gmail.com with ESMTPSA id p142sm1584040vkp.2.2022.01.19.01.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 01:43:04 -0800 (PST)
Received: by mail-vk1-f178.google.com with SMTP id w5so1120624vke.12;
        Wed, 19 Jan 2022 01:43:04 -0800 (PST)
X-Received: by 2002:a1f:384b:: with SMTP id f72mr11960099vka.0.1642585384422;
 Wed, 19 Jan 2022 01:43:04 -0800 (PST)
MIME-Version: 1.0
References: <20220119015038.2433585-1-robh@kernel.org>
In-Reply-To: <20220119015038.2433585-1-robh@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 19 Jan 2022 10:42:53 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVdja+XaXGP7YFfSgFCTHzOHQkuV5EF_9AFWY2tppyRWA@mail.gmail.com>
Message-ID: <CAMuHMdVdja+XaXGP7YFfSgFCTHzOHQkuV5EF_9AFWY2tppyRWA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Improve phandle-array schemas
To:     Rob Herring <robh@kernel.org>
Cc:     "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, dmaengine@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Wed, Jan 19, 2022 at 2:50 AM Rob Herring <robh@kernel.org> wrote:

> The 'phandle-array' type is a bit ambiguous. It can be either just an
> array of phandles or an array of phandles plus args. Many schemas for
> phandle-array properties aren't clear in the schema which case applies
> though the description usually describes it.
>
> The array of phandles case boils down to needing:
>
> items:
>   maxItems: 1
>
> The phandle plus args cases should typically take this form:
>
> items:
>   - items:
>       - description: A phandle
>       - description: 1st arg cell
>       - description: 2nd arg cell
>
> With this change, some examples need updating so that the bracketing of
> property values matches the schema.

> Signed-off-by: Rob Herring <robh@kernel.org>

The Renesas parts look good to me.
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
