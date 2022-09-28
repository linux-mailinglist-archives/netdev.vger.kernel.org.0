Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB825ED5CA
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiI1HRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiI1HRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:17:36 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D48880F51
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:17:34 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id a14so13341590ljj.8
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=TE4dxCPLnQRstcdplswZZPEWrYHTl04zyo0o16usTaA=;
        b=As/0q82nUum+sJyLoPBd6GtuWJl33qN4O68taKfghJIh7FQcvreh6Gu11qEj8hvGul
         fPEWOM4BF9GuUvQfEJS1gQH3PwuyGEpLTGcjHwHfxYZLsZL90hZftF/CWn0BT3CoMwOE
         eIOtIlq4gnuT1G72keew31h6ZB5F/aKsknGcaK1NUYTiDaCmvRIQ5Kp7tUigCFD7s1Hk
         6dVteyyPIfqTmkagSSXeufu097WmwCxuRI31twbg1vIReTe9XTK8scaDpsHHn+yJBqnP
         JmJ1rQAmuBAf8mhBRcfvDXhHFr3Hq9662lsY5CG/NxErdutSRODVcQtyiOMRFAvvOQX3
         +vfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TE4dxCPLnQRstcdplswZZPEWrYHTl04zyo0o16usTaA=;
        b=hI37EQLp/8L7/yqFOWXd51aaPzNluAbsw8Mlj/GV6I+WqSfqrtLH3PI7oUGASiyF4e
         D3zo8lsGp1wQux+g9me6+yrm4A0z8Ibhqj5fsGCfqcRrvqkHoQDsNGEn/Rwsurd38Zk/
         Gr9CaQe/MbztH1G0QG7XE4HSKGJpd1qw20nmLjpMY0Z3kRyIQf2crI1IE2lE3KGRgjFt
         GsfT7WRRDS0OQwAvl35Ito9KcYldxYQjVcBeZYgta4j2vMoV0ni963Tcxt0zN6DCvSDU
         loUwFKxssfGie07yZZQbCd3TM2GTY/hGUTdgCRB7ZRSYQkHfIkcr6+koVKGwNDQWBEbO
         KXUA==
X-Gm-Message-State: ACrzQf20naij3VdCI/migFN7Dzo5JyobaoDb7RbLwa3azRCAnpd42ETD
        H6TrB9mFuD2vmG7CLZTBEw0k4w==
X-Google-Smtp-Source: AMsMyM6z76iK8/Qm0pj3jD1AipgrGpEdJt+xFjKYGD79qqx9g2bJoS6FRXYROgJD1rVI1r9QXVPtHA==
X-Received: by 2002:a2e:9b14:0:b0:26c:7f8a:e740 with SMTP id u20-20020a2e9b14000000b0026c7f8ae740mr4578796lji.256.1664349452610;
        Wed, 28 Sep 2022 00:17:32 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id v18-20020a2e9612000000b0026c0158b87csm358913ljh.29.2022.09.28.00.17.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 00:17:32 -0700 (PDT)
Message-ID: <ff577b86-44c8-3146-3388-78021bb7edb4@linaro.org>
Date:   Wed, 28 Sep 2022 09:17:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v5 4/4] net: stmmac: Update the name of property 'clk_csr'
Content-Language: en-US
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220923052828.16581-1-jianguo.zhang@mediatek.com>
 <20220923052828.16581-5-jianguo.zhang@mediatek.com>
 <e0fa3ddf-575d-9e25-73d8-e0858782b73f@collabora.com>
 <ac24dc0f-0038-5068-3ce6-bbace55c7027@linaro.org>
 <4f205f0d-420d-8f51-ad26-0c2475c0decd@linaro.org>
 <80c59c9462955037981a1eab6409ba69fc9b7c34.camel@mediatek.com>
 <888703a8-a8e5-e691-7a53-294f88ad7a4e@collabora.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <888703a8-a8e5-e691-7a53-294f88ad7a4e@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/09/2022 12:44, AngeloGioacchino Del Regno wrote:

>>> OTOH, as Angelo pointed out, handling old and new properties is quite
>>> easy to achieve, so... :)
>>>
>> So, the conclusion is as following:
>>
>> 1. add new property 'snps,clk-csr' and document it in binding file.
>> 2. parse new property 'snps,clk-csr' firstly, if failed, fall back to
>> old property 'clk_csr' in driver.
>>
>> Is my understanding correct?
> 
> Yes, please.
> 
> I think that bindings should also get a 'clk_csr' with deprecated: true,
> but that's Krzysztof's call.

The property was never documented, so I think we can skip it as deprecated.

Best regards,
Krzysztof

