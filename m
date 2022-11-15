Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E402E62930C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiKOIOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbiKOIOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:14:42 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048AF178AC
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:14:42 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id j4so23312259lfk.0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NJUghkSUxVBongGauUcPJFS1lAxj3QqixAvKwjEubTk=;
        b=cBBk8m7XmoFr0+Q0ylI8LxpLDJUcMCNuSMdeEOxc7yPbXe108qVEPbz/Z6pO+ZkKDu
         5Bm3b5piP5RfvOFy9vxYmn0K5jEvQQfmCFta7dwmVl73PkoER5d9jwGgxl1UejDOns0x
         wOG6xEr96rU+0FM0s/PmMjUeV1dg1OZw4nMZQjURpmDPXfmWNJNLM8eUG0WmCMYkqUna
         jbtGKlSX5BmhDusrCOZzCiY9DuF5xIZA/SGKWlkX4cxF+zqEPFrHY4iVuCmc6jzr3ehb
         h9bHf/CliNnllAVzMEWvcEya9wZ8tMaKd2ZAhZAAXJRYoSiv7WcLkW0yTxWL3CBsrylc
         UjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJUghkSUxVBongGauUcPJFS1lAxj3QqixAvKwjEubTk=;
        b=F5vmM0FzTUMEvyZC79McO/fgjGKyOIwoJIBZki1iznPyNkGB6we/A+fQjFHmba1COJ
         1ffLnZwC7R7NnU9T5knJoXM6RpQ3/hvUwCdHuArtoJ7MtNEDmSPg7NV0wx5fcKm+1O8A
         XY6hChJfvYmr31BXhHVbQTYAozU9kVnJiXM2nH7XHDCWKqbh/g0AEt3QUu5flproFU4h
         9/9w/YUW8Ikb/42/aoJp9DianHwG2S2kvQoy8drswlLYovMzmJRo4X4NGSwhNja8K66j
         LY5tF63osOwXihAJzTCK9wsJYySKVqbiEOdR8eqnkvWOwctTiIyjE0N2gXG8nQ9Idg3d
         27eQ==
X-Gm-Message-State: ANoB5pndequPSd+FHmJmgPeuGPgpkGxP6vIxn8e1AgdRdmIrt7swhm07
        wgzwH43innEgP/COnkoVpPCZBg==
X-Google-Smtp-Source: AA0mqf6iiVRtWYnFEeY/1qHlfmPtscw/WYK0aqkvWvSBDGallokd8rzcWtuB1eWPEgrVm+gOuMRJWw==
X-Received: by 2002:a19:f24d:0:b0:4a2:4d28:73b9 with SMTP id d13-20020a19f24d000000b004a24d2873b9mr5696619lfk.690.1668500080348;
        Tue, 15 Nov 2022 00:14:40 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id a21-20020ac25e75000000b00494603953b6sm2121955lfr.6.2022.11.15.00.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 00:14:39 -0800 (PST)
Message-ID: <18ed041b-1ebb-910e-b426-c284f89b11cc@linaro.org>
Date:   Tue, 15 Nov 2022 09:14:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/5] dt-bindings: net: ipq4019-mdio: document IPQ6018
 compatible
To:     Robert Marko <robimarko@gmail.com>, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221114194734.3287854-1-robimarko@gmail.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221114194734.3287854-1-robimarko@gmail.com>
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

On 14/11/2022 20:47, Robert Marko wrote:
> Document IPQ6018 compatible that is already being used in the DTS along
> with the fallback IPQ4019 compatible as driver itself only gets probed
> on IPQ4019 and IPQ5018 compatibles.
> 
> This is also required in order to specify which platform require clock to
> be defined and validate it in schema.
> 
> Signed-off-by: Robert Marko <robimarko@gmail.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

