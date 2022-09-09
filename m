Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B845B3530
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiIIK2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiIIK1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:27:52 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81E012EDAC
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 03:27:51 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f9so1192090lfr.3
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 03:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=MdgTqWa8PMe5m9lGLQyBMeaM+KoNXQu56hVGmJIQl88=;
        b=yf8TXBaiqNxkECQJxgP7lb8OknI0N2YcxNkCmHQgudtOJ6rVVz6MGdrxhWHe/IitI3
         MyacPiSkU8dQ7tzFxkRHHkgLEc8Nz+oXz4oERi/SovxXXY9D5XXyThDKgIzLCplkSHge
         S4OSL4U6+o0QVoN2fz3Q4v2HK47dXWDdDXnXn2r+S8OYnmXTfpyjLdYUGaM5OtDanar1
         c61+8WcvYf4Jx4NukG04A3lxrVconx7yqrELVHreuug2ZGLbwnmlawh+OwkeEB/FbSIl
         cNSZeVcOiN0Zv52+Ge3/3HAmxFfToXMcrs4mv9ARB6jMW04n10sXsRj/Kh3XNbhlQj5y
         48CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=MdgTqWa8PMe5m9lGLQyBMeaM+KoNXQu56hVGmJIQl88=;
        b=AnALAPji9jK+2OP0IAUtr0SeWYaO6pXlm26ndx346y5Kmgr/on/J7bQhd0pD0CFu3B
         JMJencD0SrF0E7rZyWB0fdtx626O481QomaLhfFlgYhB8B38+0dAhFH5/sIcF0YdG51a
         PvhYSfYLBG7XPm0R5V5t/wzubSGO/fUkADSVwhe4XbtWiUiBEQKLbxhesxpXZ98LUTzS
         sv6dvjIUVeuLJ4B2FCtNt2sH+3MeA6CEXsJ6x4AJiRmvj8iw3372jW1VDTqpxELGvDZM
         WTDfkyXqYSXetbit3MSlzFNYPvl2/uFsahDs5AwdadkhLHY3HJ+ZD27ijkM0vWZLXEpK
         tmqA==
X-Gm-Message-State: ACgBeo0rnyOuwWsp6ORDy4nkIZo8xxoDQM4KoB0jLxAjlpU1QeiNh/JP
        Jk3eOhq1tfgi+Uad6dBPspvOYw==
X-Google-Smtp-Source: AA6agR4SsKCc+VU/xIFD0O9P6fQMp97CHSWUPhr8bbjRiSarVshTWmX0DTYjn5TzQLL11mwr9Mz1zA==
X-Received: by 2002:ac2:46f9:0:b0:498:f633:8136 with SMTP id q25-20020ac246f9000000b00498f6338136mr1330606lfo.117.1662719270311;
        Fri, 09 Sep 2022 03:27:50 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id m18-20020ac24252000000b0048a85bd4429sm27356lfl.126.2022.09.09.03.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 03:27:49 -0700 (PDT)
Message-ID: <df504a6b-fda5-adb6-6367-d75d35fce65a@linaro.org>
Date:   Fri, 9 Sep 2022 12:27:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 2/2] dt-bindings: net: renesas,etheravb: Add r8a779g0
 support
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
 <cddb61cd9702ceefc702176bd8ff640c4ff59ffd.1662714607.git.geert+renesas@glider.be>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <cddb61cd9702ceefc702176bd8ff640c4ff59ffd.1662714607.git.geert+renesas@glider.be>
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
> Document support for the Renesas Ethernet AVB (EtherAVB-IF) block in the
> Renesas R-Car V4H (R8A779G0) SoC.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>



Best regards,
Krzysztof
