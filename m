Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38415B352B
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiIIK1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIIK12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:27:28 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848099C2E3
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 03:27:27 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f11so1914274lfa.6
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 03:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=vcvSVO7eEwUNctjKRZT9oELQ2OBzLeEtMGQY3Kqpv3M=;
        b=MQEA8b+S7mOgyZq+pveaQ6KenuHKP6w260v1W3xdsdzLBQnX8eGIamKktCN1o1RwnG
         m4lZzn6MUZhQWDl21/lhmTwADZQ5ro9KABntVVr08uXvnA6E/dtXXdEES9k07tFvWBUG
         qiAhUTVzNLA7+U8EySD1fR0U+z6f+zJ7d4/nI6fT2RgMkwirL/YnaD9gNV8R1haPh988
         p0pFheYd0pLqhFsaAVkdXVVw/TZaGbxhCH4j/k/wSZ7qr4LbA2IGjtJPSpXqlHiMbtRd
         U/8YZMM3oOmv5uZ1KWYz/BnML0EpI8TyckVHATCzTRnXkLP9iaJRNRHc59sIspRJFJNr
         YF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=vcvSVO7eEwUNctjKRZT9oELQ2OBzLeEtMGQY3Kqpv3M=;
        b=aOVTV6f2dY8q+sEM8u3M5xyF9BGeUsbodC2BNwVzecNnypwH80BXadisYNkNb8HAU5
         ozIoPDcf+lx4+Byi/wkLSFBF7rNJvg/m1AJRLwtIOsF3QOkaeF5loQrSrzS/uMSOeyFm
         KAT4DbUDuAJBkRFCCmqDp6fjBAUhAHQ+ZtSy2VsOEg6cWWhxyBTakVXBt15Kmn1aE+DN
         g2Q0IBHWoQQGxLnVEtrB/upJ2wUg9KvgRE3xrwWTXNExiFby3TB1lkPFSChBIXLeDmcL
         h6cR7KN+SGVduOpOMQ+C4bfEn/rSlGcQGofU3UbfoJhCPzszTqcBQR935v6VBcL8Sskn
         y5eg==
X-Gm-Message-State: ACgBeo1mP2wkwkjE+SHA7UgbCrozUbgV56CC4HHqFWzFxelDYgu3vmns
        foWK1jG9Kq0EdEjuw9Ig8jh1Vw==
X-Google-Smtp-Source: AA6agR7NSE7pZiygumw2uPQ5r3/8TC7NVPWJK3dwjIxzt9NMfVnnSA4nT8tJOPzzhyWVwrX4PWqskQ==
X-Received: by 2002:a19:4954:0:b0:498:ff56:375d with SMTP id l20-20020a194954000000b00498ff56375dmr332038lfj.626.1662719245912;
        Fri, 09 Sep 2022 03:27:25 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id d15-20020ac244cf000000b004946a758d21sm26038lfm.161.2022.09.09.03.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 03:27:25 -0700 (PDT)
Message-ID: <14906209-bb23-f223-4384-e3c4906eedd5@linaro.org>
Date:   Fri, 9 Sep 2022 12:27:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/2] dt-bindings: net: renesas,etheravb: R-Car V3U is
 R-Car Gen4
Content-Language: en-US
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <cover.1662714607.git.geert+renesas@glider.be>
 <5355709e0744680d792d1e57e43441cb0b7b7611.1662714607.git.geert+renesas@glider.be>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <5355709e0744680d792d1e57e43441cb0b7b7611.1662714607.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2022 11:13, Geert Uytterhoeven wrote:
> Despite the name, R-Car V3U is the first member of the R-Car Gen4
> family.  Hence move its compatible value to the R-Car Gen4 section.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 6 +++++-


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
