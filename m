Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0DB24301
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 23:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfETVm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 17:42:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42597 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfETVm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 17:42:26 -0400
Received: by mail-pf1-f195.google.com with SMTP id 13so7862738pfw.9
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 14:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=njvDlxr7YZrDmhgreRLpT6vxitsIY2FDkiMyUSLMJeA=;
        b=XIboL8dYct1yGnro193hxIiVSa9ftjv5hhmF6ydQGu87U05sqSpiNLwAfPXCTgi/LT
         JseZCMkq0Up1bRCUslbWFPkKW79UmMIXkxLLyBeFqcotecgWXRJA4N3UfisR3JfGZEUF
         /GW+poq8mDQsS7giOHUKeJ+qchYEcDtyb5BnOmiJUR2CVVRchA/h5xALIxb9a+ZSY8UU
         h2CJlfFpElJa7EuI0yVzDgm8BulSdfUSX2Uy4vRqtXVFp/CKSK/FJERdvsCvc9xsM4fJ
         8Y8nI1ss56vIEf2o68cP1/cKl+E0Qke+5jYQgUDun2VOgrZRbOQu6jsklza+DC30FzCS
         amvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=njvDlxr7YZrDmhgreRLpT6vxitsIY2FDkiMyUSLMJeA=;
        b=kGy8M+Vr16Um8Slg8OPH0b+Qrctd31Aa8R9c2Ks/Z6BbJcLMVpEMaHNR/YyBYkkJeD
         VoNcvksK0JRognawxPdj7T4Adj1YnUp7FxM7DA6f9v/AdmMdcRWXPO0wyxQqqwTWOjOx
         6rAVE949Ybl2bkO//vH0JBtYVbADSPY3ql46/uMnyNYqCR/5zWdDHK1vKa9BC49WTnNY
         luZqccUpoV2w4jgc6dazNFM4gJfnsnqlBtPjOZ8ZHP8yk0lymXnh4bLWLnJnw5AR6yRq
         ba05L08djQGjMNab6Yxw3f6QMlCdYls7a0Nf5yFcPJpSRXRtPMimqOJPv8dXIehTXRHD
         ss0A==
X-Gm-Message-State: APjAAAW3l18GIikmHXUfXlZmr8gc3/veIS8uV2XhUvgtdIn6C3tPzd3S
        uRV27hrBKQ1Y8r6H+JVX8ns=
X-Google-Smtp-Source: APXvYqxIDgJnKuvDLz4QHzq0BGm6C4VFPMT6H+S8NUMaEKQ1PkXGokGKDaqk6A1ySGe7R1jOZVTHBw==
X-Received: by 2002:a63:4e23:: with SMTP id c35mr12996521pgb.224.1558388545565;
        Mon, 20 May 2019 14:42:25 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:4813:9811:27e6:a3ed? ([2601:282:800:fd80:4813:9811:27e6:a3ed])
        by smtp.googlemail.com with ESMTPSA id m1sm37055489pga.22.2019.05.20.14.42.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 14:42:24 -0700 (PDT)
Subject: Re: [PATCH net 1/2] selftests: fib_rule_tests: fix local IPv4 address
 typo
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
References: <20190520043655.13095-1-liuhangbin@gmail.com>
 <20190520043655.13095-2-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <79e2fdd9-6f46-6e3f-cc21-9a35f26c0d27@gmail.com>
Date:   Mon, 20 May 2019 15:42:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190520043655.13095-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/19 10:36 PM, Hangbin Liu wrote:
> The IPv4 testing address are all in 192.51.100.0 subnet. It doesn't make
> sense to set a 198.51.100.1 local address. Should be a typo.

The unused DEV_ADDR suggests you are correct. That should be removed as
well or the IPv6 address encoded and used for consistency.

> 
> Fixes: 65b2b4939a64 ("selftests: net: initial fib rule tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/fib_rule_tests.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
> index 4b7e107865bf..1ba069967fa2 100755
> --- a/tools/testing/selftests/net/fib_rule_tests.sh
> +++ b/tools/testing/selftests/net/fib_rule_tests.sh
> @@ -55,7 +55,7 @@ setup()
>  
>  	$IP link add dummy0 type dummy
>  	$IP link set dev dummy0 up
> -	$IP address add 198.51.100.1/24 dev dummy0
> +	$IP address add 192.51.100.1/24 dev dummy0
>  	$IP -6 address add 2001:db8:1::1/64 dev dummy0
>  
>  	set +e
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
