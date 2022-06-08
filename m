Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9E2542856
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiFHHrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbiFHHqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 03:46:01 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547402838F8
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 00:09:59 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x62so25800893ede.10
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 00:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4VhB2e/ltpu1xO6FxebSIJdavw/FcgMQSIeYIdUzE8E=;
        b=LB8glNF1OZD8rR7O+PhXb+revMGeyvo2TrVT9fhvVjTttyEoABo26rnt0n/EjhhSxT
         gN3sLTTgCcsakc/Vkd2HAoa793GrCgXy+ybkcUfkL3hJ5M3/ciuvSp4INRP9MLSB+Jtg
         jsFQVBHwyqqrjqdLSXWImg0nbS5Hgf5fW3/Wtw9T32lYnJeJ/AiA0WTuxAkiCJtEPTkV
         2K3x6A/JhFBgdFWLf97Ez7n5yiN7bhSf+wHfh6YsahQ8QrYh6bMYvNOPTCGHX8sqFVkz
         z3v/tn0QCMmB3w5iFGVHqFl4jgd9XFzGAXh9QQgRdttu5dXck1LPPY19NitDuEMCMc9G
         YV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4VhB2e/ltpu1xO6FxebSIJdavw/FcgMQSIeYIdUzE8E=;
        b=6BICWqTKi94EJTvqwQK8LsIlYAB9705seLhrSsSBDANeEGxeKY9oNJx7PCUW62Z/9d
         QPax0WOMEgT5z/BpfAF1Z6J+NvmuKvvu+m0d+3Wxzl/VBa9ILyW2xRlHsBJjkGRFr+oe
         LjL+qb2/F2ayNESjNZkTZcTErApnXXyuIjOyjmiq8+uSiSg1OJX9qKhInqyMfDG4BZtK
         +RKEIYcNEsO0adM5casV93nyBshqWvIWUZMCApMHEsknSK76kUYkZEMSvHZRK86C2D3i
         6YqMBcYrgCXwsXvg5uDMPVxmALeS/KHp/2vc39ZOOVATyQjCu3iQg82dg5RyKve5pQ+j
         jXtg==
X-Gm-Message-State: AOAM531OEOGItu2oB6y60nrFRA+5UuQ+49HGN6Ayfn4XVFBVyEbbqjYh
        FsmZY91RIaHD8iCnbOat0LJ0UA==
X-Google-Smtp-Source: ABdhPJyHF7hM8V6O84F0LFPlhTciyOv7byFP2rtEm5inGFYWa9ZRBeTODiIowgOO0jIDtMk+cgWVvA==
X-Received: by 2002:aa7:d9d9:0:b0:42d:f9e4:49e0 with SMTP id v25-20020aa7d9d9000000b0042df9e449e0mr37174658eds.299.1654672197861;
        Wed, 08 Jun 2022 00:09:57 -0700 (PDT)
Received: from [192.168.0.188] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id m11-20020a056402050b00b0042dd7e13391sm11673670edv.45.2022.06.08.00.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 00:09:57 -0700 (PDT)
Message-ID: <9d387882-3c9a-5056-9ee3-81ab6ea0a9a6@linaro.org>
Date:   Wed, 8 Jun 2022 09:09:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net v3 3/3] nfc: st21nfca: fix incorrect sizing
 calculations in EVT_TRANSACTION
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@google.com>, kuba@kernel.org
Cc:     christophe.ricard@gmail.com, gregkh@linuxfoundation.org,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        martin.faltesek@gmail.com, netdev@vger.kernel.org,
        linux-nfc@lists.01.org, sameo@linux.intel.com, wklin@google.com,
        theflamefire89@gmail.com, stable@vger.kernel.org
References: <20220607025729.1673212-1-mfaltesek@google.com>
 <20220607025729.1673212-4-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220607025729.1673212-4-mfaltesek@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2022 04:57, Martin Faltesek wrote:
> The transaction buffer is allocated by using the size of the packet buf,
> and subtracting two which seem intended to remove the two tags which are
> not present in the target structure. This calculation leads to under
> counting memory because of differences between the packet contents and the
> target structure. The aid_len field is a u8 in the packet, but a u32 in
> the structure, resulting in at least 3 bytes always being under counted.
> Further, the aid data is a variable length field in the packet, but fixed
> in the structure, so if this field is less than the max, the difference is
> added to the under counting.
> 
> The last validation check for transaction->params_len is also incorrect
> since it employs the same accounting error.
> 
> To fix, perform validation checks progressively to safely reach the
> next field, to determine the size of both buffers and verify both tags.
> Once all validation checks pass, allocate the buffer and copy the data.
> This eliminates freeing memory on the error path, as those checks are
> moved ahead of memory allocation.
> 
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
