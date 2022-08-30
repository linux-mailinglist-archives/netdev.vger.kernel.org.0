Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B005A64EA
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiH3Nhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiH3Nhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:37:46 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A089DAB422
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 06:37:44 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m16so14238646wru.9
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 06:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=eJwvPnyxYM+rkWN/B5T3u9GVEhfio+TrUX3WU5XcQn0=;
        b=eJ8Q9S1/vCT7cijJVAWN8HR5xnr4XG/bT9gfNLUDKdyxQxPABjo+s4Y6pUxKK4Tl4O
         jPc2/lY4v59LZSUGa9aKxBb01w/WAWEog2r8xqVxzlhi7sYloua5sSMoo8h1Ju3qINN/
         3avwaD6Hws/C4g+njGzPWYxF+RusS9DNMyl9nt2y5ZJnNdOG5bGLLNdGTXWMMHpi5f2E
         IIjR87c/vXSr0+OPP2cwmM1pzjUy5FHA+vG4pvTZWF9oCnm1SdWfv32yZASc1o+ERboZ
         XMrCHtZPBtVNx/gkiYGlNPnexb2ABfjXNmkHIEWQAhFq4YntlmA92bdCXkafb7r0LXVd
         7Eiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=eJwvPnyxYM+rkWN/B5T3u9GVEhfio+TrUX3WU5XcQn0=;
        b=a60Eq2fY18ufO9fdmHf87SftIAQ2FuDqENmUSbmNaIRWPC6AAgGqlWX1QG3IX6i9mo
         mD5I+cfaok3DhOCK8NJZMWqMGOOImPmKeTAKT6Jqy2LrUs3UOgu16sseV4MwIn6UK6uS
         MqDVcAo6iNXDEmaE1qAAS11RszTrU5nH82DYzKLtwMFXWN3bWnt4trJrwik5SXLXe+To
         BtYliEQheqks6S8WNH3WGxJavmxdSYXnbbBw9J2OeB4/MatUefWRjhwJW/8L1E1G/hGJ
         PSpGSSktlnsnIEE20PWm4yabgS4WFvITal2E3FPwDNwflOoZyChg8y+2EuSOI1WeEO79
         7jOg==
X-Gm-Message-State: ACgBeo1hMfAfu597ZcMccYDbX+ci/EYiKDT33BYEPGQaJzdCxS5a9xa+
        0Z798vS+DjIhHqa7U/sYO7zrQg==
X-Google-Smtp-Source: AA6agR4QHq093VZ3/eQb0FJDYlUt9A1Mn1xHd/D1qdIE2cMIfLfOMQUBjFLqXGMVXyoshwbgON+EAQ==
X-Received: by 2002:adf:dec9:0:b0:226:e033:c048 with SMTP id i9-20020adfdec9000000b00226e033c048mr3225813wrn.577.1661866663228;
        Tue, 30 Aug 2022 06:37:43 -0700 (PDT)
Received: from [192.168.86.238] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id n8-20020a5d4848000000b00226d01a4635sm9658965wrs.35.2022.08.30.06.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 06:37:42 -0700 (PDT)
Message-ID: <791ea3b6-c326-9e71-e23b-93206e305c85@linaro.org>
Date:   Tue, 30 Aug 2022 14:37:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 00/14] nvmem: core: introduce NVMEM layouts
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
References: <20220825214423.903672-1-michael@walle.cc>
 <768ff63a-54f5-9cde-e888-206cdf018df3@milecki.pl>
 <267821eee5dcab79fd0ecebe0d9f8b0c@walle.cc>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <267821eee5dcab79fd0ecebe0d9f8b0c@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

Thanks Michael for the work.

On 29/08/2022 09:22, Michael Walle wrote:
> 
>> One thing I believe you need to handle is replacing "cell_post_process"
>> callback with your layout thing.
>>
>> I find it confusing to have
>> 1. cell_post_process() CB at NVMEM device level
>> 2. post_process() CB at NVMEM cell level
> 
> What is wrong with having a callback at both levels?

we should converge this tbh, its more than one code paths to deal with 
similar usecases.

I have put down some thoughts in "[PATCH v1 06/14] nvmem: core: 
introduce NVMEM layouts" and "[PATCH v1 07/14] nvmem: core: add per-cell 
post processing" review.


--srini
> 
> Granted, in this particular case (it is just used at one place), I still
> think that it is the wrong approach to add this transformation in the
> driver (in this particular case). The driver is supposed to give you
> access to the SoC's fuse box, but it will magically change the content
> of a cell if the nvmem consumer named this cell "mac-address" (which
> you also found confusing the last time and I do too!).
> 
> The driver itself doesn't add any cells on its own, so I cannot register
> a .post_process hook there. Therefore, you'd need that post_process hook
> on every cell, which is equivalent to have a post_process hook at
> device level.
> 
> Unless you have a better idea. I'll leave that up to NXP to fix that (or
> leave it like that).
> 
> -michael
