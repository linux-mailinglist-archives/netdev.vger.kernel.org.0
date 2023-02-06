Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAEE68BA8E
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjBFKlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjBFKlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:41:45 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EC459DA
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:41:31 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id g6so1927008wrv.1
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 02:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FBhLYA+SIzudlNP9ekDtVYZHty9s86eLqUjf+FxzBZ8=;
        b=p2jDpDDo4W/9nG/lieR4uV6N4whfpKGeY8NHoV5mmucaMX2Ke5igIIdRnij1wUoDI1
         RnlsufF/77e0pUBe6S01bDess9U3hsbAZDM3b0VeJjZo9cJyXh1/laQHZLZHmV91sSTq
         UDRTOOGtMPET2lH4qfcbvWEip2yuYlGODRhVy1XqtU86FyDl11Cw1hyx9WPCoQYepwW7
         dGH4MK3sIhO/sGKhzh2yzKydhp8y4r9lki2SGcI6s0fQWUqxpwiJhGrb9sOrL9qwrlib
         V3PaqZ9E7KKLpep4Bkt8oNH72hbTc+FQFXR/InbZPuYWfE/+sE7Fkuf1yLEf02iXQ1aE
         GuHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FBhLYA+SIzudlNP9ekDtVYZHty9s86eLqUjf+FxzBZ8=;
        b=lCgMVX0VAME3sQGJkbaF6d6PiJwpIUofg90w6T6WBBztHegLzds85vUNZSpm5qrH56
         hyZ89/7zVq4wQjOwv4XdNyjBo15nFBIZlbQGLbim6PDb4Oo1nnVxpc1zkOubdou8LLPz
         J5ByRo3bewBB7OV0GOAW4EIH9mBWMkPiEU7PiVAWYs0YbdiaBmiC9yX6DJkSHDvSRnHd
         C7BBJzGsAoO89jC7meNqZobgUbMpxqDEQ5NriuKuHhXomyVa+5zrhYCJuGM2bT5bcWa+
         nx/sv8upBLMnd5SAG6XPlahvYhyxTEIdA0QUKEmHOA9l0vxQTK9O6frRokkzyf2NujtE
         +5bA==
X-Gm-Message-State: AO0yUKWtUJ2XG0aU1zo4gzfUo/wbiAPA37RQxOZraiXes6lZpiPa6Sjq
        TBeGpyUwLv4y0eBXjdjwUbY60A==
X-Google-Smtp-Source: AK7set+6WnIr4DhuxmcQ7u1hjMG57iF8m14fF8ppUYfwWa2P7jPWOXyCMlTQYN81aUELWSR3KOB7pw==
X-Received: by 2002:a5d:55ca:0:b0:2c3:e0a0:950 with SMTP id i10-20020a5d55ca000000b002c3e0a00950mr5923334wrw.0.1675680090075;
        Mon, 06 Feb 2023 02:41:30 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id i14-20020a0560001ace00b002bfb8f829eesm8944320wry.71.2023.02.06.02.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 02:41:29 -0800 (PST)
Message-ID: <bd840b3b-995e-2133-df93-a5e78128acfc@linaro.org>
Date:   Mon, 6 Feb 2023 11:41:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v4 1/2] dt-bindings: net: Add ICSSG
 Ethernet Driver bindings
Content-Language: en-US
To:     Md Danish Anwar <a0501179@ti.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch
Cc:     nm@ti.com, ssantosh@kernel.org, srk@ti.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-2-danishanwar@ti.com>
 <e0ab9ea1-59b7-506f-1e77-231a0cdc09bf@linaro.org>
 <81dc1c83-3e66-4612-9011-cf70fb624529@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <81dc1c83-3e66-4612-9011-cf70fb624529@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/02/2023 11:39, Md Danish Anwar wrote:
>>> +    properties:
>>> +      '#address-cells':
>>> +        const: 1
>>> +      '#size-cells':
>>> +        const: 0
>>> +
>>> +    patternProperties:
>>> +      ^port@[0-1]$:
>>> +        type: object
>>> +        description: ICSSG PRUETH external ports
>>> +
> 
> At least one ethernet port is required. Should I add the below line here for this?
> 
>    minItems: 1

You need after the patternProperties:
    anyOf:
      - required:
          - port@0
      - required:
          - port@1

> 
> 

Best regards,
Krzysztof

