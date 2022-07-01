Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DCD563C5E
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 00:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiGAWaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 18:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGAWay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 18:30:54 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED2338795;
        Fri,  1 Jul 2022 15:30:53 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id b24so2845573qkn.4;
        Fri, 01 Jul 2022 15:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZRqXDVBh2tyzQxE0lZROBHIZNd62HH6YkugnzahAVfE=;
        b=DSaCxZBgTmQp1xce3Jhu90CL1ztuJjAzTXLm35TAcdlEwGPjL8vSEQH7DxAmv/O/39
         uWskVo1L2IAhL6MYAVGTkn3tB+IrMnep4ORmEqpwbA8qzRJbaWJxhG7y5Vxw1Q4SL8lp
         HR85ZmyZWwvviBhDk73MDgMkRjWnmBKFlO1RbXW2GW27wjK3i34h5wd9BhfXxeME/5Nn
         vJwqzWzdVhWwF6LafX0GhhxljaQUnYYp/DplBCRCd7UDPhinw4luglRUCkEYaOsXKc5Z
         edE0fg6BBBQO1I9bfOQmC1ZaEa1Qu8JWRROn6hw4RI/BbLfftcARZO6wDbvvrmy8Id51
         IY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZRqXDVBh2tyzQxE0lZROBHIZNd62HH6YkugnzahAVfE=;
        b=CePfax79QFIbJvxLfcHtmf2bFRjub/gohoXDKVVFCtlBfBCkKBVHl+EUqOe4OjKIYp
         w+9ybd7rzf1slbcuAOmGY6zUQTLc5GcC3M43fwKckLmplR43RK10FiBGB4LyTNCULOF5
         y4/Nw/Vhk4YFCdHrWsfqgickeE4zk9yhEdrI+jhF89SJLhSEuxVVsKryMBSAArYwlWE2
         rOIId99il59v+At4kGUJspM+iohATZwDmGIw6BcaGG9ItIBTxJpoVqVqUkBx2ynNX1ig
         tHdSnjSJM2BD7daJhIw6hRS4MAbDG/vfhVqt/bc8WCA2Uzu+laTnOcGHV0MiHeoz3H8b
         kiWQ==
X-Gm-Message-State: AJIora+aqV3qGXI+hoiQn9VkAGJdxIB5r56jbB8Wv6Iy6EP32SyyvE3h
        ugN/taJf4vTCzeEUM3WD7vc=
X-Google-Smtp-Source: AGRyM1vB1SZ62N+Gy6jjsx4kJJzWeanIHG6jkt/r0+yoo6UePFIYHvj4XFuf4u/EPQXOjEjQmUmhxQ==
X-Received: by 2002:a05:620a:3c4:b0:6af:6468:1c0b with SMTP id r4-20020a05620a03c400b006af64681c0bmr12494113qkm.584.1656714652751;
        Fri, 01 Jul 2022 15:30:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h2-20020ac85482000000b00317cd3edab4sm14284228qtq.11.2022.07.01.15.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 15:30:52 -0700 (PDT)
Message-ID: <fe25fc8a-843c-72c2-e352-88fe9d819ac2@gmail.com>
Date:   Fri, 1 Jul 2022 15:30:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] dt-bindings: net: dsa: mediatek,mt7530: Add missing 'reg'
 property
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220701222240.1706272-1-robh@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220701222240.1706272-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/22 15:22, Rob Herring wrote:
> The 'reg' property is missing from the mediatek,mt7530 schema which
> results in the following warning once 'unevaluatedProperties' is fixed:
> 
> Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.example.dtb: switch@0: Unevaluated properties are not allowed ('reg' was unexpected)
> 
> Fixes: e0dda3119741 ("dt-bindings: net: dsa: convert binding for mediatek switches")
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
