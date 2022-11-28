Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9785D63B3A8
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbiK1UsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiK1UsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:48:08 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7A524F11;
        Mon, 28 Nov 2022 12:48:07 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id g10so11359019plo.11;
        Mon, 28 Nov 2022 12:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iLOqHU1tk/AJz68/ud/iFS8k8mU5vLevr7eNlqKJAW0=;
        b=QTpId1RE6T1nRmPPMUjuHE5ouaNrjjiq59Pz6+vXiM5WC2z2oiN+wUmwOsGhZinsOX
         QXvQh3DHY+i/g1sy5Ty9+P5LPCul35pN97+a/4YR5DOtWMcbfaY0DKwUT7N3+beLLT60
         U2fiHa/wwCA8XO9pqlD0XSgImVKo5rAi7T8B35rUVkbY6pw97GeYajS77fYP1kYkor5V
         fyAtcZ9eOQiJfScvF4IZuBpNWrcJ/SABneI8uB7L4lApPqUgEbomKZs8kju+x4GA8cuY
         UBBzW+umLki9Btm9KHSuMiWML780Fcq42bLNUwzqmVAmoQJdDrgx/2Kt4nIfLWkYtgf8
         F9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iLOqHU1tk/AJz68/ud/iFS8k8mU5vLevr7eNlqKJAW0=;
        b=Jd/6tQSyw0wYWLWzrZGsMURCNzBDcbjj60Yg/2R3gWjUZGbQUSOTJAQP8igHL2RQ0k
         u26jhbJ0sZ60Z7s6IxC7iY7xehrKIH8QyOaRbLXYbPIA1pXIVPPS8AAtLx1lBZiqOMiR
         lKAIbBdF3Grk8zpcsi/YvaL5F0vt4rIaC595lRwFSq/6Vo+xxu3cjExGL41uQ3f6kLKz
         qvK2aDC8xFmrUCaV6bJZwIXx+qYhU8VocVZpdE2poOIFGX4FQkMK2mb+MGN1LHqVX3QB
         kG1NSGCnsTTO3Tx0h3m7Y+l6zLF/pIQ7b61yTJ/YCsbmSW/w0iXQ4T2sgbQBIZOP7rNo
         S89Q==
X-Gm-Message-State: ANoB5pnlN+RjR/JP4vcyPr2SIJz+jZmVMBX3JOfZm7VfhcEBxp79C8lS
        gW60ZTTWSMD+vZhXKGhejaE=
X-Google-Smtp-Source: AA0mqf7JCODsPMlVjPeI01VRgoosZS9kxy1/2O2yaQXA2bRmrjVsWBSuQv73rghdqgWrVixyRSrp4Q==
X-Received: by 2002:a17:90b:4b42:b0:20a:e38c:8c5f with SMTP id mi2-20020a17090b4b4200b0020ae38c8c5fmr62292579pjb.217.1669668486801;
        Mon, 28 Nov 2022 12:48:06 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c10-20020a170902d48a00b00188a7bce192sm9264970plg.264.2022.11.28.12.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:48:06 -0800 (PST)
Message-ID: <f2e3bdb9-fc96-42d2-a143-e13b143c8cb2@gmail.com>
Date:   Mon, 28 Nov 2022 12:47:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 10/10] dt-bindings: net: mscc,vsc7514-switch:
 utilize generic ethernet-switch.yaml
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
 <20221127224734.885526-11-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221127224734.885526-11-colin.foster@in-advantage.com>
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
> Several bindings for ethernet switches are available for non-dsa switches
> by way of ethernet-switch.yaml. Remove these duplicate entries and utilize
> the common bindings for the VSC7514.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

