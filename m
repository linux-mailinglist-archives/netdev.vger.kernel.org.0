Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB576D2923
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 22:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbjCaUJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 16:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjCaUJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 16:09:30 -0400
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA6821A8E;
        Fri, 31 Mar 2023 13:09:24 -0700 (PDT)
Received: by mail-oi1-f175.google.com with SMTP id w13so6173891oik.2;
        Fri, 31 Mar 2023 13:09:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680293364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPkpKFxk7BcOpgUzJha9+qhAMS2yt0UsXgxPanJmeeY=;
        b=t3/ZYXkRBRznCSyV2h7lSIl9/GFG0cskiooUOZlzkDUalq7T6tDwYov1wwIDnvaSbo
         zqHDrVllyBVLj2+IatjCnzz61aEsGGNIwqC3lcwbuq0OIXdqaGt0Fehw3uNiVix619Co
         pwL99kFu+VdXa55ML+pKG2/yl72wk339YuXM5LBqhYyo+dXdVqrNBsRSIbaMnRT1AJvl
         oWVYMwyMsjAODn8G1YLWSr2IvHiN/TV3WWYzcXtNe6bJLdOoBCHU9KK7Q2VoAZkhA/ch
         cM4UGAMX2EF0EkCIk74XnFcoNG1CNDrH9gJYq/rHrqsEz/eXJiOUQD/BR173h1TNzhmV
         7Sqg==
X-Gm-Message-State: AAQBX9eLd92E7Dwtm8+G11mhX48CW2aJIcN1q+AQxhv8K3dDy42UdLTP
        UNtToaeOy6mtLKsINeCvpA==
X-Google-Smtp-Source: AKy350ZNGbtu+wZO9GEFh09+Q8jTGjD4N+L1g95Cjk+YUOMacEt1LSoNV3wAfsJboJEXfnqNLSWQmw==
X-Received: by 2002:a05:6808:208a:b0:389:8075:4c0b with SMTP id s10-20020a056808208a00b0038980754c0bmr1936699oiw.1.1680293363988;
        Fri, 31 Mar 2023 13:09:23 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c5-20020a4aacc5000000b00524f381f681sm1203954oon.27.2023.03.31.13.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 13:09:23 -0700 (PDT)
Received: (nullmailer pid 2156389 invoked by uid 1000);
        Fri, 31 Mar 2023 20:09:22 -0000
Date:   Fri, 31 Mar 2023 15:09:22 -0500
From:   Rob Herring <robh@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 10/16] dt-bindings: leds: Document support
 for generic ethernet LEDs
Message-ID: <20230331200922.GA2123749-robh@kernel.org>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327141031.11904-11-ansuelsmth@gmail.com>
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 04:10:25PM +0200, Christian Marangi wrote:
> Add documentation for support of generic ethernet LEDs.
> These LEDs are ethernet port LED and are controllable by the ethernet
> controller or the ethernet PHY.
> 
> A port may expose multiple LEDs and reg is used to provide an index to
> differentiate them.
> Ethernet port LEDs follow generic LED implementation.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../bindings/leds/leds-ethernet.yaml          | 76 +++++++++++++++++++
>  1 file changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/leds-ethernet.yaml
> 
> diff --git a/Documentation/devicetree/bindings/leds/leds-ethernet.yaml b/Documentation/devicetree/bindings/leds/leds-ethernet.yaml
> new file mode 100644
> index 000000000000..0a03d65beea0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/leds-ethernet.yaml
> @@ -0,0 +1,76 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/leds/leds-ethernet.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Common properties for the ethernet port LED.
> +
> +maintainers:
> +  - Christian Marangi <ansuelsmth@gmail.com>
> +
> +description:
> +  Bindings for the LEDs present in ethernet port and controllable by
> +  the ethernet controller or the ethernet PHY regs.
> +
> +  These LEDs provide the same feature of a normal LED and follow
> +  the same LED definitions.
> +
> +  An ethernet port may expose multiple LEDs, reg binding is used to
> +  differentiate them.
> +
> +properties:
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 0
> +
> +patternProperties:
> +  '^led@[a-f0-9]+$':
> +    $ref: /schemas/leds/common.yaml#
> +
> +    properties:
> +      reg:
> +        maxItems: 1
> +        description:
> +          This define the LED index in the PHY or the MAC. It's really
> +          driver dependent and required for ports that define multiple
> +          LED for the same port.
> +
> +    required:
> +      - reg
> +
> +    unevaluatedProperties: false

This does nothing to help the issues I raised. If the 'led' nodes have 
custom properties, then you need a schema for the 'led' nodes and just 
the 'led' nodes. Not a schema for the 'leds' container node.

If your not going to allow extending, then this can all be 1 file like 
you had (with unevaluatedProperties added of course).

Rob
