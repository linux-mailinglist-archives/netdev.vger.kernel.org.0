Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7335B5FFB
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiILSMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiILSMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:12:39 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4122F40BDF;
        Mon, 12 Sep 2022 11:12:37 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i3so1957325qkl.3;
        Mon, 12 Sep 2022 11:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8E7PntAsREeNfSHyD8ppPZ5kkKGXgsJxyvl0PQ0fJI8=;
        b=I/7RINzP0Z0yZPVoIdOreH/t6XQdmWwGtveYCBeVEu5VJWh7lW6ppFjR9BkhxaUGo9
         AXnm14DvFNOfLCYuhMPnWdMDSyu4jNhn/TQCzSO7SzxJl6HR8kmL8dsZdXp1D9OCxw/L
         ++SJAmew/2FAK7arDApyRpJPCVPmVDtqADcTUVX2YwFFI3OKeqQyyQq7lnDwX8gVHdxy
         pQpaIMgO2POsUO1G/jQD7sNfN1xGL/Pp7VweYWJem1GbMTBu/QqAAWj39zxADN7sBQIR
         u83wMD9Ydf812TL92+6+Nk+IYGDxuqNZ+RqlMan0MaNnL7tRAkew40Son8O+TYzh1fo8
         WwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8E7PntAsREeNfSHyD8ppPZ5kkKGXgsJxyvl0PQ0fJI8=;
        b=zRwFo4KOkjW1lk73J3mtK3WDzY3ATaZ7TDKVl8tbG3V34S8l72fD7WjHoHaG8FwUNS
         v4fOB6t2kz6vJKkV6jXMF/+LBcooGdFy7FsYWauPecPzwjQbUrvPpLYn60fPaMBfLfXt
         2yNXQyvNuNGASn6grmHNpbOgeWx+TIs1MuOASli8O+1+ZvqTYuxpnW/FJvnAvMz2GtMP
         FYf7RaALZQcVN6+78R3uUIIDeOPvrazif+UzlhIhdSdI5jZzknCyndxUj93BBmjD96Fv
         YQB4aphLml7RdTMZmVQezOrBwcCCgAB+3Plz5ZXJQsRohpv2LvYzaf7dr8mnvsOU0beF
         xX6w==
X-Gm-Message-State: ACgBeo1qeTZhjXhiNKhZx2QHbRJDoObkzQZNm9Pq3vPv8UphPkn1h3dJ
        90F1XjTXfneGK0uYXFSuVZU=
X-Google-Smtp-Source: AA6agR7EaWz1dfDbiGlBhX0giEUzB6WX6YP4xReDzRQPT/z8Lax4IuXZ12+4iPhwm+Wyq1EU8+FPrA==
X-Received: by 2002:a05:620a:22f9:b0:6ce:5ea1:a957 with SMTP id p25-20020a05620a22f900b006ce5ea1a957mr1658052qki.359.1663006356312;
        Mon, 12 Sep 2022 11:12:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h8-20020a05620a284800b006cbc40f4b36sm7450846qkp.39.2022.09.12.11.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 11:12:35 -0700 (PDT)
Message-ID: <cb90a930-8322-3d4b-ff7a-2bdde0787bd4@gmail.com>
Date:   Mon, 12 Sep 2022 11:12:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: remove label = "cpu"
 from examples
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220912175058.280386-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/22 10:50, Vladimir Oltean wrote:
> This is not used by the DSA dt-binding, so remove it from all examples.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
