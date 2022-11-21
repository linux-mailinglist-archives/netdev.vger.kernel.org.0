Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDBF632D8E
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiKUUAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiKUUAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:00:01 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D49BC6D31
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:00:00 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id j26so1673014qki.10
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=21RU7vJ9iFeZvyipK6cS/3PJOOe02fnLa62jVzukCAU=;
        b=PKyB5lRuVfncXB4NbYEk11sdQUOvnGL52mcZZ+PmmEN6TwS8er1ho9Jzuwc+X4XwfY
         TZ67ccIOu1jFiv62uJyisxsPmIFneGJm4CZ54NSKZAy5q7KA7VhCwMrFCzqqcGDReEvP
         s9XHr5jzqOAEAiWTsnXAjkx32MKtfyByd7rBoHdzmelod6trU4hcrbPhm2xqAgVGj90g
         eC7alXUZ40kG5UqPyRKCc8igg/3crcr1bMFDVgnaPwCaJUJBHMo3rcn8ObhzDMT4WxpS
         v8KUUZaI2v4ImysGQQiOxXYMprtdK0ERWLHhEsGPdKcSbT8xgyOQL5AIvnDPLhohVl4F
         WIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=21RU7vJ9iFeZvyipK6cS/3PJOOe02fnLa62jVzukCAU=;
        b=bCfalmr5R2pdD5Nqr8eVrjq5jwYH0ANUOiIKH6BxNlqwZv7WY90RmeUkHyJGddWo/z
         2JxO4dTYTak2xfXBP491cElFlNgPbsLJ/pWgTJ2B3Gk+GlfWNQhYThKyNk2jkTvQdjq6
         VcWmUcMyguFSOFxMN183JYFE3PaKuSVoSvfxDFJlABKlTdz22MDs4cNEL/7gXAMg128h
         iuA6k+3C6lSFLNtRoTT1/pG53I0E/O6ywN85A/QxAIW8IS+myoOF9ff0Ge7HARQ4NsHt
         LlAQtxe1HSTXX44q/TzwEKIPSQAv9B41VjIlFh71uDP7dp0B7PKcZOYz+T94+Q60bWw4
         ZSbw==
X-Gm-Message-State: ANoB5pmV9uSaYepW9SmP8rUO9Qq3R2GCzkAtM0PnIhop1Zqen/WCn5w4
        SuKnp8X9jdslUTjbp/SlLTk=
X-Google-Smtp-Source: AA0mqf7gyu/ZamkcNnUUWCqkhS6DZgO2OlEp8eBaMwLIUQEfNiMm8vDV2xiRprbyC9H8TgHl5PPktA==
X-Received: by 2002:a05:620a:1427:b0:6f9:ffc7:a9e4 with SMTP id k7-20020a05620a142700b006f9ffc7a9e4mr54069qkj.277.1669060799768;
        Mon, 21 Nov 2022 11:59:59 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j1-20020ac86641000000b00397b1c60780sm7151750qtp.61.2022.11.21.11.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:59:59 -0800 (PST)
Message-ID: <6784b156-b945-7486-6b9d-7b8fdf2b69ce@gmail.com>
Date:   Mon, 21 Nov 2022 11:59:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 07/17] net: dsa: move headers exported by
 master.c to master.h
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-8-vladimir.oltean@nxp.com>
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

On 11/21/22 05:55, Vladimir Oltean wrote:
> Minimize the use of the bloated dsa_priv.h by moving the prototypes
> exported by master.c to their own header file.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

