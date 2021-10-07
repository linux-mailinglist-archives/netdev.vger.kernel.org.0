Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85C4424B93
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbhJGBTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhJGBTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 21:19:42 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AD9C061746;
        Wed,  6 Oct 2021 18:17:49 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id h16-20020a9d3e50000000b0054e25708f41so4691072otg.0;
        Wed, 06 Oct 2021 18:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jT9z8RRT0XYjL+Fp0fFDi5Odn8ZxEN6A9XJGxWw8lg8=;
        b=HP9QVcmSp8NN3FqweRkOGP4M76pSrRIIOtOPfKadKK20lVgfJPapDLoY8r/pYW1MsH
         YZi6gn+rHkuPdHP4118JDz+t6vBk+phqGm338GRW74850DjHmJuSBZKy4TyyI3Jerucb
         +O/xf8Bi5XMdcpNsgbHhSuSgn8qjYjeMB8GlSWKScHE3gpsVWwObkZ2u4/qRL4oZ9JPm
         D9bPKwB7Jf0ewRPEX8EJW9qkJi5eOGFKd1xXjXMXVTFEXnuY+2uQuXUxGZFQi95OdbHr
         Eqvw9TKDL7I5ru5bOpZwnNnVMc17mIPvlY84As3svAfH0/zbp2KHU4Gf3QlvWrBd0XHv
         P1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jT9z8RRT0XYjL+Fp0fFDi5Odn8ZxEN6A9XJGxWw8lg8=;
        b=xLyM6hmYFifdB6qQwqwG13rQZ7O+l8yeaaChqmcgvKWSgCcvWzSLmxFsOG476A/JO8
         Ib1uCD0jQELhSx5vrrg4QhLB9KVfmDev8oL+LC5yVXiKEtWrmnKMA7GHC2e8rU1tjKYG
         NsFyg0TlJVK1J+vVLqbe4WOtNgnthe0O5phN2SeHWoMraSSOq1g8uEBItU0UmkYYwrpv
         R3E50uqkS34xu/zSf/BsbNdVYVDaFVC1GYfBOBPreN4ku3RRFagiraKH8zMsi0+OjH5O
         7acJn5JAoTc2uYJhxfitliSeEn91B9MI3L/F6BDsHMdGa3PqTwMz229TuXfIFUIBG2kv
         Af7w==
X-Gm-Message-State: AOAM533HjTV2Q5fFatvXwZVcd6mqaLrw4OV5N9ayciap045BNXSBZ51y
        CruspAYPEjDz/2KvBPQGFyyXT2Dckz90Bw==
X-Google-Smtp-Source: ABdhPJxr/YZkcQ5fbUlhN7RK5hl+obnSIonACN81a+1seHzogzBLQ9nkW6BS4M+2L4VdDNRhr4opiQ==
X-Received: by 2002:a05:6830:112:: with SMTP id i18mr1279668otp.186.1633569468757;
        Wed, 06 Oct 2021 18:17:48 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bl23sm2655160oib.40.2021.10.06.18.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 18:17:48 -0700 (PDT)
Subject: Re: [PATCH 11/11] selftests: net/fcnal: Reduce client timeout
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <65ae97e3-73c1-3221-96fe-6096a8aacfa1@gmail.com>
Date:   Wed, 6 Oct 2021 19:17:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c48ea9e2-acdc-eb11-a4b0-35474003fcf3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 3:26 PM, Leonard Crestez wrote:
> 
> 
> On 06.10.2021 18:01, David Ahern wrote:
>> On 10/6/21 5:47 AM, Leonard Crestez wrote:
>>> Reduce default client timeout from 5 seconds to 500 miliseconds.
>>> Can be overridden from environment by exporting NETTEST_CLIENT_TIMEOUT=5
>>>
>>> Some tests need ICMP timeouts so pass an explicit -t5 for those.
>>>
>>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>>> ---
>>>   tools/testing/selftests/net/fcnal-test.sh | 17 +++++++++++------
>>>   1 file changed, 11 insertions(+), 6 deletions(-)
>>>
>>
>> The problem with blindly reducing the timeouts is running the script on
>> a loaded server. Some tests are expected to timeout while for tests a
>> timeout is a failure.
> 
> Keeping the default value "5" would be fine as long as it is possible to
> override externally and get fast results on a mostly-idle machine.

5 is the default for nettest.c; the test script passes in -t1 for all tests.

> 
> Placing a default value in the environment which is overriden by certain
> tests achieves that.
> 
> In theory it would also be possible for fcnal-test.sh to parse as
> "--timeout" option and pass it into every single test but that solution
> would cause much more code churn.
> 
> Having default values in environment variables that can still be
> overridden by command-line arguments is a common pattern in many tools.
> It also avoids having to pass-through every flag through every
> intermediate wrapper.

I do not agree with env variables here.
