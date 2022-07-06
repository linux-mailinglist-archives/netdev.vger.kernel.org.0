Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA4856801E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiGFHkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiGFHkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:40:35 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B08A22BC1
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 00:40:33 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id e12so24449354lfr.6
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 00:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=tHC6g1e0eMvimI9KqKd/ut+Z55C7x7KvZC11uhVlLBQ=;
        b=pMhY5I6oLgh6rf97jnoly2SY51aQrh/m0AW/L+woLnGunZh3dyg4KK3UqWPRnJbhvJ
         iAHHyav7sIhYJeOPcE+M8r9s+6pZlFbXiN20t4LJQE8RJJvdQ4nFgNufDnL/JPasKTy+
         W+PXTEzXClRqKAqtNZYqTd+CL5sACsTQ49C2Z3696xC7gzIIi/+xV9ufmjo/y1rxk2vm
         kpqgltwz0V5cD/mnnshEd9lhqbRDfGOmRjS6N8oh2ryvA5zmKqJ9MjW/nvG+ASqR9Ixt
         eU7JqcnYSEvcgcg/MS1sBTwd8TVOcQVZL9BL5XI90XGGTHUsrL2weMsH9KhllNdvmwt7
         ddiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=tHC6g1e0eMvimI9KqKd/ut+Z55C7x7KvZC11uhVlLBQ=;
        b=fz4/psuEnB/W/J/S4+E826SjWcPjuevmrKj1W8LpVk2Dbz6XJ+OaMjtZSchbgaF61r
         6lGM3kkuCB0Evf956Jm3BYCHz6+x2CygllV3dYaY3hVtsrc2fBK6mmzh47tN2BpK6725
         aDPoSDwqZoxRZ70nsFCqdn9VXqE+F5s8gbDzSo+oYGCVaKmKcrKU/w2JNpQTUSf0+rpk
         l4MiRCBccYY6NNuIVbW4+l6IPzKBltirjPGHHVpSm5G4mlknt7g9Ojt2U3zGrhQVWQmb
         jWhC3qqJGx8MK17dHx73yh4+TiqgNfDDY40t9S7t/jFfc3AdOVVSg/+TvEq/6fRhuqAz
         SZug==
X-Gm-Message-State: AJIora8Vzuoelr0i9lyMx82vSiC+rnDhOvXEm3o/+u0ZMj83AE/6cN7C
        NE9xMaSRP4mJ/Koup7DpgaO8VQ==
X-Google-Smtp-Source: AGRyM1sUmxKidmtloQsmU6mxIVhwMR/efusfURXP9Md0qWiwboryqpDXm1jRxDwXDWbZpNhegi55Tg==
X-Received: by 2002:a05:6512:3a95:b0:483:e38b:528b with SMTP id q21-20020a0565123a9500b00483e38b528bmr4274849lfu.227.1657093231756;
        Wed, 06 Jul 2022 00:40:31 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id m18-20020a056512359200b00481348b1074sm4128441lfr.81.2022.07.06.00.40.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 00:40:30 -0700 (PDT)
Message-ID: <9513b46a-126f-667e-4ba1-a2a15d6d303e@linaro.org>
Date:   Wed, 6 Jul 2022 09:40:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 1/9] dt-bindings: power: Add Tegra234 MGBE
 power domains
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Bhadram Varka <vbhadram@nvidia.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, kuba@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com,
        Thierry Reding <treding@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
 <20220706031259.53746-2-vbhadram@nvidia.com>
 <708c4a86-731a-c2a6-e3d3-df23ae7c35b1@linaro.org>
In-Reply-To: <708c4a86-731a-c2a6-e3d3-df23ae7c35b1@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2022 09:35, Krzysztof Kozlowski wrote:
> On 06/07/2022 05:12, Bhadram Varka wrote:
>> From: Thierry Reding <treding@nvidia.com>
>>
>> Add power domain IDs for the four MGBE power partitions found on
>> Tegra234.
>>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
>> ---
> 
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 

Wait, I already acked this. Why do I need to ack second time?

Best regards,
Krzysztof
