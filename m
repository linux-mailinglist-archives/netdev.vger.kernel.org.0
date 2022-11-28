Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817B563B385
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiK1Um0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiK1UmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:42:19 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EDA1C921;
        Mon, 28 Nov 2022 12:42:19 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 130so11659518pfu.8;
        Mon, 28 Nov 2022 12:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0cSg9x/ccvep07LQXRqXIRSRKMxrUjkPjTlD/qxYYyA=;
        b=S0DuPK6TEGCJ7JyEmFc8u5RL+2tGc8suNcD0riR8/Yu3fSNWayulBRhUpXNtSWef2P
         nVW59s7DRIwzuHW4MAmF3FlsqwG1AN/79k+Xb2QzphMwBJ7RLutWrJRaaAz8d1QsrZPv
         ZcmaPU3MHCgZlxQ5ZCH8c3b8/Vg6ybCshJXWyZU3DHkhkFc5pJwlO5vA3NVZvYIuZsdu
         9MBdRtSRJY3Tg+07WXUSIl4sHp/iqv7KgNkSmpZVgZkq4eA+El4guVU7r6OuzCy/PIjT
         aNVeMe3QaYiqOcmwlt3eGwGcHLAi3xctj3eGdJBOieaHK6FMEWbzi7J/MSaGsaCUDNsD
         iEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0cSg9x/ccvep07LQXRqXIRSRKMxrUjkPjTlD/qxYYyA=;
        b=GUHBkLSplEhSxHP+6tW62KEA/vRO7woMyHwysTvKPMB3Q+u7nODngRDNFYV2mbCwqX
         RV1C81qwUO15IbtG1IMYqV8c/t6szZ2yoTVh0SKbhFkopy61MFbldwvZRs94UJIyo2qf
         C3ACG+89YVej4zJNQ0MPs/zQs27b6UgpMtnpTBtpmfXYFTWE3jQF+BM9Jg1miJ++EMY8
         M7OnmOmDBuiWGL3utWLmT2Ja3vBHAiOxapCfJi4C54ebh2hIoJg4JA8gDKwjSxH4XwpJ
         IoKOtTAZx+xfsmza2oInIU+c/M9RkgzHeh2JJ4yMcwRsT0zPqS/cIPKM9Tc8hzPX3HNQ
         18Fg==
X-Gm-Message-State: ANoB5plIMZQjy5haOw0bK2ZKdpYo8Ozmfo7wRwwIYwWP6ikYU+6ZVeBa
        TMrfmlWUwvZ/fpsCL2bRIVD4rP9dsMw=
X-Google-Smtp-Source: AA0mqf4nfHopmFULKIYvx0fPGZ3A6Rthh28Y+yrTorZs36JLYJwEXiFWELazalo3brIHfrsrPkDupA==
X-Received: by 2002:aa7:80d0:0:b0:565:c4e2:2634 with SMTP id a16-20020aa780d0000000b00565c4e22634mr37235658pfn.0.1669668138462;
        Mon, 28 Nov 2022 12:42:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q6-20020a170902a3c600b0017e64da44c5sm9210604plb.203.2022.11.28.12.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:42:18 -0800 (PST)
Message-ID: <0477095e-3db5-850e-2dd8-5163a05ac0e2@gmail.com>
Date:   Mon, 28 Nov 2022 12:42:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 04/10] dt-bindings: net: dsa: allow additional
 ethernet-port properties
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
 <20221127224734.885526-5-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221127224734.885526-5-colin.foster@in-advantage.com>
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
> Explicitly allow additional properties for both the ethernet-port and
> ethernet-ports properties. This specifically will allow the qca8k.yaml
> binding to use shared properties.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

