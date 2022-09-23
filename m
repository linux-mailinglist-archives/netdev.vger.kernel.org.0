Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4ECD5E81A7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 20:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiIWSQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 14:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIWSQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 14:16:04 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BAA11BCED
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 11:16:02 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a2so1522481lfb.6
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 11:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=oCR6Bo3A4ofjsJSPRwu8W/6xTMTPUToxbtx6duza/9I=;
        b=QTFH6A6ALvOnrxdBlLXWwrPn4QlREymvd6XMlcentLZ7h/3fide79fdoCHB5KTem71
         yp6pWhrM2z41mtYT5qLU1Bh2iz6CQHypAeyWgu+d26gmF+IBSGIswW9vQE8qWgJ374M4
         J/sKG8vfLGHmHmWMmL0qpwPd+e/Bj/iWmYCd/15aKADo++tGMLkwakMCAyWOepF0i+ri
         dgeTUxMR2PMwWHVfXToHcEn+O+6EOAZsDDngC6NZ/U5fhtxvtdPZuOdXrK0VhBLVtBA2
         3FBSeqMz0DB1naWCCiR7W8HX0k883wfgPGcd/oly/dmRrF0ooaifWb7Sstlh8ULCJj1C
         B7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oCR6Bo3A4ofjsJSPRwu8W/6xTMTPUToxbtx6duza/9I=;
        b=1MBP9uuWShU1o1Eia4DW6drzict/sVIebJvAkt2q9UcTnPA4WHXlK8rRPsZAqQ/ggw
         Qel8wjoEPyvqT4Wgphd3XW1P33J8lj7EE/b51wggW+0j88RVH2uRIJDqH1hdu9f8UWJu
         6vjP5q9l54lctEGDTaMFQ02rHGfLRtcC7pYdov78B16suodKKxcA7BtJP88XTyMNtYdJ
         e27KnL1BCsESF3/M/ye5BhAenfa9qQPzqJoROm0hHq/Y6veTZLjdyznrG/pOJ8Fv/CO5
         gpKlVjQClzQUTOpzCK+NjocaJVJzjOo/4Aky5YGhVilwIiFQTiRTbwNNHzbS0cALyc/K
         EoRw==
X-Gm-Message-State: ACrzQf2WJeqf2n4c6cYf3eieGBH2tgtrlvEUKlhT8sx7Rsz5+UAdJzVz
        zVmrCSvuv1cCY12fU0g7xAhXwA==
X-Google-Smtp-Source: AMsMyM5VPQHR6EgWnlQIIyiIzzfK4PFaph4377Xhq50FxdoZgzoCfLawcTAmFyxngXUm5xjobVChzg==
X-Received: by 2002:a05:6512:3295:b0:497:a156:795a with SMTP id p21-20020a056512329500b00497a156795amr3537914lfe.345.1663956960760;
        Fri, 23 Sep 2022 11:16:00 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id j5-20020a2e6e05000000b0026c59d3f557sm1487798ljc.33.2022.09.23.11.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 11:16:00 -0700 (PDT)
Message-ID: <4f205f0d-420d-8f51-ad26-0c2475c0decd@linaro.org>
Date:   Fri, 23 Sep 2022 20:15:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v5 4/4] net: stmmac: Update the name of property 'clk_csr'
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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
In-Reply-To: <ac24dc0f-0038-5068-3ce6-bbace55c7027@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/09/2022 20:14, Krzysztof Kozlowski wrote:
>> This is going to break MT2712e on old devicetrees.
>>
>> The right way of doing that is to check the return value of of_property_read_u32()
>> for "snps,clk-csr": if the property is not found, fall back to the old "clk_csr".
> 
> I must admit - I don't care. That's the effect when submitter bypasses
> DT bindings review (81311c03ab4d ("net: ethernet: stmmac: add management
> of clk_csr property")).
> 
> If anyone wants ABI, please document the properties.
> 
> If out-of-tree users complain, please upstream your DTS or do not use
> undocumented features...
> 

OTOH, as Angelo pointed out, handling old and new properties is quite
easy to achieve, so... :)

Best regards,
Krzysztof

