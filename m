Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23B858484C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 00:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiG1Wc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 18:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiG1WcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 18:32:15 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326A87AC03
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:31:31 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id iw1so3000582plb.6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=52F8TKkU1/KUzKYKCKB4hYslOV3JVCvRnfjPBcMRzH4=;
        b=qsyuQmucZpshbr6RCnszwzUkk6L0cYvVEG4ZCKCrQWTb0I1asREWXDMuuo5Bo33eEx
         BxMBs41x0/oUwrf9Pr8fNDEvzbV6ZQ6imuXgjZCIpw8VbfE8iskShMmUytQI3Muj7ffQ
         sGaJCucluarcGuy8GUgAyWxTafzZimJsLv/Uf9Mty9aantNof3Vj/WWczQX5qCbez1iE
         PHmoZyHbBpr+wASku7CRLtxwIcwWyMqphQH+8ylbK9aUWNOkWtJGmAqFXXpYf9tBaulP
         pJ2wYlMOXvsuh4uXdJXVAXQTbDmwvJwPADm2/C+DdtBHIOk53PMBBz4WWVdiE1Q6nKFG
         yYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=52F8TKkU1/KUzKYKCKB4hYslOV3JVCvRnfjPBcMRzH4=;
        b=DQuxGahY8eVq/tFvGc153aiDuOI42JouFFIK44ZEiHK/377UIpwDpTdpDFNThZnk5B
         C00wEJdeP2N7RBCG2JK7+qBYFSgmTmoyuxz8BpYy8+cZfk32dTorkYrDAz6LOvY+xCbx
         W345qCTzWsVnMjf0s7nF2AIhxey5N96p2Cl33P2foY1FvEAcuIpG0LkUobpiu76xV4Ym
         8JYONZmXbWD1a55iZNeDA7QHR8sPaLlDON0ZN5fw6goZ2wZQjgsrpAcI9VU3IF424ZE7
         xSVyjqyKTa/dPYLGnGORarPYYf98RiBPRN6bUoPVb3B3lRGAM4vVea//64sNCDxyg3AL
         X9XA==
X-Gm-Message-State: ACgBeo0RcA8muxbUPn6CnDnYcFvUYVNiH7auoheRh2CoUsO6KTj7ARJn
        Y5Pign5njTj5n/LfSPdtmkQP7QEbZqM=
X-Google-Smtp-Source: AA6agR7+97QGU0HxZY3B+7u+ohmQXbhvD1NAPltxkFsohTxwwgmO+MfP0i+ekBT3BYCXDGLOLqX1Qg==
X-Received: by 2002:a17:902:a586:b0:16c:3182:a9b with SMTP id az6-20020a170902a58600b0016c31820a9bmr1017698plb.44.1659047490656;
        Thu, 28 Jul 2022 15:31:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 127-20020a620585000000b0052516db7123sm1299573pff.35.2022.07.28.15.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 15:31:30 -0700 (PDT)
Message-ID: <f13d7a62-e975-88cb-72d8-b851ec4bb416@gmail.com>
Date:   Thu, 28 Jul 2022 15:30:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Aleksander Jan Bajkowski <olek2@wp.pl>
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <7dba0e0b-b3d8-a40e-23dd-3cc7999b8fc4@gmail.com>
 <20220728000230.kfwd5rkn433f2ecf@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220728000230.kfwd5rkn433f2ecf@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 17:02, Vladimir Oltean wrote:
> On Wed, Jul 27, 2022 at 02:07:51PM -0700, Florian Fainelli wrote:
>> Since I am in the process of re-designing my test rack at home with
>> DSA devices, how do you run the selftests out of curiosity? Is there a
>> nice diagram that explains how to get a physical connection set-up?
>>
>> I used to have between 2 and 4 Ethernet controllers dedicated to each
>> port of the switch of the DUT so I could run
>> bridge/standalone/bandwidth testing but I feel like this is a tad
>> extreme and am cutting down on the number of Ethernet ports so I can
>> put NVMe drives in the machine instead.
> 
> tools/testing/selftests/net/forwarding/README
> 
>                              br0
>                               +
>                vrf-h1         |           vrf-h2
>                  +        +---+----+        +
>                  |        |        |        |
>     192.0.2.1/24 +        +        +        + 192.0.2.2/24
>                swp1     swp2     swp3     swp4
>                  +        +        +        +
>                  |        |        |        |
>                  +--------+        +--------+
> 
> Most of the tests assume these 4 ports, otherwise the topology is
> mentioned in a drawing for that particular selftest.
> 
> The names used by the tests are actually $h1 and $h2 for the host ports
> (extreme left and extreme right) - these terminate traffic - and $swp1
> and $swp2 (mid left and mid right) - these forward traffic. In the
> drawing from the README, I suppose the names "swp1 ... swp4" were used
> to illustrate that you can use switch net devices as host ports, and
> also as forwarding ports.

Thanks! I will get to that later this week.
-- 
Florian
