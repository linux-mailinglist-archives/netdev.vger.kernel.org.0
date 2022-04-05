Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975A04F2375
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiDEGj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiDEGif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:38:35 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5011B7B2
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 23:36:27 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ot30so14600740ejb.12
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 23:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p96Qb+2waIFdLUNr/Whq+HAPEFx29+6l7nktGBs3fKo=;
        b=ajaM0BOA1d5m5mgqdFrSy0YhOtUIz+GW3qLjEJ1XA63aWgHxR9lXR/JCmpTKcaoteG
         oYbV76JF0XPcYZRy5N96LvMabZtvVP8WMtBuUwh3Y5xhHevFtlMEmcZKB9IIluggE6Oc
         4TS7fpyu09nVaBmU9VQzDNHVJZteJGr0Qo/0AAVVDDyNzVzI7kVtzuLgb2bmGbu8+3Hd
         aKUyt1OBvnnAAf+lyzgrkjiGVsxYbUcq8TjZ8cclDoiQn6xVk3pdiXmmiXOrUHMQu3Ga
         Fvh8fPy2xtS2jdvnqxCS+XTj8k2yeeGRP+d0QSuDgdcw6pzkciZwv/iYj43e1RTfX8hs
         5dsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p96Qb+2waIFdLUNr/Whq+HAPEFx29+6l7nktGBs3fKo=;
        b=YAEXa73IwXa97TWavpHpkL7DkcerWN4blAhHn/DKoErj7V8cQexVWQFSH3YArYOZmU
         9/eTXr74W2u7E4yjxaHPshRH63trRAL1//eV+kqHOKg/CQ7Uh/laTcwg/acPQ552a681
         JKfdyHmpZ1DieJC0t0+tJ1xjljd8ymy5LBAhEud89a8P6XFTDttDTyUlJ2JFC74wtIrb
         sH5LNiw4q7cSgKZDeVkwFpnA50vyZYTyMmfWdbrGBZpvhUvPe9ay9EhSxL3mrV0TVOyF
         gYIFMYv6cwMNO6YkGgce7ZlyugKZtOsZ72lv2lhbZC4UkIVtDURldjQyeSrAJO/L5uK+
         dMTQ==
X-Gm-Message-State: AOAM532WFrn3oEvl0Sb++6+utLO3OJNX7xbOUin79/UAZX5iyARJRUpG
        ktB2SVdisdFD1ypVTNVRwfum9g==
X-Google-Smtp-Source: ABdhPJw0/GPBEvRsgoQi40HLx033wJQztRvi1gzWeoU492E6b4cgltXZiWyqL4htriqQ00lUp2kgBg==
X-Received: by 2002:a17:907:d16:b0:6d6:e3b6:9cd8 with SMTP id gn22-20020a1709070d1600b006d6e3b69cd8mr1967623ejc.94.1649140586057;
        Mon, 04 Apr 2022 23:36:26 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id dn4-20020a17090794c400b006dbec4f4acbsm5228336ejc.6.2022.04.04.23.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 23:36:25 -0700 (PDT)
Message-ID: <6c5c395c-0857-e70c-dbf4-d21fc4d2a619@linaro.org>
Date:   Tue, 5 Apr 2022 08:36:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] dt-bindings: net: snps: remove duplicate name
Content-Language: en-US
To:     dj76.yang@samsung.com, "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Moon-Ki Jun <moonki.jun@samsung.com>,
        Sang Min Kim <hypmean.kim@samsung.com>
References: <20220405061922.27343-1-dj76.yang@samsung.com>
 <CGME20220405061903epcas2p345f2b2e656b3b1cbe5832e24dd4a67f3@epcms1p7>
 <20220405062945epcms1p7f9fad7f6bf10597e79c3948ba663c817@epcms1p7>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220405062945epcms1p7f9fad7f6bf10597e79c3948ba663c817@epcms1p7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/04/2022 08:29, Dongjin Yang wrote:
> snps,dwmac has duplicated name for loongson,ls2k-dwmac and
> loongson,ls7a-dwmac.
>  
> Fixes: 68277749a013 ("dt-bindings: dwmac: Add bindings for new Loongson SoC and bridge chip")
> Signed-off-by: Dongjin Yang <dj76.yang@samsung.com>
> ---
> Notes:
>     v2: Update Fix tag and change history. 
>  
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>  


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
