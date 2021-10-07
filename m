Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F28425E32
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhJGUyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhJGUyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:54:36 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55F5C061570;
        Thu,  7 Oct 2021 13:52:42 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t16so6167945eds.9;
        Thu, 07 Oct 2021 13:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vZCxEEwfZlNuSFz3ypr49dINxMEpRI9Ap0TDgahu5dA=;
        b=GP4nfLs25Lcggx7ongKrjmDyvwqQ8FpJplLIlrT8W5VVwvAencnctBCdswf5Uxmu5N
         x84FxUrBQoTyUj7PuiBpOAcnTUPF1/ruQl3PTrFyvm7x89epvOhpFMjlRbdlfE9ZutdA
         7Cayhr9+HuAXvGMnGCvKDMq0v3A3NWcdG/Ov3KS+ofCaW2UJN+q4HfyfT2RvXJp8EdIb
         cmcmchUUN9RKgoqJlyDbLjr18anrvsxRbJDgOP2rxumxgZpDAS7EMlU+JZSmF72cozb5
         1fd1plJs9/tRC2e2c1ZEmdEnz0iG/8fT835i5Fx2BSItDPziS++gfKQGKQMgTMQ/WSXM
         AMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vZCxEEwfZlNuSFz3ypr49dINxMEpRI9Ap0TDgahu5dA=;
        b=GM9UCpNwWOmWr09f8QlqkNGmQSHDCtXNGMRfBVw3Q87qpM3A7TZxJMYe/PCGTu7O1U
         LTE6XE5kIcAAQfxClZ3ihT7SEL44xMrDfMwejhahpFVWX30wBQJ8jRZz4G4BKegb+L5n
         IrtGw6IuZnSxbS2uUE+VDgJ/rIdLjggWI6yyN4r/JxuPsVdYxsyuDoSm1qxp4/Ul7H6H
         jTjZC8jb45xsw9DWUlsY2s3hhniAPQaYXLy0tgoWiAcclR9dmwnSAncXl15UrL7rNFNb
         pgbggfCYqkKLpWp3VXXPPK040+EG0/kXUAT9Y3kGgLa+J5HWVx0DgMCDcbf7KFV2tJ6Z
         7RMw==
X-Gm-Message-State: AOAM530Y7GMeJENv9kW3bkYOJG5Yrmg37MAVrCdrPFFJT93PiGPqQsya
        Xr5BtgdaLObwM2KWWNsaijXq3lvTNjorp2DZMNBZCg==
X-Google-Smtp-Source: ABdhPJy7DTDvXZNOAHbVT6qYrd2+tmNBH+CVXkM2Uvpk/nZM6x7aSsZuM3UvnKPi5RecnxRM9PBRYg==
X-Received: by 2002:a05:6402:2748:: with SMTP id z8mr9639409edd.291.1633639961243;
        Thu, 07 Oct 2021 13:52:41 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:b7fe:dd48:83ff:bcc8? ([2a04:241e:501:3870:b7fe:dd48:83ff:bcc8])
        by smtp.gmail.com with ESMTPSA id x11sm202349edj.62.2021.10.07.13.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 13:52:40 -0700 (PDT)
Subject: Re: [PATCH 11/11] selftests: net/fcnal: Reduce client timeout
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <516043441bd13bc1e6ba7f507a04362e04c06da5.1633520807.git.cdleonard@gmail.com>
 <3ed2262e-fce2-c587-5112-e4583cd042ed@gmail.com>
 <c48ea9e2-acdc-eb11-a4b0-35474003fcf3@gmail.com>
 <65ae97e3-73c1-3221-96fe-6096a8aacfa1@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <d7ac5d58-1e59-a657-a51b-4d757f7552ca@gmail.com>
Date:   Thu, 7 Oct 2021 23:52:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <65ae97e3-73c1-3221-96fe-6096a8aacfa1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.10.2021 04:17, David Ahern wrote:
> On 10/6/21 3:26 PM, Leonard Crestez wrote:
>> On 06.10.2021 18:01, David Ahern wrote:
>>> On 10/6/21 5:47 AM, Leonard Crestez wrote:
>>>> Reduce default client timeout from 5 seconds to 500 miliseconds.
>>>> Can be overridden from environment by exporting NETTEST_CLIENT_TIMEOUT=5
>>>>
>>>> Some tests need ICMP timeouts so pass an explicit -t5 for those.
>>>>
>>>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>>>> ---
>>>>    tools/testing/selftests/net/fcnal-test.sh | 17 +++++++++++------
>>>>    1 file changed, 11 insertions(+), 6 deletions(-)
>>>>
>>>
>>> The problem with blindly reducing the timeouts is running the script on
>>> a loaded server. Some tests are expected to timeout while for tests a
>>> timeout is a failure.
>>
>> Keeping the default value "5" would be fine as long as it is possible to
>> override externally and get fast results on a mostly-idle machine.
> 
> 5 is the default for nettest.c; the test script passes in -t1 for all tests.

An explicit -t is only passed for some of the tests

$ grep -c nettest.*-r tools/testing/selftests/net/fcnal-test.sh
243
$ grep -c nettest.*-t tools/testing/selftests/net/fcnal-test.sh
15

>> Placing a default value in the environment which is overriden by certain
>> tests achieves that.
>>
>> In theory it would also be possible for fcnal-test.sh to parse as
>> "--timeout" option and pass it into every single test but that solution
>> would cause much more code churn.
>>
>> Having default values in environment variables that can still be
>> overridden by command-line arguments is a common pattern in many tools.
>> It also avoids having to pass-through every flag through every
>> intermediate wrapper.
> 
> I do not agree with env variables here.

Would you agree with adding an option to fcnal-test.sh which decreases 
timeouts passed to nettest client calls?
