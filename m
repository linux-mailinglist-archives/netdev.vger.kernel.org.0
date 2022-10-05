Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BDF5F5096
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 10:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJEIDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 04:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJEIDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 04:03:12 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A9D32BBF
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 01:03:10 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id bp15so10972962lfb.13
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 01:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=vrT3/YNDGxNw6gcf7qbdcYUNYzCckFpq+zk+UqS9mFk=;
        b=WsS0OdFvsJAy0ro0nxL688BEJuU3JmND8E16jFH22cGfbaf1AIWMoz6EkYxWN6iQSM
         5hxEPcrf3BoFRh1Sldd+jZXMIRJDlBjO+j4+qaTzpD6eXvtlyFwbN6R4Ut2D2qejgda0
         NX75xIlfVDxNMH73MYHk0lG4A9Oh6meZAXZes5Gq0blZVZgJkRWXzQM1B/HfARfQ2QVh
         RgMwtRhBzhhKwQpteVES8vHyXiVwRUaxFxCoTgzW0JIXizq04G06HcicCgqvG9pUhtUp
         7W+h1v/gEaRgja1RD4+46f8926lEH2o68CKx54Fd4lo05LmTwY2rSb/vvYcSFhaW/6lb
         PhVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=vrT3/YNDGxNw6gcf7qbdcYUNYzCckFpq+zk+UqS9mFk=;
        b=dr4EDWmjQETmg3okmHRoXT8urhDwAC3WfmqWFPXcofVfRvA3lds4cC1RkI/TW6RymN
         o0rdjr9CKYS4aZBPNz7SncS9xJgtlksCtO9PWHRZxPTxqq0QG78+hx5lsYyTPpeZcYru
         BbCAGGilWQG1pSUqwWCLNt/MXKECZoz/TOEq+WURli0T/mbIyFH2aeZcOnOuI8AzkPuR
         cYvIO0uy9AYDgLr5BOBLIOas7Vh9MZ1XU/PQuAu1wr4+BqwLWpi5wpqzQgrljI89LKNQ
         vN/KNVduwi8TxN/PY3X14Aretn6e3hVfoJsC6SQE/mPa227rGyg1jy5hMbu72OZVy5Fn
         X5/w==
X-Gm-Message-State: ACrzQf0eqO5O2pxBm0JdFxOCw8Vdf5MXis/+ONfSr3ptNE8+/1s04KGo
        C9cVaIS7jakfccW9ESCG84QfAw==
X-Google-Smtp-Source: AMsMyM7h1qQF7FFgnsGNplK/Yx7DQ4hYKkUv4Jvk1LXPHxhH+pHuufq529Adf1oaJhGaPYd8oEx6jQ==
X-Received: by 2002:a05:6512:3185:b0:4a2:3e01:e1fc with SMTP id i5-20020a056512318500b004a23e01e1fcmr4639658lfe.404.1664956988657;
        Wed, 05 Oct 2022 01:03:08 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id g19-20020ac25393000000b0049fb08e91cesm2259763lfh.214.2022.10.05.01.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 01:03:08 -0700 (PDT)
Message-ID: <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
Date:   Wed, 5 Oct 2022 10:03:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <YzzLCYHmTcrHbZcH@colin-ia-desktop>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YzzLCYHmTcrHbZcH@colin-ia-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2022 02:08, Colin Foster wrote:
> Hi Krzysztof,
> 
> On Tue, Oct 04, 2022 at 01:19:33PM +0200, Krzysztof Kozlowski wrote:
>> On 26/09/2022 02:29, Colin Foster wrote:
>>> The ocelot-ext driver is another sub-device of the Ocelot / Felix driver
>>> system, which currently supports the four internal copper phys.
>>>
>>> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ...
>>> +  # Ocelot-ext VSC7512
>>> +  - |
>>> +    spi {
>>> +        soc@0 {
>>
>> soc in spi is a bit confusing.
>>
>> Does it even pass the tests? You have unit address but no reg.
> 
> I omitted those from the documentation. Rob's bot is usually quick to
> alert me when I forgot to run dt_binding_check and something fails
> though. I'll double check, but I thought everything passed.
> 
>>
>>> +            compatible = "mscc,vsc7512";
>>
>>
>>> +            #address-cells = <1>;
>>> +            #size-cells = <1>;
>>> +
>>> +            ethernet-switch@0 {
>>> +                compatible = "mscc,vsc7512-switch";
>>> +                reg = <0 0>;
>>
>> 0 is the address on which soc bus?
> 
> This one Vladimir brought up as well. The MIPS cousin of this chip
> is the VSC7514. They have exactly (or almost exactly) the same hardware,
> except the 7514 has an internal MIPS while the 7512 has an 8051.
> 
> Both chips can be controlled externally via SPI or PCIe. This is adding
> control for the chip via SPI.
> 
> For the 7514, you can see there's an array of 20 register ranges that
> all get mmap'd to 20 different regmaps.
> 
> (Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml)
> 
>     switch@1010000 {
>       compatible = "mscc,vsc7514-switch";
>       reg = <0x1010000 0x10000>,
>             <0x1030000 0x10000>,
>             <0x1080000 0x100>,
>             <0x10e0000 0x10000>,
>             <0x11e0000 0x100>,
>             <0x11f0000 0x100>,
>             <0x1200000 0x100>,
>             <0x1210000 0x100>,
>             <0x1220000 0x100>,
>             <0x1230000 0x100>,
>             <0x1240000 0x100>,
>             <0x1250000 0x100>,
>             <0x1260000 0x100>,
>             <0x1270000 0x100>,
>             <0x1280000 0x100>,
>             <0x1800000 0x80000>,
>             <0x1880000 0x10000>,
>             <0x1040000 0x10000>,
>             <0x1050000 0x10000>,
>             <0x1060000 0x10000>,
>             <0x1a0 0x1c4>;
>       reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
>             "port2", "port3", "port4", "port5", "port6",
>             "port7", "port8", "port9", "port10", "qsys",
>             "ana", "s0", "s1", "s2", "fdma";
> 
> 
> The suggestion was to keep the device trees of the 7512 and 7514 as
> similar as possible, so this will essentially become:
>     switch@71010000 {
>       compatible = "mscc,vsc7512-switch";
>       reg = <0x71010000 0x10000>,
>             <0x71030000 0x10000>,
>       ...

I don't understand how your answer relates to "reg=<0 0>;". How is it
going to become 0x71010000 if there is no other reg/ranges set in parent
nodes. The node has only one IO address, but you say the switch has 20
addresses...

Are we talking about same hardware?

Best regards,
Krzysztof

