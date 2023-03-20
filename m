Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06836C21F0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCTTwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjCTTwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:52:07 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68623ABB;
        Mon, 20 Mar 2023 12:52:05 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id n2so14662532qtp.0;
        Mon, 20 Mar 2023 12:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679341925;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j8jUicB+IPJxTf7PwnGnXl39ZOb2YWmdHBGk465kB5g=;
        b=W7LCxEgx5/g0MMiTNJ7pywK7hLQkNLJCc5WHaohikApgkuiDoiMvzcder7IIvHEJfN
         Z/Ik5RJRSTA7806B/zzZTS6BX7Wx7NHV86pueoSAPzZ6Z7Dw9qBrTKU/lcl7QgiWnT2u
         9TdTDXJyiC3VEN+PvZ6nIBuq0cLjLID6PNUwiix+VY8gvixUPtrBBeiO19Bbr6ahwk4c
         0h1G+cROHfg+28+qRQFJ49BozJYDU3c7w0YX8dx0d5Bx/iUT5Md9J9bHqs0r3EnEtajA
         aJHY9zEnOi/Q/pxJKPYArAEyPSLFBbuqAyRWTJRTLgz5FxcdJ47yoERWXZaKx8oearcw
         zRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679341925;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j8jUicB+IPJxTf7PwnGnXl39ZOb2YWmdHBGk465kB5g=;
        b=gTO9t30k5Qvr0glhycMgeNBq3KtNLlyrBMrqevgVpgjQVEVVU1y1rSKhAYAir842Sn
         tyr+bCKsJWbclZRuXv/iL3RGUMqceqQ1uoj0CePmOs98r8IaG01KeRDrdX6tz4hyu4Mg
         KMTPelQZ852ZfxXeMgNl6ueTrk3jSDCybSm7xmBSvBSUzWyJF429HgDITrTKEoeQwj5a
         5Vv6KrbRXeE9b1MUVzqdb1h3NwpiM+r3Ad50lK9P4ddALVQ6IjP0aHDqYoKwEX1urMSc
         EuHh/9Q6H5jy43vE8TVoiSOreMCwgrD6oS/2peuebSat6v6Vn0gu4aRyI84d3xor1rWm
         9o2Q==
X-Gm-Message-State: AO0yUKVMmwalHuGMYbsrHCV5za21tpygo7ZPeK/kmvBMLmcBWCm+R8GN
        FNt4ibFpq1y8pzuOlzwDLT8=
X-Google-Smtp-Source: AK7set9zeVpSTRFohUJpZceK/u41khtAdy6nPu6gVoCCbF60M8XC1qNeDjgR49HSxX0X0uY7HsBU7A==
X-Received: by 2002:a05:622a:1a9f:b0:3d5:ff70:88f2 with SMTP id s31-20020a05622a1a9f00b003d5ff7088f2mr1370407qtc.17.1679341924800;
        Mon, 20 Mar 2023 12:52:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w11-20020ac843cb000000b003d8f78b82besm6928788qtn.70.2023.03.20.12.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 12:52:04 -0700 (PDT)
Message-ID: <3d3c6618-7538-72df-6346-d6158e37d189@gmail.com>
Date:   Mon, 20 Mar 2023 12:51:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/4] dt-bindings: net: dsa: b53: add more 63xx SoCs
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230320155024.164523-2-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320155024.164523-2-noltari@gmail.com>
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

