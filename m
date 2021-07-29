Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EB43DAA2B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhG2R3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhG2R3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 13:29:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C6560F43;
        Thu, 29 Jul 2021 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627579785;
        bh=D3GkyggaS8+s7F+pG5XYZLwdyMlGI8ykOK7/wJAH8s0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d3nXdn0n9uSdRZI+synYf/53sKlOTZAkKVoooS5YzD47RvQu8MQJxv0AOXhrrF1Kh
         JwAx5jab1JVEQ9TCo0BC5pR49kibcLWun6/sfK+OIHqhb9lduJkwFB+BpF1X1/2KRM
         OTuhBZOf6P6cTeAS5SyQR6NzFLIoOYoL+WvLmPTIk0XB+PPdYHKrk9m4s05M7Vjm2m
         LAmCPqhvzttvFGcdHlgOvC31eod1A4Swvh3iHMywGn46BvxMAoiZUYkxzYkzcUFuOH
         /DL9zxX05x0YV+Oz1V9SKLlUlwwA3h0OxmTuhudq924I+3iBliar/iUF+5bWvQz+tF
         Oc+BTUyr7uF9Q==
Received: by mail-ed1-f45.google.com with SMTP id n2so9204908eda.10;
        Thu, 29 Jul 2021 10:29:45 -0700 (PDT)
X-Gm-Message-State: AOAM533IzY+wRg38rjGQ/HpdtlXbUota15jrbWAL5QMwrqJX7JJB0UV5
        QVWNX+Io1zIMzxGj3+GOcxND5sbbUlerxZV+xw==
X-Google-Smtp-Source: ABdhPJw4ypzoO5I0cFz+8tX94+fRXltPKkKQ2OvDPUtTv03o4F7mt4UfDhDO0s9y6xTSDbJkVRQlhL7Pis3zPb9TcAQ=
X-Received: by 2002:a05:6402:254a:: with SMTP id l10mr7573233edb.258.1627579784471;
 Thu, 29 Jul 2021 10:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210729125358.5227-1-luoj@codeaurora.org> <20210729125358.5227-3-luoj@codeaurora.org>
In-Reply-To: <20210729125358.5227-3-luoj@codeaurora.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 29 Jul 2021 11:29:32 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+=Vyy7_EQ_A7JW4ZfqpPU=6eCyUYMnPORChGvefw-yTA@mail.gmail.com>
Message-ID: <CAL_Jsq+=Vyy7_EQ_A7JW4ZfqpPU=6eCyUYMnPORChGvefw-yTA@mail.gmail.com>
Subject: Re: [PATCH 3/3] dt-bindings: net: rename Qualcomm IPQ MDIO bindings
To:     Luo Jie <luoj@codeaurora.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gross, Andy" <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org, Sricharan <sricharan@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 6:54 AM Luo Jie <luoj@codeaurora.org> wrote:
>
> rename ipq4019-mdio.yaml to ipq-mdio.yaml for supporting more
> ipq boards such as ipq40xx, ipq807x, ipq60xx and ipq50xx.
>
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  ...m,ipq4019-mdio.yaml => qcom,ipq-mdio.yaml} | 32 ++++++++++++++++---
>  1 file changed, 28 insertions(+), 4 deletions(-)
>  rename Documentation/devicetree/bindings/net/{qcom,ipq4019-mdio.yaml => qcom,ipq-mdio.yaml} (58%)
>
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
> similarity index 58%
> rename from Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
> rename to Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
> index 0c973310ada0..5bdeb461523b 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
> @@ -1,10 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>  %YAML 1.2
>  ---
> -$id: http://devicetree.org/schemas/net/qcom,ipq4019-mdio.yaml#
> +$id: http://devicetree.org/schemas/net/qcom,ipq-mdio.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>
> -title: Qualcomm IPQ40xx MDIO Controller Device Tree Bindings
> +title: Qualcomm IPQ MDIO Controller Device Tree Bindings
>
>  maintainers:
>    - Robert Marko <robert.marko@sartura.hr>
> @@ -14,7 +14,9 @@ allOf:
>
>  properties:
>    compatible:
> -    const: qcom,ipq4019-mdio
> +    oneOf:
> +      - const: qcom,ipq4019-mdio
> +      - const: qcom,ipq-mdio

This is more than the commit log suggests. A generic compatible by
itself is not sufficient. If other chips have the same block, just use
'qcom,ipq4019-mdio'. They should also have a compatible for the new
SoC in case it's not 'the same'.

Also, use 'enum' rather than oneOf plus const.

>
>    "#address-cells":
>      const: 1
> @@ -23,7 +25,29 @@ properties:
>      const: 0
>
>    reg:
> -    maxItems: 1
> +    maxItems: 2

This breaks compatibility because now 1 entry is not valid.

> +
> +  clocks:
> +    items:
> +      - description: MDIO clock
> +
> +  clock-names:
> +    items:
> +      - const: gcc_mdio_ahb_clk
> +
> +  resets:
> +    items:
> +      - description: MDIO reset & GEPHY hardware reset
> +
> +  reset-names:
> +    items:
> +      - const: gephy_mdc_rst

These all now apply to 'qcom,ipq4019-mdio'. The h/w had no clocks or
resets and now does?

You don't need *-names when there is only 1.

> +  phy-reset-gpios:
> +    maxItems: 3
> +    description:
> +      The phandle and specifier for the GPIO that controls the RESET
> +      lines of PHY devices on that MDIO bus.

This belongs in the phy node since the reset is connected to the phy.

>
>  required:
>    - compatible
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
