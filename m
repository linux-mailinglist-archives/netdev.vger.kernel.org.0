Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B72551BBE6
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 11:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346732AbiEEJ0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 05:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352636AbiEEJ0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 05:26:02 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A3C4EDD9
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 02:22:23 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e24so5256092wrc.9
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 02:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YZkhX8VdSbRZKmQIOzgkSfpmToAIJcyGhKGvONZeKPM=;
        b=wgm3Tdzap7kkOBihTP6T0IhnT9G6Oc8Ge/5nUNlrSnTPInQoGJ98CKanFTwb6sMccZ
         9d4KCxdg9LCYphRKvE9rvwU1++xkoof4loKmHyCYfxAY0gBFhMA3oPXw7NTjEqqxyHfC
         cNwAxA8oRijMoUjff4ROoa9YilWt5ieCB4F7ZaDx7bZ5NBlRq1XEjDizZ9ItDHbBrDJw
         rdCoDCQ1En6Y5bGPfqpHlZRcg2m4vS6Y/g4KRAX51Favpx55TneHi7u6O0EF4FPDa2B0
         NZ6FEyOLhsL2fcnruWZj5H0x5LOeT1KGIGqo+XJU4paF90d6jjbgSv1wgUCBUHYfU45r
         HmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YZkhX8VdSbRZKmQIOzgkSfpmToAIJcyGhKGvONZeKPM=;
        b=lI8FDA/WhhJC/065SkwgqSIUu0UfcfMCovpOitPXezRttuC5h2AjlAJ19tiJ2vq9gH
         7ykpAZT2TtMN0xAJVu1bGyqx0MvZS3v9OI2V4syRE8JWRy4EMudeg7P+Psjr/ifzyPUO
         aEiaAuGFnrFfuA1mlu+8tMLo8YhNDaOKWUFZS/6WX1KhZFVwrF0tLJUNlU2ykwCDKc5b
         N2AGnhyzX8ktvwfm9kNXXmpEQSqbUsBYMRj+AOFNlkRwAKL9PMn53rKUdDR8QlHD+hu1
         bNbXm2euxhZghZLaYj2bOjd3UXLkzFhzGpb8ClhRlOUtNF6TyfFSJ9l3Cz/eqiAGxYvQ
         3GVw==
X-Gm-Message-State: AOAM5317x8zj4A3IzfIPnR7XhzsaupHNlx2XxQI9oJkGutuYxAYenBKJ
        +aR9W3PzTe7JSO9ILSjarIFsHQ==
X-Google-Smtp-Source: ABdhPJwfam1b9VUuK2KiSROtjJ68KFyfCyHnaJU4kSRx96x9vSh8DG8UHpeSy1pcGwoX3pIR2XLwyg==
X-Received: by 2002:a05:6000:1110:b0:20a:e113:8221 with SMTP id z16-20020a056000111000b0020ae1138221mr19276809wrw.271.1651742541836;
        Thu, 05 May 2022 02:22:21 -0700 (PDT)
Received: from [192.168.0.217] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id o9-20020a5d4089000000b0020c5253d8d2sm779379wrp.30.2022.05.05.02.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 02:22:21 -0700 (PDT)
Message-ID: <e9e03c19-cf65-28b8-a81a-10995b1f262f@linaro.org>
Date:   Thu, 5 May 2022 11:22:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC v2 4/4] arm64: dts: rockchip: Add mt7531 dsa node to
 BPI-R2-Pro board
Content-Language: en-US
To:     frank-w@public-files.de, Vladimir Oltean <olteanv@gmail.com>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220430130347.15190-1-linux@fw-web.de>
 <20220430130347.15190-5-linux@fw-web.de>
 <20220504152450.cs2afa4hwkqp5b5m@skbuf>
 <trinity-9f557027-8e00-4a4a-bc19-bc576e163f7b-1651678399970@3c-app-gmx-bs42>
 <20220504154720.62cwrz7frjkjbb7u@skbuf>
 <313a5b2e-c571-a13f-3447-b1cd7200f4c9@linaro.org>
 <D201CE50-280C-4089-BB9F-053FEA28FE9A@public-files.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <D201CE50-280C-4089-BB9F-053FEA28FE9A@public-files.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/05/2022 11:06, Frank Wunderlich wrote:
>> You can make it "(ethernet-)?ports" as well. My comment was purely to
>> make it simpler, for bindings (goes into properties, not
>> patternProperties) and for us. If you prefer to keep it like DSA core,
>> also fine.
> 
> Ok, i'm also thinking, the dsa-definition will be the right way (pattern-properties with optional "ethernet-") in binding.
> 
> Should i use "ethernet-ports" instead of "ports" here? Current dts with mt7530/mt7531 switches using "ports" so i would use it here too. If dsa prefer ethernet-ports now it should be changed in other files too.

I think bindings allow both, so choose something consistent with
existing DTS sources.

Best regards,
Krzysztof
