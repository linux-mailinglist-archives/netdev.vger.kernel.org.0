Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E45632D94
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiKUUA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiKUUA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:00:58 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE571C6D32
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:00:56 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id h10so8719859qvq.7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1UIX4I79tzgfezjqzOL6mvQLJnpPXeBL3ccyYC7TF7k=;
        b=nVjqolMWEkkuifVaRlFA+u8/pjbvlQUXWQdR6gSjyF8hdhYMm+MU54ainX4o2zo1Q9
         XhxKzbT0QbKiHY4GBqMU1+0MGX1RJGlH0A+7Gm2PqoNJja3CqZbAwpRj1YdkOda/UINk
         bwAZk6wk6A5rRrEKEOlRw0n+7AKYpgJN9l/lUo3E4jC3JvcIHrthOYvP94owDJUYQ6qo
         PEhu4IgkBj2Ur8RElSu8RFtRkYIX7NDUae1FclOPqWTLfLCFqBqmBmv9ldD9um8smnMq
         GW/joy1b8MZwD6/KLNnTG15+PB1KaPeGtmSmsVuasCGZXrUuwhkAlsaShecTMHlQT93Q
         xJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1UIX4I79tzgfezjqzOL6mvQLJnpPXeBL3ccyYC7TF7k=;
        b=I/AalxtxuZzP5FNWAhoSeyuXsiZKkYLdOWnTonJZDhVPH4YBrz6MRJB6dpFQAIWJSB
         FXFWXbV4HSlCWQLVp0axl2TwonLSETD9mYeYMAx/IwPD/Y+dUnilACHoMs/ibVjma8Dw
         K4IWkTg5VrmFtuXt3tU0IFuzu1r9nYeEFMPVGXSbsf5K6YxgRRusfC97qu5fYplKyVxz
         nnn80VAsIILl9dUyhdVT7wVAN7q6m6cQW+JdjeTA4Pu3oSR/BN/QRRiRJ3VbI9lCRfK8
         Cc8KYqk2QzJ5bqyIO0ftZKLdij7dps3gdBNKcUym0z2/N0CVn7vTOIoHemyxrIuawaio
         qm5g==
X-Gm-Message-State: ANoB5pmlG/nxcS0ugBf1Q8Ejfl8QuBVOdA+VYtwACwum3XT5DxkYOpmX
        p+KSwjf9gg9i5MiCjFB+hoW6b8Xb1VA=
X-Google-Smtp-Source: AA0mqf4W28wltTTXh7jKy88k+PWWnWbPLPpyXiO+RTqQebUHD0mJuOWAHqC0GD1O1ncUD7I0G3MJ1Q==
X-Received: by 2002:a05:6214:5d8a:b0:4c6:98e3:5ee9 with SMTP id mf10-20020a0562145d8a00b004c698e35ee9mr8333381qvb.10.1669060855576;
        Mon, 21 Nov 2022 12:00:55 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v20-20020a05620a0f1400b006fbae4a5f59sm8725454qkl.41.2022.11.21.12.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:00:54 -0800 (PST)
Message-ID: <9b619f22-6234-e6ac-74ee-d654abafc453@gmail.com>
Date:   Mon, 21 Nov 2022 12:00:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 08/17] net: dsa: move headers exported by slave.c
 to slave.h
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-9-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-9-vladimir.oltean@nxp.com>
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
> exported by slave.c to their own header file.
> 
> This is just approximate to get the code structure right. There are some
> interdependencies with static inline code left in dsa_priv.h, so leave
> slave.h included from there for now.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

