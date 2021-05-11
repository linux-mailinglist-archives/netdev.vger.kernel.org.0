Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBB037A0B9
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 09:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhEKHVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 03:21:42 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:55287 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229892AbhEKHVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 03:21:40 -0400
Received: from [77.244.183.192] (port=62410 helo=[192.168.178.41])
        by hostingweb31.netsons.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <luca@lucaceresoli.net>)
        id 1lgMgv-000DLY-4S; Tue, 11 May 2021 09:20:29 +0200
Subject: Re: [PATCH] dt-bindings: More removals of type references on common
 properties
To:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Odelu Kukatla <okukatla@codeaurora.org>,
        Alex Elder <elder@kernel.org>,
        Shengjiu Wang <shengjiu.wang@nxp.com>,
        linux-clk@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210510204524.617390-1-robh@kernel.org>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <d3aae746-284b-b0bc-0d52-a76c361d3592@lucaceresoli.net>
Date:   Tue, 11 May 2021 09:20:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210510204524.617390-1-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca@lucaceresoli.net
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 10/05/21 22:45, Rob Herring wrote:
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

Ok, but shouldn't "percent" be listed in
Documentation/devicetree/bindings/property-units.txt?

Reviewed-by: Luca Ceresoli <luca@lucaceresoli.net>

-- 
Luca
