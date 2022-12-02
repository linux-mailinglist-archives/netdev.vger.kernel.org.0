Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAF5640969
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiLBP2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbiLBP2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:28:45 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C829381C
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 07:28:44 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id f21so7024906lfm.9
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 07:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rhy//qLFittA0coM8TxsRtxZgThmCcgsSfvJxmA9v3Y=;
        b=S9c9YgmdMr0078QQf931B1d/nJtUT4ChUdcd2Z+X18AuW2KC1S9Se8dBucyLWjtzCz
         FLJdjVcWHMoRsx6Wf+qzYN23ibicfn1LF1/xSHIHxcgNE5nHkpLzHcdIO5t37mMZ8ezP
         2eaMrkxXa19S+k3xM3peanZKU4hNlNdK6sWTS1dI6b+quR0Izvg4d5MydObLlVy3yrz8
         2mOsr6uKiql1ztsAX4chrWg6R0Yazb6BKBZYBIglpNmEYsa9GtRpOIQJ/cPlceekWd2l
         oGXH5b8hFyCTE1hUvAIQ+sX5Wb9gLaOdnkZRRBmPNlACZQBZxK+pEzwp1224XNk5FPni
         z2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rhy//qLFittA0coM8TxsRtxZgThmCcgsSfvJxmA9v3Y=;
        b=XbJ26HYKsFfKmHsL+FkHYrDwcPDCO5hr4lRlH76NYyM8vQ/51EMDldNAOYhJPJWBMN
         hhRRL1B7KL9lc+qqJYTcoTPvZLiT9HSuEUx+WjacbLQ+fhluUq2SpWONd4bqymN0i00J
         QnJc5Ie63waADGXHhqddkVY7+UQjdUtfsVbuK7Z/vBhRrlr4k6gy3HjkplXZ0ThXzD/Z
         X5//nPAsuGAlfjBE8X6sJCqMShJ54/ygT86Z3G+eIeX7UQRaA9kOw5WIV+T/VN3wrc8I
         Xob9fu3qgfqQPJJbS0VJZjduC6AZJ7E2YYL6pj8mU2koErwZ5xVjLJM4K3Ai+qqXLwU4
         nfbA==
X-Gm-Message-State: ANoB5pn1Y1QttVhFI+ZQVZz0KuyuhzlGq7xNZnLrydqOfwyjRB0WZZVa
        kuRq1ZA6WCHlzCqEDJfZVA/D5w==
X-Google-Smtp-Source: AA0mqf4FfGzuJktbtBNSonr/Ki1u5N3TeULvNzSjsU3uCztwuxgg9KYN1He2ban3YJrsqY0Bd1V/Ug==
X-Received: by 2002:ac2:592b:0:b0:4b5:5b36:28b6 with SMTP id v11-20020ac2592b000000b004b55b3628b6mr114224lfi.4.1669994922657;
        Fri, 02 Dec 2022 07:28:42 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id p1-20020ac24ec1000000b004991437990esm1059331lfr.11.2022.12.02.07.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 07:28:42 -0800 (PST)
Message-ID: <9aa26e69-3be3-fd72-4085-050384a3e353@linaro.org>
Date:   Fri, 2 Dec 2022 16:28:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v1 2/4] dt-bindings: vendor-prefixes: add
 MaxLinear
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>, Xu Liang <lxu@maxlinear.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-3-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221202151204.3318592-3-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/12/2022 16:12, Michael Walle wrote:
> MaxLinear is a manufacturer of integrated circuits.
> https://www.maxlinear.com
> 
> Signed-off-by: Michael Walle <michael@walle.cc>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

