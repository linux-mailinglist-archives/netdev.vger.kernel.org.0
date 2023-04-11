Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501406DE34E
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjDKSA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDKSA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:00:27 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FF85270
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:00:25 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id o1so11516753lfc.2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681236023;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwRBXjW3LKaf6FMdA/wwWmZg0VHbU8BDgWyAU/QAHUs=;
        b=lMLY/86gUy7qpoTj7Jju8dwSLtjfBksYqes73dWc11t6HM0axbTH0G6y4uu77e6DwA
         TCaphi37UOFahFw1XyvLd4GUXYsgkgjAZdEc1lhDD5jxEtIi3WrLHoNhlapLv6MgsW8p
         JH4a2GNcrynotw8G9Vc9dsZFY6AespUakqHHeVvKLEXGeArUiJ6QXQ6imqKVmbCsTdP+
         M2QfSKSmYzXOfsLq8+szyxE1wsDRpg61SyVVbYwf2zOSCJA2IdUhNddfyj5ebUhi1lOI
         1X/sTMNDl/SS0Iyl78UIVTDJB28yNRiZpaHcQBGXzPZyqrXtdrvlPVQ4OqaxeZHrX3Br
         ZjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681236023;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lwRBXjW3LKaf6FMdA/wwWmZg0VHbU8BDgWyAU/QAHUs=;
        b=Wr65C7yFXHx7jAKZuKP3NVFXankFKPCCLWkN0AkdfZ6ZjYzbDLxhnIHCQApGK8NwCq
         bhPRrCL9wLsFtfeYROHxA4bx/UvZPbM+6E+kSFmAaBiJvPiQBGkXfRHv2rPAnkz9qCeA
         cRN83s70YIy4a27pBu8iEXwiud6d47t2iwgtjvOqa2FfrGyLL5o5TQpFmwwG6uuZdrkn
         N20oZCXtEKf1AQx27BvOkasvw7VV8L4r7kpTIS6QlNBh6SeLXaAwmz4iskHku2haAvq1
         CeWw4hsNP1ciO+giZPnEwaA78ICIgWPJp5o189QIT49AGudw0rxfjTUiusxWJ3KCVuvP
         UDzQ==
X-Gm-Message-State: AAQBX9f4melIgkSPJ3qRswFphPc2hR72CVe32F2DJWEL1DANWdIai9L6
        gX7f3BFbqCER7xd/cC2KIigO8w==
X-Google-Smtp-Source: AKy350aqc5tqwAqaVQBe8GDzYh3HXxWbAtPfO+P8owp08Yi0tPimjDPGezSAC+QgPFJyPYdSUVT+/g==
X-Received: by 2002:ac2:43c3:0:b0:4dc:4b92:dbc4 with SMTP id u3-20020ac243c3000000b004dc4b92dbc4mr3212317lfl.14.1681236023345;
        Tue, 11 Apr 2023 11:00:23 -0700 (PDT)
Received: from [192.168.1.101] (abxj23.neoplus.adsl.tpnet.pl. [83.9.3.23])
        by smtp.gmail.com with ESMTPSA id w6-20020ac254a6000000b004e9c8290512sm2632303lfk.82.2023.04.11.11.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 11:00:22 -0700 (PDT)
Message-ID: <2aa69cb5-a545-13d4-4db2-7050d944f74e@linaro.org>
Date:   Tue, 11 Apr 2023 20:00:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 1/2] dt-bindings: net: Convert ATH10K to YAML
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <20230406-topic-ath10k_bindings-v3-0-00895afc7764@linaro.org>
 <20230406-topic-ath10k_bindings-v3-1-00895afc7764@linaro.org>
 <e75a5a75-ea42-6c7c-f6ee-b32ef735cd81@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <e75a5a75-ea42-6c7c-f6ee-b32ef735cd81@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11.04.2023 17:59, Krzysztof Kozlowski wrote:
> On 06/04/2023 14:55, Konrad Dybcio wrote:
>> Convert the ATH10K bindings to YAML.
>>
>> Dropped properties that are absent at the current state of mainline:
>> - qcom,msi_addr
>> - qcom,msi_base
>>
>> qcom,coexist-support and qcom,coexist-gpio-pin do very little and should
>> be reconsidered on the driver side, especially the latter one.
>>
>> Somewhat based on the ath11k bindings.
>>
>> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
>> ---
>>  .../bindings/net/wireless/qcom,ath10k.txt          | 215 -------------
>>  .../bindings/net/wireless/qcom,ath10k.yaml         | 357 +++++++++++++++++++++
>>  2 files changed, 357 insertions(+), 215 deletions(-)
> 
> You should have received kernel test robot warning. If not, just
> confirming here - you need to fix paths (docs, maintainers).
Will do

Konrad
> 
> Best regards,
> Krzysztof
> 
