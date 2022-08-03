Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447B3589273
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 20:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbiHCSwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 14:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236531AbiHCSwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 14:52:04 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028274A80F;
        Wed,  3 Aug 2022 11:52:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso3046633pjl.4;
        Wed, 03 Aug 2022 11:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=qakI0kMjNja616oMk36CPRVtxaRUluUF0dSRy+Y+iRg=;
        b=bbCH6djbZxuegde4jQNgakiSSFPVOA9ETDYU7/OUoP9lvYBMe+/oWfOhKDqt/RADmn
         KbY5TUeO80douXz3rWunAfoJlTXWKjTFAh1jpezuCRiu4VGe8ZyM6uX/ofhgy7AcapBP
         mFPE8rRawvoApQdcFvznp7NnGNzetX8PBhXI9z9XD6pJWsEfgNF5bx5Dm6HA6J/nYD4w
         Pc2faH/Mx19ahWAIUpSDlnwpHJyrVkO7cpjeFTUu353Md8hQF0cEF1tflUqniZ9PEdqr
         ITJ4n1qnr3F9X8XN9gExv4CWWs/4KUeA8DOpZPvYE0PBM0ghgRWbny1+IqceasWq0Pzj
         gnYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=qakI0kMjNja616oMk36CPRVtxaRUluUF0dSRy+Y+iRg=;
        b=XpwETBpCZjHLYJvfAyCX4hbvG6yR/PbRGoUSlP2oBBJovonxbqeWRTDyhZPIjw8Oig
         SZfuMBBapNzgkc0hn45XQZXpNq2szlBccHLSqy2aZVBvAdSEiic+PfkC8s/+9h34h71B
         EfQ2h0xskGKl2Hqxqh6nX/Bv4ixdKkHB9G927qt5RhZiaEO0mBtiaHlOFvUT+ftfXnHQ
         GpwVf1Ji7Ir7vtyXnZYzpfVoMgEf4Ze/s09veUJivSPMG+ClF4oZwnuK6abnebsFlkAy
         DWlo6/AVgKD5WZoDQUtfgz183YQ6WwRiwY+FHmPAV5A/4GmRW1ipdlzTG0GuWAnBXhiz
         brsQ==
X-Gm-Message-State: ACgBeo35eiduE4jSnKcxqf90jn2pPSJN/AYOALcMBZpqyBye+wNuFNqm
        eqdxI3ubFCdjf7X4PbSFmdY=
X-Google-Smtp-Source: AA6agR5KiQm70vN8UWOPhaWZwetHFdRXGJmUR/QQqpAnelHScCWTHtc/2SEviK460TiD2o1u3puavQ==
X-Received: by 2002:a17:90b:4cc5:b0:1f5:395:6c71 with SMTP id nd5-20020a17090b4cc500b001f503956c71mr6414725pjb.132.1659552722374;
        Wed, 03 Aug 2022 11:52:02 -0700 (PDT)
Received: from ?IPV6:2620:10d:c083:3603:1885:b229:3257:6535? ([2620:10d:c090:500::3:dd5a])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090a7c4700b001f2ef3c7956sm1900291pjl.25.2022.08.03.11.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 11:52:01 -0700 (PDT)
Message-ID: <4a757ba1-7b8e-6012-458e-217056eaee63@gmail.com>
Date:   Wed, 3 Aug 2022 11:51:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.0
Subject: Re: [RFC net-next 1/6] net: Documentation on QUIC kernel Tx crypto.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <adel.abushaev@gmail.com>
 <20220803164045.3585187-1-adel.abushaev@gmail.com>
 <20220803164045.3585187-2-adel.abushaev@gmail.com> <Yuq9PMIfmX0UsYtL@lunn.ch>
From:   Adel Abouchaev <adel.abushaev@gmail.com>
In-Reply-To: <Yuq9PMIfmX0UsYtL@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

Andrew,

    Could you add more to your comment? The /proc was used similarly to 
kTLS. Netlink is better, though, unsure how ULP stats would fit in it.

Cheers,

Adel.

On 8/3/22 11:23 AM, Andrew Lunn wrote:
>> +Statistics
>> +==========
>> +
>> +QUIC Tx offload to the kernel has counters reflected in /proc/net/quic_stat:
>> +
>> +  QuicCurrTxSw  - number of currently active kernel offloaded QUIC connections
>> +  QuicTxSw      - accumulative total number of offloaded QUIC connections
>> +  QuicTxSwError - accumulative total number of errors during QUIC Tx offload to
>> +                  kernel
> netlink messages please, not /proc for statistics. netlink is the
> preferred way to configure and report about the network stack.
>
> 	 Andrew
