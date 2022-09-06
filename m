Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AB25AF635
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiIFUid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiIFUi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:38:29 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA45895C7;
        Tue,  6 Sep 2022 13:38:27 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id s13so6034237qvq.10;
        Tue, 06 Sep 2022 13:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=h237n7/UKMUwrtK2SdW8VgK2awMEb5gtKYbegstNBYY=;
        b=lCUlfk1RNpuxwAiYCvs/3Af6ZbW9gCaXR/t4W5EZj0lvBH2IGsJKDmR0RcAgRSdjbG
         FIpDo9RB+OvUpMm3j3sp0ux9UB/EVGw6dw13YTCzjzUwUEUN8MpSur1hoUcF8dI+74ED
         BdnCwwU3de5L7GIapuk4DTxRQ5GvNLcLJak13f6Pzq46uyjgbaNchtVelkZ0LouCTEtk
         XinXrlCwiEKpdYkM7tWtGyPZUnAKprJ2+bTbUMnVyHrKJagiLap86OFpO5+gsHHG5YvD
         iWNkKF+Z0KCIagRozUWrRO9QgDLOHaoW2xn1lFtbOEB1DfDwB85A0OMG14DiKOH1JJau
         TEXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=h237n7/UKMUwrtK2SdW8VgK2awMEb5gtKYbegstNBYY=;
        b=GH/gVftDPrN1Y/G3odNLpnI/hmn0mLqaSdHQviMxmFJ/Tt8h9afEEEKNM2Ny0OtZpH
         a+BM3CeKCtercFALQXFr63qXYd9rbNvlLPRMjUs32FXe8su/VFjkxEE/UITBPuTZpSXN
         JZrQ7noD+RBhFmju3e4Unw1dQSwMCrQTjwYjaiAc0WEKOWyfNycjY6bG/eXZWFQ/7c1v
         VvRWdB2Nq9C2aIpF2Q17qTqiHRaTTAn4P/onV3bssgUnWfPlf8iz2EcQ93SqcH8P2Fqf
         hRWk+9pkFXNwY2BmsfrnGjwaX3+b5Hd3wLeUhkwuouzjWdt7Eqlrv6kjS5Co6Slbi4tV
         Xneg==
X-Gm-Message-State: ACgBeo1FGfmQNGXY2c8clYODAEYrH9aQFx0YcwIT5AeUCTQa/9u2LhbP
        Z1r3++HR1p4ey9E+4V1cNTA=
X-Google-Smtp-Source: AA6agR4/gnXe/kw9M8c9Ft8wZy+DRa7WhO497d/AyApMFfagKNLbUVb7qzJX/XoqxQvZyYcORdmRMg==
X-Received: by 2002:a0c:b2de:0:b0:499:363f:222f with SMTP id d30-20020a0cb2de000000b00499363f222fmr319781qvf.73.1662496706717;
        Tue, 06 Sep 2022 13:38:26 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bn5-20020a05620a2ac500b006bb41ac3b6bsm12005175qkb.113.2022.09.06.13.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 13:38:26 -0700 (PDT)
Message-ID: <9df7311e-3b8c-40e0-d100-b8dbeb24373e@gmail.com>
Date:   Tue, 6 Sep 2022 13:38:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v3 04/11] leds: bcm6328: Get rid of custom
 led_init_default_state_get()
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gene Chen <gene_chen@richtek.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lee Jones <lee@kernel.org>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
 <20220906135004.14885-5-andriy.shevchenko@linux.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220906135004.14885-5-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/2022 6:49 AM, Andy Shevchenko wrote:
> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
