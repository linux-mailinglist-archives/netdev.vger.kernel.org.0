Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50C46A8728
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 17:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCBQpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 11:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjCBQpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 11:45:14 -0500
Received: from mailrelay1-1.pub.mailoutpod2-cph3.one.com (mailrelay1-1.pub.mailoutpod2-cph3.one.com [IPv6:2a02:2350:5:400::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15E72ED57
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 08:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa2;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=sAIc9DICHOwHXe3hoL0M1Cz46v91ph++acz6kjkneyk=;
        b=kDFUay36skYmps2/wdqt4fAH3ooPZbYWVp4pqBqM961wiZduj7P0xLgJw2P+NpMGf7kg1DoicLT6s
         g6l09K8HwL4RYQ8zGGoaFGn4km6zQYbAroP+EN+9HlyJrhV1W8t5cDqTAwscYUwdLDpYbIiHboO9rZ
         aMzoAa0S/vUdoj1kf/OGdJTZUpW+MrjaNGUTQavNWIRuYfGMKTi7Tl3hROfbZVtoTWtbKeUCJQ2L0I
         vgAjzdLxgJIXjLXCeRFb3ZpkshGAWy49N0muwOqA6SWUqwPx0aPY3DSGC5+6RFk99RSbDSFXHj01s6
         xLMWjzebL84uGzeen8v31LzBEjuhwEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed2;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=sAIc9DICHOwHXe3hoL0M1Cz46v91ph++acz6kjkneyk=;
        b=dTZtzyqF/jIMi0Zr3bfFJbyk3/PAmHQdX/XPn81EeMGXIgD+hYOJ9q2VlxqlJBJy6Rr6S2UsHglzv
         pur80rgBQ==
X-HalOne-ID: 943971d9-b919-11ed-babc-11abd97b9443
Received: from ravnborg.org (2-105-2-98-cable.dk.customer.tdc.net [2.105.2.98])
        by mailrelay1 (Halon) with ESMTPSA
        id 943971d9-b919-11ed-babc-11abd97b9443;
        Thu, 02 Mar 2023 16:45:06 +0000 (UTC)
Date:   Thu, 2 Mar 2023 17:45:04 +0100
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix SPI and I2C bus node names in examples
Message-ID: <ZADSkGa6dK4H9p75@ravnborg.org>
References: <20230228215433.3944508-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228215433.3944508-1-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob.

>  .../bindings/display/bridge/analogix,anx7625.yaml |  2 +-
>  .../bindings/display/bridge/anx6345.yaml          |  2 +-
>  .../bindings/display/bridge/lontium,lt8912b.yaml  |  2 +-
>  .../bindings/display/bridge/nxp,ptn3460.yaml      |  2 +-
>  .../bindings/display/bridge/ps8640.yaml           |  2 +-
>  .../bindings/display/bridge/sil,sii9234.yaml      |  2 +-
>  .../bindings/display/bridge/ti,dlpc3433.yaml      |  2 +-
>  .../bindings/display/bridge/toshiba,tc358762.yaml |  2 +-
>  .../bindings/display/bridge/toshiba,tc358768.yaml |  2 +-
>  .../bindings/display/panel/nec,nl8048hl11.yaml    |  2 +-
Acked-by: Sam Ravnborg <sam@ravnborg.org>



> index 669f70b1b4c4..8bd58913804a 100644
> --- a/Documentation/devicetree/bindings/display/solomon,ssd1307fb.yaml
> +++ b/Documentation/devicetree/bindings/display/solomon,ssd1307fb.yaml
> @@ -226,7 +226,7 @@ unevaluatedProperties: false
>  
>  examples:
>    - |
> -    i2c1 {
> +    i2c {
>              #address-cells = <1>;
>              #size-cells = <0>;
>  
> @@ -239,7 +239,7 @@ examples:
>  
>              ssd1306_i2c: oled@3d {
>                      compatible = "solomon,ssd1306";
> -                    reg = <0x3c>;
> +                    reg = <0x3d>;
>                      pwms = <&pwm 4 3000>;
>                      reset-gpios = <&gpio2 7>;
>                      solomon,com-lrremap;

I can see this align the example with i2c-mux-gpio.yaml so the change
should be fine. I am just positive surprised the tooling caught it.

The change is
Acked-by: Sam Ravnborg <sam@ravnborg.org>

the above was just me thinking loud.

	Sam
