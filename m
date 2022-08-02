Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E49D587948
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 10:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbiHBIqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 04:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiHBIqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 04:46:12 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE19C17E36
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 01:46:10 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id a13so14856220ljr.11
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 01:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K7X8iIHy3LYj/4krwug3nx931AvXti0vH9iBS7pE2K4=;
        b=gKMlaGsVh25UzUYMjr4Vs6/HiaqzYMDs8EuW9FSc8JTkLiwtIaBKAxFLYvLHzemfv3
         B/QzgEil+FtNljhSp9oMzcgbbnJn7osjyPu/4UWgeJoh/x6rrUitpXjrSL3ie13n9rGp
         u+7fk1bI+8s7iyQ7YODEmTTs80gLAw8YYnrhYcfwiYdm2MOb2mlzqfwKKLyYi9uD+tgv
         CCfK4OvfjAozqBZq82yurA4fnzOTHtXX7JcCrsN9TjKcuNJrZNG8FnWN+6KwWcAyv+Gd
         Bv5yoNZzwmUMv9/c6GucJm5fWWITzEHEJrTeO5HA2tNWtU/Ms9raJprzMkBypZjxXA1E
         CmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K7X8iIHy3LYj/4krwug3nx931AvXti0vH9iBS7pE2K4=;
        b=jbh1DHYNAiUPP6dwJe2jUdVGWrWuNryO0hFy6+LgDept6s2RSF9BjGGRdxKErrFadC
         z+6xfUnCIXrd7wGd9AxC2SZVy/uEbLEm9YaMFEUnqhnSdONWxlBiG5r1eSTtJogvv25/
         APwhapIP7EplUQ/KPGdpT8uaHMKaUIRS0Jw0cxjeF/v3J41U2D0cjszkQdsWs2oI7hxD
         oR1t2rwapVdrIFlKpRIslOoWleKsuI7IdEebvwOIImVkFDt4O+/iQlRoLJyFw9ZZX+Se
         VuAmPpfiIyfWB7N1UD6Bmri39DTMBiOksmQJaA/S4Qv2IbKyDMolo7QiSOlX4YVLExHW
         jM4w==
X-Gm-Message-State: AJIora+xAZeycnZlqn2z1eoNZt+LSYqHxWWvgbSyhgNm57KLt1cbIWJ9
        vHOuuKtWwG+fE5qj/1z8l0vLGw==
X-Google-Smtp-Source: AGRyM1upmtLknsx94k+qHnKPOHBBNE6qH3/UR5Vxo+HHCzeGIiCrY7Pv1IO/NKUma4lABAzfE7WyEA==
X-Received: by 2002:a05:651c:1504:b0:25e:2443:9bfd with SMTP id e4-20020a05651c150400b0025e24439bfdmr5832466ljf.104.1659429969357;
        Tue, 02 Aug 2022 01:46:09 -0700 (PDT)
Received: from [192.168.1.6] ([213.161.169.44])
        by smtp.gmail.com with ESMTPSA id r4-20020ac25c04000000b0048a9ec2ce46sm2012205lfp.260.2022.08.02.01.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 01:46:08 -0700 (PDT)
Message-ID: <e5cf8a19-637c-95cf-1527-11980c73f6c0@linaro.org>
Date:   Tue, 2 Aug 2022 10:46:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4/4] dt-bindings: net: dsa: mediatek,mt7530: update
 json-schema
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
References: <20220730142627.29028-1-arinc.unal@arinc9.com>
 <20220730142627.29028-5-arinc.unal@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220730142627.29028-5-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2022 16:26, Arınç ÜNAL wrote:
> Update the json-schema for compatible devices.
> 
> - Define acceptable phy-mode values for CPU port of each compatible device.
> - Remove requiring the "reg" property since the referred dsa-port.yaml
> already does that.
> - Require mediatek,mcm for the described MT7621 SoCs as the compatible
> string is only used for MT7530 which is a part of the multi-chip module.

3 separate patches.

> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 220 +++++++++++++++---
>  1 file changed, 191 insertions(+), 29 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index a88e650e910b..a37a14fba9f6 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -135,35 +135,6 @@ properties:
>        the ethsys.
>      maxItems: 1
>  
> -patternProperties:
> -  "^(ethernet-)?ports$":
> -    type: object

Actually four patches...

I don't find this change explained in commit msg. What is more, it looks
incorrect. All properties and patternProperties should be explained in
top-level part.

Defining such properties (with big piece of YAML) in each if:then: is no
readable.

> -
> -    patternProperties:


Best regards,
Krzysztof
