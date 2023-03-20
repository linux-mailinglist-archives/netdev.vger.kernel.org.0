Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588AB6C21F3
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjCTTwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCTTwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:52:33 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE06BEC4A;
        Mon, 20 Mar 2023 12:52:20 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id r5so14619374qtp.4;
        Mon, 20 Mar 2023 12:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679341940;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j8jUicB+IPJxTf7PwnGnXl39ZOb2YWmdHBGk465kB5g=;
        b=iXbvE6qVB7ZVr5FfdG2NLsZZj6VqW4vj7rz8RsfzA/d+NW3gokwPRiHLUafK8T0Z1v
         09aT1FCMX71q62HWfKUoACchAjGKo39yHxyNr5V/Wvx0/lEIZsFfjtOkQRdW6UGQgZeY
         nvMiufCo2s5uGUjHnDdUyU5w+A0FZytDdJuZjHDdzCBF9QaNLR264/ykZzkZj7O93AEC
         CLIbA+HxiNySZMVcqY7LWSjZjM/HvuXTti9Q5UlNIKq9/d3ECYiO1XdrL1qSYxwiU+dI
         GyPl8FtnDeLlfSTonvAOYBWDdmLjFaO5C7JZFCHdYfDpfnMPWiQ5WOJBzR9PB/dni/S9
         2xeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679341940;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j8jUicB+IPJxTf7PwnGnXl39ZOb2YWmdHBGk465kB5g=;
        b=USTvsxgf2ztfcULfaEGDkWfD0n3EKFoMpmqMxBQEK/DlYQ3ykjirwHx7pMOHrF7ANt
         7p8UKsenupeOaKq6zvBCU0jT0zqKsA9bXmKI1fzuetdSue6NMMruunq/wnMN+LC70Nkn
         qNbr8TIy1pzJt3ZuHVPhXeLDwmwhPNXxMrM0PxE4lj2OQz67+KN6Kumg0Jke8eNuUNtD
         dbw5RYWF/GOSNvm36A7PRhI8Qey47vrKthBocTVtAoecQV6Ig1OoidpUmcVX8FNGCKas
         IoVIjy1YZFvO2psahzYCZcOxblcXFNP3qiovBmwoAM5CiykA0Od3oRNdYU2DdgRYK3nQ
         4mOw==
X-Gm-Message-State: AO0yUKVH/RgfMQSaVpBYmxevxWAVsvYBf6qPir16gT430gMIMIANGzCR
        kQq7YO//Mp67M7SIhSL1S9s=
X-Google-Smtp-Source: AK7set+epTucvTFXDIYlnYKC4xZ9PSXRBr7C2QxqgB3nlCulYMfMe2jFLnl3Hdm7mRSWdFnwgHl7/g==
X-Received: by 2002:a05:622a:100a:b0:3b6:36e1:ed42 with SMTP id d10-20020a05622a100a00b003b636e1ed42mr783454qte.9.1679341939960;
        Mon, 20 Mar 2023 12:52:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fp42-20020a05622a50aa00b003a81eef14efsm6942446qtb.45.2023.03.20.12.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 12:52:19 -0700 (PDT)
Message-ID: <74d5ce02-c89d-960c-fc25-ed15a5ecb91b@gmail.com>
Date:   Mon, 20 Mar 2023 12:52:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/4] net: dsa: b53: mmap: add more BCM63xx SoCs
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230320155024.164523-3-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320155024.164523-3-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/23 08:50, Álvaro Fernández Rojas wrote:
> BCM6318, BCM6362 and BCM63268 are SoCs with a B53 MMAP switch.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

