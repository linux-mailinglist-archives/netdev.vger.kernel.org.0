Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE9461A435
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiKDWjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiKDWj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:39:26 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFCC24961;
        Fri,  4 Nov 2022 15:39:25 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id w4so3951311qts.0;
        Fri, 04 Nov 2022 15:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6W8E3BDm7E3tarf/V/stdyuuh8cK8rlnERZvAPQWbrc=;
        b=cUxXIm2WtZfDG/i0LrW/TK0V+VkVMvMCB8JPKDfUlueguvq1hgIYgRcpX2BDS0AqzC
         LwYXvIAeono5df3vouEBFf1ZF9eHrInosYkncasdXjwoGlKLg6nheziP88/hjromhtLo
         60XwSaeF9RZXH1ES66Czix/h7TR4qXqwFqpPFgn0WJOuopZH9wUzl6H/cI5se8YluT3I
         Rr4ILEoMuB6jl+tC3KCWCC2IF7B01qanFcyXMXMslS7UElMDtLgFYUuYbY3BVIKBu4Rd
         t18/um4hZvn0KSSn8jjad9cUSax7QZi720lEm1OyCOR1qqpPj68u1cgeYCgHBd/TmlU2
         Qwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6W8E3BDm7E3tarf/V/stdyuuh8cK8rlnERZvAPQWbrc=;
        b=E7CmbbezRctV4MnZlA1OSDIc9AF1TfTNSfWgcCQlXkQb52pJ5CkzdynLDuKfGT/DF9
         /1swgbCwUldH5nsfXaPzb0I3SpH5VsAZE1ELZZIE4XkBMkzdm7aFZGMOQiONZwfNFXRA
         SIma2Uh817NHaDKoXvFD/604Y9g05ZFCkRfWYIYaqeq6MUDbd6BMrrfZ2VsqZ18qahZB
         x4fNLanx5segcmGHiVx3JOkzMsD6RMZpNvduIKvXlGORu/wtkN2fj5BNsS2SLr1dViMO
         dErHAQpuhBlTrx//4pRkhNL68RJK01pa0lWOh4eA1rhGfB6YFxXV74GrPNqUck+Dek2H
         8U3Q==
X-Gm-Message-State: ACrzQf1MoMqr/EtXZVtHkNL3YHxbMXMP/KM/UkbjeH5ddElVNm/nop6P
        WSEYtCLWoagHG2qG/ma+tBAOVNOZYmVFeQ==
X-Google-Smtp-Source: AMsMyM50leLP6jhhQAVr6ZXWpolnuHTEf54nfJnKe+T1i53awPl75TznxftbMLG5GSBV6xVZEUtLjQ==
X-Received: by 2002:ac8:7309:0:b0:3a5:44d0:f000 with SMTP id x9-20020ac87309000000b003a544d0f000mr13947385qto.448.1667601564963;
        Fri, 04 Nov 2022 15:39:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b23-20020ac86797000000b003a526675c07sm393928qtp.52.2022.11.04.15.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 15:39:24 -0700 (PDT)
Message-ID: <ce18eb40-2a5c-68cd-6b16-8cbdb3118007@gmail.com>
Date:   Fri, 4 Nov 2022 15:39:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3 1/2] dt-bindings: net: constrain number of 'reg' in
 ethernet ports
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>
References: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
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

On 11/2/22 09:15, Krzysztof Kozlowski wrote:
> 'reg' without any constraints allows multiple items which is not the
> intention for Ethernet controller's port number.
> 
> Constrain the 'reg' on AX88178 and LAN95xx USB Ethernet Controllers.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

