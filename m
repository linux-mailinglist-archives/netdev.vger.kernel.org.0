Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0282598659
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244941AbiHROre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245520AbiHROrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:47:23 -0400
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69885BBA43;
        Thu, 18 Aug 2022 07:47:21 -0700 (PDT)
Received: by mail-qk1-f171.google.com with SMTP id b9so1263559qka.2;
        Thu, 18 Aug 2022 07:47:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=gdljhD4izytPCTwhmdt8DBVVfc0NydPAltPgDipKvog=;
        b=z21x2EFoAdNeIjrz68Au7PO2e9cPtW0hiwQpPagWD378YKOU24Kiv1WLGGLpLtisUR
         qBk1cmhmh7sPvwMU6eHzIXmgq+kg2d4NgE7GPDq+clkNTZWsKVrEkvZHry8FMONDW8J9
         4iyi6nFbvprD/o0eEeck5HAahW/0disiGm6noXG21VzPGXb/RMwxvQ7/uVMkG85ronW6
         8XN593sIqFSPghnVuC1jOYMbZZrT5j9/A1BN7SBDsaej93rC4JGzkUNA0qsKEi6pxiij
         YjLgrpuureSyFZwfk1xtddwhKp4WQvLJWgZc1C3Pikmm1CUdimKmpKPNKsCyl+whQ5nd
         Lipg==
X-Gm-Message-State: ACgBeo3Lvc0nxCHMN1kJlXgiwEYJAiFy5FrXDoCOIJu4RxxQJadrpjOJ
        xCzgVISjm1KCKluhLunPMw==
X-Google-Smtp-Source: AA6agR6os7Il7llhYeMa4bR2kBtfZkcv6PCsh86UdfBNsIhRKKgO+IREW4lBHpdZzuhJU3WR6VLMIQ==
X-Received: by 2002:a05:620a:2286:b0:6bb:5fa4:58 with SMTP id o6-20020a05620a228600b006bb5fa40058mr2241995qkh.202.1660834040446;
        Thu, 18 Aug 2022 07:47:20 -0700 (PDT)
Received: from robh.at.kernel.org ([2607:fb90:25d2:ea0d:b91c:d10a:6423:3870])
        by smtp.gmail.com with ESMTPSA id n1-20020ac86741000000b0031eebfcb369sm1049301qtp.97.2022.08.18.07.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:47:20 -0700 (PDT)
Received: (nullmailer pid 1843176 invoked by uid 1000);
        Thu, 18 Aug 2022 14:47:13 -0000
Date:   Thu, 18 Aug 2022 08:47:13 -0600
From:   Rob Herring <robh@kernel.org>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH] MAINTAINERS: Update email of Neil Armstrong
Message-ID: <20220818144713.GC1829017-robh@kernel.org>
References: <20220816095617.948678-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816095617.948678-1-narmstrong@baylibre.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 11:56:17AM +0200, Neil Armstrong wrote:
> From: Neil Armstrong <neil.armstrong@linaro.org>
> 
> My professional e-mail will change and the BayLibre one will
> bounce after mid-september of 2022.
> 
> This updates the MAINTAINERS file, the YAML bindings and adds an
> entry in the .mailmap file.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .mailmap                                      |  1 +
>  .../amlogic/amlogic,meson-gx-ao-secure.yaml   |  2 +-
>  .../display/amlogic,meson-dw-hdmi.yaml        |  2 +-
>  .../bindings/display/amlogic,meson-vpu.yaml   |  2 +-
>  .../display/bridge/analogix,anx7814.yaml      |  2 +-
>  .../bindings/display/bridge/ite,it66121.yaml  |  2 +-
>  .../display/panel/sgd,gktw70sdae4se.yaml      |  2 +-
>  .../bindings/i2c/amlogic,meson6-i2c.yaml      |  2 +-
>  .../mailbox/amlogic,meson-gxbb-mhu.yaml       |  2 +-
>  .../bindings/media/amlogic,axg-ge2d.yaml      |  2 +-
>  .../bindings/media/amlogic,gx-vdec.yaml       |  2 +-
>  .../media/amlogic,meson-gx-ao-cec.yaml        |  2 +-
>  .../devicetree/bindings/mfd/khadas,mcu.yaml   |  2 +-
>  .../bindings/net/amlogic,meson-dwmac.yaml     |  2 +-
>  .../bindings/phy/amlogic,axg-mipi-dphy.yaml   |  2 +-
>  .../phy/amlogic,meson-g12a-usb2-phy.yaml      |  2 +-
>  .../phy/amlogic,meson-g12a-usb3-pcie-phy.yaml |  2 +-
>  .../bindings/power/amlogic,meson-ee-pwrc.yaml |  2 +-
>  .../bindings/reset/amlogic,meson-reset.yaml   |  2 +-
>  .../bindings/rng/amlogic,meson-rng.yaml       |  2 +-
>  .../bindings/serial/amlogic,meson-uart.yaml   |  2 +-
>  .../bindings/soc/amlogic/amlogic,canvas.yaml  |  2 +-
>  .../bindings/spi/amlogic,meson-gx-spicc.yaml  |  2 +-
>  .../bindings/spi/amlogic,meson6-spifc.yaml    |  2 +-
>  .../usb/amlogic,meson-g12a-usb-ctrl.yaml      |  2 +-
>  .../watchdog/amlogic,meson-gxbb-wdt.yaml      |  2 +-
>  MAINTAINERS                                   | 20 +++++++++----------
>  27 files changed, 36 insertions(+), 35 deletions(-)

Applied, thanks!

Rob
