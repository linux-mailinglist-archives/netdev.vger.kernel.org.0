Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EF94182C8
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 16:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343510AbhIYOjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 10:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbhIYOjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 10:39:42 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6024BC061570;
        Sat, 25 Sep 2021 07:38:07 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c21so47661113edj.0;
        Sat, 25 Sep 2021 07:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xzHbIKUdSOaJuwjfaoRJbrHUYOSVx8ucR0op1libfso=;
        b=L2nTQl0BWQlTcp2ShOhT195N+sQrqjP7fMcFQWVf5nTQ8bXl5m0/3xFw0aWR/RoNRr
         GfaggP+H3r6T7SY5YJlIFiuTryKPPsOWKfdcvv2qyMg4maCFC7jv6IAiXWufuiaV8npM
         fXDEi7n2u9Y6ARDIKwoyXO1YNvI21voRgVe8Ce5ig60GZUZtfqdhwgaHgqUu1YPB//KH
         oR9Im5qPAffmK7TJjMLInyjb1+WqQ8+1/aeiOJhu+NSQt5U1KAK2TvNdsajtGdwCbWUf
         wylSnYDHMjPFVpJA23pHI69ReSaPHM+g7lB9sPQlQ4M098mftiqUGp7fzs84S306YirF
         Nh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xzHbIKUdSOaJuwjfaoRJbrHUYOSVx8ucR0op1libfso=;
        b=vvJeLkKTWahy1BaR5hlDC2FHVczRFWzN5IQFDgt5cZJZn3WIqj0I90jaQZNchPUq4j
         raIn2b4xknD86izx2gel17CRZwyAznO6BqvEw7rY7xpi8goA/5tiZh0jCvODueu8PLSE
         OFpD0WSuDL9WpM5/h+j33Rzlsv2bVIFjSG/eA4rU9KlR30j0c+5BTTmgrtwVZMDGoncV
         Lh8diZxWpeuaHHRBa+8HdBHvh9Qq6E63+9vOK/prcJwpaR2cdJ2h8K7qziSyt2PAeJae
         7ijFPXdj3steE5L/utT6U86tPTP1TgnXRvIL0zOLAxQkdhX4mDDf+CnN/9aK4MlPuNBW
         dkwA==
X-Gm-Message-State: AOAM531LcQBqciY0YgyrVhlKNnQ5J5BXHhn8hTOr6gyP+USB3evfMzy4
        gqjdcUq8ViiOos8jaWvcQHGsK3oACN216UmrHK0=
X-Google-Smtp-Source: ABdhPJzj1RRjI0yWqPdueFUbJmsHfU9Spjq/ZfBywmKGj0TYFU7/X/Y0oe5pSAwJb/WUYTnGRSjjBw==
X-Received: by 2002:a05:6402:b51:: with SMTP id bx17mr11655023edb.193.1632580685985;
        Sat, 25 Sep 2021 07:38:05 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:55c:dc9d:9cc1:2c16? ([2a04:241e:501:3800:55c:dc9d:9cc1:2c16])
        by smtp.gmail.com with ESMTPSA id e28sm7539011edc.93.2021.09.25.07.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 07:38:05 -0700 (PDT)
Subject: Re: [PATCH 17/19] selftests: Add -t tcp_authopt option for
 fcnal-test.sh
To:     David Ahern <dsahern@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
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
References: <cover.1632240523.git.cdleonard@gmail.com>
 <c52733a1cd9a7bd16aea0b6e056fad9dd1cc5aed.1632240523.git.cdleonard@gmail.com>
 <c72ad0be-9499-dcfb-0faa-be3dd51f4a86@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <5471a640-d2e9-8f92-84ba-bf4fb136abe2@gmail.com>
Date:   Sat, 25 Sep 2021 17:38:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c72ad0be-9499-dcfb-0faa-be3dd51f4a86@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/21 4:52 AM, David Ahern wrote:
> On 9/21/21 10:15 AM, Leonard Crestez wrote:
>> This script is otherwise very slow to run!
> 
> there are a lot of permutations to cover.

I believe that some of the sleeps are not necessary and could be 
replaced with waits.

>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   tools/testing/selftests/net/fcnal-test.sh | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
>> index 74a7580b6bde..484734db708f 100755
>> --- a/tools/testing/selftests/net/fcnal-test.sh
>> +++ b/tools/testing/selftests/net/fcnal-test.sh
>> @@ -1331,10 +1331,21 @@ ipv4_tcp()
>>   	log_subsection "With VRF"
>>   	setup "yes"
>>   	ipv4_tcp_vrf
>>   }
>>   
>> +
>> +only_tcp_authopt()
>> +{
>> +	log_section "TCP Authentication"
>> +	setup
>> +	set_sysctl net.ipv4.tcp_l3mdev_accept=0
>> +	log_subsection "IPv4 no VRF"
>> +	ipv4_tcp_authopt
> 
> This feature needs to work with VRF from the beginning. v4, v6, with and
> without VRF.

I ignored the l3mdev feature because I'm not familiar with it but I'll 
go through it.

--
Regards,
Leonard
