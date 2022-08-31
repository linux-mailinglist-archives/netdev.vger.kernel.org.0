Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3359F5A780A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 09:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiHaHsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 03:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiHaHsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 03:48:15 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ED6BD2B5
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:48:08 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p16so763083lfd.6
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=dKwUKqyzx080nN57Qu5BhT7GLES0nR5U2OgHxHW4Ezc=;
        b=hl+Q4cmXAGv7OYDv7Qj4tlRkQxNyddYi7q/ngGx6bFSaSmRkwN8dzwSW4eHO1bmuMz
         rWZy0ESlGPkMAq5eBjIM0vStrCffAA+R8fglShdYfdQOHeLNKGYTGWc7Tn0lx8Io6P7X
         xh9WAQENzFmSOsHgXxLrbbuCdch4X+kgvlOsnuBrCgIxI7F+mZVDF8tNXshH72d9Bb8y
         ya7lHgqxS2tp6N/5Xs1JL3m43Kx+yN+7KzEt3F0/3vVshghTe8Zd3UioB47XVNHbDRwL
         9zIcTkhtBNqxbnhw9FnKggmt3vkfG1DjhWyOpwRHJ5I1Z4hs8kNgVH5i+lTVX+0pPP9y
         rzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=dKwUKqyzx080nN57Qu5BhT7GLES0nR5U2OgHxHW4Ezc=;
        b=gZILjOTr4VG5vKaIhqNgMseSal//NzsfZLxUZsFCq0EtXmVqXgWqcsJGU7IKQdTGV1
         u6qZl1h8YvX/o0YZtHbD+5htbSgfFX4qI4O/giR6yQjZlFaofR2oDFR2pAQXAIyA2E7Y
         27CTEzORKR7u7uP7OtU/xVSdZKa7U9xg06vcSxdh6AaoaLThhaSzOBs4b6uMyRfWR6tT
         JKBVPz/OrXD0I6sohtGzg8/a972nJaHjoHVJFKuXrYJ4huD3BmjjB0Si2xd4w5qEPdIb
         91wcerClKRNFNnCGAmdVanYqpHVvcXqQwWmK+7A4T10uBb+LCeTN/WuSrKswaih20G77
         UBpA==
X-Gm-Message-State: ACgBeo3kE+gRT3Qvo5ESjKB9YCdpjNW5ATxSkz2zxsEIVeQVj3nAUfYa
        4d1ZujUaSG1DDk1gpMe76pcBCg==
X-Google-Smtp-Source: AA6agR4W/w1pRyESLXYMtdHVCoA4b3PCovSoib0WzKVz2vuHkr+YlwYeMrToBxLCSTYKQ/8NWcUGKA==
X-Received: by 2002:a05:6512:33d3:b0:494:6e1c:f870 with SMTP id d19-20020a05651233d300b004946e1cf870mr3854026lfg.196.1661932087047;
        Wed, 31 Aug 2022 00:48:07 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id l19-20020a2e9093000000b0025d5eb5dde7sm1937279ljg.104.2022.08.31.00.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 00:48:06 -0700 (PDT)
Message-ID: <8995b1ce-e236-1272-39d6-2dd498aafb38@linaro.org>
Date:   Wed, 31 Aug 2022 10:48:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v1 00/14] nvmem: core: introduce NVMEM layouts
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
References: <20220825214423.903672-1-michael@walle.cc>
 <768ff63a-54f5-9cde-e888-206cdf018df3@milecki.pl>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <768ff63a-54f5-9cde-e888-206cdf018df3@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/08/2022 18:05, Rafał Miłecki wrote:
> On 25.08.2022 23:44, Michael Walle wrote:
>> This is now the third attempt to fetch the MAC addresses from the VPD
>> for the Kontron sl28 boards. Previous discussions can be found here:
>> https://lore.kernel.org/lkml/20211228142549.1275412-1-michael@walle.cc/
>>
>>
>> NVMEM cells are typically added by board code or by the devicetree. But
>> as the cells get more complex, there is (valid) push back from the
>> devicetree maintainers to not put that handling in the devicetree.
> 
> I dropped the ball waiting for Rob's reponse in the
> [PATCH 0/2] dt-bindings: nvmem: support describing cells
> https://lore.kernel.org/linux-arm-kernel/0b7b8f7ea6569f79524aea1a3d783665@walle.cc/T/
> 
> Before we go any further can we have a clear answer from Rob (or
> Krzysztof now too?):
> 
> 
> Is there any point in having bindings like:
> 
> compatible = "mac-address";
> 
> for NVMEM cells nodes? So systems (Linux, U-Boot) can handle them in a
> more generic way?

I think Rob is already in the subject, but I wonder how would that work
for U-Boot? You might have multiple cards, so how does this matching
would work? IOW, what problem would it solve comparing to existing
solution (alias to ethernet device with mac-address field)?

Best regards,
Krzysztof
