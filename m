Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E555A212F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245040AbiHZGtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243137AbiHZGtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:49:09 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04C8B6D2F
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:49:07 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id s1so808289lfp.6
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=8shYHI5qnyesibZOJHcF69skgsSb++vkrS1ksDjd804=;
        b=MH7c4PTN5491vzJaxItrJvsp2d54VdHCleNKYtUufTivwe8sp8YtCzh0L2FmeW9dmk
         cPC6Giw77c99htJDRJsu1c3pkn0AE/2MmQEO5RXvMKpobhfK6ybYGyCI03FLGHYre8Ff
         FnVmEb2Hqs+bP4F0rdJnDpuC50IHB0b6+QfNx9fOR+MQMrkZ+uk/iKSQzG2jJwmrJW65
         kX+eQtPxqW9fBgeKH/iHADmXjHLdCHAcemrawwjCu/PqirMZxeIgJ3FhJlSwnxMY+pdt
         qCWT+VH0PjC7BeGmrh5ST2hkUxAHCn39yxaoTC1Ca2f7reZc7/lmj7adqCxUvhfGpcxd
         ABDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=8shYHI5qnyesibZOJHcF69skgsSb++vkrS1ksDjd804=;
        b=IJTupevtKCClDJYoKWEQmyVpXjeQs9xL6sgz4yaqI9gbKd6zPToalPWdKz+zCkPjAu
         sWShHxWD9qdjimam3EiZEmC6S8yWakvrG/wFwuPqlchptHAGLf2JgtHHzKu+NU/l9xPP
         dzpclUCJt7rRKQ/adMeyZsdO2ccabTFe8ZWOTrNqdjD2dU/59Jhbg5Q0IUhNk4U0YIIr
         /WgTtHyPpnoegfs7njBfKrhPiFqp/FuencOOaJAxnbdco5tG2QAMQj2VcEn2Cil7lQAL
         17/OTq/ry7aRoWnfK9jFkoo3hg5j4shOyTA1cwN1RfxPyVDPBr3QMgwnBW0S/K1SZ5Bi
         asNw==
X-Gm-Message-State: ACgBeo0rpQz4T4JvKxS3gWxi3maHayqUIGTvTOMdLGiJAAsoBDPtDCh6
        C+6udAZBtw8be9TYjyxdWx2FUw==
X-Google-Smtp-Source: AA6agR4n8wu6cU+e1LJN+2qT52EhS0729YcyXjrhMcjUf6IOv1gJPCfT/e0dK9/QvHZSzhUsmvvuXQ==
X-Received: by 2002:ac2:4907:0:b0:493:266:74d6 with SMTP id n7-20020ac24907000000b00493026674d6mr2270018lfi.36.1661496546143;
        Thu, 25 Aug 2022 23:49:06 -0700 (PDT)
Received: from [192.168.0.71] (82.131.98.15.cable.starman.ee. [82.131.98.15])
        by smtp.gmail.com with ESMTPSA id w3-20020a05651234c300b00492eebe1f09sm269321lfr.74.2022.08.25.23.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 23:49:05 -0700 (PDT)
Message-ID: <a1c4e262-caf5-7369-f8f7-02d790fa1947@linaro.org>
Date:   Fri, 26 Aug 2022 09:49:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v6 5/6] dt-bindings: net: dsa: mediatek,mt7530: define
 phy-mode per switch
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220825082301.409450-1-arinc.unal@arinc9.com>
 <20220825082301.409450-6-arinc.unal@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220825082301.409450-6-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/08/2022 11:23, Arınç ÜNAL wrote:
> Define acceptable phy-mode values for the CPU ports of mt7530 and mt7531
> switches. Remove relevant information from the description of the binding.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
