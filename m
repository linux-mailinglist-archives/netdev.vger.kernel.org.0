Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59D557A10F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbiGSORP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238838AbiGSOQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:16:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABA361D78;
        Tue, 19 Jul 2022 06:48:25 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id m8so6220328edd.9;
        Tue, 19 Jul 2022 06:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H/QcNljsBbmdjrwrwjwtjEvq2HQmGFprhuK7NiBbLCY=;
        b=hLYimp8Okd9vJhnWXpRDdSRvTL1boG2q8EvYEEyc85GQ9lkfLa6YdBtEzDouHm6rJ+
         LPWjEXaeqGh/rVPplyIzvJDel4t8LcmKGAtG78Kuhv4Q+NQlFoZTJ1//dzvsgrJNS/Hf
         n4eBPbw0WinGSHbJowo1VrRODCGSGvxZIVj3wEaRAcZQNTlqJwmbluqSTM5dOxavCC+0
         UY5BXyZlLW3sXUstjgaWm+0C59Hsp/4YszXJIeygPrAGWUqvjqJSX4hvZlehk2arTjkM
         TA4htYczsZU7t+q0wWIfTUsaNlsy0LPo5WSARGMWS88sJXfMMalRLLXhUogpc+5amebS
         jnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H/QcNljsBbmdjrwrwjwtjEvq2HQmGFprhuK7NiBbLCY=;
        b=P3clVFcq1w0gaf6k0Gy/TJcGRJJyRTFrpspP18inO5NGOpv8qdW7LbttN5Ci2cijly
         g9xrWFyaegAaqHqtG8Z8EvL/KY5wY9QfrDh0ZR9D62/p381tjUU8ldMGMNLO7Ng9aTId
         DViCQvqjIrgZdv/Rl3CER6KJi8jZEuh/K/BhqVABJLmpldQ3a13YCcqzq9xqp9hYjfg5
         1PvJ7SYW6zIDRGwUBrtAH9tFruK5x3HO7XkO9Heq3Hf3+eIJDn1TgzsAQp01ljKUgNVD
         DAmB+azZgC1rTwVf6zu/yy0heEahQmIk5mHrniCedM6F4gh12CUQXyTYSBZQ1mR+WnSv
         rU8Q==
X-Gm-Message-State: AJIora+7ETgv3FNMFD6A/Hi+ozSZvkwtC1aeZPwhRNYHACGKkcYySSlQ
        HglekL9CqwBwKbAyRAnqWnu+R7ZRXXM=
X-Google-Smtp-Source: AGRyM1vfB8m0S9L87u7x8sMnidtJ7ms8KbYxF6JCQWGFj227DYAusFol270rKqeVp2RsdAd7Nzr2Dg==
X-Received: by 2002:a05:6402:c0b:b0:43a:25ff:ff08 with SMTP id co11-20020a0564020c0b00b0043a25ffff08mr44462159edb.148.1658238504156;
        Tue, 19 Jul 2022 06:48:24 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id v18-20020a170906293200b00721d8e5bf0bsm6758112ejd.6.2022.07.19.06.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 06:48:23 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 0/5] cleanup for data casting
To:     Pu Lehui <pulehui@huawei.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220718132938.1031864-1-pulehui@huawei.com>
 <CAADnVQJQ_WU6wfyaAkk3f9DaawDtsDT4BLZeBp2aPEZ4TMaYVQ@mail.gmail.com>
 <b5c03458-7fd8-3739-63b1-11618f4b8a6a@huawei.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <df76c412-d9e4-b89d-1bd3-eefb50280f57@gmail.com>
Date:   Tue, 19 Jul 2022 14:48:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <b5c03458-7fd8-3739-63b1-11618f4b8a6a@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> On Mon, Jul 18, 2022 at 5:59 AM Pu Lehui <pulehui@huawei.com> wrote:
>>> Previously, we found that memory address casting in libbpf
>>> was not appropriate [0]. Memory addresses are conceptually
>>> unsigned, (unsigned long) casting makes more sense. With the
>>> suggestion of Daniel, we applied this cleanup to the entire
>>> bpf, and there is no functional change.
Fwiw, pointers in C aren't necessarily unsigned; some versions of
 gcc have treated them as signed and — if no object can straddle
 the sign boundary — it's even allowed by the standard. [1]
(And at a hardware level, a memory address is just a pattern of
 bits on an address bus, which isn't arithmetic at all.)

-ed

[1]: https://yarchive.net/comp/linux/signed_pointers.html
