Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994B6650F3C
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiLSPuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbiLSPtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:49:33 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1575D13D6B
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 07:46:45 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id z26so14232702lfu.8
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 07:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xFCpf3PbvIQQ1SNGLa/aq7+Wn4jdyYZuDDJi9LLB1B4=;
        b=gKqbO1meKhIZD2D09ZCzm9ZeMDy0hOdvyqFlDWsgKXhxMOn3wYnBWjx6GBVU8A6nOq
         558ZgA48b1G1NSDdF41U5Hqwe3MnKEkyJx+3a5wMI91G643gV7AdTZHF4+OVRjPzshll
         vnnCbPOgUYy61iR7un4ZHS7Lk7yvhkMOdXWsMUvDa1SHvlXjZ9jBv44IbEuijC5r7DHE
         Ye1VEimwxDffRyiMC5ESvQWe6En7sypHId4Q3QuhOZw1aki2iq8OJKilEgrylXMgt6ir
         XiRDrJ+PSrWeVCB41wWTQsr+Ht/6rOJOdTrxKMrnfCRpMKZrVv9TNLwuwbyETBT3232F
         w+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xFCpf3PbvIQQ1SNGLa/aq7+Wn4jdyYZuDDJi9LLB1B4=;
        b=MqSj9U24g2xbbfyFvok6K1bmxc2yeeDb7AuEPqvu9q0wW31QaxicOvTPOL9LPpM73j
         tsSbXdBzldF7OeqhEyAdVJg/hd9vsIsGLKjnODkRgzcJ9GpiHXDqGDX/58WDOtWL5MHC
         RWxrIDgXYX/oJJ4vDcDKgyuw7pBVzcAGmixxVG3GrUwidOUEXNiN4mOriisFbFSLLtmK
         z2aUNMB9qvLdMQLmGx+ZZiydziCb+Xk13qyXvwukKoLt9tkAUgJnJcrs7s40WqsmjLPA
         LbYCEpSQHMgm9hDHUlaiT0JALeh0Flqp/Z8jnNlL2DD/CFhIQi1lbO9OHxtn7TfGuIBw
         ywFw==
X-Gm-Message-State: ANoB5pmJl05xRiQMYruLF2F5tHRj7/wR2odZthOnG3zbabAlGozC7zuK
        d6WtlhYbKfP1BFffbQ3yZP1jJg==
X-Google-Smtp-Source: AA0mqf6Wmq5YhXOuEkTp/H84nOahnrxrpmRb9ofAmBdzPy6LBU5agQfTH+mptXSQeW/d6pPgAATx0A==
X-Received: by 2002:a05:6512:68a:b0:4b4:e2c9:9b25 with SMTP id t10-20020a056512068a00b004b4e2c99b25mr15398614lfe.44.1671464803399;
        Mon, 19 Dec 2022 07:46:43 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c4-20020a056512074400b004b59871f457sm1121269lfs.247.2022.12.19.07.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 07:46:42 -0800 (PST)
Message-ID: <ebc66796-ec22-7fe9-a93a-0c6b1dc56496@linaro.org>
Date:   Mon, 19 Dec 2022 16:46:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] nfc: st-nci: array index overflow in st_nci_se_get_bwi()
Content-Language: en-US
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Aleksandr Burakov <a.burakov@rosalinux.ru>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20221213141228.101786-1-a.burakov@rosalinux.ru>
 <5841f9021baf856c26fb27ac1d75fc1e29d3e044.camel@gmail.com>
 <bd44539b-b3fb-f88d-86f2-fbc3fa83c783@linaro.org>
 <CAKgT0UemyUYpfchg7=ArO1NzkLofUgbSK8F71SRLHZDUxaDc-Q@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAKgT0UemyUYpfchg7=ArO1NzkLofUgbSK8F71SRLHZDUxaDc-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/12/2022 16:41, Alexander Duyck wrote:
> On Mon, Dec 19, 2022 at 1:06 AM Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> On 14/12/2022 19:35, Alexander H Duyck wrote:
>>> On Tue, 2022-12-13 at 09:12 -0500, Aleksandr Burakov wrote:
>>>> Index of info->se_info.atr can be overflow due to unchecked increment
>>>> in the loop "for". The patch checks the value of current array index
>>>> and doesn't permit increment in case of the index is equal to
>>>> ST_NCI_ESE_MAX_LENGTH - 1.
>>>>
>>>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>>>
>>>> Fixes: ed06aeefdac3 ("nfc: st-nci: Rename st21nfcb to st-nci")
>>>> Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
>>>> ---
>>>>  drivers/nfc/st-nci/se.c | 5 +++--
>>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
>>>> index ec87dd21e054..ff8ac1784880 100644
>>>> --- a/drivers/nfc/st-nci/se.c
>>>> +++ b/drivers/nfc/st-nci/se.c
>>>> @@ -119,10 +119,11 @@ static u8 st_nci_se_get_bwi(struct nci_dev *ndev)
>>>>      /* Bits 8 to 5 of the first TB for T=1 encode BWI from zero to nine */
>>>>      for (i = 1; i < ST_NCI_ESE_MAX_LENGTH; i++) {
>>>>              td = ST_NCI_ATR_GET_Y_FROM_TD(info->se_info.atr[i]);
>>>> -            if (ST_NCI_ATR_TA_PRESENT(td))
>>>> +            if (ST_NCI_ATR_TA_PRESENT(td) && i < ST_NCI_ESE_MAX_LENGTH - 1)
>>>>                      i++;
>>>>              if (ST_NCI_ATR_TB_PRESENT(td)) {
>>>> -                    i++;
>>>> +                    if (i < ST_NCI_ESE_MAX_LENGTH - 1)
>>>> +                            i++;
>>>>                      return info->se_info.atr[i] >> 4;
>>>>              }
>>>>      }
>>>
>>> Rather than adding 2 checks you could do this all with one check.
>>> Basically you would just need to replace:
>>>   if (ST_NCI_ATR_TB_PRESENT(td)) {
>>>       i++;
>>>
>>> with:
>>>   if (ST_NCI_ATR_TB_PRESENT(td) && ++i < ST_NCI_ESE_MAX_LENGTH)
>>>
>>> Basically it is fine to increment "i" as long as it isn't being used as
>>> an index so just restricting the last access so that we don't
>>> dereference using it as an index should be enough.
>>
>> These are different checks - TA and TB. By skipping TA, your code is not
>> equivalent. Was it intended?
> 
> Sorry, I wasn't talking about combining the TA and TB checks. I was
> talking about combining the TB check and the bounds check so that you
> didn't return and se_info_atr for a value that may not have actually
> aligned due to the fact you had overflowed. Specifically, is skipping
> the i++ the correct response to going out of bounds? I'm wondering if
> you should be returning the default instead in the case of overflow?
> 
> The TA check could be modified so that it checks for "++i =
> ST_NCI_ESE_MAX_LENGTH" and if that is true break rather than continue
> in the loop.

Ah, right. From that point of view, the first check (TA) also does not
look correct or equivalent. If we reached end of
ST_NCI_ESE_MAX_LENGTH(), we should not check TB on that entry. I would
propose to end the loop at that stage.

Best regards,
Krzysztof

