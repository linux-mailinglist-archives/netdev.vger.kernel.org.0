Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80097530A98
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 10:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiEWH2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 03:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiEWH1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 03:27:39 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C505CDFAA;
        Mon, 23 May 2022 00:24:01 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id DFF2F1F42B4D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1653289176;
        bh=fMIMMhJRlJQe9JKTSpnuOU6Ds5f0JXS0sAh5aX1dd3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b93nE9YSM6DJsc4kIBgfLAD6U78/aWTdtTmsANj5h0ZRnRfo49OptjrpkvL4fnoKm
         wB8yj9ZRGClhMgn1w9k6xiOW8xGF8aMj8SPwbcgV4hXJb9FMUHIsOTTQGKRSQb+kG5
         ePAX785C9NVljDivTAcPR1iUa37w9iJxbOT3cMYCJXDEmkknbpRk5ejESbjH/uE02w
         daTt/EZpgIgStQAkSWMNMhpvEBFiHaUJ0l3oxRKs8rkGig6JbRQdGBk0R5B+MbW2Bx
         nPusTCOcwNztXImaE8sIQlB7OBIU0ivaJnNdkupLnTAa3C5F6+47ch4ScrpzpYdXhO
         TZjBStxjJ8xgQ==
Received: by mercury (Postfix, from userid 1000)
        id 8AA59106043A; Mon, 23 May 2022 08:59:33 +0200 (CEST)
Date:   Mon, 23 May 2022 08:59:33 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix properties without any type
Message-ID: <20220523065933.kq5dxxe2chvp2r7w@mercury.elektranox.org>
References: <20220519211411.2200720-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qdtpx5mo3ymeklm2"
Content-Disposition: inline
In-Reply-To: <20220519211411.2200720-1-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qdtpx5mo3ymeklm2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 19, 2022 at 04:14:11PM -0500, Rob Herring wrote:
> Now that the schema tools can extract type information for all
> properties (in order to decode dtb files), finding properties missing
> any type definition is fairly trivial though not yet automated.
>=20
> Fix the various property schemas which are missing a type. Most of these
> tend to be device specific properties which don't have a vendor prefix.
> A vendor prefix is how we normally ensure a type is defined.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../arm/hisilicon/controller/hip04-bootwrapper.yaml       | 5 +++--
>  .../bindings/display/bridge/toshiba,tc358768.yaml         | 1 +
>  .../devicetree/bindings/display/panel/panel-timing.yaml   | 5 +++++
>  .../bindings/display/panel/raydium,rm67191.yaml           | 1 +
>  .../bindings/display/panel/samsung,s6e8aa0.yaml           | 1 +
>  .../devicetree/bindings/gpio/fairchild,74hc595.yaml       | 1 +
>  .../devicetree/bindings/input/google,cros-ec-keyb.yaml    | 1 +
>  .../devicetree/bindings/input/matrix-keymap.yaml          | 4 ++++
>  Documentation/devicetree/bindings/media/i2c/adv7604.yaml  | 3 ++-
>  Documentation/devicetree/bindings/mux/reg-mux.yaml        | 8 ++++++--
>  Documentation/devicetree/bindings/net/cdns,macb.yaml      | 1 +
>  Documentation/devicetree/bindings/net/ingenic,mac.yaml    | 1 +
>  .../devicetree/bindings/net/ti,davinci-mdio.yaml          | 1 +
>  .../devicetree/bindings/net/wireless/ti,wlcore.yaml       | 2 ++
>  .../devicetree/bindings/pci/snps,dw-pcie-ep.yaml          | 6 ++++--
>  Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml   | 2 ++
>  .../devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml    | 2 ++
>  Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml | 1 +
>  .../devicetree/bindings/power/supply/battery.yaml         | 7 ++++++-
>  .../devicetree/bindings/power/supply/charger-manager.yaml | 1 +
>  Documentation/devicetree/bindings/rng/st,stm32-rng.yaml   | 1 +
>  Documentation/devicetree/bindings/serial/8250.yaml        | 1 +
>  .../devicetree/bindings/sound/audio-graph-card2.yaml      | 3 +++
>  .../devicetree/bindings/sound/imx-audio-hdmi.yaml         | 3 +++
>  Documentation/devicetree/bindings/usb/smsc,usb3503.yaml   | 1 +
>  25 files changed, 55 insertions(+), 8 deletions(-)

For power-supply:

Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com>

-- Sebastian

>=20
> diff --git a/Documentation/devicetree/bindings/arm/hisilicon/controller/h=
ip04-bootwrapper.yaml b/Documentation/devicetree/bindings/arm/hisilicon/con=
troller/hip04-bootwrapper.yaml
> index 7378159e61df..483caf0ce25b 100644
> --- a/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bo=
otwrapper.yaml
> +++ b/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bo=
otwrapper.yaml
> @@ -17,14 +17,15 @@ properties:
>        - const: hisilicon,hip04-bootwrapper
> =20
>    boot-method:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>      description: |
>        Address and size of boot method.
>        [0]: bootwrapper physical address
>        [1]: bootwrapper size
>        [2]: relocation physical address
>        [3]: relocation size
> -    minItems: 1
> -    maxItems: 2
> +    minItems: 2
> +    maxItems: 4
> =20
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/display/bridge/toshiba,tc3=
58768.yaml b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358=
768.yaml
> index 3bd670b8e5cd..0b6f5bef120f 100644
> --- a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.y=
aml
> +++ b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.y=
aml
> @@ -58,6 +58,7 @@ properties:
> =20
>              properties:
>                data-lines:
> +                $ref: /schemas/types.yaml#/definitions/uint32
>                  enum: [ 16, 18, 24 ]
> =20
>        port@1:
> diff --git a/Documentation/devicetree/bindings/display/panel/panel-timing=
=2Eyaml b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
> index 7749de95ee40..229e3b36ee29 100644
> --- a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
> @@ -146,6 +146,7 @@ properties:
>        Horizontal sync pulse.
>        0 selects active low, 1 selects active high.
>        If omitted then it is not used by the hardware
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
> =20
>    vsync-active:
> @@ -153,6 +154,7 @@ properties:
>        Vertical sync pulse.
>        0 selects active low, 1 selects active high.
>        If omitted then it is not used by the hardware
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
> =20
>    de-active:
> @@ -160,6 +162,7 @@ properties:
>        Data enable.
>        0 selects active low, 1 selects active high.
>        If omitted then it is not used by the hardware
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
> =20
>    pixelclk-active:
> @@ -169,6 +172,7 @@ properties:
>        sample data on rising edge.
>        Use 1 to drive pixel data on rising edge and
>        sample data on falling edge
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
> =20
>    syncclk-active:
> @@ -179,6 +183,7 @@ properties:
>        sample sync on rising edge of pixel clock.
>        Use 1 to drive sync on rising edge and
>        sample sync on falling edge of pixel clock
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
> =20
>    interlaced:
> diff --git a/Documentation/devicetree/bindings/display/panel/raydium,rm67=
191.yaml b/Documentation/devicetree/bindings/display/panel/raydium,rm67191.=
yaml
> index 745dd247c409..617aa8c8c03a 100644
> --- a/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
> @@ -24,6 +24,7 @@ properties:
> =20
>    dsi-lanes:
>      description: Number of DSI lanes to be used must be <3> or <4>
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [3, 4]
> =20
>    v3p3-supply:
> diff --git a/Documentation/devicetree/bindings/display/panel/samsung,s6e8=
aa0.yaml b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.=
yaml
> index ca959451557e..1cdc91b3439f 100644
> --- a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
> @@ -36,6 +36,7 @@ properties:
> =20
>    init-delay:
>      description: delay after initialization sequence [ms]
> +    $ref: /schemas/types.yaml#/definitions/uint32
> =20
>    panel-width-mm:
>      description: physical panel width [mm]
> diff --git a/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yam=
l b/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
> index 5fe19fa5f67c..a99e7842ca17 100644
> --- a/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
> +++ b/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
> @@ -26,6 +26,7 @@ properties:
>      const: 2
> =20
>    registers-number:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      description: Number of daisy-chained shift registers
> =20
>    enable-gpios:
> diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.=
yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> index e8f137abb03c..aa61fe64be63 100644
> --- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> +++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> @@ -31,6 +31,7 @@ properties:
>      type: boolean
> =20
>    function-row-physmap:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>      minItems: 1
>      maxItems: 15
>      description: |
> diff --git a/Documentation/devicetree/bindings/input/matrix-keymap.yaml b=
/Documentation/devicetree/bindings/input/matrix-keymap.yaml
> index 6699d5e32dca..9f703bb51e12 100644
> --- a/Documentation/devicetree/bindings/input/matrix-keymap.yaml
> +++ b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
> @@ -27,6 +27,10 @@ properties:
>        column and linux key-code. The 32-bit big endian cell is packed as:
>            row << 24 | column << 16 | key-code
> =20
> +  linux,no-autorepeat:
> +    type: boolean
> +    description: Disable keyrepeat
> +
>    keypad,num-rows:
>      $ref: /schemas/types.yaml#/definitions/uint32
>      description: Number of row lines connected to the keypad controller.
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.yaml b/D=
ocumentation/devicetree/bindings/media/i2c/adv7604.yaml
> index c19d8391e2d5..7589d377c686 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
> @@ -60,7 +60,8 @@ properties:
>        enables hot-plug detection.
> =20
>    default-input:
> -    maxItems: 1
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [ 0, 1 ]
>      description:
>        Select which input is selected after reset.
> =20
> diff --git a/Documentation/devicetree/bindings/mux/reg-mux.yaml b/Documen=
tation/devicetree/bindings/mux/reg-mux.yaml
> index 60d5746eb39d..e2f6b11f1254 100644
> --- a/Documentation/devicetree/bindings/mux/reg-mux.yaml
> +++ b/Documentation/devicetree/bindings/mux/reg-mux.yaml
> @@ -25,8 +25,12 @@ properties:
>      const: 1
> =20
>    mux-reg-masks:
> -    description: an array of register offset and pre-shifted bitfield ma=
sk
> -      pairs, each describing a single mux control.
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +    items:
> +      items:
> +        - description: register offset
> +        - description: pre-shifted bitfield mask
> +    description: Each entry describes a single mux control.
> =20
>    idle-states: true
> =20
> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Docum=
entation/devicetree/bindings/net/cdns,macb.yaml
> index 6cd3d853dcba..59fe2789fa44 100644
> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> @@ -129,6 +129,7 @@ patternProperties:
>        reset-gpios: true
> =20
>        magic-packet:
> +        type: boolean
>          description:
>            Indicates that the hardware supports waking up via magic packe=
t.
> =20
> diff --git a/Documentation/devicetree/bindings/net/ingenic,mac.yaml b/Doc=
umentation/devicetree/bindings/net/ingenic,mac.yaml
> index 8e52b2e683b8..93b3e991d209 100644
> --- a/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> +++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> @@ -37,6 +37,7 @@ properties:
>      const: stmmaceth
> =20
>    mode-reg:
> +    $ref: /schemas/types.yaml#/definitions/phandle
>      description: An extra syscon register that control ethernet interfac=
e and timing delay
> =20
>    rx-clk-delay-ps:
> diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b=
/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> index 6f44f9516c36..a339202c5e8e 100644
> --- a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> @@ -34,6 +34,7 @@ properties:
>      maxItems: 1
> =20
>    bus_freq:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      maximum: 2500000
>      description: MDIO Bus frequency
> =20
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yam=
l b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> index 8dd164d10290..d68bb2ec1f7e 100644
> --- a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> @@ -54,9 +54,11 @@ properties:
> =20
> =20
>    ref-clock-frequency:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      description: Reference clock frequency.
> =20
>    tcxo-clock-frequency:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      description: TCXO clock frequency.
> =20
>    clock-xtal:
> diff --git a/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml b=
/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml
> index e59059ab5be0..b78535040f04 100644
> --- a/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml
> +++ b/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml
> @@ -55,13 +55,15 @@ properties:
>        Translation Unit) registers.
> =20
>    num-ib-windows:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    maximum: 256
>      description: number of inbound address translation windows
> -    maxItems: 1
>      deprecated: true
> =20
>    num-ob-windows:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    maximum: 256
>      description: number of outbound address translation windows
> -    maxItems: 1
>      deprecated: true
> =20
>  required:
> diff --git a/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml b/Do=
cumentation/devicetree/bindings/pci/snps,dw-pcie.yaml
> index a5345c494744..c90e5e2d25f6 100644
> --- a/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml
> +++ b/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml
> @@ -68,6 +68,8 @@ properties:
>        Translation Unit) registers.
> =20
>    num-viewport:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    maximum: 256
>      description: |
>        number of view ports configured in hardware. If a platform
>        does not specify it, the driver autodetects it.
> diff --git a/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.=
yaml b/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
> index 53e963e090f2..533b4cfe33d2 100644
> --- a/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
> @@ -120,6 +120,7 @@ patternProperties:
>        input-schmitt-disable: true
> =20
>        input-polarity-invert:
> +        type: boolean
>          description:
>            Enable or disable pin input polarity inversion.
> =20
> @@ -132,6 +133,7 @@ patternProperties:
>        output-low: true
> =20
>        output-polarity-invert:
> +        type: boolean
>          description:
>            Enable or disable pin output polarity inversion.
> =20
> diff --git a/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml b/=
Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
> index 3301fa0c2653..301db7daf870 100644
> --- a/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
> +++ b/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
> @@ -51,6 +51,7 @@ properties:
>        supported by the CPR power domain.
> =20
>    acc-syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle
>      description: A phandle to the syscon used for writing ACC settings.
> =20
>    nvmem-cells:
> diff --git a/Documentation/devicetree/bindings/power/supply/battery.yaml =
b/Documentation/devicetree/bindings/power/supply/battery.yaml
> index d56ac484fec5..491488e7b970 100644
> --- a/Documentation/devicetree/bindings/power/supply/battery.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/battery.yaml
> @@ -85,8 +85,13 @@ properties:
>      description: battery factory internal resistance
> =20
>    resistance-temp-table:
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +    items:
> +      items:
> +        - description: the temperature in degree Celsius
> +        - description: battery internal resistance percent
>      description: |
> -      An array providing the temperature in degree Celsius
> +      A table providing the temperature in degree Celsius
>        and corresponding battery internal resistance percent, which is us=
ed to
>        look up the resistance percent according to current temperature to=
 get an
>        accurate batterty internal resistance in different temperatures.
> diff --git a/Documentation/devicetree/bindings/power/supply/charger-manag=
er.yaml b/Documentation/devicetree/bindings/power/supply/charger-manager.ya=
ml
> index c863cfa67865..fbb2204769aa 100644
> --- a/Documentation/devicetree/bindings/power/supply/charger-manager.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/charger-manager.yaml
> @@ -36,6 +36,7 @@ properties:
> =20
>    cm-poll-mode:
>      description: polling mode
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      default: 0
>      enum:
>        - 0 # disabled
> diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Do=
cumentation/devicetree/bindings/rng/st,stm32-rng.yaml
> index 9a6e4eaf4d3c..fcd86f822a9c 100644
> --- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> @@ -27,6 +27,7 @@ properties:
>      maxItems: 1
> =20
>    clock-error-detect:
> +    type: boolean
>      description: If set enable the clock detection management
> =20
>  required:
> diff --git a/Documentation/devicetree/bindings/serial/8250.yaml b/Documen=
tation/devicetree/bindings/serial/8250.yaml
> index 3bab2f27b970..5f6b113d378f 100644
> --- a/Documentation/devicetree/bindings/serial/8250.yaml
> +++ b/Documentation/devicetree/bindings/serial/8250.yaml
> @@ -138,6 +138,7 @@ properties:
>      description: The current active speed of the UART.
> =20
>    reg-offset:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      description: |
>        Offset to apply to the mapbase from the start of the registers.
> =20
> diff --git a/Documentation/devicetree/bindings/sound/audio-graph-card2.ya=
ml b/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml
> index f7e94b1e0e4b..7416067c945e 100644
> --- a/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml
> +++ b/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml
> @@ -24,10 +24,13 @@ properties:
>        connection's sink, the second being the connection's source.
>      $ref: /schemas/types.yaml#/definitions/non-unique-string-array
>    multi:
> +    type: object
>      description: Multi-CPU/Codec node
>    dpcm:
> +    type: object
>      description: DPCM node
>    codec2codec:
> +    type: object
>      description: Codec to Codec node
> =20
>  required:
> diff --git a/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml =
b/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml
> index d5474f83ac2c..e7e7bb65c366 100644
> --- a/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml
> +++ b/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml
> @@ -20,9 +20,11 @@ properties:
>      description: User specified audio sound card name
> =20
>    audio-cpu:
> +    $ref: /schemas/types.yaml#/definitions/phandle
>      description: The phandle of an CPU DAI controller
> =20
>    hdmi-out:
> +    type: boolean
>      description: |
>        This is a boolean property. If present, the transmitting function
>        of HDMI will be enabled, indicating there's a physical HDMI out
> @@ -30,6 +32,7 @@ properties:
>        block, such as an HDMI encoder or display-controller.
> =20
>    hdmi-in:
> +    type: boolean
>      description: |
>        This is a boolean property. If present, the receiving function of
>        HDMI will be enabled, indicating there is a physical HDMI in
> diff --git a/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml b/Do=
cumentation/devicetree/bindings/usb/smsc,usb3503.yaml
> index b9e219829801..321b6f166197 100644
> --- a/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml
> +++ b/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml
> @@ -45,6 +45,7 @@ properties:
>        property if all ports have to be enabled.
> =20
>    initial-mode:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [1, 2]
>      description: >
>        Specifies initial mode. 1 for Hub mode, 2 for standby mode.
> --=20
> 2.34.1
>=20

--qdtpx5mo3ymeklm2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmKLMMYACgkQ2O7X88g7
+ppw2xAAl0vBYZf1CgfDpJ+FG8uvWFMvL1zJnLWnGehckZCyHM1UPl7+pMlnNQH9
CcE2ZhnsNwbnVyzwE6cM7wHpykHZ1vm10oEQ5NCJXGYfwkJliFfY+1FjDYr4u0CC
cBv4Jtm+9aeuMNdQSlLdKe42tsvdfrszZ87rvZCjrGDCHTfdBMzQJq52ubyRN+Js
GcNCpZcmU4wHx2KaV5ulTDcbn/aszCfgiXv5OnrcgTYNyYxQhC2KTabev9SHKXeG
GqKebLt5HjxB5zxcZ6gIDHZCagq9Gz5zdFNMbpDghXrzV90UjhFnoCmTq5x6YQjV
WAzIdCjj28n91dDC+MojBZtHTtjCA63D2ywbbPZaNIRXkHbpMOTU18I91TkAYF2e
lD56173I9XS2qsr/vgryeaFruiaLMKk1igWcXZsKkvsNuJsB2gbHjrr9uie0ysaR
sS9bs9tgOrjbOFx+jxCafEn98JvhYTwG3w3NGPzYwL2I9WNn6IdZHquTtsQHenWU
55FmwvfHrzvR2S6Ehe9xiwfog6CJpTSbegiXhhN/iRwrSDoCFZTtwLDut7rGNqQ2
0tLIJV/wMAF6TJegC24Q3NB+DdxPJ3r020+BSeswqoAzxg8XFrOx+A9xlcbxQGtY
kJh1dEYtYu5bZLDiX7QdbEW1aiz2TTSsnhXBi3/xDSqJx05/bnk=
=n1xp
-----END PGP SIGNATURE-----

--qdtpx5mo3ymeklm2--
