Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD79554E06
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358827AbiFVOzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358633AbiFVOzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:55:41 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9290C3BBE2
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:55:40 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c13so19815730eds.10
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=X4Pad+8YipqXc8GK64t0Ga8h3j5acT4+ZXhROSFDHAY=;
        b=XaohlEvylppMCY+/f6p9Lh/ym1Lu1XP4HY/ahNo8U3FobNAq5i6QYoHqsYQH7gsp/l
         tG0fOtThXQAFnAk1dNF7pnFrQ4KacfboqDJZlHSNCi4MNhEBK0MOqo2TKJ5CV6RGbdy8
         f/vaZA3fJT4lB6x10IJLm42VIZPioeOE849DYzCJzmkT5XAmzPFH0e4Lx73dVQo/n6yZ
         fuefbMwfGTzqKghT6wkElXWdCU/OdNrrAZm3GfLUkwweapg38cqZQE4YLIwjMk0PUKNW
         J5fNUAaAnUmKURnXn9ZUxVa43/wCQBV6PEFl2Db86eHY9Aapzu44VY1ZzO8bo+0KlerO
         dDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X4Pad+8YipqXc8GK64t0Ga8h3j5acT4+ZXhROSFDHAY=;
        b=4Oyf1rs527vIHbrGX+8Nu552EZV4K3g6mgm39jFncIzzFb7klqkFYPMJoImyt/LI4/
         yiTWmE+lWU19ldV4n/GIUOBRNslQp/2d4tYjlMz1z9GQZ1gCnvlX5hc0Lc0BIsHjvXiV
         4hgE3PRZwyAXWnm/HtS+PFrE4qYWoiz0rPS22wx958lLXUXu+lxUqKpiu80/oO+iqt3+
         w9PDCXXmv+I4BQUZZlDvDNTLxLrieDuywxImIeYzk4NWn+pTkV//G0mbL7XeyhICGb6v
         W/xsKXCuYWVFROmt10SlLyG+e91NkQVxArh2/rxFgO9P2wCzzmueYxGEFhIKfFixvveR
         f9WQ==
X-Gm-Message-State: AJIora9oL3XlyVpnieDd4Hs0VaW/DbvMiRMT+8y7TWpcdkK1MLbqMrc/
        9XoddKDgHj8+e5b1S9h7I/5LSQ==
X-Google-Smtp-Source: AGRyM1u0tYBGnlEakino5fvDCPmYG7WkCkTmr987C3P4bO2FgwL/3yqTnzyi+ecJDIW6Kl+6s3mbNw==
X-Received: by 2002:a05:6402:528d:b0:435:89c6:e16b with SMTP id en13-20020a056402528d00b0043589c6e16bmr4717954edb.292.1655909739169;
        Wed, 22 Jun 2022 07:55:39 -0700 (PDT)
Received: from [192.168.0.226] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id ju27-20020a17090798bb00b00722e57fa051sm2678547ejc.90.2022.06.22.07.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 07:55:38 -0700 (PDT)
Message-ID: <60ee4aa5-4fef-24e0-0ccf-b93eee1db876@linaro.org>
Date:   Wed, 22 Jun 2022 16:55:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/2] dt-bindings: net: wireless: ath11k: add new DT entry
 for board ID
Content-Language: en-US
To:     Robert Marko <robimarko@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Rob Herring <robh+dt@kernel.org>,
        krzysztof.kozlowski+dt@linaro.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Devicetree List <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220621135339.1269409-1-robimarko@gmail.com>
 <a194d4c5-8e31-ecd9-ecd0-0c96af03485b@linaro.org>
 <CAOX2RU6fBo5f6cxAUgLKj3j+_oP7nSm7awCpr_yiO_p3NssWkQ@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAOX2RU6fBo5f6cxAUgLKj3j+_oP7nSm7awCpr_yiO_p3NssWkQ@mail.gmail.com>
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

On 21/06/2022 20:47, Robert Marko wrote:
> On Tue, 21 Jun 2022 at 17:58, Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> On 21/06/2022 15:53, Robert Marko wrote:
>>> bus + qmi-chip-id + qmi-board-id and optionally the variant are currently
>>> used for identifying the correct board data file.
>>>
>>> This however is sometimes not enough as all of the IPQ8074 boards that I
>>> have access to dont have the qmi-board-id properly fused and simply return
>>> the default value of 0xFF.
>>>
>>> So, to provide the correct qmi-board-id add a new DT property that allows
>>> the qmi-board-id to be overridden from DTS in cases where its not set.
>>> This is what vendors have been doing in the stock firmwares that were
>>> shipped on boards I have.
>>>
>>> Signed-off-by: Robert Marko <robimarko@gmail.com>
>>
>> Thank you for your patch. There is something to discuss/improve.
>>
>>> ---
>>>  .../devicetree/bindings/net/wireless/qcom,ath11k.yaml     | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>>> index a677b056f112..fe6aafdab9d4 100644
>>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>>> @@ -41,6 +41,14 @@ properties:
>>>          * reg
>>>          * reg-names
>>>
>>> +  qcom,ath11k-board-id:
>>
>> The "board" a bit confuses me because in the context of entire system it
>> means the entire hardware running Qualcomm SoC. This is sometimes
>> encoded as qcom,board-id property.
> 
> Hi Krzysztof,
> I agree that the name is a bit confusing, it's not the same as
> qcom,board-id AFAIK
> and QCA as well as vendors are using a similar property in the wifi
> node to override
> the default qmi-board-id to the correct one as its rarely properly fused.
> 
> I assume it would be better-called qcom,ath11k-qmi-board-id as you
> dont even have
> to be using a Qualcomm SoC as the same is used by PCI ath11k cards as well.
> 

Thanks for the explanation. What is the "board" in that context? The
card/hardware with ath11k? Then maybe qcom,ath11k-qmi-id or
qcom,ath11k-qmi-hw-id?

Best regards,
Krzysztof
