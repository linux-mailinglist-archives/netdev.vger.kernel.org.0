Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106E36391FD
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiKYXFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiKYXFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:05:02 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C33532F2;
        Fri, 25 Nov 2022 15:05:01 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id f7so8126174edc.6;
        Fri, 25 Nov 2022 15:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SrTRFSS/x4t6+IVdYOMgEeoJ308qI/cUd08WWdG+ebA=;
        b=bsrCkPS7FyV3HCb4+fg+Qg08H/NUS8Fj7Q0hEixpV+cYoGxhfTbZ8MZCtDdquHpioj
         we7k2tDT7sUow8SX8+UDZ3BHUFOI2RqHFQER+e+NeFQ7wccSpwcvvtvzPTJheDUsRp3l
         kSzCi2BFiNnjAAGyybdy6ZhCqP4bLeVfsUg2gfqhE9thjPwwCClGF414PEF3gaaaOVHr
         0DkloM4FXRV7XHh0SMZjYop6Pn2STK64kgXjzEmke6lDts3uSTDombG7A9RTYcDPDX40
         eFXLCiPrRIZIBHqWlmOvSAPeWTSMrwi/LaZVmnRmTiuAv9Zcxy7+P57twERnlgdvGpNN
         ls4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SrTRFSS/x4t6+IVdYOMgEeoJ308qI/cUd08WWdG+ebA=;
        b=hq7U+n3I/LC43B7DYSmlIHvvYf3zkmQq5ur0QozLdShv5XVx2aD+GPpRsPz3aJBKLr
         uVHECEz+fqYtW3npJjdrn0W3XnXnyp7i8NahUS1GzxJ9d/N3PHn19erd6gYxGGxRW//2
         8yGFxqFlf0Slo+p2ssGXlNpko7fJveR7Cq8QiPRoP8BdLSIpjpr+HR+YOlcPNEGUt7+h
         Q9ZZsl0PkrbInOaMowjgp/WtuvhqC9E/DEWY4TuUxWz7YJqzNX+woZlm+g/qrPlVZfJh
         ivMvTHw7VrMMUMuK1i1K5Zvh2YPO76Ao4Vwi3AeF3X/yUay8xkrzX+jUK1C+kZIkl9df
         tFZw==
X-Gm-Message-State: ANoB5pnwBOK+bszVSungYYQxeL5DhYLYJdIvFgkRvDdueYkiTJeRp7h6
        moLwP94zZuM529qelN1y51cCZCBngMTH0w7j8WU=
X-Google-Smtp-Source: AA0mqf7oYYnOUvxYJelBH+ZCQeIchQJlARoJQwAnQuoPWecqswsfj8HILcbdy2jSsZv7bqLG10yyurKQ2U9QeGAVcvw=
X-Received: by 2002:a05:6402:2404:b0:467:67e1:ca61 with SMTP id
 t4-20020a056402240400b0046767e1ca61mr4120477eda.27.1669417499790; Fri, 25 Nov
 2022 15:04:59 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-3-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-3-3f025599b968@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Nov 2022 00:04:48 +0100
Message-ID: <CAFBinCANM=AOw1bbGCheFy20mqQ1ym_maK0C1sYpjceoNH-dNQ@mail.gmail.com>
Subject: Re: [PATCH 03/12] dt-bindings: nvmem: convert amlogic-meson-mx-efuse.txt
 to dt-schema
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Eric Dumazet <edumazet@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neil,

thanks for your work on this!

On Fri, Nov 18, 2022 at 3:33 PM Neil Armstrong
<neil.armstrong@linaro.org> wrote:
[...]
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +
> +        sn: sn@14 {
> +            reg = <0x14 0x10>;
> +        };
> +
> +        eth_mac: mac@34 {
> +            reg = <0x34 0x10>;
> +        };
> +
> +        bid: bid@46 {
> +            reg = <0x46 0x30>;
> +        };
I assume you took these examples from the newer, GX eFuse?
Unfortunately on boards with these older SoCs the serial number and
MAC address are often not stored in the eFuse.
This is just an example, so I won't be sad if we keep them. To avoid
confusion I suggest switching to different examples:
  ethernet_mac_address: mac@1b4 {
    reg = <0x1b4 0x6>;
  };
  temperature_calib: calib@1f4 {
     reg = <0x1f4 0x4>;
  };

What do you think?


Best regards,
Martin
