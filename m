Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4F0654DA4
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 09:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiLWIoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 03:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiLWIoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 03:44:20 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDFD357B0
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 00:44:18 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id b13so6279553lfo.3
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 00:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AArFLCEhAcZ7aY9j7CjYYD/RhgyRJ7pvXAeQ/FnQ75Y=;
        b=eBF3BGTPcoT/0eJGmMhItnGGKcsooDojeM3nnRuVpnsDsgkNYY0RmD1psNp63Qbve5
         jaM7OBgI3SVY+eTzqURbWT/1tr/Ii16vNOGJzPMbwgK3GxAmQItnoIc834ybIeOaU8N8
         Q2e/pjpBov0SbnBGZgkEcNmInsdUe15FCyFb15zmdDEn4YZ84W/zwLpwb95/5DMf7f/t
         JUiHfjA3XmBdn6M+Eo8XtJJ9d5z1BR+h3evGoe1krOUUrtZhEuO9ASghnVkbKBaNqZIj
         5v2NCcTHsUSCjuaxFabtx5hrq28bi4XFV/T02zGfQyjIFanzexW0yPFWcbjUkpmmAd9X
         MNAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AArFLCEhAcZ7aY9j7CjYYD/RhgyRJ7pvXAeQ/FnQ75Y=;
        b=6kFl7YpyNmsUUQSxqFlV67QoTuQ7Hkh02eTN61RtfZTNuNRr/uswEreRbg4BEI0Uf2
         Wih6szRgUbrVR79blVNPCMZf8VYyu/53ncCQvifjheCVcVXLPepgZhAdhuNrn1N0X4HQ
         3EJDp/GRNlsZPfZ1FtHfjkV/JcHKzgxLWOIf5GwyGRj7IS77dDj7wYo3F/zGKekITAgV
         gBIs9Z6yn5d+exwOL6JMW68aBDez21irlGwaHdDJz386YSLj9uOOxhZvba/tzdgkSCxl
         9jWHDNs6QRQEkwkVQvt/KovOpSBaU38f1uUR6VFksaO0Wo3W04riIj2/ngxFU82BG457
         Ir8Q==
X-Gm-Message-State: AFqh2kp587kyK1vhxtkf3iJtFfmtDYLsqcjUZS5NYrK2fpVpWwSCRbaC
        W0+dISJFJ1KCH6ZthcmkxPVW7w==
X-Google-Smtp-Source: AMrXdXuxSz5HcL5VgwcrGUyIY0464r9l4IedVIfX89TyJMlS0hx/cbAdj5sp904mcfsFzrEr/4UmYA==
X-Received: by 2002:ac2:4250:0:b0:4b4:b5c1:77f3 with SMTP id m16-20020ac24250000000b004b4b5c177f3mr2312601lfl.16.1671785056888;
        Fri, 23 Dec 2022 00:44:16 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id q10-20020ac2514a000000b004ad5f5c2b28sm427958lfd.119.2022.12.23.00.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 00:44:16 -0800 (PST)
Message-ID: <4263dc33-0344-16b6-df22-1db9718721b1@linaro.org>
Date:   Fri, 23 Dec 2022 09:44:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Advice on MFD-style probing of DSA switch SoCs
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20221222134844.lbzyx5hz7z5n763n@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221222134844.lbzyx5hz7z5n763n@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/12/2022 14:48, Vladimir Oltean wrote:
> Hi,


(...)

> To add interrupts in a naive way, similar to how other DSA drivers have
> done it, it would have to be done like this:
> 
> #include <dt-bindings/interrupt-controller/nxp-sja1110-acu-slir.h>
> 
> 	sw2: ethernet-switch@2 {
> 		compatible = "nxp,sja1110a";
> 		reg = <2>;
> 		spi-max-frequency = <4000000>;
> 		spi-cpol;
> 		dsa,member = <0 1>;
> 
> 		slir2: interrupt-controller {
> 			compatible = "nxp,sja1110-acu-slir";
> 			interrupt-controller;
> 			#interrupt-cells = <1>;
> 			interrupt-parent = <&gpio 10>;
> 		};
> 
> 		ethernet-ports {
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 


just trim the code... we do not need to scroll over unrelated pieces.

> 		};
> 
> 		mdios {
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 
> 			mdio@0 {
> 				compatible = "nxp,sja1110-base-t1-mdio";
> 				#address-cells = <1>;
> 				#size-cells = <0>;
> 				reg = <0>;
> 
> 				sw2_port5_base_t1_phy: ethernet-phy@1 {
> 					compatible = "ethernet-phy-ieee802.3-c45";
> 					reg = <0x1>;
> 					interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY1>;
> 				};
> 

...

> 		};
> 	};
> 
> However, the irq_domain/irqchip handling code in this case will go to
> drivers/net/dsa/, and it won't really be a "driver" (there is no struct

Why? Devicetree hierarchy has nothing to do with Linux driver hierarchy
and nothing stops you from putting irqchip code in respective directory
for such DT. Your parent device can be MFD, can be same old DSA switch
driver etc. Several options.

Best regards,
Krzysztof

