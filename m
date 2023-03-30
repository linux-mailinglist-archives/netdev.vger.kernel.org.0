Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3CE6D0C59
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjC3RKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbjC3RJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:09:57 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3607AFF13;
        Thu, 30 Mar 2023 10:09:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h17so19804184wrt.8;
        Thu, 30 Mar 2023 10:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680196162;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3TRHg+cTs43kfHGBM/5sDvwk2CMTBx+iHyHIRc3YKQQ=;
        b=CpJm8U3E2ngq5rxs2vxcVii+NSUiivF5PvrdcT9zIODeeTR8/M1driEylYB4tXc+Ji
         Q70bTtmldbgaiM6gPDCwwpP4JYUlZfvgOGXw/q3h2qmOruMVI77FkXK3uNKe7CJox0Ad
         mhTTSDEwVzmE6+lIwyuIXO03g7jGnZBHmdNdtlZ4WsGaX7oVflyFZ+t+FIvmVlTPvt1T
         0oCaLiyfvd3T+RPL/+MuOB0d4AX2qa2mVqZRGfAfnk9ooi64pwyxRcGoRGbQcvOowbCS
         u4Uz9nq51cWuuF9isJefbrSLM/wqoM+7sVBMfzf29x0m+F0fVhTU8L7vHJxPpxxMaYNC
         ew4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680196162;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3TRHg+cTs43kfHGBM/5sDvwk2CMTBx+iHyHIRc3YKQQ=;
        b=Y2GHcC/48fnGUJezE5aiKXP3JQw7ok0r8QZB8EuUN3cIbHhdTPduVUkgsMmjUXGEML
         +gBEqD++dw3vQYeF1Go+RwHJ7k5xz3Wb1tmkxvg5+71oIONZTTwSwPgbZSQh/vmAmP3+
         Aelmjg2tWooceo3cgWK1V4r1xsYbS70IBJ17Dl485jC35eIzDsvoaUJS1nzEY3I+Zklc
         CoJXSlk0y8LrQEecrpDAGcAk3F3ABo8oHaUrQzmu0oMRDNRaWFx4wUzh82AoUUayzTR+
         rtc00VEoBcWtWsGijRKSaDrhLnR/osxvWRidB8TjOSXeMyDEZ9sLuZa2+MxgR4Frsz29
         8x0w==
X-Gm-Message-State: AAQBX9d5MrasdguZKPoOFK6QXBub0oSwv7NfYd+8+Upv874tQPJMh2NL
        ywTeS07bvv8ahEy+1C7Sh4w=
X-Google-Smtp-Source: AKy350brgt1+Yl/+qZ7NQ5as83uCi0jHokhPsY7zou3nvHJT9Eg+7r5f7fUfv8kl5fSyf5OCPkzRUA==
X-Received: by 2002:adf:efc3:0:b0:2ce:a944:2c6a with SMTP id i3-20020adfefc3000000b002cea9442c6amr18546399wrp.70.1680196161696;
        Thu, 30 Mar 2023 10:09:21 -0700 (PDT)
Received: from [192.168.1.135] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id j6-20020a5d5646000000b002d2f0e23acbsm33229184wrw.12.2023.03.30.10.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 10:09:20 -0700 (PDT)
Message-ID: <8a6d8107-436a-1b13-3799-59fa75c59635@gmail.com>
Date:   Thu, 30 Mar 2023 19:09:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] dt-bindings: mt76: add active-low property for led
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230207133504.21826-1-linux@fw-web.de>
 <7aa132aa-d2fe-e2a1-a2a7-97321a74165c@linaro.org>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <7aa132aa-d2fe-e2a1-a2a7-97321a74165c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Felix and Kalle,

On 07/02/2023 14:36, Krzysztof Kozlowski wrote:
> On 07/02/2023 14:35, Frank Wunderlich wrote:
>> From: Frank Wunderlich <frank-w@public-files.de>
>>
>> LEDs can be in low-active mode, driver already supports it, but
>> documentation is missing. Add documentation for the dt property.
>>
>> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>\
> 
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 

Can you take that through your tree or are fine if I take it through mine?

Regards,
Matthias
