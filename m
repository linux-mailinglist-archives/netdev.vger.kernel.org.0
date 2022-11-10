Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6BD624487
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiKJOnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiKJOnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:43:01 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541AF54B18;
        Thu, 10 Nov 2022 06:42:57 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y13so2331736pfp.7;
        Thu, 10 Nov 2022 06:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OtdUIheOaMsS5I9jJzKhlaAMYdylOGStK9YhoGM9JeI=;
        b=FEY5Y3bbfQIm36ePSC39fQx7OhKz0f9fV96OCt2j1XdxbSpNb9wfQUJSfWSHA+5cHn
         89n510d5Q7u+f5gHtzFPV9okiInWC4qMx9DxSO2LBgD6GeE6Po4aNp+oC1F3B/b9WWMc
         9qajTeL8ZiIDx+087m2vBj+KdFcrdc4cmARnIutulgDkRjmTYigb8m25D3acLy2qgJm1
         ch4jAmSTn0xKEre/AyyrQHe89gjFj6Ecso39xESbl8mq2fJpZ7gTsqx/VFprpdvfiW+r
         6l0gtdbvwGplfFX+/4oyGnsqYqyF45kyZNzkUdnS0UbGm2pdpgLMeIJLn6Qb0566bc/l
         qSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OtdUIheOaMsS5I9jJzKhlaAMYdylOGStK9YhoGM9JeI=;
        b=xMHOpuYER4Oj9CFODGAMcJFpKK7BkYXzEnE0j7AGpBz2QMUDLtwChofHDreHdbw1MF
         APNeh28hklcgRAZ1Sr2++6z+hL/vRMnOFW6c3WUQi8XZmK03qZDKqhYfsIGlNOdLfxY4
         t1pqQqx63Skb77yUgHHfe0WMvOYCSOuyMAG7fS3YdnzdREKvtc2/fYbNrinEAmpsSgGu
         gs+AE4Tiezn+So070s0hykmSiOypCpBciSfsH3V/L19keLad9YcT8k7qaki2WQmiC60A
         JJSQWXiDKqfu+j0ziP1soPH01GOyWN/dSWzdKF9jQiSKsLoIftr5lrzi4q3pYf0GcHXD
         NU1w==
X-Gm-Message-State: ACrzQf3ySFqBrGduuAldyRY7aBtrE/h4StH+THoJzzBnRIPvYQk/aj2N
        GGl5KoTkdTJPKou29kmoOj0=
X-Google-Smtp-Source: AMsMyM6W8rRxr+dZWfc2ZjWd3PWbykt4ZPeF+BNPqM3QzCvVHj+nal+gDERdc+MoNwpYAItWZvUHxA==
X-Received: by 2002:a63:1810:0:b0:464:3985:3c63 with SMTP id y16-20020a631810000000b0046439853c63mr2669153pgl.141.1668091376720;
        Thu, 10 Nov 2022 06:42:56 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:c0ce:1fc9:9b4c:5c3d? ([2600:8802:b00:4a48:c0ce:1fc9:9b4c:5c3d])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709029b8b00b00178b6ccc8a0sm11298765plp.51.2022.11.10.06.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 06:42:56 -0800 (PST)
Message-ID: <5953e7f2-8377-cb25-6197-de5dfbb9c12a@gmail.com>
Date:   Thu, 10 Nov 2022 06:42:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v4 3/4] net: dsa: microchip: add ksz_rmw8()
 function
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arun Ramadoss <arun.ramadoss@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20221110122225.1283326-1-o.rempel@pengutronix.de>
 <20221110122225.1283326-4-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221110122225.1283326-4-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 11/10/2022 4:22 AM, Oleksij Rempel wrote:
> Add ksz_rmw8(), it will be used in the next patch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
