Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD9F59E5F7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237677AbiHWP1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242396AbiHWPZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:25:55 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98771D4884
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:02:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id d21so7324809eje.3
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=NPkz8CIReFRkXXNi+9wXJA08oHYjzaiWMjPixEXkoww=;
        b=iigcejhnAnjVrYq+8ynJNXJJa0Vfsj8KP5tp65+xPF/AC9cPRgUrB26NE3gtauWUwx
         qQD9jaFSKTuo5y6taEgj4zT5WglBx2XFrToeNbs7P2yVO/qXm550HoYgwANo/8U3l2X/
         qD6uIGFVGhfDTFVBzn0eLuBTuJDoRlIwZQ+IIvjVqLH3q805BXxLnwm4kY/v8HsVVfbb
         a8o8/TZEs0PF91gyok9kM1GOBPuEXGkN/kg9f0C7mM/4R2yBD7QZXsKgCsCNKc0P0EIV
         jbxzrxOeX0LPVaXkLwbTQ/iqDPUtOab3XBE2USm0iPAzVuHlVxBxdzZJjjqrjHU3TtnO
         r1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=NPkz8CIReFRkXXNi+9wXJA08oHYjzaiWMjPixEXkoww=;
        b=nZhRjeJpq/4UTehyzRhADulp5jXOfro8oIBYmW1NWfJ84qOIm+LhN0HfC4OjZinAae
         T5nBifZOj5v8TKMbfTDew8qIYKSXF2C+K2GMcGY7XTWpklbjGnLpb8xZRPiCTxZ5LiWg
         +3KV1ud7lYuHw8AkLjH6+4Q8QcbcWCWyfOSmkuSAjocEQbzRPCmYl2Ajiv/NpQ/pQ5oQ
         N2B22m2Byuyr9bDDKWnqTTY5cZEMdBVjB6zd68wHzH2DO1pmiQn2yxcrcYRvjYB6wJLA
         Vxk+JNnXohVlv7L78CT+IOQix60Y2JtOxxAcAfhnsCVWyDSb5zFb9IIRqHQtMuadKiRM
         wZCQ==
X-Gm-Message-State: ACgBeo3ICg01fJXQk057AdUIt2xuzx/LFOOKpOoJBExDyyL79XHNDbVe
        M/dwUKr5maX6sRc2yvZka8/tdTRhU5xNT3yZ
X-Google-Smtp-Source: AA6agR7u26JTojsyB4JuWJX8y8BItLKRip4aR1+/399iD/iKWu9l7BTdi42s42J+uuQrVDAiJBBmGQ==
X-Received: by 2002:a05:6512:c10:b0:492:d263:f918 with SMTP id z16-20020a0565120c1000b00492d263f918mr5533940lfu.501.1661251676796;
        Tue, 23 Aug 2022 03:47:56 -0700 (PDT)
Received: from [192.168.0.11] (89-27-92-210.bb.dnainternet.fi. [89.27.92.210])
        by smtp.gmail.com with ESMTPSA id x16-20020a056512131000b00489e812f05asm2441697lfu.21.2022.08.23.03.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 03:47:56 -0700 (PDT)
Message-ID: <c24da513-e015-8bc6-8874-ba63c22be5d6@linaro.org>
Date:   Tue, 23 Aug 2022 13:47:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 4/6] dt-bindings: net: dsa: mediatek,mt7530: define
 port binding per switch
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
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220820080758.9829-1-arinc.unal@arinc9.com>
 <20220820080758.9829-5-arinc.unal@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220820080758.9829-5-arinc.unal@arinc9.com>
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

On 20/08/2022 11:07, Arınç ÜNAL wrote:
> Define DSA port binding per switch model as each switch model requires
> different values for certain properties.
> 
> Define reg property on $defs as it's the same for all switch models.
> 
> Remove unnecessary lines as they are already included from the referred
> dsa.yaml.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 56 +++++++++++--------
>  1 file changed, 34 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 657e162a1c01..7c4374e16f96 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -130,38 +130,47 @@ properties:
>        ethsys.
>      maxItems: 1
>  
> -patternProperties:
> -  "^(ethernet-)?ports$":
> -    type: object
> -
> -    patternProperties:
> -      "^(ethernet-)?port@[0-9]+$":
> -        type: object
> -        description: Ethernet switch ports

Again, I don't understand why do you remove definitions of these nodes
from top-level properties. I explained what I expect in previous
discussion and I am confused to hear "this cannot be done".

Best regards,
Krzysztof
