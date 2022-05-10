Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A9552121E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiEJK1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239852AbiEJK02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:26:28 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C4F11160
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:22:31 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id m20so31946860ejj.10
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OvSokG1YfB+jHNhhvCDMkjSiYIJPjRlYhKEW+jp7CfM=;
        b=ALcEm2b+LDbs6Kfb1KW0mtOim1GJ8wwRSoHjZcZ6+YVzP42miQkDmiAh2YdrtRww/A
         S61vqD4eT+3qaf3uGAKjdAdDW6xNaDc+DMxsFB9xP5gcBWq0Y/snVrxaxTUs+JQadz1E
         5bgwZ3Pl8ALnSFTBrCl8XJzgqpuk64QGSqVraq8KidmEgVuCa7lqAGRbS/96nyuh+Bxw
         k3DNzF8+LY7qN9YJL45v/uE2dUgKkfxwWWwmhtZ4oU49kzmQIVCwFxMdy+ZevSiZJO28
         7DzsffF923WUkTXFAl2/AGVEdqV1LqENga+yq0hxzjb4yGXP0CgpsG8Y9RllWvIK4MyI
         7jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OvSokG1YfB+jHNhhvCDMkjSiYIJPjRlYhKEW+jp7CfM=;
        b=KCwL3If2gSaIoZ8aLHWtvBFyVX/qGrNGQlK5aaORaWhfeeWFRmvjFXQY852FUEBtw5
         MrE8U7V3MnlKhjO+0rkcGgJ8VR208uFJYOSLCziNEk0rClb8QPYNdnkksth/nR0V6ofR
         LPvsriUIv8fHal8zF5JCHqzMNKId5FWgfJ6cb5vhfsqEwA3y8zKO4+YGAx49MjUDu8wK
         1KqQLZ90HyOXp84XFG+YD1i1l/s29j1V2uglOHyZ9i3JXWoZjG7AmRnKo47mjCimqmZR
         C9lB86zUyQ+e8h5xQlB/LjNDCjpndR4DW5q1VqlZGXnRfZB9BTQFfbimtgOZf9il2PLz
         oM1w==
X-Gm-Message-State: AOAM531kjkQDPDPOAHC8pmL8ydIs2R2Q9dBHyaUDrUmrdFj9BHk/iBXo
        hpY5Vu4SCyFn8fMtEnxsGYgsZg==
X-Google-Smtp-Source: ABdhPJwdEDaYoC7Zg2EK1wrimzQJdsgTLpx9taU+t0HUbDgVZOhF1i2VbHN60MOl6/OsAKLnFo5GQQ==
X-Received: by 2002:a17:906:c114:b0:6f5:db6f:71a1 with SMTP id do20-20020a170906c11400b006f5db6f71a1mr15992181ejc.338.1652178150278;
        Tue, 10 May 2022 03:22:30 -0700 (PDT)
Received: from [192.168.0.251] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id u5-20020a50d505000000b0042617ba63cdsm7444920edi.87.2022.05.10.03.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 03:22:29 -0700 (PDT)
Message-ID: <e3c8a914-b5f0-b96d-c90d-f2d25ca682a3@linaro.org>
Date:   Tue, 10 May 2022 12:22:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock output
 properties
Content-Language: en-US
To:     Josua Mayer <josua@solid-run.com>, netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
References: <20220428082848.12191-1-josua@solid-run.com>
 <20220509143635.26233-1-josua@solid-run.com>
 <20220509143635.26233-2-josua@solid-run.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220509143635.26233-2-josua@solid-run.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2022 16:36, Josua Mayer wrote:
> The ADIN1300 supports generating certain clocks on its GP_CLK pin, as
> well as providing the reference clock on CLK25_REF.
> 
> Add DT properties to configure both pins.
> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>

Don't attach new patchsets to some old patchsets. Basically this makes
the thread buried deep and possible ignored.

> ---
> V3 -> V4: changed type of adi,phy-output-reference-clock to boolean
> V1 -> V2: changed clkout property to enum
> V1 -> V2: added property for CLK25_REF pin
> 
>  .../devicetree/bindings/net/adi,adin.yaml       | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
