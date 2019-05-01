Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2394910A40
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfEAPsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:48:04 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41765 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfEAPsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:48:04 -0400
Received: by mail-pg1-f193.google.com with SMTP id f6so8456247pgs.8
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 08:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XChiewrbzcAYGjVA34PR/Tl1hpDd9r4c+ztPWruHDaI=;
        b=npE1Pw/wkyXrjg+dEGTmFP8FB1xFJ568zsWpPE78VIJDbDFdXG/Tzqcu91Ltpxnp0D
         k1AqVQ43HFqi4OtlBxaHBavjE7BUUwvvoXMciwaOt3QWb8pWA+EtoQHjNHga+Na4BetY
         RTKpfJQG12FZNeJV5qgwDDde0mKaPQpXPihnQjUFBJ392ZgdEXdoOWBnuuG4TLndmfAB
         wwl1vVQ89tdS5BrCN8GHLwnOFPWt3XMS8HU1LavZRBY0ZB2MN5Smc4YEDfrNdI8FpuNZ
         URjyii9e34cO/n47l7bWQnClB4sWTySBTcdpr8tCfcgieQ32nDu1aJCGIkh3tRPWd2+Q
         ignw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XChiewrbzcAYGjVA34PR/Tl1hpDd9r4c+ztPWruHDaI=;
        b=doD+6gEyP6FkniQcYEnMhyxqxKHigsFFZ/AjjIVGmBuxG30YWE9yjZ2/kCjpaZt4XJ
         l2llMf2atmqnoDih+oQy3I/TyLD4l3fzjOBMsllBecb7xLIx5n4Kiw6ziCb9L61JIa15
         8L9hjmzwTUS2mWHi2kYa4SA3HnXSWbNhRHIU1drKjPc6MNr9sVlMk5daRHz/Nuzk093h
         zEUgCF3Z/GTkeqhCNyeU2RqiEy9Losr4hNHQJJEsqI4vxguUbYisD9GGUkkp7h+cOobi
         wk9djlCMfrgsHbjvunNMdz/cCUdNeebiEgwqh2Hh0OCtTCJaMTgCiwNeBlRztg5nxmg2
         avTg==
X-Gm-Message-State: APjAAAUEQndDDHDhdPeAiXR883WAXL6R3rn92dJP7LmC+w9S1zVrjiBZ
        wL3AuRqKoxqPRv0t8Vl0hQI=
X-Google-Smtp-Source: APXvYqwagQdFyrFpknTOgGEpRXOsAgzg1wDwqzBfmkbGIoC0CohwU22w7A/RBvwEX48t9M4MclnuPg==
X-Received: by 2002:a63:d10:: with SMTP id c16mr38479789pgl.156.1556725683460;
        Wed, 01 May 2019 08:48:03 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:950d:299e:8124:b280? ([2601:282:800:fd80:950d:299e:8124:b280])
        by smtp.googlemail.com with ESMTPSA id q20sm59574882pfi.166.2019.05.01.08.48.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 08:48:02 -0700 (PDT)
Subject: Re: [PATCH net] selftests: fib_rule_tests: print the result and
 return 1 if any tests failed
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>
References: <20190430024610.26177-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a5c3a774-45c4-29fb-ccfd-12051246237d@gmail.com>
Date:   Wed, 1 May 2019 09:48:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190430024610.26177-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/29/19 8:46 PM, Hangbin Liu wrote:
> Fixes: 65b2b4939a64 ("selftests: net: initial fib rule tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/fib_rule_tests.sh | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
> index d4cfb6a7a086..d84193bdc307 100755
> --- a/tools/testing/selftests/net/fib_rule_tests.sh
> +++ b/tools/testing/selftests/net/fib_rule_tests.sh
> @@ -27,6 +27,7 @@ log_test()
>  		nsuccess=$((nsuccess+1))
>  		printf "\n    TEST: %-50s  [ OK ]\n" "${msg}"
>  	else
> +		ret=1
>  		nfail=$((nfail+1))
>  		printf "\n    TEST: %-50s  [FAIL]\n" "${msg}"
>  		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
> @@ -245,4 +246,9 @@ setup
>  run_fibrule_tests
>  cleanup
>  
> +if [ "$TESTS" != "none" ]; then
> +	printf "\nTests passed: %3d\n" ${nsuccess}
> +	printf "Tests failed: %3d\n"   ${nfail}
> +fi
> +
>  exit $ret
> 

Thanks for adding the summary.

Reviewed-by: David Ahern <dsahern@gmail.com>
