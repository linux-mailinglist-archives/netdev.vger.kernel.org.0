Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E95E253825
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgHZTRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgHZTR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:17:27 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A528C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:17:26 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id f12so2781272ils.6
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ExK/Kp7jufqHCJi1+H6jYMZdeZPCKgxIUIoARnP/x3c=;
        b=aIV2du+JXGVn6WtoHODSMTReBbF1CXW8C7MLtFhX+hd7X+V+unhHsNCzNc26ccsvT7
         66ViNK+Ru88rARourQwGbPFWG6dlkmNplSgecV9R/evmY7EloBAKffav6a7B+rMEWGMq
         J+bv1RD7XPll9yPuhAzTbu5x4UmrZdg6Xko6Y0kUoCBquTmCZJsYXLUFa6bRznj8LrAE
         7KfqW4i6DtuOE+gZS9kmaWb0920Ss9XjLJKomZOKQ6I/pkAOz240cGB2uIK8HFHmTPgS
         +Y/7fUhIXF2VPqz6TyDzx0kKBeMnXQKFyHbhvMznoXCHcC895Be/yoCiuPdkNePjL1e4
         axOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ExK/Kp7jufqHCJi1+H6jYMZdeZPCKgxIUIoARnP/x3c=;
        b=bylvvT8mYUM0UOl6am0i7RC5Mvd95yLgD/fTfkeMLAwjAViBbXBBPh/VC9Oka8EdyJ
         8xyfCUe78ufjCM63DqW4WW+q3JKMmAccnfTpl4YCbVTZnEwhVvGKN/yI1Ehicwt55gxG
         gzhVGQsx42cnrFfgOjkPOsB3qFNhh2I0/UeM2O1iQtkEohY0T0FKIozDHHyhygQ3aRUw
         lwAhJxvvg5uA0owl8PyNxGkBN7/ycAKP5pXsliszwfkCFR+uSHFrRkFX3HMjZVXdQfon
         z5TKv9n7SvESNZ1L+GqrOOVo8P+8Zdn5wRAgUJpyD3V86TJPJyYufGIRF9EicRA1lIUE
         xzyg==
X-Gm-Message-State: AOAM5321Ug5MUNt/ooocFkOQh82hgnZwNh9VDFDf8idWfCO8n5uuoGh+
        2pIT37zfGta2Dhp/+2gYpT8=
X-Google-Smtp-Source: ABdhPJxoIPNOClRndR6UB3f4v/ORi5iOTXX7Ne3thc3mIOg098C5jkx4Lpxv5bX85sI3itMFEl5d3Q==
X-Received: by 2002:a92:d342:: with SMTP id a2mr14709045ilh.16.1598469445987;
        Wed, 26 Aug 2020 12:17:25 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id q23sm1562574ior.47.2020.08.26.12.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:17:25 -0700 (PDT)
Subject: Re: [PATCH net-next 7/7] selftests: fib_nexthops: Test IPv6 route
 with group after replacing IPv4 nexthops
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200826164857.1029764-1-idosch@idosch.org>
 <20200826164857.1029764-8-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0f94789a-cb55-699e-eb8b-abbd00b3bb2d@gmail.com>
Date:   Wed, 26 Aug 2020 13:17:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164857.1029764-8-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 10:48 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Test that an IPv6 route can not use a nexthop group with mixed IPv4 and
> IPv6 nexthops, but can use it after replacing the IPv4 nexthops with
> IPv6 nexthops.
> 
> Output without previous patch:
> 
> # ./fib_nexthops.sh -t ipv6_fcnal_runtime
> 
> IPv6 functional runtime
> -----------------------
> TEST: Route add                                                     [ OK ]
> TEST: Route delete                                                  [ OK ]
> TEST: Ping with nexthop                                             [ OK ]
> TEST: Ping - multipath                                              [ OK ]
> TEST: Ping - blackhole                                              [ OK ]
> TEST: Ping - blackhole replaced with gateway                        [ OK ]
> TEST: Ping - gateway replaced by blackhole                          [ OK ]
> TEST: Ping - group with blackhole                                   [ OK ]
> TEST: Ping - group blackhole replaced with gateways                 [ OK ]
> TEST: IPv6 route with device only nexthop                           [ OK ]
> TEST: IPv6 multipath route with nexthop mix - dev only + gw         [ OK ]
> TEST: IPv6 route can not have a v4 gateway                          [ OK ]
> TEST: Nexthop replace - v6 route, v4 nexthop                        [ OK ]
> TEST: Nexthop replace of group entry - v6 route, v4 nexthop         [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route using a group after removing v4 gateways           [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route using a group after replacing v4 gateways          [FAIL]
> TEST: Nexthop with default route and rpfilter                       [ OK ]
> TEST: Nexthop with multipath default route and rpfilter             [ OK ]
> 
> Tests passed:  21
> Tests failed:   1
> 
> Output with previous patch:
> 
> # ./fib_nexthops.sh -t ipv6_fcnal_runtime
> 
> IPv6 functional runtime
> -----------------------
> TEST: Route add                                                     [ OK ]
> TEST: Route delete                                                  [ OK ]
> TEST: Ping with nexthop                                             [ OK ]
> TEST: Ping - multipath                                              [ OK ]
> TEST: Ping - blackhole                                              [ OK ]
> TEST: Ping - blackhole replaced with gateway                        [ OK ]
> TEST: Ping - gateway replaced by blackhole                          [ OK ]
> TEST: Ping - group with blackhole                                   [ OK ]
> TEST: Ping - group blackhole replaced with gateways                 [ OK ]
> TEST: IPv6 route with device only nexthop                           [ OK ]
> TEST: IPv6 multipath route with nexthop mix - dev only + gw         [ OK ]
> TEST: IPv6 route can not have a v4 gateway                          [ OK ]
> TEST: Nexthop replace - v6 route, v4 nexthop                        [ OK ]
> TEST: Nexthop replace of group entry - v6 route, v4 nexthop         [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route using a group after removing v4 gateways           [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route using a group after replacing v4 gateways          [ OK ]
> TEST: Nexthop with default route and rpfilter                       [ OK ]
> TEST: Nexthop with multipath default route and rpfilter             [ OK ]
> 
> Tests passed:  22
> Tests failed:   0
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index 06e4f12e838d..b74884d52913 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -754,6 +754,21 @@ ipv6_fcnal_runtime()
>  	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
>  	log_test $? 0 "IPv6 route using a group after removing v4 gateways"
>  
> +	run_cmd "$IP ro delete 2001:db8:101::1/128"
> +	run_cmd "$IP nexthop add id 87 via 172.16.1.1 dev veth1"
> +	run_cmd "$IP nexthop add id 88 via 172.16.1.1 dev veth1"
> +	run_cmd "$IP nexthop replace id 124 group 86/87/88"
> +	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
> +	log_test $? 2 "IPv6 route can not have a group with v4 and v6 gateways"
> +
> +	run_cmd "$IP nexthop replace id 88 via 2001:db8:92::2 dev veth3"
> +	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
> +	log_test $? 2 "IPv6 route can not have a group with v4 and v6 gateways"
> +
> +	run_cmd "$IP nexthop replace id 87 via 2001:db8:92::2 dev veth3"
> +	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
> +	log_test $? 0 "IPv6 route using a group after replacing v4 gateways"
> +
>  	$IP nexthop flush >/dev/null 2>&1
>  
>  	#
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
