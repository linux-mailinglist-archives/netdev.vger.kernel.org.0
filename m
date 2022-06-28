Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898E755CC19
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245654AbiF1HvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245621AbiF1HvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:51:02 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6E66257
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 00:51:00 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id o4so12430675wrh.3
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 00:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FPuG2slX+fgnrij7UFSAjejroSuyzdpt+S2NxTs06r4=;
        b=ms+DL1wuK8oZDIA1k/Phb+J3PG+BjucVp/a/8c+3ABKUt1yU4IYe1i7yTrZv+ru8WY
         coDJwPsFyU/b213bbdPwkEmXGSBk7dCdZnRdBJrX5wNVa3N63+RSTT+RmYDPDhsKucsz
         dG07nuD3ygNO5w0AvJCk/lBAymKgnzn6P0BzoTSDB62kYXsMQj0F18U5w/9Yzl3s/NaV
         mplVKXuUPxrNN7SWUhKZ9j1YtpIqgXU8czDZDcIoO1S3k4x7ZI1oyKgSxqHgjK5Et8G5
         23OjOJcgAjhXvHoA2H5IH33lOv+4vL6o4g0twneVOe2Y332BJyiDt1/WkpeMQQp4JvWj
         td/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FPuG2slX+fgnrij7UFSAjejroSuyzdpt+S2NxTs06r4=;
        b=1hYX+TTLqjqH1vltO2DoxUNSEKpJ0i28rTOO32MnLv7A68lbiRyWaYWEN4jhIY1FT9
         JHrFS4mRt1a6lASxZxv/HvVMPcYSSOBFtugwsvOUBJ3GuwrMUBUd2PLweA0S8KqfXN7C
         6eDMT5M3RjqjQRNq4BNytOzNobFJXq87q80qVzovAmC6y9ry9+FK8LzQ9wewN/wbmOv0
         XJD2S4qVGu71Cvz6NXLgkfuECbz25cH+o4oCzH/IRf+EDU0vfAnfKI8nXJ5FCUtdPrZb
         0X0Dh4Ko+9ZAKsqozNu0BoWlPGSYOWR4A/v3aRaxemTyGQLLvZhQNvIht322GXpTY3XD
         ck9w==
X-Gm-Message-State: AJIora+XKcEzOU7tbRM//gB0Jr5TYZaPqdkHZLTGV2ZMnnks3VKGWX31
        E10Wwss5nW5Dd0MO3JJF0iZ+rg==
X-Google-Smtp-Source: AGRyM1s+1Y2n+Dlb2cgUwS4/ez4e+dqiSQiRFZBd1i7u/YwBXsk4xreCIaxAwl8AEWTKNkag9hr6Fg==
X-Received: by 2002:a5d:414a:0:b0:21b:81fd:6b7f with SMTP id c10-20020a5d414a000000b0021b81fd6b7fmr7126184wrq.309.1656402659016;
        Tue, 28 Jun 2022 00:50:59 -0700 (PDT)
Received: from [192.168.0.252] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id c17-20020a05600c0ad100b003973ea7e725sm28172553wmr.0.2022.06.28.00.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 00:50:50 -0700 (PDT)
Message-ID: <93925a1d-19ca-9643-ca13-8de3a4e9ae0a@linaro.org>
Date:   Tue, 28 Jun 2022 09:50:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] dt-bindings: nfc: nxp,nci: drop Charles Gorand's mail
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220628070959.187734-1-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220628070959.187734-1-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/06/2022 09:09, Michael Walle wrote:
> Mails to Charles get an auto reply, that he is no longer working at
> Eff'Innov technologies. Remove the entry.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml | 1 -


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
