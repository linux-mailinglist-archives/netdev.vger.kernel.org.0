Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40E75AD2D2
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbiIEMe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 08:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbiIEMeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 08:34:22 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4828D55089
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 05:27:52 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id k18so9039998lji.13
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 05:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=VjT77Y8+HEIuNnjusk1YftNIVA1QWJZI3Mf5HLrrrls=;
        b=i3oFSwWW81UGXG0vxzOX1hV6+X74ouF8oVIDzczn3fjuwfzDMtGdzsTwCry4yHZ9Uf
         cQWfJyt1YUcXiVJJDT6c7Dv6waLUiJN/6Gf9BSkUJ9NSqsXBNh9//u4rpCViELfa1F2e
         pxn02clW9d+O/XCwTj5dvCViS67Rzyt+lAbz72kKenXKc043PamA+BmPfHnui2uFe+n0
         JS9CLPofidCxHzuhFmCjoeFVCLRHUgLs7OUG8Q5l1zZXIKkkOKz/l1Gex4swGpAgksJW
         Kv9d4DtQUPWSv1lXK6vn1c86I87eIhaJO/ITd1h227fbsHSu+qkS/ULetod9qi0jz6ze
         BHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=VjT77Y8+HEIuNnjusk1YftNIVA1QWJZI3Mf5HLrrrls=;
        b=IwH6FMqp/o0iGKgNPDuex8An+B0raW2ep6RriThnvywlNgdAtBLt+7vZ/LC88+Vmz0
         7uUfOypMLeTwDlHSB9Sm+whQTibW0KJt2FcsV/DmyEKZ1AxnPcOCwOjl8tpufpn0fP9y
         vwUgzTCWalMA6pzck0g0A5O+6PmBz0bR1OovJ1qZHdMS2WkHlLOhYx/x4JonfkhdqXlq
         WC2R+7DHPX79hqBiItV5DBa4Xw3C2kS6Q/5K0Ja1hp1gvnwgfFIcJVBqdz3GclLUzZ2Q
         U9QgJF8PH4gughKCfx5Dea/L0DZ9VjZ2JxMPIx/7f0HWu3jKdLS45VSIxMPDKqt3YhFS
         yE0Q==
X-Gm-Message-State: ACgBeo0rz/L4r/Pdg9wNbx6JkAL4W5FMVbpcFUE9TauitsQn4Q2GPhEb
        LMAAvHqct1rF4SnFDapF5oVW0Q==
X-Google-Smtp-Source: AA6agR7veY/y2QHPF3TywjCqgZpMb5Y9lO1EP2k3n/xbHw+CDZpSB1UqQoWqHbDb+EAofuD7w1fyGA==
X-Received: by 2002:a05:651c:178d:b0:261:bd23:a5f8 with SMTP id bn13-20020a05651c178d00b00261bd23a5f8mr13588955ljb.411.1662380871019;
        Mon, 05 Sep 2022 05:27:51 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id be11-20020a05651c170b00b00261800f0e02sm1397822ljb.26.2022.09.05.05.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 05:27:50 -0700 (PDT)
Message-ID: <1c69c2b7-dc9c-f3e2-796c-0310b94b1ff7@linaro.org>
Date:   Mon, 5 Sep 2022 14:27:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v4 1/5] dt-bindings: net: Convert Altera TSE
 bindings to yaml
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
References: <20220902083205.483438-1-maxime.chevallier@bootlin.com>
 <20220902083205.483438-2-maxime.chevallier@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220902083205.483438-2-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/09/2022 10:32, Maxime Chevallier wrote:
> Convert the bindings for the Altera Triple-Speed Ethernet to yaml.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Your messages ended up in spam:
DMARC:	'FAIL'
dmarc=fail (p=REJECT sp=REJECT dis=QUARANTINE) header.from=bootlin.com

> ---
> V3->V4 : No changes
> V2->V3:
>  - Moved allOf below required
>  - Removed unnedded reg/reg-names in the properties section
>  - Removed stray minItems
> 
> V1->V2:
>  - Removed unnedded maxItems
>  - Added missing minItems
>  - Fixed typos in some properties names
>  - Fixed the mdio subnode definition

The patchset was applied without waiting for DT maintainers review, so
not much to do here for me...


Best regards,
Krzysztof
