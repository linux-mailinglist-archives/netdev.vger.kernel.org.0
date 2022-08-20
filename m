Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E2959AAC5
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 04:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiHTCzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 22:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiHTCzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 22:55:06 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28827BB69B;
        Fri, 19 Aug 2022 19:55:05 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id w28so4606053qtc.7;
        Fri, 19 Aug 2022 19:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=ROMAN6FB6IuI/ClwiFrcCO2VFfyuMXSLSUjID3QPCqs=;
        b=M23Fcyrpb8BHZmooq95a3Znd89PQatOl9XnCuwQovieOjm/qe1ZaT7tLR2NAPzV8pU
         Y6AlKWCUwloAVTrx4eKP484dJAxBZqwa9WtOJm25UnXpEzTk/zyPoUtehuVGO3w41Bg5
         yU4PWl+JUTB0j1/DfWdTAgwNra5vW8IpPUUB5VFa6aNmtmClYQILxkUerdhcF3ITxpQr
         8AZ6iq6TTEqIiZRA0LCJ1Yao/5mkh/4TinNYcbD79f3RoYkL8eYHtS5CnPr6w5ccnu0p
         LIgXCZPwbJAnTL+wUQchHDQcSq/0VGSlhPE9LS3f+rntP/AtwXUI2NnvRXSBXhHJ59dn
         coWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ROMAN6FB6IuI/ClwiFrcCO2VFfyuMXSLSUjID3QPCqs=;
        b=Hp8DCnligUpOwzSeeRTSGbQnuQSTadhVgKEI4/EZ7CzyJF6bWvxv+7A1DmzjKtikwd
         AmhXsDxBu7rY9lm255iZGE00S1gRpo2MBVexXebWOIh5lULHZ8yTmi+UzdVYmJ+ZhRET
         zDMOkc4b/40Xq6mWvbOoR0VK+2t+D9dM7ZMoCJxvi0gwI0vDOC9+FB7GpPYsfyEk64R5
         4mcrsc0reNRIDTTau8C2szY2Opj7w97NimuXrEzgzIzCWas4SaRA8moObUwI6gvIi0GW
         gna6hcIpdYnm3JFupS1T8SXrfr/vN3Hn//ItlOiCIw92eS8t+IbQ7yYm7FDfq0Wbse0F
         /uuw==
X-Gm-Message-State: ACgBeo1Gh8VT2nTj7N13eNRFp5eZUPihHoU6+4NA6BBZgfDmrD2SBo5L
        WZUAYScTdyRY5ajXxEGw9h8=
X-Google-Smtp-Source: AA6agR48RsCYvSGmwwOcxfE4IkImyfF3f8hTpHJA7vWMHWwL/B9edQOz+XQVCb9YoUMd3W9e0ZxMmg==
X-Received: by 2002:a05:622a:198c:b0:342:fd20:239c with SMTP id u12-20020a05622a198c00b00342fd20239cmr8668975qtc.358.1660964104204;
        Fri, 19 Aug 2022 19:55:04 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id x2-20020ae9e642000000b006b5e50057basm4923653qkl.95.2022.08.19.19.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 19:55:03 -0700 (PDT)
Message-ID: <b299c79b-196c-7b38-fafd-16e9443f6bd3@gmail.com>
Date:   Fri, 19 Aug 2022 19:54:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v4 net-next 03/10] dt-bindings: net: dsa: b53: add missing
 CPU port phy-mode to example
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rob Herring <robh@kernel.org>
References: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
 <20220818115500.2592578-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220818115500.2592578-4-vladimir.oltean@nxp.com>
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



On 8/18/2022 4:54 AM, Vladimir Oltean wrote:
> Looking at b53_srab_phylink_get_caps() I get no indication of what PHY
> modes does port 8 support, since it is implemented circularly based on
> the p->mode retrieved from the device tree (and in PHY_INTERFACE_MODE_NA
> it reports nothing to supported_interfaces).
> 
> However if I look at the b53_switch_chips[] element for BCM58XX_DEVICE_ID,
> I see that port 8 is the IMP port, and SRAB means the IMP port is
> internal to the SoC. So use phy-mode = "internal" in the example.
> 
> Note that this will make b53_srab_phylink_get_caps() go through the
> "default" case and report PHY_INTERFACE_MODE_INTERNAL to
> supported_interfaces, which is probably a good thing.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Rob Herring <robh@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
