Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A5763B390
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiK1UnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiK1UnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:43:05 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF20811A2A;
        Mon, 28 Nov 2022 12:43:03 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d18so560822pls.4;
        Mon, 28 Nov 2022 12:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yShKpOzbDuo08Rg5O/TzApxhHvkpQuPMiQfCmDQcZ/U=;
        b=Tn4UgNSh5PJ/a6+F/p3bEfoiPnJaEa3KxeftDRiIY64KDKcdZUVjA9UunfGanCITt0
         8RyFa+NNeDcpN0vrC+kn38gnjXjA3DxFBHr+z9Ao7XIh6et50vA7aguBDVjwhrBCDlJP
         aELgJRviyv5MBueGEUofC7KVQQ/NuC2/lvYWmFscYc4mPunq9N2zKwS1mOfCWAkRiJ/P
         Ac/WoFpFYjlLzPhhJblON8gZMvIX5kFHAxilBD845ZCbVOmH9Z9YlK7PiF0VvjKbL6qY
         TBFo9gz3aPQq19d/8yb62YcR1u7OTLBPTxQeXrse7xfxaPSzDEBiK8dh+auCuHk6j5Ff
         vTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yShKpOzbDuo08Rg5O/TzApxhHvkpQuPMiQfCmDQcZ/U=;
        b=YAmOT0/YBTMO6kfIYs8yh4MeU/Os+N9rjnHz3/wSBVkVWw745TTm5smII8K6Cj5Iob
         2PmKThRvwNkk5jhnSX0UX4y1ypwvgxWH9X1jLTmQXy4KLM6JQQ8Deu+/P0KpRklhsXVP
         /m1U0rhshbiQXhNw7NqMBpR5CjVKgjfzbJnbm1f6RlZ0qX8Em96MCqsTga5QLpRLav9v
         4tmYlYaPAJrNL/O+0hIa8daENNCkv2ypsIqiFjZ74M4Uha5t96BKPJ2EeUIkcXvOy+KK
         YYW+2tDVFWXLckwYbo9/ZHaCBJXCr+0C1RUUjRl7qappyuZwID5pe+zDInIo1XqvZtX1
         wA2w==
X-Gm-Message-State: ANoB5pnR50oSakj/RipWhF8syA1tfQJaPZticddnlWl+RCltuamkK2m/
        K2kqczPScpl0Tq77mnupgywdSY7HQL8=
X-Google-Smtp-Source: AA0mqf6ZzYK1KKUuoQS9eiyjwmePFmysShUH5q2ZzrN08M8GAsZ1Xf4AikNPKbV1iym4f4q7vs1Ccw==
X-Received: by 2002:a17:90b:3c0a:b0:213:7030:b2ec with SMTP id pb10-20020a17090b3c0a00b002137030b2ecmr62028618pjb.95.1669668183410;
        Mon, 28 Nov 2022 12:43:03 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x2-20020a634a02000000b0043c22e926f8sm7149770pga.84.2022.11.28.12.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:43:02 -0800 (PST)
Message-ID: <fdb3463f-a41a-9490-a3a6-5b091445543d@gmail.com>
Date:   Mon, 28 Nov 2022 12:42:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 05/10] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-6-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221127224734.885526-6-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/22 14:47, Colin Foster wrote:
> The dsa.yaml binding contains duplicated bindings for address and size
> cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> this information, remove the reference to dsa-port.yaml and include the
> full reference to dsa.yaml.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

