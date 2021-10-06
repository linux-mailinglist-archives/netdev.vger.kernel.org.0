Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEA14248E9
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbhJFV2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbhJFV2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 17:28:53 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1972C061746;
        Wed,  6 Oct 2021 14:27:00 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r18so14970299edv.12;
        Wed, 06 Oct 2021 14:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TEIVevLr+KkOe+yPKE3J8X4wJFJQbdygarJo9OKidbQ=;
        b=p0GJzPzOWa+cfAfY7747JRX8oWbNXWM97C+z3apyCRClrxPBjlhMCbhDwrP1n5mIBV
         RgI9GJMetZmD5wfDzGyGcIQ4EGyVVWS0StFQRyS/V0XPGF5xxBxlfbkKcRTeVla+EY3C
         sSWC++lI0pD0Z+2zRCLmlsVf+tDEfw7NBO9DFupQAZe2XPKEg22DASeETxnztVfVYe4p
         5rnWbtkj/LTjQ8EaBANyPrukGnYuemEPj5T3nnk8jJCkuH2OqbMWTLwYAl7ZfYhQBAgO
         21waD25l8+vmUCrtobkSWroSM2MkCUTjDEtSVI66OO5KNMh/RX4SFGDl0a1qnUoOSt+Z
         QrNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TEIVevLr+KkOe+yPKE3J8X4wJFJQbdygarJo9OKidbQ=;
        b=ZaBL33TLosI14z+pOCna39qRVpA6llOL3BIFAU0HducJNYYYMjwd/cKaIM/d2BGWWF
         FzFmrbk5ZOHU/hH0ZCkUdfPvH2USRl74vThiGU0yt2E2LX5DC40iqBNGcjH5BHgSrXd/
         dwa5Gygyt3OS4wgsgKBnG04JKeLXDQk+nTgfzbI0U9PCLif9b5n3o1yed0xQ2bdv/bIM
         48fMF8VrsyGgV3+Www+BvbzsWulSXdUaQscFo2606+odX/G7c2ho2vRRFD5YvIjrHzdA
         OCGfkkESW0YpegVRqs1u4Db4eC+uIsbxujtOd7KbZBMf+vR7KjODchAuazOGy5VUDgaM
         4myA==
X-Gm-Message-State: AOAM5322PQvE9EnYS3EBJVAta+Kb6MpAT4ZXsAdc1KaQRCMJ2aoxuaaL
        2SE25lSURcjb+QP31+QWINVmnafYO66NwEBFiuhqBA==
X-Google-Smtp-Source: ABdhPJyCU+oSJN5PiFKY5i0hkVZ1JGnxR2EGlN1fAjiHYGe2Leq7H1zEuBIFtcu4sJpy8XtCJSp02g==
X-Received: by 2002:a05:6402:3509:: with SMTP id b9mr780972edd.187.1633555619218;
        Wed, 06 Oct 2021 14:26:59 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:473a:8ebc:828b:d6c6? ([2a04:241e:501:3870:473a:8ebc:828b:d6c6])
        by smtp.gmail.com with ESMTPSA id x16sm5204655eds.92.2021.10.06.14.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 14:26:58 -0700 (PDT)
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
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <c48ea9e2-acdc-eb11-a4b0-35474003fcf3@gmail.com>
Date:   Thu, 7 Oct 2021 00:26:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3ed2262e-fce2-c587-5112-e4583cd042ed@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06.10.2021 18:01, David Ahern wrote:
> On 10/6/21 5:47 AM, Leonard Crestez wrote:
>> Reduce default client timeout from 5 seconds to 500 miliseconds.
>> Can be overridden from environment by exporting NETTEST_CLIENT_TIMEOUT=5
>>
>> Some tests need ICMP timeouts so pass an explicit -t5 for those.
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   tools/testing/selftests/net/fcnal-test.sh | 17 +++++++++++------
>>   1 file changed, 11 insertions(+), 6 deletions(-)
>>
> 
> The problem with blindly reducing the timeouts is running the script on
> a loaded server. Some tests are expected to timeout while for tests a
> timeout is a failure.

Keeping the default value "5" would be fine as long as it is possible to 
override externally and get fast results on a mostly-idle machine.

Placing a default value in the environment which is overriden by certain 
tests achieves that.

In theory it would also be possible for fcnal-test.sh to parse as 
"--timeout" option and pass it into every single test but that solution 
would cause much more code churn.

Having default values in environment variables that can still be 
overridden by command-line arguments is a common pattern in many tools. 
It also avoids having to pass-through every flag through every 
intermediate wrapper.

--
Regards,
Leonard
