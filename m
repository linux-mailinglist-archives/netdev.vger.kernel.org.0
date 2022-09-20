Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D4E5BE7BC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiITNz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiITNzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:55:40 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC5963A9
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:54:33 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id c7so3046171ljm.12
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=wBzI+FDP/xHbpMc4ZR1RvLoZ+WufA1CKuPKcPQeIWxs=;
        b=jKP4O2Vs5dgzrrV3QjJGsS/tq+4AAw9Cn0UMg7Z6+RT5/S8x55GBEmciQyE2xBxHNl
         cLEOAq+ndnid9UY81L7XfUzwUAOo5jDRyRbeCuYPY4Tm4U3mlu4CWwBBwhg6yjKuY1Jg
         9/naHdgqElN1RZGaH9ErYL6Lbtjo/zvZy/0qP6+HwVfM0DbxeNYkgLTWVFrIGPUwFGrI
         R0bywwdc02ZDYB1rk27nDWXxeczPZ1gBsH9WcfAzC6Ow2y/Kw1wuwAjBfNKDdUDUbFO6
         /1vcUU8n1TN/qwbOJ2Tg1l9doC45MY9Axh2lDP5oq2E16JdYboriwb0t9iRscsBIKRCs
         Z+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=wBzI+FDP/xHbpMc4ZR1RvLoZ+WufA1CKuPKcPQeIWxs=;
        b=6GhA+bAt7j/DL4P7uCmApaZQvgbw1cMmRGYJUygm2fM87gAezP4olp/QC1fzhDT/a/
         rtTpefSW5CedLY9KoKIhnzst0ae7J8VCimT8oRsw8vt+IvZp9aq5l+pGYVlr14riUK1N
         +oMYNjxY5Iz0patSN4XvR7OnhDdG7Fnd/V++yc6u9Rb7Rz52ndIXihsmDqvkNW1QKGtG
         qYCZV82IIl5dh1MJfJ0ql80xXJGPl9QemHlrsTHStpSYdfFugzrr3uTH3qKkgproVmgo
         zGWH2Jaf6tmw2e0aof0+iCfi7TIc/JCR/xF+c4qa40H1EEMMsZnylPihiYtIUqP57pDg
         0KTg==
X-Gm-Message-State: ACrzQf2VFvocwoO19T1KGQT7z0LRU+cDHtZERbkCG6zKLXiLttpcrXXm
        VFFsIozyeEdpHXJqLO9sBbeDxE/3aFC6HQ==
X-Google-Smtp-Source: AMsMyM7qwNQsEBzVzh51pbKzZ073N0bCU/uLTdwj8t+B9IR78GGUWgkfjRPrW7ec6ftreXNBIXP7qw==
X-Received: by 2002:a2e:964b:0:b0:26c:5a42:ed99 with SMTP id z11-20020a2e964b000000b0026c5a42ed99mr1310939ljh.169.1663682071302;
        Tue, 20 Sep 2022 06:54:31 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id u22-20020a05651c131600b0026c4113c150sm8590lja.111.2022.09.20.06.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 06:54:30 -0700 (PDT)
Message-ID: <18828928-415f-2faa-8069-b4d01fa38fc6@linaro.org>
Date:   Tue, 20 Sep 2022 15:54:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: task hung in port100_send_cmd_sync
Content-Language: en-US
To:     Rondreis <linhaoguo86@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>
References: <CAB7eexL3ac2jxVQ70Q06F6sK9VdwY2aoO=S6OqYu7DTgFMg6tQ@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAB7eexL3ac2jxVQ70Q06F6sK9VdwY2aoO=S6OqYu7DTgFMg6tQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2022 15:22, Rondreis wrote:
> Hello,
> 
> When fuzzing the Linux kernel driver v6.0-rc4, the following crash was
> triggered.

Hi,

Thanks for the report.

> 
> HEAD commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
> git tree: upstream
> 
> kernel config: https://pastebin.com/raw/xtrgsXP3
> C reproducer: https://pastebin.com/raw/hjSnLzDh
> console output: https://pastebin.com/raw/3ixbVNcR
> 
> Basically, in the c reproducer, we use the gadget module to emulate
> attaching a USB device(vendor id: 0x54c, product id: 0x6c1, with the
> printer function) and executing some simple sequence of system calls.
> To reproduce this crash, we utilize a third-party library to emulate
> the attaching process: https://github.com/linux-usb-gadgets/libusbgx.
> Just clone this repository, install it, and compile the c
> reproducer with ``` gcc crash.c -lusbgx -lconfig -o crash ``` will do
> the trick.
> 
> I would appreciate it if you have any idea how to solve this bug.

You can try to bisect. Or you can build kernel with lockdep and try to
reproduce.

> 
> The crash report is as follows:

It's not a crash, but a blocked task, so there might be deadlock,
incorrect synchronization or some missing cleanup path. Actually quite a
lot could lead to this.

Best regards,
Krzysztof
