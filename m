Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA541596B0A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 10:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbiHQIKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 04:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiHQIKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 04:10:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2264D24C;
        Wed, 17 Aug 2022 01:10:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id x19so293386plc.5;
        Wed, 17 Aug 2022 01:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=yDyqXXuN5rFWHjE/u6lA6dNFJY0ydf5Bv6weQesHpqQ=;
        b=G4iZu8kyTF8Phd/KPNzRcRZjC3rK20PbbPKdSDgBBYre6kr/7C4KCnjlxGmtQ/N9o4
         hU/WwhXlTtq7l00OBoiu+cBz7kC4Kxik07W34up2RsAf66OmiNTImZMluELf+MfVloAr
         Y/o9TIb1qzd6xOO2d8ooV9OZXkWrXr66kgXfxYIxYSw1e7slziQ62yXPVXFZvrZELXXb
         EsAn2OWB50OStemwwvrjyN84g78zhYsb7Etm5kasilu0PunW0NmPhqVssZtrN0qejPI8
         bl6GyJ3COZztOl6nfZM1tE19ZMO4F8hTsmeOgz72Oj6LC4HaTBWdtCJnRDF7PiJYA2c9
         HZdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=yDyqXXuN5rFWHjE/u6lA6dNFJY0ydf5Bv6weQesHpqQ=;
        b=v9UlhbHSMbMyMrRX98oixo3QAGvcOIXNXJ684TMHXH11KeiVAVW79rW8kB7p8jzVID
         QrnDgpE+mIL4qtiREMfxtRWigj5cE9A/yDnYADDttjR9pQMm8FwsvdhAPlLDYgcLb1IO
         pmE86qngvbZPa/CPGrVvUJMCDo2zvo29K5lq/xoOkixNoICJ9tG8+VfEo5+W17QlK2sD
         Msh6DIU21eEBXOXyplJD1effofWGpqpDATSpgOHpjAtbTDXCBgT1EqYf/N+MqHrtSk+j
         wzw4N6U7g4H8zQhs6JCeRSNsywVexJ9vJVp8i0twpreDxxuZUXtqQFJ7o13XhNEKAyGC
         yEwg==
X-Gm-Message-State: ACgBeo0KQyuQvU9IFUmwUuT57GirgjiO9fM5rLBSMEwwn7I1hC6GJuFb
        Fk+bqbokgBqvck1C/y2g2Ndzqu0lBOc=
X-Google-Smtp-Source: AA6agR4Q1ekOzxu8bNgBdEWsUOpMG80+bN++7dVn0UiLLFkrbLbpLJRyjmFeIHN9N9PojENdJCGPMA==
X-Received: by 2002:a17:902:cf43:b0:172:86f3:586a with SMTP id e3-20020a170902cf4300b0017286f3586amr5533184plg.71.1660723806255;
        Wed, 17 Aug 2022 01:10:06 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-75.three.co.id. [180.214.232.75])
        by smtp.gmail.com with ESMTPSA id p4-20020a631e44000000b00429e093cbadsm58164pgm.10.2022.08.17.01.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 01:10:05 -0700 (PDT)
Message-ID: <68e3a841-3c03-9d70-8c89-b7c05788e077@gmail.com>
Date:   Wed, 17 Aug 2022 15:09:58 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [net-next 0/6] net: support QUIC crypto
Content-Language: en-US
To:     Adel Abouchaev <adel.abushaev@gmail.com>, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220816181150.3507444-1-adel.abushaev@gmail.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220816181150.3507444-1-adel.abushaev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/22 01:11, Adel Abouchaev wrote:
> QUIC requires end to end encryption of the data. The application usually
> prepares the data in clear text, encrypts and calls send() which implies
> multiple copies of the data before the packets hit the networking stack.
> Similar to kTLS, QUIC kernel offload of cryptography reduces the memory
> pressure by reducing the number of copies.
> 
> The scope of kernel support is limited to the symmetric cryptography,
> leaving the handshake to the user space library. For QUIC in particular,
> the application packets that require symmetric cryptography are the 1RTT
> packets with short headers. Kernel will encrypt the application packets
> on transmission and decrypt on receive. This series implements Tx only,
> because in QUIC server applications Tx outweighs Rx by orders of
> magnitude.
> 
> Supporting the combination of QUIC and GSO requires the application to
> correctly place the data and the kernel to correctly slice it. The
> encryption process appends an arbitrary number of bytes (tag) to the end
> of the message to authenticate it. The GSO value should include this
> overhead, the offload would then subtract the tag size to parse the
> input on Tx before chunking and encrypting it.
> 
> With the kernel cryptography, the buffer copy operation is conjoined
> with the encryption operation. The memory bandwidth is reduced by 5-8%.
> When devices supporting QUIC encryption in hardware come to the market,
> we will be able to free further 7% of CPU utilization which is used
> today for crypto operations.
> 

Hmmm...

I can't cleanly applied this series on top of current net-next. Exactly
on what commit this series is based on?

Also, I see two whitespace warnings when applying. Please fixup and resend.
When resending, don't forget to pass --base to git-format-patch(1).

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
