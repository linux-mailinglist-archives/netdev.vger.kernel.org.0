Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D52B4B10AA
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243077AbiBJOmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:42:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243091AbiBJOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:42:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EA1BD4;
        Thu, 10 Feb 2022 06:42:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F9DBB82570;
        Thu, 10 Feb 2022 14:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DEBC340E5;
        Thu, 10 Feb 2022 14:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644504128;
        bh=a4M/rYYWto+M6gF5xYlU8eBsD4sZ/r4lcdv1lGuC7fo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hBnkUSgucBq4WkI8fAi9ZwaWb7ENfsF/+THZa8KB7Jd2mRhCZEIG3uOh1XIUFQXzN
         +kogdBsoxzkC16eOk1qW9Ku+4Ribm0LhywTBpLo5dDktxmyGsNC1fYK4dxvgBoSSdB
         6iUxsRPiXdO0wyvES5JAyEkiIGWcTB39fb8hxQAwc/aHhl5Pa93D7EWuF/yM+Y1+TJ
         7DPlJp11+YOfCo6WcKHZgg+9SyZPL45+FAivtLTauI6inBVeLN+xCSOD8JfGRg/Iwh
         0AmNXTfOtojs7a+YLPy1E5zCFogXW++5ls6TAjR5nvQiptggOqDhREW6VVzDJjSdDq
         GQyabZkVYa02g==
Received: by mail-ed1-f52.google.com with SMTP id m11so11220251edi.13;
        Thu, 10 Feb 2022 06:42:08 -0800 (PST)
X-Gm-Message-State: AOAM5300EnOe5OFExz2+0eXwej9noc756PsRHdfQYyujD64HrVetXJ8j
        xGjf2h1CYd+tBFFUDiI2nDYduE9XOLz7elF6eA==
X-Google-Smtp-Source: ABdhPJwgLchtcgBH9V1DoJdRfQDtG3i+RFBrDF7ZWN69K0vPTMOXBzwNOm994/JMepPOrMAsiJYPwpyINuKpSBGEaVw=
X-Received: by 2002:a50:e68d:: with SMTP id z13mr8805643edm.307.1644504127113;
 Thu, 10 Feb 2022 06:42:07 -0800 (PST)
MIME-Version: 1.0
References: <20220210063651.798007-1-matt@codeconstruct.com.au> <20220210063651.798007-2-matt@codeconstruct.com.au>
In-Reply-To: <20220210063651.798007-2-matt@codeconstruct.com.au>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 10 Feb 2022 08:41:55 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJac2XzpBdN2rs63qSkwrpcODWN+5e5ts3Tkx0fSM167Q@mail.gmail.com>
Message-ID: <CAL_JsqJac2XzpBdN2rs63qSkwrpcODWN+5e5ts3Tkx0fSM167Q@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/2] dt-bindings: net: New binding mctp-i2c-controller
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Zev Weiss <zev@bewilderbeest.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 12:37 AM Matt Johnston
<matt@codeconstruct.com.au> wrote:
>

No need to resend, but the DT list should be CCed so that checks run.
They do fail sometimes after I've reviewed patches.

> Used to define a local endpoint to communicate with MCTP peripherals
> attached to an I2C bus. This I2C endpoint can communicate with remote
> MCTP devices on the I2C bus.
>
> In the example I2C topology below (matching the second yaml example) we
> have MCTP devices on busses i2c1 and i2c6. MCTP-supporting busses are
> indicated by the 'mctp-controller' DT property on an I2C bus node.
>
> A mctp-i2c-controller I2C client DT node is placed at the top of the
> mux topology, since only the root I2C adapter will support I2C slave
> functionality.
>                                                .-------.
>                                                |eeprom |
>     .------------.     .------.               /'-------'
>     | adapter    |     | mux  --@0,i2c5------'
>     | i2c1       ----.*|      --@1,i2c6--.--.
>     |............|    \'------'           \  \  .........
>     | mctp-i2c-  |     \                   \  \ .mctpB  .
>     | controller |      \                   \  '.0x30   .
>     |            |       \  .........        \  '.......'
>     | 0x50       |        \ .mctpA  .         \ .........
>     '------------'         '.0x1d   .          '.mctpC  .
>                             '.......'          '.0x31   .
>                                                 '.......'
> (mctpX boxes above are remote MCTP devices not included in the DT at
> present, they can be hotplugged/probed at runtime. A DT binding for
> specific fixed MCTP devices could be added later if required)
>
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/i2c/i2c.txt |  4 +
>  .../bindings/net/mctp-i2c-controller.yaml     | 92 +++++++++++++++++++
>  2 files changed, 96 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
>
> diff --git a/Documentation/devicetree/bindings/i2c/i2c.txt b/Documentation/devicetree/bindings/i2c/i2c.txt
> index b864916e087f..fc3dd7ec0445 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c.txt
> @@ -95,6 +95,10 @@ wants to support one of the below features, it should adapt these bindings.
>  - smbus-alert
>         states that the optional SMBus-Alert feature apply to this bus.
>
> +- mctp-controller
> +       indicates that the system is accessible via this bus as an endpoint for
> +       MCTP over I2C transport.
> +
>  Required properties (per child device)
>  --------------------------------------
>
> diff --git a/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml b/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
> new file mode 100644
> index 000000000000..afd11c9422fa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
> @@ -0,0 +1,92 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/mctp-i2c-controller.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MCTP I2C transport binding
> +
> +maintainers:
> +  - Matt Johnston <matt@codeconstruct.com.au>
> +
> +description: |
> +  An mctp-i2c-controller defines a local MCTP endpoint on an I2C controller.
> +  MCTP I2C is specified by DMTF DSP0237.
> +
> +  An mctp-i2c-controller must be attached to an I2C adapter which supports
> +  slave functionality. I2C busses (either directly or as subordinate mux
> +  busses) are attached to the mctp-i2c-controller with a 'mctp-controller'
> +  property on each used bus. Each mctp-controller I2C bus will be presented
> +  to the host system as a separate MCTP I2C instance.
> +
> +properties:
> +  compatible:
> +    const: mctp-i2c-controller
> +
> +  reg:
> +    minimum: 0x40000000
> +    maximum: 0x4000007f
> +    description: |
> +      7 bit I2C address of the local endpoint.
> +      I2C_OWN_SLAVE_ADDRESS (1<<30) flag must be set.
> +
> +additionalProperties: false
> +
> +required:
> +  - compatible
> +  - reg
> +
> +examples:
> +  - |
> +    // Basic case of a single I2C bus
> +    #include <dt-bindings/i2c/i2c.h>
> +
> +    i2c {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      mctp-controller;
> +
> +      mctp@30 {
> +        compatible = "mctp-i2c-controller";
> +        reg = <(0x30 | I2C_OWN_SLAVE_ADDRESS)>;
> +      };
> +    };
> +
> +  - |
> +    // Mux topology with multiple MCTP-handling busses under
> +    // a single mctp-i2c-controller.
> +    // i2c1 and i2c6 can have MCTP devices, i2c5 does not.
> +    #include <dt-bindings/i2c/i2c.h>
> +
> +    i2c1: i2c {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      mctp-controller;
> +
> +      mctp@50 {
> +        compatible = "mctp-i2c-controller";
> +        reg = <(0x50 | I2C_OWN_SLAVE_ADDRESS)>;
> +      };
> +    };
> +
> +    i2c-mux {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      i2c-parent = <&i2c1>;
> +
> +      i2c5: i2c@0 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        reg = <0>;
> +        eeprom@33 {
> +          reg = <0x33>;
> +        };
> +      };
> +
> +      i2c6: i2c@1 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        reg = <1>;
> +        mctp-controller;
> +      };
> +    };
> --
> 2.32.0
>
