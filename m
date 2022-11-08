Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00F962144E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbiKHN7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbiKHN7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:59:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC9E528A4;
        Tue,  8 Nov 2022 05:59:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79D9AB81AFB;
        Tue,  8 Nov 2022 13:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329FBC43144;
        Tue,  8 Nov 2022 13:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667915984;
        bh=gt3e/46Fztc4JQae3Mx8JCLYeah5CxMi8WSozle/3iA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fB9gCqxgaOkiVIJZFtjTFtPeciaEpPfvLLIdmkZH6SH0KJCkgub5Pt//FU+Ss+nXJ
         +cQjPUS7oyqm3M1vGNi10M9nVimW5ZSI9+3eIlcVD1uEg81oJcXFFD2D6xHjJoj1kf
         Il3pkcKiV2j7kFC/mHFz7qcjraz0mCmMVALpPwkBAsKlLAbWHgT/Nsok1h1exCX1tS
         aBYEjLlLhXskfflZc22j1kNDcwcjLLtAIHRfxsjvaDw0r0VjMyxNx7VbaYcUkQT4EN
         4ExPbq8ZpeP2MuN8Zo5BpdpgFEJGe2pL5eS0CWXHBrR7ad01VXXuLPAw5QeScY24Fk
         uXXiAzNkewt/w==
Received: by mail-lj1-f175.google.com with SMTP id x21so21204447ljg.10;
        Tue, 08 Nov 2022 05:59:44 -0800 (PST)
X-Gm-Message-State: ACrzQf0cslshuUlmJfR8xkNScAr7YGRUmRIyZ7FJoMsFTlh51OqH/KIt
        CBPSj7EqX6o2UJph7KUz43Orji58uA2jxCXxTw==
X-Google-Smtp-Source: AMsMyM6v95NHP6D6kjSL3cfj63z3lVhmN0hKNF2Re0ZxrUaTNruCtaNBrEflOi0n2jImuvMyuQALQF+iytz273/QVJo=
X-Received: by 2002:a05:651c:114a:b0:25d:5ae6:42a4 with SMTP id
 h10-20020a05651c114a00b0025d5ae642a4mr19189817ljo.255.1667915982102; Tue, 08
 Nov 2022 05:59:42 -0800 (PST)
MIME-Version: 1.0
References: <20221108055531.2176793-1-dominique.martinet@atmark-techno.com> <20221108055531.2176793-2-dominique.martinet@atmark-techno.com>
In-Reply-To: <20221108055531.2176793-2-dominique.martinet@atmark-techno.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 8 Nov 2022 07:59:33 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKCb2ZA+CLTVnGBMjp6zu0yw-rSFjWRg2S3hA7S6h-XEA@mail.gmail.com>
Message-ID: <CAL_JsqKCb2ZA+CLTVnGBMjp6zu0yw-rSFjWRg2S3hA7S6h-XEA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: h4-bluetooth: add new bindings
 for hci_h4
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, mizo@atmark-techno.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 7, 2022 at 11:56 PM Dominique Martinet
<dominique.martinet@atmark-techno.com> wrote:
>
> Add devicetree binding to support defining a bluetooth device using the h4
> uart protocol

The protocol is mostly irrelevant to the binding. The binding is for a
particular device even if the driver is shared.

>
> This was tested with a NXP wireless+BT AW-XM458 module, but might
> benefit others as the H4 protocol seems often used.
>
> Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> ---
>  .../devicetree/bindings/net/h4-bluetooth.yaml | 49 +++++++++++++++++++

Use the compatible string for the filename.

There's now a pending (in linux-next) net/bluetooth/ directory and a
bluetooth-controller.yaml schema which you should reference.

>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/h4-bluetooth.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/h4-bluetooth.yaml b/Documentation/devicetree/bindings/net/h4-bluetooth.yaml
> new file mode 100644
> index 000000000000..5d11b89ca386
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/h4-bluetooth.yaml
> @@ -0,0 +1,49 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/h4-bluetooth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: H4 Bluetooth
> +
> +maintainers:
> +  - Dominique Martinet <dominique.martinet@atmark-techno.com>
> +
> +description:
> +  H4 is a common bluetooth over uart protocol.
> +  For example, the AW-XM458 is a WiFi + BT module where the WiFi part is
> +  connected over PCI (M.2), while BT is connected over serial speaking
> +  the H4 protocol. Its firmware is sent on the PCI side.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - nxp,aw-xm458-bt
> +
> +  max-speed: true
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/clock/imx8mp-clock.h>
> +
> +    uart1 {

serial {

> +        pinctrl-names = "default";
> +        pinctrl-0 = <&pinctrl_uart1>;
> +        assigned-clocks = <&clk IMX8MP_CLK_UART1>;
> +        assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_80M>;
> +        status = "okay";
> +        fsl,dte-mode = <1>;
> +        fsl,uart-has-rtscts;

All these properties are irrelevant to the example. Drop.

> +
> +
> +        bluetooth {
> +            compatible = "nxp,aw-xm458-bt";
> +            max-speed = <3000000>;
> +        };
> +    };
> --
> 2.35.1
>
>
