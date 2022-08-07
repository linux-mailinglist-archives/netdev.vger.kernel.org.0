Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C95B58B9C2
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 08:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbiHGGCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 02:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiHGGCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 02:02:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA8ACE37
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 23:01:59 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 186-20020a1c02c3000000b003a34ac64bdfso3626004wmc.1
        for <netdev@vger.kernel.org>; Sat, 06 Aug 2022 23:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=6gmfXr9QGls9vVBZe4q8fXg3fecncB9at70wrmD69Qw=;
        b=Dx8EBlMlnujAcL9POR4z2LCil7xzrzSLu+M5x7sy8g+aE5taUgevZdLyf0/mS75T23
         iUFElXtj1qgGr8Y2Zlza1phWrmuZh1kUwpWtpMcYfteGwM73U36Rp6r9oijy66kG7E94
         GX6JIZbgquVW3oJfK1RyvQTZWog2GcFlqKc2ZzFYWLvpVItoMcFEFZm85YQ70LlgMw+d
         bLYCL/my6HbG7S3O96nEjd0WXLR4Ho98v6oXOBtvhPYR5nwrjfMAsYP0tXRHflH9w9Da
         3eQKEA6h2+yb3QWYKFMEVQWc3tzJSgifRWm49OTbLu4rmjdtRMvhaGbTVIzrJXWiq3tc
         Hu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=6gmfXr9QGls9vVBZe4q8fXg3fecncB9at70wrmD69Qw=;
        b=THnRoS20FiwXIPfcTF0RTytrTHZ1pPBDDOoj/EAzzPx1WfQHgPuDOrEvxwbROOk8xH
         qqnZRmwI9f54//2unw6hJqw9aZ0uYibtmKs4dP7U2Rm8pqXQXNv027GcEf2i1HMcDvzV
         lEfGMnJOrWYuw225vMxRx+K7t/KJBy3hsN6rHe2WD0EwV3RewEXMjpKxxNnrtFdruL8A
         xm55Lzw8251CihzeT8q+1eYdloYISHtRL0z/TjBZamf/8UuhYJ1x8ddJRnocqb0zEAQS
         xnRKDkgIHT1QnXwDjn29IP1zvPsn0WBoSTLnloAfVYxE3ekTc6y1yyw1DYoVT2Uscccf
         LfQw==
X-Gm-Message-State: ACgBeo0ORHf8wJ44cOcO2A8nXy8HPPPkWBtRtkY8UGdR3BipAO5xteeO
        BNxgCAZOekiZ2yP4md0qEE0=
X-Google-Smtp-Source: AA6agR4lYC6slSrl3T1Nx2CPVmWF+jjCNqrA3g9Pf1ItD882JXOkCl0+19ap63ZSipEQrbtp7zAs6w==
X-Received: by 2002:a7b:c4d6:0:b0:3a5:3abc:8f6f with SMTP id g22-20020a7bc4d6000000b003a53abc8f6fmr776212wmk.10.1659852118426;
        Sat, 06 Aug 2022 23:01:58 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id f6-20020a05600c4e8600b003a37d8b864esm10892226wmq.30.2022.08.06.23.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Aug 2022 23:01:58 -0700 (PDT)
Message-ID: <a76a2ff8-e2b7-acd1-f5eb-32daddb23df5@gmail.com>
Date:   Sun, 7 Aug 2022 09:01:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220722235033.2594446-1-kuba@kernel.org>
 <20220722235033.2594446-8-kuba@kernel.org>
 <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
 <20220803182432.363b0c04@kernel.org>
 <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
 <20220804083508.3631071e@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220804083508.3631071e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2022 6:35 PM, Jakub Kicinski wrote:
> On Thu, 4 Aug 2022 11:05:18 +0300 Tariq Toukan wrote:
>>>    	trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - rxm->full_len,
>>
>> Now we see a different trace:
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 4 PID: 45887 at net/tls/tls_strp.c:53
> 
> Is this with 1.2 or 1.3?

Repro with 1.2.
We didn't try with 1.3.
