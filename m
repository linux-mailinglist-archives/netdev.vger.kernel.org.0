Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4DD5A361B
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 10:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiH0Iz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 04:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiH0Iz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 04:55:28 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586F512D18;
        Sat, 27 Aug 2022 01:55:24 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id y3so7010520ejc.1;
        Sat, 27 Aug 2022 01:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=vOI84sZdwSXoHHFauLqlUAPvGEyu0wLF74hrJBYkpsY=;
        b=N+ywI9yrM6vlHdtGY70f/HNljRCBO7dO8RyvHnxLlMCo3rkPlC8TLipmohew1WSAlB
         EjYo6AsAYOEtkBY+mP+IunEm8yVdl8ssv6460V35fOdOVOxBIo+O6cQcq6L5lSV3sKGt
         i7OslYHAvhu/bmKN/NRbPMc65VCrFccSdJI3NKUoaoBZOR1EKqjljrbO/cgbYrGtciAn
         Juh9WVr7OHv09X21bjQkNzPlhQk0Bo4P74K4dzc+xMmeeDRCO6ecPU6A5SoTn8Rq7ZFN
         4CHFh9vFhCawYdj7WfYDzoxpCe1gB3aw/YkFd6W0FUkLSAP6OceEDWj5TwQIXE1+WsJT
         HNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=vOI84sZdwSXoHHFauLqlUAPvGEyu0wLF74hrJBYkpsY=;
        b=VUiUBwhqFD06n62ZHQ8An7+LzosAXWAzLK+HehGEL/ombUueH+5+gw9dOgJZ6KuDbZ
         9foC+be4cLoJCoRvFYyI4HT5wfR3zzmTkZNZHfuxTRL3xV5RTMDFTz08YmlbpifTVw6s
         LL8DQRBKoSjXVcyBhdDQbiFZT4iXFkuhE3RFVZr9FBYbudcgXmGxgWEYfnMFwPVSsEpf
         efIc2KgDIhdm/M2bGIOvcGm3M5w31jisqSpJmxiD4jmYQZAFLakrIp8EgR407YxhMgjv
         /pfSGXGdMH2Rk8euceOrdIAXQIUbgVcF3rlQpTchRtZ1sr7o+wu+24Kg1n8ks3ZnuSMC
         beDw==
X-Gm-Message-State: ACgBeo2Oa1xZGqP5jpryfrUayHo9syRTj0ImAsQmqO/V0yqnQH5ylxEz
        lx+O0HItoxrqhgV31JQekI0=
X-Google-Smtp-Source: AA6agR5APnxPUBh8hJPbTOu+Ra7p6g09Ym5gPLH4TmR1b8Ywmvz8v5gV7Xf8+oIavQpTp4dciwgLQg==
X-Received: by 2002:a17:907:3da4:b0:73c:d2f4:a633 with SMTP id he36-20020a1709073da400b0073cd2f4a633mr7801398ejc.446.1661590522883;
        Sat, 27 Aug 2022 01:55:22 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:8f53:b527:b359:d425? ([2a04:241e:502:a09c:8f53:b527:b359:d425])
        by smtp.gmail.com with ESMTPSA id bc17-20020a056402205100b00445e1489313sm2459776edb.94.2022.08.27.01.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Aug 2022 01:55:22 -0700 (PDT)
Message-ID: <f02ae4bb-2e50-e096-7505-3928b16d4009@gmail.com>
Date:   Sat, 27 Aug 2022 11:55:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 00/31] net/tcp: Add TCP-AO support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Dmitry Safonov <dima@arista.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20220818170005.747015-1-dima@arista.com>
 <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
 <a83e24c9-ab25-6ca0-8b81-268f92791ae5@kernel.org>
 <8097c38e-e88e-66ad-74d3-2f4a9e3734f4@arista.com>
 <7ad5a9be-4ee9-bab2-4a70-b0f661f91beb@gmail.com> <YwYdqEFQuQjXxATb@lunn.ch>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <YwYdqEFQuQjXxATb@lunn.ch>
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



On 8/24/22 15:46, Andrew Lunn wrote:
>> I think it would make sense to push key validity times and the key selection
>> policy entirely in the kernel so that it can handle key rotation/expiration
>> by itself. This way userspace only has to configure the keys and doesn't
>> have to touch established connections at all.
> 
> I know nothing aobut TCP-AO, nor much about kTLS. But doesn't kTLS
> have the same issue? Is there anything which can be learnt from kTLS?
> Maybe the same mechanisms can be used? No point inventing something
> new if you can copy/refactor working code?
> 
>> My series has a "flags" field on the key struct where it can filter by IP,
>> prefix, ifindex and so on. It would be possible to add additional flags for
>> making the key only valid between certain times (by wall time).
> 
> What out for wall clock time, it jumps around in funny ways. Plus the
> kernel has no idea what time zone the wall the wall clock is mounted
> on is in.

A close equivalent seems to exist in ipsec in the "xfrm_lifetime_cfg" 
struct, specifically the soft/hard expires timers. These are optional 
validity times for each xfrm_state which is equivalent to a "key".

I'm not familiar with how those are used but ipsec usually relies on 
complex userspace daemons for managing xfrm states and policies and 
those daemons should be capable of adding and removing keys based on 
internal timers. Still, the linux kernel supports checking for key 
validity on it's own.

--
Regards,
Leonard
