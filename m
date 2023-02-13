Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F281694079
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjBMJOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjBMJOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:14:20 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D139AD3F
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:14:19 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id n33so2192004wms.0
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvHDMUzeluufEeHph0ENumOann+/QiEfW8b/S7gPi+s=;
        b=DqxOfAQDiloqIH1ESZjz8i4hY8LwAwXX0Uj4PmkPJKImL9ngImlmoCt6yjADMW+J6w
         OPBkkP22o9JklNpmrh4Iumkr1YD2S7uBvXsnIPD/LITl8XEboQABQG3fOJ2pmXWs4Yzy
         MOF0lVY5f+5viifXXcXPCv+qdcwieOyCKTfqQi/r/S02KdGPPuVsedVHyiV7Xq8WCuj7
         +Db/eJ8AYJDZ00MFIOSHgLdQBxlM0//LMdPKFHxotBr+iC7zVBmR+uACznh50ZoOMl5j
         xkAvEvn7daCYW4nVODMgN09oP9eo2syMqOdQStqkV/0AM5vugIoaNm6AWkAEawxDRWHV
         aXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvHDMUzeluufEeHph0ENumOann+/QiEfW8b/S7gPi+s=;
        b=6FffXb7oVu4Ps6tUTX9tc+AuCi3hntt2YOXbbIJDtOhMPHLfvXEjAMW6vFbWGkpaZt
         vGkLLcstzM0ShO6LGZaOvfEyh+1Ko9elNhjcyilEpY9HerJU/q3M1uIWubw5y/SmAtt3
         yrbeKlw2twoC29nQaL69Xt6h1rYUz+QEGj2A3SNHwlzN8TPX+K8wxAF50edAIuQp0jTk
         iDHyzt2ee800/dKig2PBXviBiHis9W7IYy9vq4m+A2bzyWVvwtfXGo58lemlHr/+Yp7H
         o5ozJ11+4hMe8BktN9EHCvszujggFWdhtdedUPFFicqCFg7Sl4A0AcMenRp65kjXzvgK
         jTgg==
X-Gm-Message-State: AO0yUKWEdmtjFM+mZNNVJhiBUIh6NWUn3tvNj3ukOT5puv53MHzv2Y1O
        QyV5yIobMnKWsK7f0J7/u+rd0Q==
X-Google-Smtp-Source: AK7set9tgRo5lFAVpgHrCLNyV1ZeygrioZEaIMRiq+ujIM7Ea+or2IFx2u4OpkK9TZuPNQY9IXnHOA==
X-Received: by 2002:a05:600c:1898:b0:3e0:185:44af with SMTP id x24-20020a05600c189800b003e0018544afmr3825561wmp.20.1676279658073;
        Mon, 13 Feb 2023 01:14:18 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id p3-20020adff203000000b002c3f6d7d5fesm10089446wro.44.2023.02.13.01.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 01:14:17 -0800 (PST)
Message-ID: <3578406e-a2ab-15a3-64fe-5873fc26477f@linaro.org>
Date:   Mon, 13 Feb 2023 10:14:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 02/12] dt-bindings: net: mediatek,net: add mt7981-eth
 binding
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <cover.1676128246.git.daniel@makrotopia.org>
 <43d5e9cbf0e75ea2c039ffc632aa5cc5c83a3c33.1676128246.git.daniel@makrotopia.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <43d5e9cbf0e75ea2c039ffc632aa5cc5c83a3c33.1676128246.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2023 17:02, Daniel Golle wrote:
> Introduce DT bindings for the MT7981 SoC to mediatek,net.yaml.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---

Confusing diff but in general looks ok except:

> +
> +        mediatek,wed-pcie: true

This is now anything. I propose to cleanup the bindings first, before
adding new compatible.


Best regards,
Krzysztof

