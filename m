Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFCF48DA9B
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 16:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbiAMPVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 10:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236053AbiAMPVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 10:21:31 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738DAC06161C;
        Thu, 13 Jan 2022 07:21:31 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id z19so3176252ioj.1;
        Thu, 13 Jan 2022 07:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hKXDNPqj6gdEYMlDwoeecnOcDljaU6gXI4Mb+Rt+28U=;
        b=Vi74UQhZn++PKnt5nrSk6Bkw8PTyQePjyiQBRXaeeVKABXcX0QzpShQMo45YCdU8MG
         oKUSHWyFX70YqYt5rKlXjmPLAh2eXeVMulb3eoHPnjw47bQ5QnrNljzGeGBoDYJ3dyZ2
         z6QcEEu4cixZO8eiWNhIhR1+j1B30hNmJUcfST/e8D9RHie4rbdp3TOdAneC+bpm31ad
         TQ4jH3NjY2u2229Ed3gUili+bMQZVwcEnAm+Qrxx1ugYjpJDlqA8nUXpG5ibVxq/Hpky
         EJPDOVj06GcFGColkCVJqp1EKH6pcSc9T3bhLaSm/6nnyKxAFwWPVVMjYM9zWDCChmtR
         TgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hKXDNPqj6gdEYMlDwoeecnOcDljaU6gXI4Mb+Rt+28U=;
        b=ELMiQN/xWDWuYErgCEGjLLQ7tJrQv+jJcM5CIHH2TEGwyTr1J+iMA0st9tAE//imkt
         xrTcsNEvQhnaaVU9PAG7Vv79WszrwKbrJTjnfi8p4aWVEgBA2n8FPwnUYNZdCGnh5Q8M
         Fwsbtd01HzgeiK9BTatBN3hApiiMHhyYJi3kioJF7vTC6tGewSRBytacm1JJ8NPTnBys
         zHnf1yfJZLV5LS22FTEp9LPfQVSMeZ5jzxYDdA9qbq+42Fbnydi/8eEiqVeHyU4YJJiK
         T6UGyTus9oQs8r1lcYynh3PDaDPjjIHPBzx5XmAG8UYVlS/qiHUpCjG+K66/NsJx0Xoj
         /gpA==
X-Gm-Message-State: AOAM531XzX/xG5kppWeJ58o9yQCuJx7zOI/HuBwYzzk6R7668fjMg4na
        I5/HQbkuf7clJEJkmbZLjME=
X-Google-Smtp-Source: ABdhPJxutNrugiwBcJxztzoJQVwdZdbtjIkpwPZyziUuu/9hgY23/dOq8f89KzgcDkyBYcATBHaCdg==
X-Received: by 2002:a05:6602:2dcf:: with SMTP id l15mr1215471iow.71.1642087290934;
        Thu, 13 Jan 2022 07:21:30 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id j7sm3290573iow.26.2022.01.13.07.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 07:21:30 -0800 (PST)
Message-ID: <8bde7cdc-6bd5-d50e-ea44-dfb480b88ca0@gmail.com>
Date:   Thu, 13 Jan 2022 08:21:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 2/2] selftests: add option to list all available tests
Content-Language: en-US
To:     "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20211202022954.23545-1-lizhijian@cn.fujitsu.com>
 <20211202022954.23545-2-lizhijian@cn.fujitsu.com>
 <b76c51c6-80b6-c3ec-f416-f5e48aa5a6c5@fujitsu.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <b76c51c6-80b6-c3ec-f416-f5e48aa5a6c5@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/22 10:53 PM, lizhijian@fujitsu.com wrote:
> ping

seems to have been lost in the void

> 
> 
> On 02/12/2021 10:29, Li Zhijian wrote:
>> $ ./fcnal-test.sh -l
>> Test names: ipv4_ping ipv4_tcp ipv4_udp ipv4_bind ipv4_runtime ipv4_netfilter
>> ipv6_ping ipv6_tcp ipv6_udp ipv6_bind ipv6_runtime ipv6_netfilter
>> use_cases
>>
>> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
>> ---
>>   tools/testing/selftests/net/fcnal-test.sh | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
>> index 5cb59947eed2..7e78be99aa4c 100755
>> --- a/tools/testing/selftests/net/fcnal-test.sh
>> +++ b/tools/testing/selftests/net/fcnal-test.sh
>> @@ -3993,6 +3993,7 @@ usage: ${0##*/} OPTS
>>   	-4          IPv4 tests only
>>   	-6          IPv6 tests only
>>   	-t <test>   Test name/set to run
>> +	-l          List all available tests
>>   	-p          Pause on fail
>>   	-P          Pause after each test
>>   	-v          Be verbose
>> @@ -4006,10 +4007,15 @@ TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_bind ipv4_runtime ipv4_netfilter"
>>   TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_bind ipv6_runtime ipv6_netfilter"
>>   TESTS_OTHER="use_cases"
>>   
>> +list()
>> +{
>> +	echo "Test names: $TESTS_IPV4 $TESTS_IPV6 $TESTS_OTHER"
>> +}

Just add the test list at the end of usage() like this:

@@ -4019,6 +4019,9 @@ usage: ${0##*/} OPTS
        -p          Pause on fail
        -P          Pause after each test
        -v          Be verbose
+
+Tests:
+       $TESTS_IPV4 $TESTS_IPV6 $TESTS_OTHER
 EOF
 }



