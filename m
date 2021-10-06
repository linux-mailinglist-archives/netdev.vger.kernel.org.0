Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83974248FD
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbhJFVhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhJFVhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 17:37:10 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4D3C061753;
        Wed,  6 Oct 2021 14:35:17 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r18so15038991edv.12;
        Wed, 06 Oct 2021 14:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k2aWKq81FbwNlwh5R8TQ/Jg8udU/6vv2IjPzFQ2xQYI=;
        b=MO3EPnYEBmt3cY4QIjuUzEkrBOj4RXjpfwB77pM/xDipuhauDTCEAa0cxkz4+HNQYT
         X5Q2SiOx7f0uGD/i5MeGXjde3rwJitLh/fVa1rEAezu5HnKriP66VUePWE/rygi6Sbnf
         bb3zh3Ksmr5MDjCa8yHLVDkl5c1ka1SJSbR78NVLqBkKd01SLJd+rYM5VWg5fyg3Aif1
         8AU46DcA9DVczx6lpEjNFkVj4YuDPj/v2+R4YZOvu060ahg5n11qhpbDNJB5bZAki/Eg
         k8NkaANEd6zsct2IALxXqGIO3EO/oyULIpSXd/o/iCbdbmIOW78RuNPXs6L/qZAdBJj9
         UUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k2aWKq81FbwNlwh5R8TQ/Jg8udU/6vv2IjPzFQ2xQYI=;
        b=KmuSj2VX5jkYIiSAFUcOHFT0SZUeACQIR4v9jCZXjPsqmDIY4qkTMKSAZigwIQ37UE
         tqeCedlHGI0qZNe6nC69W293s0XpM1yXY6K0dn2PPCX7DpBQasXHYmVUHaw77ViV6gWe
         KgMKC4kgj06ZRP4G1F8U6qGtyIoGhUFiY9PeCrfDOf6NC8432jQ81KFNSSNTRXGN1xTY
         zEZCW5ylNKWd8Pc7sunt+EHXISnLijtSCpt+NF11sLwL8zKJTxMsV6UAf/RckXqdXhmL
         cLyX5k4y4ppBwafekiBduXIesxDqS2TkQsjt7876Fto6Nv0GhcGNz0s6/YYSh0GhkYk+
         w3Dg==
X-Gm-Message-State: AOAM530qJEKbufcEhdqXX6eSLmZ5KPLM+w5TuUKcC1oxVxFqim18oIlj
        DCjY1qnPAOk8ZSWZvimgCV5luth7LylH5JAKTMadvA==
X-Google-Smtp-Source: ABdhPJwjMTd1GVQw9RB1UdIg9jNf4eF/3QHYTlF9HB2C7uy1+9qeoPgzPYQVzkTrMNVt3FJzNYtZEQ==
X-Received: by 2002:a17:906:5855:: with SMTP id h21mr780128ejs.230.1633556115999;
        Wed, 06 Oct 2021 14:35:15 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:473a:8ebc:828b:d6c6? ([2a04:241e:501:3870:473a:8ebc:828b:d6c6])
        by smtp.gmail.com with ESMTPSA id d17sm6302991edv.58.2021.10.06.14.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 14:35:15 -0700 (PDT)
Subject: Re: [PATCH 08/11] selftests: net/fcnal: Replace sleep after server
 start with -k
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <ec40bd7128a30e93b90ba888f3468f394617a010.1633520807.git.cdleonard@gmail.com>
 <43210038-b04b-3726-1355-d5f132f6c64e@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <d6882c3f-4ecf-4b4e-c20e-09b88da4fbd6@gmail.com>
Date:   Thu, 7 Oct 2021 00:35:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <43210038-b04b-3726-1355-d5f132f6c64e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06.10.2021 17:54, David Ahern wrote:
> On 10/6/21 5:47 AM, Leonard Crestez wrote:
>> The -k switch makes the server fork into the background after the listen
>> call is succesful, this can be used to replace most of the `sleep 1`
>> statements in this script.
>>
>> Change performed with a vim command:
>>
>> s/nettest \(.*-s.*\) &\n\s*sleep 1\n/nettest \1 -k\r
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   tools/testing/selftests/net/fcnal-test.sh | 641 ++++++++--------------
>>   1 file changed, 219 insertions(+), 422 deletions(-)
>>
> 
> I have a change from January [1] that runs the tests with 1 binary -
> takes both client and server side arguments, does the server setup,
> switches namespaces as needed and then runs the client side. I got
> bogged down validating the before and after which takes a long time
> given the number of tests. The output in verbose mode is as important as
> the pass / fail. Many of the tests document existing behavior as well as
> intended behavior.
> 
> You used a search and replace to update the tests. Did you then do the
> compare of test results - not pass / fail but output?

I counted the [FAIL] or [ OK ] markers but not the output of nettest 
itself. I don't know what to look for, I guess I could diff the outputs?

Shouldn't it be sufficient to compare the exit codes of the nettest client?

The output is also modified by a previous change to not capture server 
output separately and instead let it be combined with that of the 
client. That change is required for this one, doing out=$(nettest -k) 
does not return on fork unless the pipe is also closed.

I did not look at your change, mine is relatively minimal because it 
only changes who decide when the server goes into the background: the 
shell script or the server itself. This makes it work very easily even 
for tests with multiple server instances.

--
Regards,
Leonard
