Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0BA676C9B
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 12:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjAVL7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 06:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAVL7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 06:59:33 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516A61631A
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 03:59:32 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id b7so8487623wrt.3
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 03:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bX0ppwR4BuuF7IPGnfpNxPm8UxuSP31WgtoC2+ctL4I=;
        b=dEJWQOoRWwV43nuPZxOsdA8YfKXo7zRF0wcDFosGZ8iHikK6ITqoixH4Tncj75STch
         INxRSKEJ2ivM0zm/a1T3iSIW+FsvXbv+2iiYYczry3cWTbuF8TKlnqfU7ytJBTRrSDs5
         NjU7Bz7Ke/Dvy/TH0dHTQUNHgBPizs57IsUDFJZABdkWuCNMNc1NtO2QdnD6OWQZxy0P
         07gvR/4nFzu1RgYRFjehlyAXhRuff+P2NTEhRPckGsfWb7wGAVN9va71QdOVgdQeasih
         rWoSqdyt9ckbX3eAWm42dRIBcp59Ei5TagWq4TM0lZCN//CwxCFULFvKdVZpxl3CgMPD
         uX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bX0ppwR4BuuF7IPGnfpNxPm8UxuSP31WgtoC2+ctL4I=;
        b=srzxUdHFOy1/F3DuS50SEnMlHAx3VNh9zWWLUeuMWvzuNXD5Ma77CuR31JI22z98kH
         YOZX5TVXpqSUKRL9SiRF8KLC7CQ7P3EOBNHfwRNYAEufdv2KyhLhN8rGI+Srp3W7jioJ
         vQJYxzfkoR+14YJ7pARAGt45TeggFsrdd1GZ1ZjOqA3nNgIlsDF/s+5IKUyaMgP+fgXg
         5gPVLdXN8ihHmEd5pUPEmQ/OC3a5CUHAW5yMpbXbbJwMDuZGRXeXsjJ3kS8i7Bn9H/TY
         8pdBeAOc+2WoWLH697kp/5yLNPp8CF2a+O4B6nNV0aqABxwYsq87c/YhEc4KtSTd2pac
         XxFw==
X-Gm-Message-State: AFqh2krHzGVMAa/4zxuC8yMrKAt66Ozc+RUR1lW/7XGUw9r3sjmwYENc
        PXO6wxLG05CiHy2z0pihVEcR6g==
X-Google-Smtp-Source: AMrXdXs6ZNSUPETFhq5UKG5M9/+z5EuxGgyP4tlcyL9pbWklEj18MQfNCQZnSiJRNit45U+YU8LJXA==
X-Received: by 2002:a05:6000:1b85:b0:2be:f21:6af6 with SMTP id r5-20020a0560001b8500b002be0f216af6mr18166531wru.23.1674388770882;
        Sun, 22 Jan 2023 03:59:30 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id q17-20020adff511000000b002366553eca7sm17703058wro.83.2023.01.22.03.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 03:59:30 -0800 (PST)
Message-ID: <1100d303-1ad0-c0d1-a001-aaa64979181d@linaro.org>
Date:   Sun, 22 Jan 2023 12:59:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [net-next 3/3] dt-bindings: net: adin1110: Document ts-capt pin
Content-Language: en-US
To:     Alexandru Tachici <alexandru.tachici@analog.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        yangyingliang@huawei.com, weiyongjun1@huawei.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org, lennart@lfdomain.com
References: <20230120095348.26715-1-alexandru.tachici@analog.com>
 <20230120095348.26715-4-alexandru.tachici@analog.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230120095348.26715-4-alexandru.tachici@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2023 10:53, Alexandru Tachici wrote:
> Add documentation for the use of the timestamp capture pin.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

