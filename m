Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3A8519889
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345711AbiEDHue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345705AbiEDHud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:50:33 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7B313F09
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:46:57 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id n10so1292465ejk.5
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 00:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dbzifzA6YWjAHWM9xC9m3ofdq7acNbmRxozpGYUPCtE=;
        b=WtFgU7UglwUUumyb36pSqBc+1d5a/d2D8JfIWgvVj7vb1AzP1+o+nBh1742oBFe1yG
         A85bEMM1H33grTxN/5vEwJHRIJT5Wp9ZKuMI0K06oQNpRJdLBLKXKvAs0EFqMMqpipeO
         fIQ+e5iFKEUkbArJO6EAwAJmIr/SxDKjBpOWAxuX8o4J/5HI1i4KMUaFIz/QY72UDqAw
         frQZyzHKLsqzlcOj3cZBhgYk8H4Nf5y5mdDYWMXdZR9UArhe2KDqdHb01ecfJAyAk4/J
         Rth9rgKqLtPLs8dHdJNbpSKqueNFFuaNqDnTFmYHOiMqfTg32gcMgdd5V7TmTVAfsKyX
         Ouzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dbzifzA6YWjAHWM9xC9m3ofdq7acNbmRxozpGYUPCtE=;
        b=UuvXBqLTcrvjngIw1Z1sQl+Fz2Q5gUcDiRiSy/jcLtJducIlzy1fp2U34mjdwRRlZV
         F3BebIO/tXXjURRGwaPICunVMKth6p0uyyaryc++aiIr6Hs6o7B8Hm7rJwN+HUdhv3cS
         fSB/mFnSy+IedP87G03WjGMKIKguXyJkr4nVb39kGrbDztLE1od+1Ad34DOWaO1cykNv
         iNThn5qVHklhST5sQl06G5v5hEb/wZPArb+4HNKywObBsFWJiF7vbieaoi1Yql5I8DWw
         6TTneLQTh2Zl2OGHHUWqqiI8SZGpAnZZnXSovzbub92rkVbvT3u5N2BQQv2EYFjL2qzr
         U8gQ==
X-Gm-Message-State: AOAM530WR6FHjJbusD4UeumaZFqQQtWWYP9bSNwOir/cYKmah0oy4S1A
        b51OPJsOyqp3ThornmG/cKGsNQ==
X-Google-Smtp-Source: ABdhPJza/rONsXGNOhvKUQVjcTRriV992KVrug0N5dRQ5ZwwdofSpjQfWff2pSW3E7l9neelG9GSVQ==
X-Received: by 2002:a17:907:97d4:b0:6f4:c876:6f6b with SMTP id js20-20020a17090797d400b006f4c8766f6bmr861238ejc.627.1651650415791;
        Wed, 04 May 2022 00:46:55 -0700 (PDT)
Received: from [192.168.0.209] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id x42-20020a50baad000000b00426cae11e63sm5570458ede.43.2022.05.04.00.46.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 00:46:55 -0700 (PDT)
Message-ID: <876cbf68-121a-2cae-e40b-67f4556fd2fd@linaro.org>
Date:   Wed, 4 May 2022 09:46:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Aw: Re: Re: [RFC v1] dt-bindings: net: dsa: convert binding for
 mediatek switches
Content-Language: en-US
To:     frank-w@public-files.de
Cc:     Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Frank Wunderlich <linux@fw-web.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220502153238.85090-1-linux@fw-web.de>
 <d29637f8-87ff-b5f0-9604-89b51a2ba7c1@linaro.org>
 <trinity-cda3b94f-8556-4b83-bc34-d2c215f93bcd-1651587032669@3c-app-gmx-bap25>
 <10770ff5-c9b1-7364-4276-05fa0c393d3b@linaro.org>
 <trinity-213ab6b1-ccff-4429-b76c-623c529f6f73-1651590197578@3c-app-gmx-bap25>
 <95aea078-3e85-79c3-79c0-430bd7c0fbae@linaro.org>
 <69290DD3-0179-49C2-8E7D-9F8DBDEBC96F@public-files.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <69290DD3-0179-49C2-8E7D-9F8DBDEBC96F@public-files.de>
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

On 04/05/2022 09:44, Frank Wunderlich wrote:
> m 4. Mai 2022 08:51:41 MESZ schrieb Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>:
>> On 03/05/2022 17:03, Frank Wunderlich wrote:
>>>
>>> have not posted this version as it was failing in dtbs_check, this
>> was how i tried:
>>>
>>>
>> https://github.com/frank-w/BPI-R2-4.14/blob/8f2033eb6fcae273580263c3f0b31f0d48821740/Documentation/devicetree/bindings/net/dsa/mediatek.yaml#L177
>>
>> You have mixed up indentation of the second if (and missing -).
> 
> The "compatible if" should be a child of the "if" above,because phy-mode property only exists for cpu-port. I can try with additional "-" (but i guess this is only needed for allOf)
> 
> Rob told me that i cannot check compatible in subnode and this check will be always true...just like my experience.
> I can only make the compatible check at top-level and then need to define substructure based on this (so define structure twice). He suggested me adding this to description for now.
> 
> Imho this can be added later if really needed...did not found any example checking for compatible in a subnode. All were in top level. Afair these properties are handled by dsa-core/phylink and driver only compares constants set there.


Sure.

> 
>> But I think your check was not correct. I looked at bpi-r2 DTS
>> (mt7623n)
>> and pio controller uses GPIO flags.
> 
> I see only same as in the example
> 
> https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts#L196

I meant other consumers of pio GPIOs:
https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts#L97

https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts#L320

Best regards,
Krzysztof
