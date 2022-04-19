Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC64507047
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348107AbiDSO2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353436AbiDSO17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:27:59 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3437F27CF4
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:25:14 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o20-20020a05600c511400b0038ebbbb2ad8so1624228wms.0
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1rCZaHJuTpJRz4i+A17lZ5cdNjdyzzHreRVkB3jQ+0I=;
        b=jYfGW7aqNFOtNtqc8epI5V66+n2Thu2jV/TEPvMILel8F126B5xHHPBPsIEmfZBT2i
         eo5xTtPUFiiIVPUSsVfpr1nlvJ97qTPCDoDEHGeRALA8DEKYLahDZO9/5D4/P800TOi0
         IBSzLicvta/OgkOhwhhVE5PHR6KaBkiGCwnGoPAoBpSyi41xy5Gt7RxECabngUyBvevW
         dHwhJzWKw8+DDJvz+zFOCecTiCThdjzzL6qo/tRFtN/Oa7BeEiQ92il2zlR7LsNu+FJf
         yfzerpdyRBNWNhQ4tkAH3942HHImEzz9Y5hs23QYcaqNl7xgQSAT5qVgSX9h2+z7f0xz
         7IMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1rCZaHJuTpJRz4i+A17lZ5cdNjdyzzHreRVkB3jQ+0I=;
        b=m+lLV3siZlSG2rcpzxeegbXoaHbnD30iILf2oQKx4ae1YW7fQcgxMKWew0pP+vU5LD
         TnLE8q07EhU7z0q2Zup8LGDCzkIIeweqDShlpeel6oLLVQVA3D0xKR1t3nMarQ1YsX7R
         1cKltz4lVgHP8GjCANsrZb0z5KorrRBBYCWKyX8A9MXf28ew/w0qNevqlTNV+DZz4vG+
         6lZL38tB5HygnDKIAjidf19Mtk7bMTMTROoQjby4OfgXQhdRWqppeym2w24ueLgWzxrW
         0ByXISKuvqDb0kXYBl+f5n5ccsVQGL5ilBTYDGFP2rrViby3PcuE20ryr6dflXmz5XWd
         Vlww==
X-Gm-Message-State: AOAM531mELKTLeWNSgF8koLZOzyzjA47uHbmsfpjGlmsC1vOegWj3kEP
        +NiomEnVf/6MyJt+JXZRAImtWQ==
X-Google-Smtp-Source: ABdhPJzfMfzBfeOO6WtvTTSRnmKvG8IZ76AYXVQCwRzrzROb0t0iDB1MNyj3OasRZve5wR79n5I/rQ==
X-Received: by 2002:a05:600c:3503:b0:38f:fbd7:1f0d with SMTP id h3-20020a05600c350300b0038ffbd71f0dmr16014604wmq.170.1650378312804;
        Tue, 19 Apr 2022 07:25:12 -0700 (PDT)
Received: from [10.4.59.131] (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id n7-20020a5d5987000000b0020aaba99b4asm257967wri.72.2022.04.19.07.25.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 07:25:12 -0700 (PDT)
Message-ID: <a84e9cc1-fac7-459e-55e2-f463bddd05bc@wifirst.fr>
Date:   Tue, 19 Apr 2022 16:25:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 net-next 0/4] rtnetlink: improve ALT_IFNAME config and
 fix dangerous GROUP usage
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
 <Yl6iFqPFrdvD1wam@zx2c4.com>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <Yl6iFqPFrdvD1wam@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jason,

Thanks for the report. Stephen was right, and I introduced a regression 
on ip-link.

I submitted a revert patch with more context on what happened. I'm very 
sorry for that.

-- 
Florent Fourcot.
