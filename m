Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF98437A136
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 09:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhEKHxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 03:53:42 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3059 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhEKHxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 03:53:33 -0400
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FfVNg53Pnz6wm4T;
        Tue, 11 May 2021 15:46:27 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 11 May 2021 09:52:24 +0200
Received: from localhost (10.52.125.126) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 11 May
 2021 08:52:23 +0100
Date:   Tue, 11 May 2021 08:50:41 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Rob Herring <robh@kernel.org>
CC:     <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Luca Ceresoli" <luca@lucaceresoli.net>,
        Stephen Boyd <sboyd@kernel.org>,
        "Olivier Moysan" <olivier.moysan@foss.st.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        "Orson Zhai" <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        "Chunyan Zhang" <zhang.lyra@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Odelu Kukatla <okukatla@codeaurora.org>,
        Alex Elder <elder@kernel.org>,
        Shengjiu Wang <shengjiu.wang@nxp.com>,
        <linux-clk@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-iio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-input@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: More removals of type references on common
 properties
Message-ID: <20210511085041.00000d39@Huawei.com>
In-Reply-To: <20210510204524.617390-1-robh@kernel.org>
References: <20210510204524.617390-1-robh@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.125.126]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 May 2021 15:45:24 -0500
Rob Herring <robh@kernel.org> wrote:

> Users of common properties shouldn't have a type definition as the
> common schemas already have one. A few new ones slipped in and
> *-names was missed in the last clean-up pass. Drop all the unnecessary
> type references in the tree.
> 
> A meta-schema update to catch these is pending.
> 
> Cc: Luca Ceresoli <luca@lucaceresoli.net>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Olivier Moysan <olivier.moysan@foss.st.com>
> Cc: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Georgi Djakov <djakov@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Orson Zhai <orsonzhai@gmail.com>
> Cc: Baolin Wang <baolin.wang7@gmail.com>
> Cc: Chunyan Zhang <zhang.lyra@gmail.com>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Fabrice Gasnier <fabrice.gasnier@st.com>
> Cc: Odelu Kukatla <okukatla@codeaurora.org>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Shengjiu Wang <shengjiu.wang@nxp.com>
> Cc: linux-clk@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-input@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  Documentation/devicetree/bindings/clock/idt,versaclock5.yaml    | 2 --
>  .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml         | 1 -
>  Documentation/devicetree/bindings/input/input.yaml              | 1 -
>  Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml   | 1 -
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml             | 1 -
>  .../devicetree/bindings/power/supply/sc2731-charger.yaml        | 2 +-
>  Documentation/devicetree/bindings/sound/fsl,rpmsg.yaml          | 2 +-
>  7 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> index c268debe5b8d..28675b0b80f1 100644
> --- a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> +++ b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> @@ -60,7 +60,6 @@ properties:
>      maxItems: 2
>  
>    idt,xtal-load-femtofarads:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      minimum: 9000
>      maximum: 22760
>      description: Optional load capacitor for XTAL1 and XTAL2
> @@ -84,7 +83,6 @@ patternProperties:
>          enum: [ 1800000, 2500000, 3300000 ]
>        idt,slew-percent:
>          description: The Slew rate control for CMOS single-ended.
> -        $ref: /schemas/types.yaml#/definitions/uint32
>          enum: [ 80, 85, 90, 100 ]
>  
>  required:
> diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> index 6f2398cdc82d..1e7894e524f9 100644
> --- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> @@ -102,7 +102,6 @@ patternProperties:
>  
>        st,adc-channel-names:
>          description: List of single-ended channel names.
> -        $ref: /schemas/types.yaml#/definitions/string-array
>  
>        st,filter-order:
>          description: |
> diff --git a/Documentation/devicetree/bindings/input/input.yaml b/Documentation/devicetree/bindings/input/input.yaml
> index 74244d21d2b3..d41d8743aad4 100644
> --- a/Documentation/devicetree/bindings/input/input.yaml
> +++ b/Documentation/devicetree/bindings/input/input.yaml
> @@ -38,6 +38,5 @@ properties:
>        Duration in seconds which the key should be kept pressed for device to
>        reset automatically. Device with key pressed reset feature can specify
>        this property.
> -    $ref: /schemas/types.yaml#/definitions/uint32
>  
>  additionalProperties: true
> diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> index cb6498108b78..36c955965d90 100644
> --- a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> +++ b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> @@ -92,7 +92,6 @@ properties:
>        this interconnect to send RPMh commands.
>  
>    qcom,bcm-voter-names:
> -    $ref: /schemas/types.yaml#/definitions/string-array
>      description: |
>        Names for each of the qcom,bcm-voters specified.
>  
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 7443490d4cc6..5fe6d3dceb08 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -105,7 +105,6 @@ properties:
>        - description: Whether the IPA clock is enabled (if valid)
>  
>    qcom,smem-state-names:
> -    $ref: /schemas/types.yaml#/definitions/string-array
>      description: The names of the state bits used for SMP2P output
>      items:
>        - const: ipa-clock-enabled-valid
> diff --git a/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml b/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml
> index db1aa238cda5..b62c2431f94e 100644
> --- a/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/sc2731-charger.yaml
> @@ -20,7 +20,7 @@ properties:
>      maxItems: 1
>  
>    phys:
> -    $ref: /schemas/types.yaml#/definitions/phandle
> +    maxItems: 1
>      description: phandle to the USB phy
>  
>    monitored-battery:
> diff --git a/Documentation/devicetree/bindings/sound/fsl,rpmsg.yaml b/Documentation/devicetree/bindings/sound/fsl,rpmsg.yaml
> index b4c190bddd84..61802a11baf4 100644
> --- a/Documentation/devicetree/bindings/sound/fsl,rpmsg.yaml
> +++ b/Documentation/devicetree/bindings/sound/fsl,rpmsg.yaml
> @@ -49,7 +49,7 @@ properties:
>      maxItems: 1
>  
>    memory-region:
> -    $ref: /schemas/types.yaml#/definitions/phandle
> +    maxItems: 1
>      description:
>        phandle to a node describing reserved memory (System RAM memory)
>        The M core can't access all the DDR memory space on some platform,

