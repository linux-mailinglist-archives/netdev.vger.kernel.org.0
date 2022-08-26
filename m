Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3C65A2117
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245098AbiHZGqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245091AbiHZGqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:46:00 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B356BB6AC
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:45:59 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id by6so682331ljb.11
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=kS++P7f/sxm+5fpcUlBki4yBaSJvYpRpgROhsMETBW8=;
        b=g2PebV7DA2dG91zJ+3A5Ck9fY4G2rWpOELAfA2Ey7hk2LYZzSBnkKYTY7Zr6rAbdFd
         q46AAJBJE7yTCTd+hQDxa0jNPkVOv6mbAFOM4C+ydfPvRyUAa72QWu+0x1jf6bRp+k79
         lnGUQedJWnwGTSwtefSnqfcdXKg/IVEad78NLN2cumTD4n0okhNXYRHGQtKwsTfJ5sJn
         Wqz+JOCykDAXL+y297nti4d0npk/wvA06rQKSCKAFQeCih8lregz+K+CbeJZe8GzmywA
         PdzsHZaJNXcDaszh3RQOSIntAryy2ULRKf0t72Ibxvpf1CrUBguJYGKnt6cX4aKaaVBP
         DhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=kS++P7f/sxm+5fpcUlBki4yBaSJvYpRpgROhsMETBW8=;
        b=Gy26l00oRqY0tCsAkVbJomrE5Xnsqovz1Y6lNcLGT/7iNpZdnw/oOGCCaq4v+pwRrU
         08dZM/ukjdz5+KcXI/YQCwLaXCKXH2TOQS3s3de4m0kiOicLof6jLS+vytYRyL88BJGB
         e4EzmLvf4dnxTq+IsqPkojq5kereZOylgct+PAgaN4QXYHfVKAwJeRBapW5R6I7Ku/Qn
         CXxof5xSCW6nDlt43p8RpCJCh4aBe0y91Djo+rjsrQqlXqySXdEgJN8J3l2Ao8jqMg71
         WP3Uxdgm6uukcs+GTPymbkeAh1TRJ1V9Yw+LomaPsUkzeahTN3zNi8fZxFqLBHNxHmLx
         0zhQ==
X-Gm-Message-State: ACgBeo0W+zpPgab2k4l8ynmijbDaon970qu9O9tOliEiuTiaPifBMIKr
        HAdc/Nv2Hu4Wc+YOZ4gTAXZGUg==
X-Google-Smtp-Source: AA6agR4P1Lppd9IyB4a2iit7fR1482AuCseveFfT3iZ+aY3X33NJaw9K20gOE/6FuNs2mXlh6X8R1A==
X-Received: by 2002:a05:651c:90a:b0:25d:57c9:30c4 with SMTP id e10-20020a05651c090a00b0025d57c930c4mr1790962ljq.386.1661496357412;
        Thu, 25 Aug 2022 23:45:57 -0700 (PDT)
Received: from [192.168.0.71] (82.131.98.15.cable.starman.ee. [82.131.98.15])
        by smtp.gmail.com with ESMTPSA id f18-20020a056512229200b0048a73d83b7csm262960lfu.133.2022.08.25.23.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 23:45:56 -0700 (PDT)
Message-ID: <c5e22875-745d-7334-84bf-d854b2011af3@linaro.org>
Date:   Fri, 26 Aug 2022 09:45:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v6 0/6] completely rework mediatek,mt7530 binding
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220825082301.409450-1-arinc.unal@arinc9.com>
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

On 25/08/2022 11:22, Arınç ÜNAL wrote:
> Hello.
> 
> This patch series brings complete rework of the mediatek,mt7530 binding.
> 
> The binding is checked with "make dt_binding_check
> DT_SCHEMA_FILES=mediatek,mt7530.yaml".
> 
> If anyone knows the GIC bit for interrupt for multi-chip module MT7530 in
> MT7623AI SoC, let me know. I'll add it to the examples.
> 
> If anyone got a Unielec U7623 or another MT7623AI board, please reach out.
> 
> v6:
> - Do not remove binding for DSA ports from top level.
> - On the first patch, remove requiring reg as it's already required by
> dsa-port.yaml and define acceptable reg values for the CPU ports.
> - Add Krzysztof's Reviewed-by: and Acked-by: to where they're given except
> the first patch because of the changes above.

Review should have stayed. It's a close to trivial change.

https://elixir.bootlin.com/linux/v5.17/source/Documentation/process/submitting-patches.rst#L540

Best regards,
Krzysztof
