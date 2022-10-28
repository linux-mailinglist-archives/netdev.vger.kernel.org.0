Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF47611CBD
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 23:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiJ1Vyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 17:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ1Vys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 17:54:48 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC5FB497
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:54:31 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id h24so4343915qta.7
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ypWGFUNGDLHwApi026F7Lg/Q5kEFIG84xDzjJbXD2/k=;
        b=bMfd6Y+8Bb/7mf+v1RLdW/boQm7hm/01WMe8QE0c5GDKd2VGHAtcvI3CNSnMEeEwK3
         JS2/9wDnNOQ2RuwD6QOnb7CN/0VbLdvrbBnuH7MC0x/Z1K2xcbBc0K4JuexgMcHRy9JX
         hYiaUCxQXZ9TJL9ECS/LnDrGcmXdJnx1aZDMz7GZXd1jcD/hp0r8aBwC4MRqceEFyJac
         uhg9c3g3VycO4B0qEaouNN5EaNEAwXhdZiThPIj/M6/wL6bwgzA/cNqCkQaKFAGW6xKe
         T5NSoZbSG39YFqh6xGrL5m2anXvEcgleQ2nnEKbEh7nzpIrZy2ajbBLHUMqucK3eLTKk
         dxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ypWGFUNGDLHwApi026F7Lg/Q5kEFIG84xDzjJbXD2/k=;
        b=umfKhUL4Bpw2GMq265ziGX/8HT8xAwVf2Us3DB4+5JmPYHUIkeU5BuZO68jr2VyWxZ
         FbNmSMA/nsMqaYeoODPMCzIfCE0zvo4kkCAnhXpuyqm7fmgx4gPbelRa0ROVSQF/pVkv
         YmCyUHQyxjn9UvTA7Rx30xzeypoTL9/FCSDDXo0Q+vSqj4IQDRenwtWX6ya7vUqoHPVm
         +Aa8VllEPHR5Ib9XtnSaPj9zzLqVDyHr81nmjOWVf0IMaC1IzGG5RHHuqhX9EGIsKHfh
         O3Qhc8eGn+oPPVNU8p/zJnZpZIV7CxHEyX4468U7O8gsTNGT2PLyIebGGh/CDsSHoklO
         kxhg==
X-Gm-Message-State: ACrzQf1C8JXj8lh4C7TnQgUgySLPWTawISbWYVUDFdQfVHpCNM6Oz9OU
        s2UL63jdaWn5F/6H19azyECBeg==
X-Google-Smtp-Source: AMsMyM44UxC+QbkUhxkJ2SJwwV42LBcRooft0gZyiny7ak1R+Cj0fteS2bzsSPuqL7uPupt7Dj088g==
X-Received: by 2002:a05:622a:350:b0:39a:286b:1b21 with SMTP id r16-20020a05622a035000b0039a286b1b21mr1412784qtw.427.1666994070681;
        Fri, 28 Oct 2022 14:54:30 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id bl4-20020a05622a244400b0039a08c0a594sm2920026qtb.82.2022.10.28.14.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 14:54:29 -0700 (PDT)
Message-ID: <07f8d510-e2df-ed9c-c70b-ba159e9bcb69@linaro.org>
Date:   Fri, 28 Oct 2022 17:54:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v6 1/3] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20221028065458.2417293-1-yoshihiro.shimoda.uh@renesas.com>
 <20221028065458.2417293-2-yoshihiro.shimoda.uh@renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221028065458.2417293-2-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/10/2022 02:54, Yoshihiro Shimoda wrote:
> Document Renesas Etherent Switch for R-Car S4-8 (r8a779f0).
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

