Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43F0462985
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 02:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbhK3BUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 20:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhK3BUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 20:20:09 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C88C061574;
        Mon, 29 Nov 2021 17:16:51 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso27994990ots.6;
        Mon, 29 Nov 2021 17:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1ZEmtCcFbx9RGf9eWexeNci8XqT+MY8xIxIUzBU+qPY=;
        b=kPJn/KGyUqhDtgvrcieRooin88XOS9kdXOFSBFGS0TfmK3qD9wT02IrojDfa2N0Pza
         MmzQTK6P2Lx1EWb+CZPdSWYP10oXmpeqQ7QL1uPkHMi94gDlrBX21XRgQZmxfB9DBPbm
         Pw197b0CmFwvB5gP6mBKe+Kw+YEUxutl6cHqSZQHgdXDCw+seLQb1tLzqJcYVIIdt9c+
         2P+KxJ5DVfRPc3sIo7QB6gR5voXKv7m2rJD8Qi9fEqtBNU9NH1080P9mMX96Erg29PI+
         ppyCkroOWbGig3dJraXTa5QSiWNiL5QnkuKkHlrP+Ugdx7Ur2Tzy0iSTk88t8iqU09iz
         dFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1ZEmtCcFbx9RGf9eWexeNci8XqT+MY8xIxIUzBU+qPY=;
        b=AtnhJ7WTHt+CdK9Gv/FkCGenGurmmAqio9FngupiYhnMjwUz+bsp0UIqeuOLGPaiJh
         3A/bc0t+2rutrynyg0WqeEqZjrPTrIP0vZMbEUqTQu/8QNMXnbqyfjA8uzMF18oLhvVt
         +I3rMzq8eTpdG32I+/R5hHHefyIVkBCTYrsMMV+m5/kuY1rjc5PL0bFnFmnUCuBQG2Gi
         LoAhtNXyvtA5xRr76ht/9RsE3zkdNc9N4qRIVqQ6iYPpwTGctS4CJoBF7NZ0Glwb0ooV
         Fi1KyUggNzXOghwiNgKsE3QdskmSa4meIKh5ZHe9r8Jc8x1rCR7XBYAcSMItiuQN+Ub1
         HqhQ==
X-Gm-Message-State: AOAM5325WMdeLHYTP/lEshiMkYHh+r7KsGa/e8zt8ztjGwH67G1Cf6Vj
        jEvdhjKUXsFeuSGc/j/J1YM=
X-Google-Smtp-Source: ABdhPJzzokVnyg4AooF1Lp7IY1QG9zSS1syyGl9CzTYszpvRgzHYJA5UIPw+otUO2SxTZ8fYAE0IGw==
X-Received: by 2002:a9d:798d:: with SMTP id h13mr46205333otm.132.1638235010442;
        Mon, 29 Nov 2021 17:16:50 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id i3sm2501566ooq.39.2021.11.29.17.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 17:16:50 -0800 (PST)
Message-ID: <c19ebcb5-2e25-ce9c-af83-e934cc3d0996@gmail.com>
Date:   Mon, 29 Nov 2021 18:16:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net v2] selftests/fib_tests: ping from dummy0 in
 fib_rp_filter_test()
Content-Language: en-US
To:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211129225230.3668-1-yepeilin.cs@gmail.com>
 <20211130004905.4146-1-yepeilin.cs@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211130004905.4146-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/21 5:49 PM, Peilin Ye wrote:
> diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
> index 5abe92d55b69..b8bceae00f8e 100755
> --- a/tools/testing/selftests/net/fib_tests.sh
> +++ b/tools/testing/selftests/net/fib_tests.sh
> @@ -453,15 +453,19 @@ fib_rp_filter_test()
>  	$NS_EXEC sysctl -qw net.ipv4.conf.all.accept_local=1
>  	$NS_EXEC sysctl -qw net.ipv4.conf.all.route_localnet=1
>  
> +	$NS_EXEC tc qd add dev dummy0 parent root handle 1: fq_codel
> +	$NS_EXEC tc filter add dev dummy0 parent 1: protocol arp basic action mirred egress redirect dev dummy1
> +	$NS_EXEC tc filter add dev dummy0 parent 1: protocol ip basic action mirred egress redirect dev dummy1
> +
>  	$NS_EXEC tc qd add dev dummy1 parent root handle 1: fq_codel
>  	$NS_EXEC tc filter add dev dummy1 parent 1: protocol arp basic action mirred egress redirect dev lo
>  	$NS_EXEC tc filter add dev dummy1 parent 1: protocol ip basic action mirred egress redirect dev lo
>  	set +e
>  
> -	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 198.51.100.1"
> +	run_cmd "ip netns exec ns1 ping -I dummy0 -w1 -c1 198.51.100.1"
>  	log_test $? 0 "rp_filter passes local packets"
>  
> -	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 127.0.0.1"
> +	run_cmd "ip netns exec ns1 ping -I dummy0 -w1 -c1 127.0.0.1"
>  	log_test $? 0 "rp_filter passes loopback packets"
>  
>  	cleanup
> 

confused by the point of this test if you are going to change dummy1 to
dummy0. dummy0 has 198.51.100.1 assigned to it, so the ping should
always work.
