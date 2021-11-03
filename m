Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA98443B69
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhKCCeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhKCCeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:34:21 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5231C061714;
        Tue,  2 Nov 2021 19:31:45 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id v40-20020a056830092800b0055591caa9c6so1572517ott.4;
        Tue, 02 Nov 2021 19:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eWyMSzi2F1vTevHmGjTTEEqZIatQhxM0h+aLftMaVeQ=;
        b=Xs8eAc3eUz3/7cZBD1GHXKyurmnQQ4x1k7JPTYJD2YMaKvd7ogaqHjRlqvAgNiyQ8h
         s86g4x/ZpAlw1JWofIltbw5Y62s6pulSv+Q3sqXo6RIuktR87pm61tme4KGVLoM3wnKq
         EJWlltHVxK7S8WdcsAsTWEuxgcRwwhcV7vJKn56eeY0tKi1Ly/2C0pAwosk65F5OAjAY
         B25OggueMknjLxBE4YyiSs+rp6m4Tm4zksJO04L1uVdbkpzjEYNsggqoJrvH0XjVXFVP
         TY8PAJPfcbD+yb5H31GqOKMJy29211HaauypIPUuyiJbxVyhcmeq4OeMf4OYfCz5fr39
         Z4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eWyMSzi2F1vTevHmGjTTEEqZIatQhxM0h+aLftMaVeQ=;
        b=m+1HIJ6dd3rhx5rKRv5tRerUuKVPQC11G1Eac86DOaLavo/BRskmneUqT4kh6FAXKl
         1Ckqmo3vma0hIAqM7Wmk+f0kfCP6bToTpWtpSNu9SgtBF0J/QICmpSW3zuvB50I7sTn5
         8q9DuYzAXe0XbeFFi4+nnMdeJRQFfsCNmhv4X8EyBbgHoH70xAQG5FyaR1nmFVEq/oAc
         j3TTvIkM4wyjSmh7ZkobA1255JvMJMLQNYPZ0/KqZklWpNrZVlIqCE8M6lcSlrIsYNEs
         esVMXg97cXWppm8S9bUfN1S5lqOs2/ZWS7BKsi6QPm3bTUmfRs6cxtH8PD/0anPIXKOb
         xtVQ==
X-Gm-Message-State: AOAM533giOfvkOcmmPX3Dn3yoE1E8kvr4dnokCYwiPb9qXkAgRwYfFJd
        T3GXCMsCamrWhWaBsz2fsaE=
X-Google-Smtp-Source: ABdhPJxGEspg2Dx5iY6aNJ1hX8kUE9/73Q1Iu1YDGcF8bTFgAlGM9re4kH+M118mhVSW2W1QTPDMfw==
X-Received: by 2002:a9d:6743:: with SMTP id w3mr20044539otm.120.1635906705036;
        Tue, 02 Nov 2021 19:31:45 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id v66sm236687oib.18.2021.11.02.19.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 19:31:44 -0700 (PDT)
Message-ID: <79ab8aae-8a61-b279-a702-15f24b406044@gmail.com>
Date:   Tue, 2 Nov 2021 20:31:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 07/25] tcp: Use BIT() for OPTION_* constants
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <dc9dca0006fa1b586da44dcd54e29eb4300fe773.1635784253.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <dc9dca0006fa1b586da44dcd54e29eb4300fe773.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:34 AM, Leonard Crestez wrote:
> Extending these flags using the existing (1 << x) pattern triggers
> complaints from checkpatch.
> 
> Instead of ignoring checkpatch modify the existing values to use BIT(x)
> style in a separate commit.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  net/ipv4/tcp_output.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 

This one could be sent outside of this patch set since you are not
adding new values. Patch sets > 20 are generally frowned upon; sending
this one separately helps get the number down.
