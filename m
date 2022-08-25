Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9335A08C2
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 08:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiHYGSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 02:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiHYGSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 02:18:42 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11C2A00E2
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 23:18:40 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id z25so26926072lfr.2
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 23:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=LCeRgAr90AjP72BARFiQs5/0imRongy9yblqwBgpMJw=;
        b=c3RlXRDaCp4vYWxqcyLpXjoAHiDJ0wrIIcONyeaAraWpAjQYEC51alebj1AQrr5xJ3
         0JCZnlpUQtsKJjJiTgWDccNqR6NMnrbXCDj6LAnTJ6rw9OFPRtR5zWwLrhJFNhECVhBz
         UOunN4yWD7EJvjCey/CBpxxnCxhmToSfFIgqj4U0BuArgrJYUp+NZ8aYfT5EZkeTBjEt
         fnvIoiqL9uoXq6oYoaeSf7SFQXkoBLaowtzcRdPB62ZimXRQh0OvG09QjFjQE2k1SyUK
         PSGe3qgXUg0uN95oS5On0SV6qM7neLlUYfAPe5iG5411BzKn1lvKoSeZYwmAX8HLAkev
         7Dqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=LCeRgAr90AjP72BARFiQs5/0imRongy9yblqwBgpMJw=;
        b=k1F8Q51r/vYhhk81pT8/0c96MNzvSWwpzn6VlHP/ittXGb+8M7VlRq+EUU+16q8JM+
         czgDEgH4P+3JIApCX0SrD7RQT5LiHeyPeDXcQNML/zo/uJtJblL9rN3qxE3ijCUSatKB
         AlpLvanr6aey6dXGOqYuNZCU50rdjc0Ul5DsJLk4XDHn0Eb+zVr86QgQhZCOjFtOnFBC
         COq7bQB35b5nwFO6rca7ql9s6M0sztAW5HtMNWeSIf1lFZNOrltL6/fymUI56Oq8nUTB
         nF2OJman3EPlhBEm7LENrfA/YdZe1AWw0TAkvaIG3WHW14d4KR34/JCFbtQdJQTkcbrm
         5q9w==
X-Gm-Message-State: ACgBeo1PZlmnJi3S2uMZ5OBjBu0vuWE/A3oNDSUotQc+KlDw0X2leqBV
        XcWetpvzSA7JUWtkiCUDOFpKFg==
X-Google-Smtp-Source: AA6agR75ynzRVgvfBbdqJ2QkXycl9WBPmjwpM9MQUP9CsZJX93WYal3zBWqrzkkwzk66jgGdDVldhw==
X-Received: by 2002:a05:6512:2302:b0:492:ce48:1bab with SMTP id o2-20020a056512230200b00492ce481babmr612617lfu.266.1661408319341;
        Wed, 24 Aug 2022 23:18:39 -0700 (PDT)
Received: from [192.168.0.71] (82.131.98.15.cable.starman.ee. [82.131.98.15])
        by smtp.gmail.com with ESMTPSA id o13-20020ac25e2d000000b00492b7d7ee20sm323634lfg.87.2022.08.24.23.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 23:18:38 -0700 (PDT)
Message-ID: <0eea5c56-534a-aec6-b9f1-dd306fccf282@linaro.org>
Date:   Thu, 25 Aug 2022 09:18:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v5 5/7] dt-bindings: net: dsa: mediatek,mt7530: define
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
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220824104040.17527-1-arinc.unal@arinc9.com>
 <20220824104040.17527-6-arinc.unal@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220824104040.17527-6-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/08/2022 13:40, Arınç ÜNAL wrote:
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
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 55 +++++++++++--------
>  1 file changed, 33 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 8dfc307e6e1b..a6003db87113 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -127,37 +127,45 @@ properties:
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
> -

I don't see improvements here. We might have here misunderstanding,
because I mentioned it several times yet no effect.

This hunk with reg and maybe few other properties which are always
applicable should stay. You do not need any defs for this binding...


Best regards,
Krzysztof
