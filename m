Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A6E5EE269
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbiI1Q7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 12:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI1Q7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:59:04 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C277D783;
        Wed, 28 Sep 2022 09:59:04 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id g2so8269578qkk.1;
        Wed, 28 Sep 2022 09:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Au941G7l7BgqQ/wE2oSbMdBllGGF8B4MeZUvzUpdMXA=;
        b=ABYUHFhN4/WtrDIGyD9Eyb9+xb7CvD5L+/2LwO7wTjjanycyJAJaTkfL8maQWXf5zA
         ZZTWGwGKpPPFD+J0nd2DIzxf9XBsHP9JTXrIvK9FPRTf3U8SOC681bXif6YN5EKkT6uo
         T3+KbyvSBMmB9MN7REaES+J5zGAVcm0WTDT28CeIVAZMRwfqZeB6XWY3TFZEHvcMRPDV
         dUajJ/XqZ4no0ZMNorQa3ylgMO2fm4jARnLlwIP3I+gDtXfjkgFfghCm0TLjV37SsWxv
         dPvGDT+aPFfPXLlBpmlbU+Svkuiv6kEBEZjdzwcxyyepKVhVP/4cf/T5evjhS+RAttzR
         /eaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Au941G7l7BgqQ/wE2oSbMdBllGGF8B4MeZUvzUpdMXA=;
        b=Iwy2fDscEE+mXp0XQYOxDW5ZRjIqoAIkFKuTv6D+3LxHxBSISg9dS1J/rFhwCDkfJ0
         H5QtG4C+4gdIfy+my2UzOCjUoyioX9j7WJ2/MLg3OdwqBF+TjYRtcoWQBM+tyU1d4kXA
         xQABdhpHX1RF+yFA0vTGcx9CGMFp0VXckcPe4GQA+iS6RHuTPfjJKnUAoCkxLD3VmC9i
         fyDDQmQSHbkwyi2LP68s8/sY/qfoEa5zssWBd1TpTmUMTk8dwrYuMZyu8c++pJgul+sc
         UivH9+Kqb2iW7WMyMubqoB9taQzzfRVVll1+r21X4tvzWImIzemwplfz/t9HSqu6it8I
         ROhw==
X-Gm-Message-State: ACrzQf000snSzT5hNXuzSri6yUwrw0OxSDRJNtKoqUwHrQy4WzrnviFN
        Q0TXrYUEzXXOFcunG+NQEkA=
X-Google-Smtp-Source: AMsMyM73YhIVgNdyVXFvOvr7hz+MtrfrH12dFBPodOm+DrlyyZXWSYZtHiaN8ACohotTHJad7iiu1g==
X-Received: by 2002:a05:620a:c90:b0:6ce:710:eefe with SMTP id q16-20020a05620a0c9000b006ce0710eefemr22514785qki.419.1664384342972;
        Wed, 28 Sep 2022 09:59:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v32-20020a05622a18a000b0035cf2995ad8sm3416236qtc.51.2022.09.28.09.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 09:59:02 -0700 (PDT)
Message-ID: <beb1fe93-5ef5-0cb0-c375-7fa99d8650c6@gmail.com>
Date:   Wed, 28 Sep 2022 09:59:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH -next] net: cpmac: Add __init/__exit annotations to module
 init/exit funcs
Content-Language: en-US
To:     ruanjinjie <ruanjinjie@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220928031708.89120-1-ruanjinjie@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220928031708.89120-1-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/22 20:17, ruanjinjie wrote:
> Add __init/__exit annotations to module init/exit funcs
> 
> Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
