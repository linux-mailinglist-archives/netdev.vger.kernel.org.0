Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F285F8C28
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 17:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiJIP6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 11:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJIP6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 11:58:40 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC73429C9E
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 08:58:37 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id z8so856887qtv.5
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 08:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5orZ+DziI6W/f9HXFXiv87iJt/PGMb8hqSKXkaX84tc=;
        b=pDtyOlPFSEP4qgQu4T4B0J+N6vslW87IBxWwnSCJRaYWRvfrQl5xZPlP4qHbqI5jJp
         ++g8/YCyJypk9U66/2nV0jQB0MMElG/FkqptlK3x99XpNe8FW9Wrala+Ev0qYtfT29Ae
         pRzIs1KyCR/MJgtSbhTgIv5K0riCp3V3pMdrvy/vGk74qtvoHkA7Ke9rTMB1FpVRg4kW
         6FhAye5EgQ6RRP9+lOuzdIDSEq1AVJk5UB3xetdC4AJVOed9vNA93bDWzziliEMjYdB8
         szjXCvJDTVirSdRcOvDdqYa2KPepL3HWpcL5mvdf7JSunRyJuL/THL2rSC1U9kGQJW3i
         Pgeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5orZ+DziI6W/f9HXFXiv87iJt/PGMb8hqSKXkaX84tc=;
        b=GuBxsQ4Z4EARR43DyoYC491OGvo1NYsPyeRoSQ6kV7ryz9qA4wgzsnejNve6PhvTg6
         B0zLhviRGiNV4WXvKmeK0KxP8NYLKk/aQ809mSsimInC36z2KOUQ5io91ATCKpG/K7SJ
         7puI+IVOfFE7kh6PPDlzjnj/7jZ/v3qKxZTxZZ84Z9L4cKGQMb1ZZ9qIjvcYBhIHwPHL
         YObxqK2rMydC2Y2cp8mfOphIwNMhMsE4tM8PLSCAMzGP1UnvdZcsc9QK5bn7eOnD/oc8
         8xf/4DUTp5e28V6k0fBNivW0wgEX90CtEpO+duI35vcaztWrj7CK49k3Vi1FWB+PCYF8
         R33w==
X-Gm-Message-State: ACrzQf0bJOinJLMXANup4J2Q1Z4kMKCENHznrd8K4+BhNueWGfGN45VR
        vIW/WdpSBTzrkIwkvfMiC5vzPw==
X-Google-Smtp-Source: AMsMyM61dS16RMHrOhhdFqzjMyzmt/ixs7MQZED+RHxiW4UwQ7zvJ3sbsnu7g9hRJd8ZSKgz/1GIeA==
X-Received: by 2002:ac8:5a16:0:b0:391:8800:a78e with SMTP id n22-20020ac85a16000000b003918800a78emr11937707qta.273.1665331117127;
        Sun, 09 Oct 2022 08:58:37 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a0bcd00b006b95b0a714esm8064135qki.17.2022.10.09.08.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Oct 2022 08:58:36 -0700 (PDT)
Message-ID: <97f77164-264b-68e3-3d77-1a5ed1d44d34@linaro.org>
Date:   Sun, 9 Oct 2022 17:58:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [RFC v4 net-next 15/17] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
 <20221008185152.2411007-16-colin.foster@in-advantage.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221008185152.2411007-16-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/10/2022 20:51, Colin Foster wrote:
> The ocelot-ext driver is another sub-device of the Ocelot / Felix driver
> system. It requires a register array similar to the VSC7514 and has
> different ports layout than existing devices.
> 

Thank you for your patch. There is something to discuss/improve.

> @@ -54,9 +54,24 @@ description: |
>        - phy-mode = "1000base-x": on ports 0, 1, 2, 3
>        - phy-mode = "2500base-x": on ports 0, 1, 2, 3
>  
> +  VSC7512 (Ocelot-Ext):
> +
> +    The Ocelot family consists of four devices, the VSC7511, VSC7512, VSC7513,
> +    and the VSC7514. The VSC7513 and VSC7514 both have an internal MIPS
> +    processor that natively support Linux. Additionally, all four devices
> +    support control over external interfaces, SPI and PCIe. The Ocelot-Ext
> +    driver is for the external control portion.
> +
> +    The following PHY interface types are supported:
> +
> +      - phy-mode = "internal": on ports 0, 1, 2, 3
> +      - phy-mode = "sgmii": on ports 4, 5, 7, 8, 9, 10
> +      - phy-mode = "qsgmii": on ports 4, 5, 6, 7, 8, 10
> +
>  properties:
>    compatible:
>      enum:
> +      - mscc,vsc7512-switch
>        - mscc,vsc9953-switch
>        - pci1957,eef0
>  
> @@ -258,3 +273,100 @@ examples:
>              };
>          };
>      };

Blank line

> +  # Ocelot-ext VSC7512
> +  - |
> +    #include <dt-bindings/phy/phy-ocelot-serdes.h>
> +
> +    soc@0 {
> +        compatible = "mscc,vsc7512";
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +        reg = <0 0>;
> +
> +        ethernet-switch@0 {

Does not look like you tested the bindings. Please run `make
dt_binding_check` (see
Documentation/devicetree/bindings/writing-schema.rst for instructions).

Best regards,
Krzysztof

