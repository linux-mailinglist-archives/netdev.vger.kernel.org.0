Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7A6195F8C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgC0UWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:22:14 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:38568 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgC0UWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 16:22:13 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 14C2B804E5;
        Fri, 27 Mar 2020 21:22:01 +0100 (CET)
Date:   Fri, 27 Mar 2020 21:21:59 +0100
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-iio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Lee Jones <lee.jones@linaro.org>, linux-clk@vger.kernel.org,
        Kevin Hilman <khilman@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Brian Masney <masneyb@onstation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-amlogic@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@kernel.org>, netdev@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Hartmut Knaack <knaack.h@gmx.de>, linux-media@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 1/4] dt-bindings: iio/accel: Drop duplicate adi,
 adxl345/6 from trivial-devices.yaml
Message-ID: <20200327202159.GA12749@ravnborg.org>
References: <20200325220542.19189-1-robh@kernel.org>
 <20200325220542.19189-2-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325220542.19189-2-robh@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=XpTUx2N9 c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=gAnH3GRIAAAA:8
        a=VwQbUJbxAAAA:8 a=DN42nk9sAAAA:8 a=e5mUnYsNAAAA:8 a=KWDWuRJ9IF3UujpQpV0A:9
        a=CjuIK1q_8ugA:10 a=oVHKYsEdi7-vN-J5QA_j:22 a=AjGcO6oz07-iQ99wixmX:22
        a=ee1JA_unvF1TMR62yWF-:22 a=Vxmtnl_E_bksehYqCbjh:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob.

On Wed, Mar 25, 2020 at 04:05:38PM -0600, Rob Herring wrote:
> The 'adi,adxl345' definition is a duplicate as there's a full binding in:
> Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
> 
> The trivial-devices binding doesn't capture that 'adi,adxl346' has a
> fallback compatible 'adi,adxl345', so let's add it to adi,adxl345.yaml.
> 
> Cc: Michael Hennerich <michael.hennerich@analog.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Hartmut Knaack <knaack.h@gmx.de>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
> Cc: linux-iio@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/iio/accel/adi,adxl345.yaml     | 10 +++++++---
>  Documentation/devicetree/bindings/trivial-devices.yaml |  4 ----
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
> index c602b6fe1c0c..d124eba1ce54 100644
> --- a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
> +++ b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
> @@ -17,9 +17,13 @@ description: |
>  
>  properties:
>    compatible:
> -    enum:
> -      - adi,adxl345
> -      - adi,adxl375
> +    oneOf:
> +      - items:
> +          - const: adi,adxl346
> +          - const: adi,adxl345
> +      - enum:
> +          - adi,adxl345
> +          - adi,adxl375

I assume it is my schema understanding that is poor.
But I cannot parse the above.

The mix of items, enum and const confuses me.

I guess that if I am confused then others may end in the same situation.
Can we improve readability here or amybe add a comment?

	Sam

>  
>    reg:
>      maxItems: 1
> diff --git a/Documentation/devicetree/bindings/trivial-devices.yaml b/Documentation/devicetree/bindings/trivial-devices.yaml
> index 978de7d37c66..51d1f6e43c02 100644
> --- a/Documentation/devicetree/bindings/trivial-devices.yaml
> +++ b/Documentation/devicetree/bindings/trivial-devices.yaml
> @@ -42,10 +42,6 @@ properties:
>            - adi,adt7476
>              # +/-1C TDM Extended Temp Range I.C
>            - adi,adt7490
> -            # Three-Axis Digital Accelerometer
> -          - adi,adxl345
> -            # Three-Axis Digital Accelerometer (backward-compatibility value "adi,adxl345" must be listed too)
> -          - adi,adxl346
>              # AMS iAQ-Core VOC Sensor
>            - ams,iaq-core
>              # i2c serial eeprom  (24cxx)
> -- 
> 2.20.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
