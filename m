Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A9559B652
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 22:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiHUUev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 16:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiHUUeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 16:34:50 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CC038AD;
        Sun, 21 Aug 2022 13:34:48 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z2so11557867edc.1;
        Sun, 21 Aug 2022 13:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=u0xBB4WUkDL1tOr4RrTmkzbO/MXDWUk8RIDFwSxLKdI=;
        b=J/fpXmPtE5zJsfd66953UehJQLpxnFOnksELk8lhmNdj+8tDj+gLaagjzblKtntrdm
         62Jr0ApVttBDxEiMuNkOUS02xDAzgKPYK5xZS6g3TkrOgbT9BDGSQlbNAogfO19ii77S
         3lkrBmuYSCOsKxYDDg91JRuOIYxD9IyjsRioxB/GXn7jR9jewPXIkw1LRhjIjNcA+ExA
         +r0IHy5Y1MPFRNoaN7PcSvv98uEWAg5D7x0UpwcbYvB1eidQazaJv5w8DCpD8pCdg7GZ
         3IXoCtRb/qDOweuMdIpr8GaoRxk9uh6mtDr4mJMLk2/Eq9m00eSPiw22pmgfUeAeIq+4
         7LRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=u0xBB4WUkDL1tOr4RrTmkzbO/MXDWUk8RIDFwSxLKdI=;
        b=FKHMdlCnTzvu2N8XF9dlN2BGMuLm0WOGFUkFhsK2W7ncdnn4COvhv+mDWB8BCaZFtq
         uw/TGuMV/oLeAnvejz9txC5uCXjvu7epDB2xLNcDHt7uCU3QbD4iHErsqpqfiQq3aB8D
         fVN5lQGKkxtzhXo/CmUzUk7lG4qVZaKLrDYt2rOLQwrIdhGhk/Y5V7tshO3hbRErd+uN
         H8tzAjQkgmVY9OcCrRW6VL74bUpyLSL1d00UWmk9efsLQVdgXPpU10ETUoUXfwvjMr06
         e9Qxp+CwNlo/G9T2vYxnc2Oje0yXfgvJlZRU5RGDgk0KWJ28udMcqZ2yWuuELygLN/Xm
         GSYA==
X-Gm-Message-State: ACgBeo29MkFD++UXsq1mNVfC4k6f/eH49+vK5+ZnVQ8ECpRNnjF38oUX
        Whe+i+BKMRSusybmq3Dq4mE=
X-Google-Smtp-Source: AA6agR5Ng4qXqJJwNoXQ/uWqgJ1Nfyzc4aQQhyGalR3Xvf9QRBPmhj+GA1FiqHKO8+6D/1PyJy/Q+Q==
X-Received: by 2002:a05:6402:4496:b0:446:9708:5e12 with SMTP id er22-20020a056402449600b0044697085e12mr4114619edb.165.1661114086858;
        Sun, 21 Aug 2022 13:34:46 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:4f96:3eb5:9f0e:290e? ([2a04:241e:502:a09c:4f96:3eb5:9f0e:290e])
        by smtp.gmail.com with ESMTPSA id p7-20020a170906b20700b0073d706ac66csm1666322ejz.46.2022.08.21.13.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Aug 2022 13:34:46 -0700 (PDT)
Message-ID: <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
Date:   Sun, 21 Aug 2022 23:34:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 00/31] net/tcp: Add TCP-AO support
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
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
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220818170005.747015-1-dima@arista.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
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

On 8/18/22 19:59, Dmitry Safonov wrote:
> This patchset implements the TCP-AO option as described in RFC5925. There
> is a request from industry to move away from TCP-MD5SIG and it seems the time
> is right to have a TCP-AO upstreamed. This TCP option is meant to replace
> the TCP MD5 option and address its shortcomings. Specifically, it provides
> more secure hashing, key rotation and support for long-lived connections
> (see the summary of TCP-AO advantages over TCP-MD5 in (1.3) of RFC5925).
> The patch series starts with six patches that are not specific to TCP-AO
> but implement a general crypto facility that we thought is useful
> to eliminate code duplication between TCP-MD5SIG and TCP-AO as well as other
> crypto users. These six patches are being submitted separately in
> a different patchset [1]. Including them here will show better the gain
> in code sharing. Next are 18 patches that implement the actual TCP-AO option,
> followed by patches implementing selftests.
> 
> The patch set was written as a collaboration of three authors (in alphabetical
> order): Dmitry Safonov, Francesco Ruggeri and Salam Noureddine. Additional
> credits should be given to Prasad Koya, who was involved in early prototyping
> a few years back. There is also a separate submission done by Leonard Crestez
> whom we thank for his efforts getting an implementation of RFC5925 submitted
> for review upstream [2]. This is an independent implementation that makes
> different design decisions.

Is this based on something that Arista has had running for a while now 
or is a recent new development?

> For example, we chose a similar design to the TCP-MD5SIG implementation and
> used setsockopt()s to program per-socket keys, avoiding the extra complexity
> of managing a centralized key database in the kernel. A centralized database
> in the kernel has dubious benefits since it doesn’t eliminate per-socket
> setsockopts needed to specify which sockets need TCP-AO and what are the
> currently preferred keys. It also complicates traffic key caching and
> preventing deletion of in-use keys.

My implementation started with per-socket lists but switched to a global 
list because this way is much easier to manage from userspace. In 
practice userspace apps will want to ensure that all sockets use the 
same set of keys anyway.

> In this implementation, a centralized database of keys can be thought of
> as living in user space and user applications would have to program those
> keys on matching sockets. On the server side, the user application programs
> keys (MKTS in TCP-AO nomenclature) on the listening socket for all peers that
> are expected to connect. Prefix matching on the peer address is supported.
> When a peer issues a successful connect, all the MKTs matching the IP address
> of the peer are copied to the newly created socket. On the active side,
> when a connect() is issued all MKTs that do not match the peer are deleted
> from the socket since they will never match the peer. This implementation
> uses three setsockopt()s for adding, deleting and modifying keys on a socket.
> All three setsockopt()s have extensive sanity checks that prevent
> inconsistencies in the keys on a given socket. A getsockopt() is provided
> to get key information from any given socket.

My series doesn't try to prevent inconsistencies inside the key lists 
because it's not clear that the kernel should prevent userspace from 
shooting itself in the foot. Worst case is connection failure on 
misconfiguration which seems fine.

The RFC doesn't specify in detail how key management is to be performed, 
for example if two valid keys are available it doesn't mention which one 
should be used. Some guidance is found in RFC8177 but again not very much.

I implemented an ABI that can be used by userspace for RFC8177-style key 
management and asked for feedback but received very little. If you had 
come with a clear ABI proposal I would have tried to implement it.

Here's a link to our older discussion:

https://lore.kernel.org/netdev/e7f0449a-2bad-99ad-4737-016a0e6b8b84@gmail.com/

Seeing an entirely distinct unrelated implementation is very unexpected. 
What made you do this?

--
Regards,
Leonard
