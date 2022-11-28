Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B145163B39A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiK1Uog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiK1Uo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:44:29 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D59C2C670;
        Mon, 28 Nov 2022 12:44:29 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id g10so11350361plo.11;
        Mon, 28 Nov 2022 12:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nBb+P0/n49Id7n7ZlG8fSGtAH3uSOCjmcnFinIp66gs=;
        b=fU8qukFdsMAw9M3IR/Uz+aCBg+OcMJv/R1U1B7fnrh1//qeaceCwWyi+wwn8n+b40C
         UvFWgbeALna8ygBhyV2QnUs2CK8C4zeqFevfHGggvBwAtwok3G5ym5TuhvtlZSxPEidj
         mCu78GsYp1MVJYemhrWgsnnS3u9LTlGWraMi1a6FLzTAUX37cEizr1JUxB2WWuMa4IOH
         AAnMB9+pHJiF5iiJa6I3SUmvoOevK5GC276VR+BAj927mGJHbGeX77mAWvSxKPKG0LP7
         qz7gjgE92DWvLbCi18WUNWS4TjfukB6yMOu9d4P1OwrSF/dcn/r2c7azW2G1ikt+rRu3
         Bbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nBb+P0/n49Id7n7ZlG8fSGtAH3uSOCjmcnFinIp66gs=;
        b=m7GvfNQ3LYkofrudwiU3a9LxBqULd6qNhdEzB50FmaH3Eg+PDwoxfg7eCYYk4uUCQo
         8edrnBfa8SvzRn5f5VJmFZxi/C7wuJn7DkULFkZcjQypIJa+sdiXP6OdEmYpeJGKbnkS
         rMCtr+MxedQg4gpINEtVUcNwMDEHxoQ6MFUPGAd5a2sZJK6fuwYonvALd9eZdhHlpXvN
         2kDzun2vflpHSP9tHNVlN8HKeHMJO00x6xWd977Ijn39zjJD7aWh1wf0seX6GrC3YfC8
         2UOR4IpFmSzM2Kq/YE1SfiK2C/nTsqOtCGu7Y7SN5LU752C+POJM+UFczZgA2WNdrXKm
         MF3Q==
X-Gm-Message-State: ANoB5pmMzFXMpPejeTBnQkcKkS/B7pxGJSzBL9aEgnCrzcCcJ72PU8mQ
        OAkkGQ5p9W7E2fSBge1kczQ=
X-Google-Smtp-Source: AA0mqf6vQCiSvx/+6VWhAHkNMd1v1xkv3c2ocMTBBfl1gCa5YPuS3GX/NyDzDEA3kZ6nnq4P03GRuA==
X-Received: by 2002:a17:902:ecca:b0:189:ee1:23f with SMTP id a10-20020a170902ecca00b001890ee1023fmr35017558plh.75.1669668268572;
        Mon, 28 Nov 2022 12:44:28 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c17-20020a6566d1000000b0046f469a2661sm7257597pgw.27.2022.11.28.12.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:44:28 -0800 (PST)
Message-ID: <c07e6089-5d87-2a4a-df1f-fbbd0c94136d@gmail.com>
Date:   Mon, 28 Nov 2022 12:44:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 08/10] dt-bindings: net: add generic
 ethernet-switch
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
 <20221127224734.885526-9-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221127224734.885526-9-colin.foster@in-advantage.com>
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
> The dsa.yaml bindings had references that can apply to non-dsa switches. To
> prevent duplication of this information, keep the dsa-specific information
> inside dsa.yaml and move the remaining generic information to the newly
> created ethernet-switch.yaml.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

