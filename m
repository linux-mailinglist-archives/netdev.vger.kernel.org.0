Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EA6443BB7
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 04:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhKCDKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 23:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbhKCDKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 23:10:43 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34137C061714;
        Tue,  2 Nov 2021 20:08:08 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id o10-20020a9d718a000000b00554a0fe7ba0so1621894otj.11;
        Tue, 02 Nov 2021 20:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6z+k/QJ3HLFDXmheNramV17JGzWyyyvIDWrnMuDwkLA=;
        b=FfQcG5mTLGLN1elGHktYImCBJDsKoz61ZNEuYVT/rhJNIVDie3vbPTR2nb6iDDiB1Y
         ZLEn169dniLHbsWQI4XkSONRkAMTpN8/lEt4vEYiewbE21pQbT9+NktjmtXGUxqFoFc4
         jjHmmcFgIkRx1rZZI74q7xPjj641/ujZx3ZgJUbIs3SbqTdgRkYIF83eUvaaVVlSWGEJ
         b+eumKiag+rcDjPIATO/+RMJ9ddNkbPBCXQeUa7RY2jP81nBWJdxu+3l9ooO2DSZQr5w
         br5butrCIcHTkaqWxhoV3s+HbVdh+Hc3H7WmMBc4/u/FfjLRQKmCzG7DmnQxQCM6M+Zz
         9LuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6z+k/QJ3HLFDXmheNramV17JGzWyyyvIDWrnMuDwkLA=;
        b=vM8fGpBRVAkj22XyVm4UB1R+PX9vo10RYU1tgL0N9QFBUCNeodpDin3RJEy8lDZy5E
         l+HbQUijmfRM7F48iOC1uO7urHLj1hWQr3+hCOktir17odBmAHHpIEcReXmxQ2zjByqw
         +ei9kCP+TQvDwG5E6CZWdU/ucjG5yueT6BllRS/qWPv1jjQjk7ynty+Q908V8n5vPEKH
         WQn9M4RyHFH6Y4XhLgWhmmfuappkVgI3cHK2yUo0j6ZxWvtXPqRbpncGqOtc+vKzEaPF
         ycN7HdKxH6xYzM1GZI6BPFr1dFkn1vN6mgxaE1UvgpI+5q9nCPZA1YwuL8kkIh4rySVE
         7kKw==
X-Gm-Message-State: AOAM531UUHdgOFxN0XaF/tkEcVXywUSebdP7nzh2A56ryYnYCyZNMSYE
        a23jUWVM0Uhncj6aJEqd+Ko=
X-Google-Smtp-Source: ABdhPJyl4Y23t6HlkmjspjV7oeRdlgNqrgdl/id+qc3tA1GsWb788QrxbbsElZp4IhaFkdqVNnLNag==
X-Received: by 2002:a05:6830:2b1e:: with SMTP id l30mr13267377otv.287.1635908887327;
        Tue, 02 Nov 2021 20:08:07 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id s26sm229459otq.14.2021.11.02.20.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 20:08:07 -0700 (PDT)
Message-ID: <99d4f065-0561-e97e-f588-09d2d1a1fd32@gmail.com>
Date:   Tue, 2 Nov 2021 21:08:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 23/25] selftests: nettest: Rename md5_prefix to
 key_addr_prefix
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
 <1261828edf213915fa3810d6fa849c4857582dd6.1635784253.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <1261828edf213915fa3810d6fa849c4857582dd6.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:34 AM, Leonard Crestez wrote:
> This is in preparation for reusing the same option for TCP-AO
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/nettest.c | 50 +++++++++++++--------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


