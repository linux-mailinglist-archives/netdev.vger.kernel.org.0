Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3490A6C3CB0
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCUV3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjCUV3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:29:53 -0400
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5618F58C1D;
        Tue, 21 Mar 2023 14:29:29 -0700 (PDT)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-17ab3a48158so17654123fac.1;
        Tue, 21 Mar 2023 14:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679434156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbvd4MiQ0n3ACh48MQO9r1tkLfqb32ZNN6Ei0TVQKuw=;
        b=L9r1i3nP+1kvNq2srHTRGtcfhkgYmPk6bDiVskmyjCnkl+y8d3SmW5f588dLYBFnPM
         Si2iQZ/1OisIStL5hMrkEEBXaYw3LopvVTVKgQpix10hzjCYCJ1KM1C1Nvpw++e92xek
         XHd0ILZK++31lqP50PMcvGL0xbw7096j073F4sAmChCLOPiRnxQZFWBws/9/gVl+tPcx
         Fr1OYMsKq28pXWxYsO+RtOe/TRyX6hey43ytY0JsLKME5HExK/If9SiyyDjDxhsthTjy
         Nj3diSQ3s4rTyFSQ7MPajAq6Zsi+SKEw9RVloIZbqGUQHdm7y069qfbJIsI84aTC9GOC
         L0pQ==
X-Gm-Message-State: AO0yUKUmceRvLuTRmSKYQiwxhgNOyTSCvo2M+6hNApPVYV8/YWTZVpsb
        mwBPGmfKhampM1yOvOes/w==
X-Google-Smtp-Source: AK7set/cV9nJfnT/jPDxwqQ4IPuH0ACvO2AqQ3rqNFYXe8V5KcrSmIpHMlh6/MlcBjbGmGOoWQpXKg==
X-Received: by 2002:a05:6870:3313:b0:177:956c:36d5 with SMTP id x19-20020a056870331300b00177956c36d5mr281386oae.29.1679434154637;
        Tue, 21 Mar 2023 14:29:14 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id ta10-20020a056871868a00b0017197629658sm4595013oab.56.2023.03.21.14.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:29:14 -0700 (PDT)
Received: (nullmailer pid 1645135 invoked by uid 1000);
        Tue, 21 Mar 2023 21:29:13 -0000
Date:   Tue, 21 Mar 2023 16:29:13 -0500
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
Subject: Re: [net-next PATCH v5 14/15] dt-bindings: net: phy: Document
 support for LEDs node
Message-ID: <20230321212913.GA1643897-robh@kernel.org>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-15-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-15-ansuelsmth@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 08:18:13PM +0100, Christian Marangi wrote:
> Document support for LEDs node in phy and add an example for it.
> PHY LED will have to match led pattern and should be treated as a
> generic led.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  .../devicetree/bindings/net/ethernet-phy.yaml | 31 +++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 1327b81f15a2..84e15cee27c7 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -197,6 +197,22 @@ properties:
>        PHY's that have configurable TX internal delays. If this property is
>        present then the PHY applies the TX delay.
>  
> +  leds:
> +    type: object
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

Same questions/issues in this one.
