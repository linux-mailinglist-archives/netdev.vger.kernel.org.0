Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65768443BBB
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 04:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhKCDMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 23:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhKCDMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 23:12:12 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FC5C061714;
        Tue,  2 Nov 2021 20:09:36 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id y11so1780624oih.7;
        Tue, 02 Nov 2021 20:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SQPaJ+2x2aG7EdCTgMSTtmw4QvWqKmF63/ZVUND23BQ=;
        b=NaT65DmZnwy+hfDkfQOJjtwa0ZuiCFCTiQEtS4mg6A/ixkENcZnBXNj7Ky6epdajvO
         PVJDEvnOjJr3DJRiRO+K6FgMcMX1Hl1tQF8CNlcdHNqLmiRp+q2nV5ZnBeDG8yvfe9oC
         R3Rfuulhgoy4YO3apo50xa0GUJb5cLPkaXafUcUccF4PP9VXHpMNOyhwFFbf/H9g+FnL
         H63+RkwrbMMXJwRMZCSUOXqhSyzmRNB7X7wRAoOrYmeBrRnLPvWQZEdmdNK3vrKZMSMM
         sS3kchfXQlZ1MWjnMczDl+wChlSx+jkucRVgKEY8CK130Iz8OLmWmwTix4sXt0g4UhT3
         3ySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SQPaJ+2x2aG7EdCTgMSTtmw4QvWqKmF63/ZVUND23BQ=;
        b=RWRPsDoQQd/0+KXhnoKqgECf+Kz+GKCvXcHTq+I11vkwjmFw378Lc72+MnWSWwaJel
         mJjA8y6130zHFb0lLi8hf2X1Hkg143zs7xbl8QSP5xccJ6vRYFsFOfse+Izlhg4EMnRW
         RQZO7yG32e+2C6GX3+wh7BdxBCDwaBZKD/Hw1mGL1z82gRqyFxuqfOqALHK7SR1YhfVn
         HZQ5aNaA/QdUXtPMS3ptDbnDY3alLTmVQk5cSFQCK01tcfpcbwAqZMfoRlCaSPIdO1mE
         CFzPNzcZw8+x2kFnNduIamJ9YL3gn9TMYx0Mp8jGndEgwhwF6Z0Qv41az82VNga9ueuP
         v3VQ==
X-Gm-Message-State: AOAM531umioZI9J6dyX+8o8DOZJAi11SeRM1p/NiL9okadaD1ZAswIqM
        oS8uEFyc+DfFnPmYWohMHTU=
X-Google-Smtp-Source: ABdhPJyb43jnveyBOtTgKJKN2sc5zh9yciFMBEkx2eMnB+Qv3mEkIj8Y748sr2O4ij5Nl0VxuAROmg==
X-Received: by 2002:a05:6808:2189:: with SMTP id be9mr8557420oib.145.1635908975905;
        Tue, 02 Nov 2021 20:09:35 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id k4sm229122otr.7.2021.11.02.20.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 20:09:35 -0700 (PDT)
Message-ID: <cc905cfc-ab74-a64a-f734-06ed6701df9d@gmail.com>
Date:   Tue, 2 Nov 2021 21:09:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 24/25] selftests: nettest: Initial tcp_authopt support
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
 <0a89ec520bb406c046e76537ba7e218c882a2d2f.1635784253.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <0a89ec520bb406c046e76537ba7e218c882a2d2f.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:34 AM, Leonard Crestez wrote:
> Add support for configuring TCP Authentication Option. Only a single key
> is supported with default options.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/nettest.c | 75 ++++++++++++++++++++++++---
>  1 file changed, 69 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


