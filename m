Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D84B5521B0
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243562AbiFTP5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243351AbiFTP5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:57:04 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DF31DA68
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:57:03 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id o10so15746164edi.1
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BLJok6X/XP9rRP7OVZBxo2FoWIuF2yxnMwl8P3cexO4=;
        b=Xt7y5Qe7+Wa7yYibcVvdOfwMtbLwRTN0Zq/M6R55v21ht1WGi/IPChYQ+SvJSe5Brc
         B6UA+MJObyH2Fm+8VXqwNRvg1mfurkHWqw8Xbq8NPqQmqVIqnya1L4ZahflvmPBtyeXD
         VR938s9+lVuSDM/XmiZewPLFp4twSGcwligcvSmIjjVgtuPVp18bhkKjkYllVesSTaZs
         Jp3PInwjuiJ6YQT3OjVPWlrCjvSeG8i4XyiMH2ryEGFTehrTgAEF1eroWKXB3auLr8r4
         rBXbBgtscJ94JK8zvmoHlBJtsNtdaiYDWxMtwmVzVyGytdzcjzV4nZS7ol/DknUXGzjx
         5TxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BLJok6X/XP9rRP7OVZBxo2FoWIuF2yxnMwl8P3cexO4=;
        b=vtCUp29/7bwVMjTGl5HZbbClz22GUrLFsc9FMyNZicbbGG0rbABdzK3dzcCuuq4pPF
         4OiHfhajNkds5mCyEhH2iEvgtxxUjokUoDr8F9sNOWdqFKtrm4o1AbakSYrL7fzgw9Lv
         BKWoC6fl9SoyN8cAfTb0jzMPVxS0P/TaIEKdU1jEFn8oW/Nead5BBT78lIyhvYeG3vNV
         Yzu78MX1tu6UkTwgFPU94QE6XUiDLU0W52yyEAa783CMj39PBj9TW8GWoW7klnV+A1dB
         lpns34UykQGtaZyxSMSZTZc/Bq+wr6usjrL3Sbz4R2kOmVfkRxxxaRX6mSQxA5R3jqjl
         Rd8g==
X-Gm-Message-State: AJIora++FZqV2ymqCD6l/sB4lWOrBNY4lvhlHb4WV49RM7G07g4DFe0p
        elI6ZiDeYtqeX6WD3u+IyAiR5A==
X-Google-Smtp-Source: AGRyM1vB4w9kMQvsDMIwngcwm/lZJao/j8ndNodHf3Z/j1CnWv4Tx74ZUtC1ToZcNlh2DUsmeckxOQ==
X-Received: by 2002:a05:6402:5c8:b0:433:545f:a811 with SMTP id n8-20020a05640205c800b00433545fa811mr30285866edx.101.1655740622007;
        Mon, 20 Jun 2022 08:57:02 -0700 (PDT)
Received: from [192.168.0.210] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id e1-20020a056402148100b004357171dcccsm5866342edv.12.2022.06.20.08.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 08:57:01 -0700 (PDT)
Message-ID: <bc3268e1-2a6e-8faf-3d3b-a8841569a42f@linaro.org>
Date:   Mon, 20 Jun 2022 17:57:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] dt-bindings: net: broadcom-bluetooth: Add CYW55572 DT
 binding
Content-Language: en-US
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
References: <cover.1655723462.git.hakan.jansson@infineon.com>
 <acd9e85b1ba82875e83ca68ae2aa62d828bfdfa3.1655723462.git.hakan.jansson@infineon.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <acd9e85b1ba82875e83ca68ae2aa62d828bfdfa3.1655723462.git.hakan.jansson@infineon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/06/2022 14:01, Hakan Jansson wrote:
> CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.
> Extend the binding with its DT compatible.
> 
> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
> ---
>  Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
