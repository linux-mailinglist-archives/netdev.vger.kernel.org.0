Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AFF580C13
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiGZHC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237705AbiGZHCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:02:55 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070DA27CDF
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:02:54 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id q7so81845ljp.13
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qs4nlbaptn4SS7lO1ed8i+LgqAJu8EVWyB5i90ueW/E=;
        b=tlSLHw/IN9bA0kO8udFCAPyEUA4eOJRr1FILlTHUmyTKB5KXMIUjBUmK9mbqWd60kN
         XLNVC7huPbCSdV6UHqEK1SWlSDdBIM6HRXNcFU/L7y5QgRWm8mS/3x9G0rQKvfkOM51N
         6NaWIXa/V/71TTh91szc8Bpe9xGlA7GOXXVESEkS3nhzg31QZiJmmVvlPwTzrT99uuwq
         3U6H5CwEBoAtj7RBdoBsTZKhtdoFl/hxR7fUpmqE50Mz3fbYRM9H8jFkfB4ZCwduwWfA
         6JnbbWdsUpknt7fFQWx6ZYJtV01A1qVo9Rdi5zjGSlROt6YBw6cIQ4Akt+EClJspXWEf
         TysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qs4nlbaptn4SS7lO1ed8i+LgqAJu8EVWyB5i90ueW/E=;
        b=qL/Mk9p+Qwl5c16P7kMqN4gJrxAkzulKg9ZzyBbK35001E5u6jbLA7WWA7lMuY9y+l
         Ufz7TOcEKShMGe91hqKwQ8iDTmwXrdJyi9edDfIBCgt0YxPaRZqdEkhWhyMHWm7ympp/
         a/orn+r/uQxmJ0F6/1WehTR4zM8RUIRZvXwX7aA2EIM4W32LWxX/VQcxXL43Dxqvtpdm
         7OV6fQLqRvZJ4Q7PNaf1bWFDMBb2IJcxxT8jDVGMjX67kmwQL2eKWMClzT1kRRhNbYf9
         MiyX/n3Qb/K4G5jLSsW/WVnbVZBLS83b5pxpyauNLGHEWMU00unaxxaLA1del58iZLlp
         eq0Q==
X-Gm-Message-State: AJIora85h8y5oc8XeWMRl/euKj8rX3dddKuPv4zuAVe0Own5XUFBXHBP
        x60h8MVmQRYJAkcx7EJD2nbFEQ==
X-Google-Smtp-Source: AGRyM1sJe4uT3uHa3v/TZDf1AKnRAIXlJoSP29UOCXzailKypi0Qi0KUx66LyoJuZ0Q+M/u7y1u/Yg==
X-Received: by 2002:a2e:9b14:0:b0:25e:62:aad1 with SMTP id u20-20020a2e9b14000000b0025e0062aad1mr3787264lji.77.1658818972408;
        Tue, 26 Jul 2022 00:02:52 -0700 (PDT)
Received: from [192.168.3.197] (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id a26-20020a2e88da000000b0025e00822532sm1297296ljk.92.2022.07.26.00.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 00:02:51 -0700 (PDT)
Message-ID: <2cc0c987-0509-5305-2c1b-5019785213fd@linaro.org>
Date:   Tue, 26 Jul 2022 09:02:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] dt-bindings: net: cdns,macb: use correct xlnx prefix
 for Xilinx
Content-Language: en-US
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
References: <20220725195127.49765-1-krzysztof.kozlowski@linaro.org>
 <CAL_JsqJc7Lagqr=Mkvags1dvua5AEvEzZHcsMqmOGNbp-v_Bxg@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAL_JsqJc7Lagqr=Mkvags1dvua5AEvEzZHcsMqmOGNbp-v_Bxg@mail.gmail.com>
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

On 26/07/2022 04:27, Rob Herring wrote:
>>        - items:
>>            - enum:
>> -              - cdns,versal-gem       # Xilinx Versal
>>                - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
>>                - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
>>            - const: cdns,gem           # Generic
>> +        description: deprecated
> 
> You meant 'deprecated: true', right? With that,

Yes, I'll send a v2.

> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> 


Best regards,
Krzysztof
