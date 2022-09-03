Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DCD5ABE25
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 11:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiICJgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 05:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiICJgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 05:36:07 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F4A2B27A;
        Sat,  3 Sep 2022 02:36:01 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id p16so8053454ejb.9;
        Sat, 03 Sep 2022 02:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=cYpK52+AbV0mo3/PdZ6oSyeezUksBCAZPCdP5o2p4qQ=;
        b=hWeJbzzd5Vv/c7G5J+qdsWZWuyvLD+6FW7EBpWY1oyV2IimGtw91VnZU6ykBhKxRd0
         HI/96YapkPZ/Qb4/kqaW4eEDuAyMD1X9WfXF6zxWTs/aQplO4nYBuINcP3ia27eqf4UJ
         2zXJmG75WpnBUWPf0F56nYuPjp3tnu2DNOkcfSqkaCzC84w3M9Rllu3/iqK3KYKzo1Nd
         yGl0dV5x1gEnElOVQSdnmI+bLDJGYJmn6UPajVPZUkas/IPEifhcQvJLO/1QIdBO7JOL
         BchBJgDnma3ZtQNxffW+NjcqLme5Uch9iNbm/1uAVVrQ7p5rcvAPN15Nu2/qpTnbfII8
         vThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=cYpK52+AbV0mo3/PdZ6oSyeezUksBCAZPCdP5o2p4qQ=;
        b=fy8LIHCeIild9gWHlppA3rxF+7zgqQUcnHFCj1M7zyeU8+P0+uvakNQHY0h3Qg+Tu3
         JbeFYQYbN+9VjUnF1TDSQaJDVmNLCLz3plwieiZUQgB2AVwaQEK31/VhiIYfue2GtmKc
         1Dmyv+ltgVVWg0qB920er6Z9av8OEGHLcZUDVM+ytgks+wZCQnKsTKxGKg2koiEYXYB+
         YbOnPSeygIUkk62gHFcoRo7ptOONRt3HAlOagQyKtbaC1cs8Kgu5guGzUAmCNQOa0vId
         0a4cAbEOID4VUnVgrJ8YD/ypwJaoP1ARpg34MSMfNQkcTnLc16DIujI5rYSX8xCeepFS
         TLxw==
X-Gm-Message-State: ACgBeo35dUyUywQl4Xpz3gUgRNVxjAt1vefQnU1Ji8/zNA8d6YWr1gsF
        Uc+pGCoCDSZZdmwIdDMaKNY=
X-Google-Smtp-Source: AA6agR4omMFKjEKOdgtb55PZdhzqZpjCSGctYWyltoqHlH76z+4YzTjZ+VzWrbhbU4D8lNkcPMiHmA==
X-Received: by 2002:a17:906:5a64:b0:741:3586:92f with SMTP id my36-20020a1709065a6400b007413586092fmr25542689ejc.721.1662197759752;
        Sat, 03 Sep 2022 02:35:59 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:f5ae:4a6b:1158:493a? ([2a04:241e:502:a09c:f5ae:4a6b:1158:493a])
        by smtp.gmail.com with ESMTPSA id 8-20020a170906328800b0073dbaeb50f6sm2259494ejw.169.2022.09.03.02.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Sep 2022 02:35:59 -0700 (PDT)
Message-ID: <64091cfa-b735-14d4-f184-b02333dd303c@gmail.com>
Date:   Sat, 3 Sep 2022 12:35:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 08/31] net/tcp: Introduce TCP_AO setsockopt()s
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
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
        linux-crypto@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <20220818170005.747015-1-dima@arista.com>
 <20220818170005.747015-9-dima@arista.com>
 <162ae93b-5589-fbde-c63b-749f21051784@gmail.com>
 <CAGrbwDTW4_uVD+YbsL=jnfTGKAaHGOmzNZmpkSRi4xotzyNASg@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <CAGrbwDTW4_uVD+YbsL=jnfTGKAaHGOmzNZmpkSRi4xotzyNASg@mail.gmail.com>
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

On 8/31/22 21:48, Dmitry Safonov wrote:
> On 8/23/22 15:45, Leonard Crestez wrote:
>> On 8/18/22 19:59, Dmitry Safonov wrote:
> [..]
>>> +#define TCP_AO            38    /* (Add/Set MKT) */
>>> +#define TCP_AO_DEL        39    /* (Delete MKT) */
>>> +#define TCP_AO_MOD        40    /* (Modify MKT) */
>>
>> The TCP_AO_MOD sockopt doesn't actually modify and MKT, it only controls
>> per-socket properties. It is equivalent to my TCP_AUTHOPT sockopt while
>> TCP_AO is equivalent to TCP_AUTHOPT_KEY. My equivalent of TCP_AO_DEL
>> sockopt is a flag inside tcp_authopt_key.
> 
> Fair point, the comment could be "Modify AO", rather than "Modify MKT".
> On the other side, this can later support more per-key changes than in
> the initial proposal: i.e., zero per-key counters. Password and rcv/snd
> ids can't change to follow RFC text, but non-essentials may.
> So, the comment to the command here is not really incorrect.

I think it makes sense to at least separate per-key and per-socket 
options. This way a sockopt for per-socket info doesn't contain fields 
used to identify keys which is much clearer.

>> I also have two fields called "recv_keyid" and "recv_rnextkeyid" which
>> inform userspace about what the remote is sending, I'm not seeing an
>> equivalent on your side.
> 
> Sounds like a good candidate for getsockopt() for logs/debugging.
> 
>> The specification around send_keyid in the RFC is conflicting:
>> * User must be able to control it
> 
> I don't see where you read it, care to point it out?
> I see choosing the current_key by marking the preferred key during
> an establishment of a connection, but I don't see any "MUST control
> current_key". We allow changing current_key, but that's actually
> not something required by RFC, the only thing required is to respect
> rnext_key that's asked by peer.
> 
>> * Implementation must respect rnextkeyid in incoming packet
>>
>> I solved this apparent conflict by adding a
>> "TCP_AUTHOPT_FLAG_LOCK_KEYID" flag so that user can choose if it wants
>> to control the sending key or let it be controlled from the other side.
> 
> That's exactly violating the above "Implementation must respect
> rnextkeyid in incoming packet". See RFC5925 (7.5.2.e).

This is based on paragraphs towards the end of Section 7.1:

 >> TCP SEND, or a sequence of commands resulting in a SEND, MUST be
augmented so that the preferred outgoing MKT (current_key) and/or the
preferred incoming MKT (rnext_key) of a connection can be indicated.

This is for TCP SEND, not just open/connect. I'm reading this as a
requirement that userspace *MUST* be able to control the current key. 
Yes, it does seem contradict 7.5.2.e which is why I implemented this as 
a "key lock flag".

 >> TCP RECEIVE, or the sequence of commands resulting in a RECEIVE,
MUST be augmented so that the KeyID and RNextKeyID of a recently
received segment is available to the user out of band (e.g., as an
additional parameter to RECEIVE or via a STATUS call).

It seems to me that it *MUST* be possible for userspace to read the 
incoming rnextkeyid and handle it by itself. It could choose to follow 
7.5.2.e or it could do something entirely different. When it can't 
respect rnextkeyid because the key is not yet valid then userspace has 
more information to make an alternative current_key decision.

> 
> [..]
>> Only two algorithms are defined in RFC5926 and you have to treat one of
>> them as a special case. I remain convinced that generic support for
>> arbitrary algorithms is undesirable; it's better for the algorithm to be
>> specified as an enum.
> 
> So, why limit a new TCP sign feature to already insecure algorithms?
> One can already use any crypto algorithms for example, in tunnels.
> And I don't see any benefit in defining new magic macros, only downside.

Adding support for arbitrary algorithms increases complexity for no 
real-world gain. There are also lots of corner cases that must be 
treated correctly like odd traffic_keylen and maclen, having an enum
means that userspace can't attempt to trick us. The ABI is also smaller.

There's also a special case in one of the two concrete KDFs defined by 
RFC5925. What if there are more, will the ABI be expanded to support all 
the cases?

Disagreements over whether a particular form of extensibility is 
"useful" are unlikely to result in any sort of useful conclusion. I'm 
lazy so I only care about interop with existing implementations from 
Juniper and Cisco.

--
Regards,
Leonard
