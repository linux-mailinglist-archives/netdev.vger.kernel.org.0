Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B950F6696C5
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 13:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241025AbjAMMTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 07:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241451AbjAMMSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 07:18:33 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4BF59F97
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 04:11:47 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id u9so51916768ejo.0
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 04:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IPJSg4Zmt3zIF1jwOF51a0Egys8yUgt0jOK5/EupfkE=;
        b=VLl1Ajn3MlZ5ERaYDB9LRWELgbetfSa8z1cxnG+wb5ES3bSr8Oub8ar8TjffBkcnjd
         MPx4leKbJLxCP0nvqdApzLNwIjLPC1MNfKcdLJ1ymJwNAutaU0xhlZ2PlIjgNJFCIwtl
         ll/6kCs0rrM1ilkogyOnQC5598ZeVCDZveFxUaRkZSYgCrCCFLL+yA7nzjmU69NwQYUW
         Vi6W7BjsYUc/VC4xwm5ktFTQqd9dvlE7ESM79mZnxkN2bVp/z7c2bU/psjVuZZ7i3viq
         y1klB9hmZ7o3aSGUYJpdgF/gSBaKQBjEewMGbuaHRt6Rziq3wUpmnuM50TpbRu0u9g/V
         BG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPJSg4Zmt3zIF1jwOF51a0Egys8yUgt0jOK5/EupfkE=;
        b=m/i0mH8Dm//JHrQAHDyONFTxiXiLYWUV1PHcpR83PwdxC08ryn50Yw8+RkTfUq2Zph
         otTBiTZTADu3YIvYuuWLwy7rFl2+uk7JLhMf2guhygFF9GhB9LQJXbZ0kOpUg7S+3oQP
         OXbfhVfaV+KJx9huUJpDo0FYvRddg4Xi7ZrBremFs++IMF0txLFodlMq8qlFFTew5VYB
         MmZi4HCzElyG+0goCzNsbduCC86jRetY8IZy2N5Z1xz6SibeWZuxhxv+aGrUmL4xwVu6
         jUg+ZLBuMKmjA8AsT3HRld5i8kF6SfJJOq/i3SuobkGNcvHta2Pi18bAk5C99wPxlfL8
         j2ew==
X-Gm-Message-State: AFqh2konPj5TWG1w/eqn4J5t4lEvxH9R6YW20XlnRW6vSLdptqAQXtAz
        +/FHkEwKyI/d+qIcLY/m3qgDDw==
X-Google-Smtp-Source: AMrXdXtTnYm2ahDtT2Fc3hNhQJ2Qbn2zsMBf/+9ai6bmBO+J8tlWVPudhisWuV6WiUGeiR1xTosMCA==
X-Received: by 2002:a17:906:5dad:b0:7c0:dfba:54d3 with SMTP id n13-20020a1709065dad00b007c0dfba54d3mr11022747ejv.20.1673611905595;
        Fri, 13 Jan 2023 04:11:45 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id g18-20020a1709061c9200b007c1675d2626sm8592741ejh.96.2023.01.13.04.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 04:11:44 -0800 (PST)
Message-ID: <435a6047-834c-ef3d-9aac-8bafa5e322ff@linaro.org>
Date:   Fri, 13 Jan 2023 13:11:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V2 3/7] dt-bindings: net: fec: add mx93 description
Content-Language: en-US
To:     Clark Wang <xiaoning.wang@nxp.com>, wei.fang@nxp.com,
        shenwei.wang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com
Cc:     linux-imx@nxp.com, kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
References: <20230113033347.264135-1-xiaoning.wang@nxp.com>
 <20230113033347.264135-4-xiaoning.wang@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230113033347.264135-4-xiaoning.wang@nxp.com>
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

On 13/01/2023 04:33, Clark Wang wrote:
> Add mx93 compatible string for fec driver.
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
> ---
> New patch added in V2 for FEC
> ---

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

