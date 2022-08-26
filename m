Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C0B5A210C
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiHZGpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244864AbiHZGpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:45:23 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E6BAA3DF
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:45:21 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id l1so791524lfk.8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=76qBouYIHeC6d/ctco6Wmf4ZHs3wGtu4s1Cs+RWbvmI=;
        b=wv+Xyza+ltAZ/PD/0TreZBciu5zRPf/PRZBnb5o2mANd+7GTTG1nuu0dL/DQDdHhYJ
         pG7GSLsTYDS+wHn4+4AlZOWOMGPRbSG7TYDmIg78dgSixEyISbKBWPaF/P1RBGUfGpIQ
         tRKFnWCkmBZWnRJRKNsBUqK+tU6ol1pKsXqXWgRF37hzHVyaNcxIpFxWbMH4Wcp0vw/a
         R+swT8rzKXaNHTEuYHex5nQgvIpSHXVltY/qkHU64n2WOr1wTt/xJ34ROF53svJqfU9S
         FSAuNfeZh676JzS3ssEWim1DWTi4NJRGn75HsBHgzfprjdQcL+TUR1OQHddPMjmy0Jmd
         xiTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=76qBouYIHeC6d/ctco6Wmf4ZHs3wGtu4s1Cs+RWbvmI=;
        b=7nOmADb8mHmFWN4r9biJSksfw5Ajj9MvBsTJOTtgmEA/NKQIAtDHQXDEmiwPP/lfLM
         GaKZ7CEREjOHNPSPEObbOrJWu66fXWX9R2/apeOUM2tAVvvFz0VyfTcjrAHmC+twhiM+
         /ZsF9UNfOEotrfCkH5UfCaCZ2nHpQm06RaZ6OsTFKKzp1DHER/QmVGtSHOpI2okeG159
         6LvQUhMH4aM3hHsalXSJD0A03av7YK6t7tIe5hC5ZzU3VYL0L4M0xpnJbN7uclxN/h3A
         MTEb69+V5ggf6/uYNavazkOkFuUPZ5Q96rIHlp1hvSodedms6/L/OIU4A6XKMY92n5so
         puMQ==
X-Gm-Message-State: ACgBeo3DOFsz0ogV+X2qRkTP1TSrOKU3KqUgwhw0S9HmNq2kUbBvTAsJ
        pTwRyBbUwcbc0VavT77LZaKI1w==
X-Google-Smtp-Source: AA6agR4SJUwINorjaTc/7IHwXWRWERcYLsGWka9nNqc0mk3QNBrJYwP+7oaIoI2J1QriQ4TjtdnkuQ==
X-Received: by 2002:ac2:52ad:0:b0:492:d8ae:364f with SMTP id r13-20020ac252ad000000b00492d8ae364fmr1907211lfm.249.1661496319499;
        Thu, 25 Aug 2022 23:45:19 -0700 (PDT)
Received: from [192.168.0.71] (82.131.98.15.cable.starman.ee. [82.131.98.15])
        by smtp.gmail.com with ESMTPSA id m6-20020a056512114600b0048af6242892sm274234lfg.14.2022.08.25.23.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 23:45:18 -0700 (PDT)
Message-ID: <f85c693b-daf4-c2d5-9ad8-88aef99eecaf@linaro.org>
Date:   Fri, 26 Aug 2022 09:45:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v6 1/6] dt-bindings: net: dsa: mediatek,mt7530: make
 trivial changes
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
 <20220825082301.409450-2-arinc.unal@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220825082301.409450-2-arinc.unal@arinc9.com>
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

On 25/08/2022 11:22, Arınç ÜNAL wrote:
> Make trivial changes on the binding.
> 
> - Update title to include MT7531 switch.
> - Add me as a maintainer. List maintainers in alphabetical order by first
> name.
> - Add description to compatible strings.
> - Stretch descriptions up to the 80 character limit.
> - Remove lists for single items.
> - Remove requiring reg as it's already required by dsa-port.yaml.
> - Define acceptable reg values for the CPU ports.
> - Remove quotes from $ref: "dsa.yaml#".
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
