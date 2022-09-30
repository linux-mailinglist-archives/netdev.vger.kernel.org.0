Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35115F0581
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 09:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiI3HIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 03:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiI3HIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 03:08:47 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235B31D1E05
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:08:46 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id s6so5506346lfo.7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=92LAtO2Hsf2qxOUype//w1OA04un6BRw7s5gsf1Jd6g=;
        b=O344S7hx7YSjXCMl8MJZ8VA1WZE6DdNQhGZgJ7J4nMeZrGA64fZ/5tZHD7qG7Lm+fT
         bpSMy53kgSCRflniKZSYPjXIL6yzAb7bnf+JTrZHapvFKaeLOEpB1uDdfpQ+f/D+QAF4
         tQa2tEoear3keJJzzyYUbrHC299f26YHAb6OovmJMIpMZVCXX2gRfDsGx7O4mscQdmXC
         tsNwaZYS4DeRIF5CMhzcJMkV1LB6nI5xg8b6wxS7Z2JvPeTkFgicykYfgB7ZY/ubBv18
         sb9jtiJpzxc9AOJe282sTTRf/OBoZKzejFT5OkUS2S1H1WQCXCOf1bK8x8RVMNhLqC8d
         SUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=92LAtO2Hsf2qxOUype//w1OA04un6BRw7s5gsf1Jd6g=;
        b=ecHfJm8dtV2xfXcu3C1XsE+ZcsjYKDxetYAShozd/mPUhgZxTC5aq01AdgDw9jVQY0
         +UVW++Dl5aaDhLYgHrAh6ugPjVECpvIV9VFzlGC6SNWRlFCbpZIIC5p7jBi6LmxJoWZI
         ulkTtNfkOZyiXXgZUcu8J2vwq/3y4PEXNwl59TVXna8zgfflN5bC0nDTl31P6HPYGdif
         0kR/bM6BsyNtiMf8Rk6WVmAaycrm3TBweZ6n1x29FWBxBRQjVBo7iaFTC951Cg/+QLji
         LG5spcfPqZbDzpt/Gno7lSJ+ClCVEiGJNdvai+wn1FaAYmQZupLXzh1xLNmCXHO5xglL
         Enqw==
X-Gm-Message-State: ACrzQf0AjNSAD4HhPaXSPkhAVRYBHX17tQDix9PEbXGFDAj26aI9U4cC
        ByefWKkMgI6fDJRTG1g0VmqrIA==
X-Google-Smtp-Source: AMsMyM53KJgWJaJwUxKWJVUog0nvfns2veqVcGQzSBVVWamNTXQLbDoeciYPOTZEaVkIll8xjhdKRA==
X-Received: by 2002:a05:6512:ea3:b0:497:a170:a23b with SMTP id bi35-20020a0565120ea300b00497a170a23bmr2962599lfb.514.1664521724520;
        Fri, 30 Sep 2022 00:08:44 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id q23-20020a2eb4b7000000b0026c2d2a9b92sm82724ljm.101.2022.09.30.00.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 00:08:44 -0700 (PDT)
Message-ID: <28443329-e8ce-f0e0-f8ef-a80c887f7700@linaro.org>
Date:   Fri, 30 Sep 2022 09:08:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] dt-bindings: nfc: marvell,nci: fix reset line polarity in
 examples
Content-Language: en-US
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YzX+nzJolxAKmt+z@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YzX+nzJolxAKmt+z@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2022 22:22, Dmitry Torokhov wrote:
> The reset line is supposed to be "active low" (it even says so in the
> description), but examples incorrectly show it as "active high"
> (likely because original examples use 0 which is technically "active
> high" but in practice often "don't care" if the driver is using legacy
> gpio API, as this one does).
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

