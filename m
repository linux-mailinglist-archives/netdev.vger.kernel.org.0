Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0A96C3C8E
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCUVT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCUVT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:19:56 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD8E15CA1;
        Tue, 21 Mar 2023 14:19:55 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id s8so2293530ois.2;
        Tue, 21 Mar 2023 14:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679433595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxrm14m3oOQq155kNi7UN+pIky0d6E6e5S3ZZURwtHI=;
        b=dWYMj952ENsHTcFOvTsaDHzTeiMxmh244VuLITViqN/XsO8VXTbScAg5DBOAOTn2bN
         S/gbF+/X4NvH8Tb+U/m9N3h3KaZ7yGRr+j7tmUsZyfFpwLBr5Veu1j8p+SLkz6yF5dKD
         YSfjjlcDb13Q/rAsmOlbKZPbmrDzJwh/RMtCKghb4iLNBuPxeryyo3IymI43Tq8bkXXP
         wP9X1Swpa2Oj5XZm3liitQiE8yly2hGxKJw7cNXv+/Txw1l+9LW/INsIVI/UVltYASAb
         /QSlMW4HQwahgMOMHK+bnZigdjoOrgHUL6cn0yBP138R5V93kGKnCb9knFceFvjEh6Lz
         2kiw==
X-Gm-Message-State: AO0yUKX/LhDaX+9aestZxqrzYegh1os1QqYCyjhfsa1kM4r55DxpwozF
        qPtoAIn6le+ddd95UqVpboo/sj89wA==
X-Google-Smtp-Source: AK7set+DQD+hptyUlvhbR1ibNJoT1JdCD96NXfu6tMZkCuead4Bp4COOgVeDLZXLAO1gyQwMEitUBw==
X-Received: by 2002:aca:a90f:0:b0:386:9e54:aac3 with SMTP id s15-20020acaa90f000000b003869e54aac3mr271068oie.32.1679433594715;
        Tue, 21 Mar 2023 14:19:54 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q204-20020a4a33d5000000b0053853156b5csm5117406ooq.8.2023.03.21.14.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:19:54 -0700 (PDT)
Received: (nullmailer pid 1635108 invoked by uid 1000);
        Tue, 21 Mar 2023 21:19:53 -0000
Date:   Tue, 21 Mar 2023 16:19:53 -0500
From:   Rob Herring <robh@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 10/15] dt-bindings: net: ethernet-controller:
 Document support for LEDs node
Message-ID: <20230321211953.GA1544549-robh@kernel.org>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-11-ansuelsmth@gmail.com>
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 08:18:09PM +0100, Christian Marangi wrote:
> Document support for LEDs node in ethernet-controller.
> Ethernet Controller may support different LEDs that can be configured
> for different operation like blinking on traffic event or port link.
> 
> Also add some Documentation to describe the difference of these nodes
> compared to PHY LEDs, since ethernet-controller LEDs are controllable
> by the ethernet controller regs and the possible intergated PHY doesn't
> have control on them.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../bindings/net/ethernet-controller.yaml     | 21 +++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 00be387984ac..a93673592314 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -222,6 +222,27 @@ properties:
>          required:
>            - speed
>  
> +  leds:
> +    type: object
> +    description:
> +      Describes the LEDs associated by Ethernet Controller.
> +      These LEDs are not integrated in the PHY and PHY doesn't have any
> +      control on them. Ethernet Controller regs are used to control
> +      these defined LEDs.
> +
> +    properties:
> +      '#address-cells':
> +        const: 1
> +
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      '^led(@[a-f0-9]+)?$':
> +        $ref: /schemas/leds/common.yaml#

Are specific ethernet controllers allowed to add their own properties in 
led nodes? If so, this doesn't work. As-is, this allows any other 
properties. You need 'unevaluatedProperties: false' here to prevent 
that. But then no one can add properties. If you want to support that, 
then you need this to be a separate schema that devices can optionally 
include if they don't extend the properties, and then devices that 
extend the binding would essentially have the above with:

$ref: /schemas/leds/common.yaml#
unevaluatedProperties: false
properties:
  a-custom-device-prop: ...


If you wanted to define both common ethernet LED properties and 
device specific properties, then you'd need to replace leds/common.yaml 
above  with the ethernet one.

This is all the same reasons the DSA/switch stuff and graph bindings are 
structured the way they are.

Rob
