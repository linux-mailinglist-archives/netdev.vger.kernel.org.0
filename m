Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF1A59760F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241304AbiHQSti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241302AbiHQStf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:49:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F7B33A10;
        Wed, 17 Aug 2022 11:49:33 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t22so13271539pjy.1;
        Wed, 17 Aug 2022 11:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=YZXdqwb5A4cK2ZLDgN37By3nDf7z0KCHSAijNLkJe1U=;
        b=FdwBl7BCc3B8O90ecsZ5kMyqFzaNAISJV/CIxqwnMRkDwt2OazLF/gh4lGJ++F0kRc
         82K1U95iitw56QpXruqY7ejLHOg4kkgMp3Qj3JxoiWqMOtVvwVEeYtJspSpS/Ceiq05q
         uFS6mZELnGmwmfOmopJOg9ANrwfvg9Rlr7WjuaxnWkusuqjpmmiGtDNejk9JgaUdmtSv
         LwmnyatV+D0QgIOKYvID9gxaa/kGn5DQMf1MURQhNogbulcxSns+9whld+tqjDFcRhg5
         cktK/Jk1zfAhxmjUY6Ipv+ImGvyf7geaMG8XIj01PJOGnFDfOAghZScD093QRrePWj4d
         YL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=YZXdqwb5A4cK2ZLDgN37By3nDf7z0KCHSAijNLkJe1U=;
        b=VtBgbut0J88tdYcsCWZ17CjpFwbVjQATiTkxdNQTuUqfoKl8rpHCrjYTCTxzzmw3aF
         2+HrhzH2YZKArbyfSLoObyzN/JwyWp/w3VQihBe9NhuML+nc9lieefV1uejy+Z8h45uJ
         FJH7qcCsA/fpKx/V0/pROq47F5Xw1molsn4SSU+IfZvTk3f3q7D7z6CKeJhbhbEtWNB3
         tKeqOkWuknhY81HuilM+6GsuWbuCso/JowvfvM9QlsSjlZ6yJh1+dlEcoB8i119yUTXr
         j0Wp6h1c0hxDlxnCQVoEx+h/WUFjhwtXbDCcYOK9GWqMvOJk9Xn8GHfhUHvfy9cbbTuJ
         BrmQ==
X-Gm-Message-State: ACgBeo2Dep/w0H3z44jEncbUXOPoFiTViz6ZCulCiNkYW2Px+Zo2Nfln
        5WeE1DBwagGmtFJKwXvObEA=
X-Google-Smtp-Source: AA6agR5XV3ubO2gfC2o2YrYfc9mn+8mIook5e8IVB6zpCLW16GZNMh9OJa+rDvBxAnz2uE0Nw/OEIw==
X-Received: by 2002:a17:902:ef96:b0:172:abb9:657e with SMTP id iz22-20020a170902ef9600b00172abb9657emr817288plb.48.1660762172548;
        Wed, 17 Aug 2022 11:49:32 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e8::128c? ([2620:10d:c090:400::5:8975])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902684e00b0016d5428f041sm244435pln.199.2022.08.17.11.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 11:49:32 -0700 (PDT)
Message-ID: <56034d0a-4100-b185-73d8-44edc8508dc0@gmail.com>
Date:   Wed, 17 Aug 2022 11:49:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
Subject: Re: [net-next 0/6] net: support QUIC crypto
To:     Bagas Sanjaya <bagasdotme@gmail.com>, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220816181150.3507444-1-adel.abushaev@gmail.com>
 <68e3a841-3c03-9d70-8c89-b7c05788e077@gmail.com>
Content-Language: en-US
From:   Adel Abouchaev <adel.abushaev@gmail.com>
In-Reply-To: <68e3a841-3c03-9d70-8c89-b7c05788e077@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The base commit for the branch I am using here is:

commit f86d1fbbe7858884d6754534a0afbb74fc30bc26 
(origin/net-next-upstream, net-next/master, net-next/main, net-next)
Merge: 526942b8134c 7c6327c77d50
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Aug 3 16:29:08 2022 -0700

Will fix the whitespaces and resubmit.

On 8/17/22 1:09 AM, Bagas Sanjaya wrote:
> On 8/17/22 01:11, Adel Abouchaev wrote:
>> QUIC requires end to end encryption of the data. The application usually
>> prepares the data in clear text, encrypts and calls send() which implies
>> multiple copies of the data before the packets hit the networking stack.
>> Similar to kTLS, QUIC kernel offload of cryptography reduces the memory
>> pressure by reducing the number of copies.
>>
>> The scope of kernel support is limited to the symmetric cryptography,
>> leaving the handshake to the user space library. For QUIC in particular,
>> the application packets that require symmetric cryptography are the 1RTT
>> packets with short headers. Kernel will encrypt the application packets
>> on transmission and decrypt on receive. This series implements Tx only,
>> because in QUIC server applications Tx outweighs Rx by orders of
>> magnitude.
>>
>> Supporting the combination of QUIC and GSO requires the application to
>> correctly place the data and the kernel to correctly slice it. The
>> encryption process appends an arbitrary number of bytes (tag) to the end
>> of the message to authenticate it. The GSO value should include this
>> overhead, the offload would then subtract the tag size to parse the
>> input on Tx before chunking and encrypting it.
>>
>> With the kernel cryptography, the buffer copy operation is conjoined
>> with the encryption operation. The memory bandwidth is reduced by 5-8%.
>> When devices supporting QUIC encryption in hardware come to the market,
>> we will be able to free further 7% of CPU utilization which is used
>> today for crypto operations.
>>
> Hmmm...
>
> I can't cleanly applied this series on top of current net-next. Exactly
> on what commit this series is based on?
>
> Also, I see two whitespace warnings when applying. Please fixup and resend.
> When resending, don't forget to pass --base to git-format-patch(1).
>
> Thanks.
>
