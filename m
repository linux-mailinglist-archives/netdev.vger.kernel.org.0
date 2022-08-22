Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D41059C6F3
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbiHVSqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237859AbiHVSph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:45:37 -0400
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1507BE34;
        Mon, 22 Aug 2022 11:45:36 -0700 (PDT)
Received: by mail-oi1-f176.google.com with SMTP id n124so2321663oih.7;
        Mon, 22 Aug 2022 11:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=dujWxXaizLrdJpI5Emw3zNNDDzfgbdfCL73RMlhbdPc=;
        b=Q0pvqIW1VByR9+Cl1eh/YxBuaiW0Pvw0AB6fQ5YgpjpuZTBqYJaahUPcWZE6IQr2US
         //WsiHTiP9QltzAl/pdjNemDkC4vHL2XY8+pjlUz6dDaTMbnfoeZzHIjEQkmH26qjMT3
         4lN9VXDt/dyIURgrLfXWmPITj48f+SOY4y8Kp10+WVTPo8U3HFXnEZmXCiTVIw/YCBR5
         p+AwtmIfkCIh2ugeVX9xRiFBODKlDJ9dVBQPRw4ZcbNjKcwTPjSeFvqXLDujM7VG8Qh4
         4m4yzItA4kuaUsTABRRoehTEHrV82AlPF2houz/V+SPRVxKJE5bom3Kit/boLSeFrjyi
         BGJg==
X-Gm-Message-State: ACgBeo11hOnQ0YdKscsR6Gwy5mq6t2ONBsiXU81+xfr07dBizY3mM3DX
        V1a525ANIis4hNkGknuQZA==
X-Google-Smtp-Source: AA6agR5yCq25WIzFIKTaVSIC/8lvH+6BZQftwagFI6UVQNXCCniOtIXtLzDO5UOO9HMDJWlZVQLtZg==
X-Received: by 2002:a54:4899:0:b0:343:3f7c:713d with SMTP id r25-20020a544899000000b003433f7c713dmr9445519oic.116.1661193936067;
        Mon, 22 Aug 2022 11:45:36 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t20-20020a9d5914000000b0061cbd18bd18sm3154205oth.45.2022.08.22.11.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 11:45:35 -0700 (PDT)
Received: (nullmailer pid 146269 invoked by uid 1000);
        Mon, 22 Aug 2022 18:45:34 -0000
Date:   Mon, 22 Aug 2022 13:45:34 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 2/7] dt-bindings: net: phy: add PoDL PSE
 property
Message-ID: <20220822184534.GB113650-robh@kernel.org>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819120109.3857571-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 02:01:04PM +0200, Oleksij Rempel wrote:
> Add property to reference node representing a PoDL Power Sourcing Equipment.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index ed1415a4381f2..49c74e177c788 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -144,6 +144,12 @@ properties:
>        Mark the corresponding energy efficient ethernet mode as
>        broken and request the ethernet to stop advertising it.
>  
> +  ieee802.3-podl-pse:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Specifies a reference to a node representing a Power over Data Lines
> +      Power Sourcing Equipment.

Ah, here is the consumer.

Why do you anything more than just a -supply property here for the 
PoE/PoDL supply? The only reason I see is you happen to want a separate 
driver for this and a separate node happens to be a convenient way to 
instantiate drivers in Linux. Convince me otherwise.

Rob
