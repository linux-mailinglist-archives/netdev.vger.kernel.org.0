Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE5B413615
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhIUPYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbhIUPYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 11:24:37 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B76BC061574;
        Tue, 21 Sep 2021 08:23:09 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id w206so18519347oiw.4;
        Tue, 21 Sep 2021 08:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/nZ9bK/KbbxK+2a5wmYlOp5pst8k2IWMXVVFmr6mHHU=;
        b=Im81TSZrnxJ1+fVdIFIMF/XvZvzMeN6crXi6vW28iaAuatTckrsthRL6Cy/086Y9gL
         n+84zdt5ZO1xstGt2Vbe7aIfALQ9+utPFtGXXJTi0zW4e6R96MxjhwwEu+04dcjNk/Hv
         BfBKQQkuF09iAVcYKpyLZtDRq1sdpHpX2+IzyBjLXy9y7bZS7d0WjH6pemlwk0TinJtE
         iZoWapaPqy7GaEq3lvP/BiXgksdNgM4pzy11IJ47NbThtKnqHVNbSSI6FdX/d60WYMJM
         osrINTiLX2tS1Yt/xW0t9YvyGQz5cRD4vULsWbSt0Q9KvO6XZ96OPSBe7bswmxiwe6i0
         cfeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/nZ9bK/KbbxK+2a5wmYlOp5pst8k2IWMXVVFmr6mHHU=;
        b=dShStEe/OZ162KJMBwqB1cHq9gPf1h3nJ5FVZxT1WydQEazBxSrgtmU1UOEd2vvMXU
         8nAikMtNRUB5V5mQM56fF5+q7kCIBSLjDvHkQVdjGZVV/5S3aej87mbDwz2dXTlgy8XS
         Nx3EuIjdF3kbdH66B7epIc7wtylhSCFauz9/PH0whqDJiq74AM3ilE2yZDnBmAA82K0P
         r7WzOnPGlB0RRY5ogvmGXAuPb/RcUqml248uummjbxH3TTdtItJAe1n7pC/JL6VchQld
         8nEpmOuq7x4F25ch+mKRrtrQfdkSb5rpyLKe/trGpjTedkH6XXR60SixD12+Nk7cSpNx
         h/sA==
X-Gm-Message-State: AOAM533PJ0YhUeUZEKE3rLjlJ4KOInGrpKFvCRx1DcErDsMnMAB6hyNk
        r6Azrp8GL2R9Tpq2JV7rydZ/+iNAWZlGuw==
X-Google-Smtp-Source: ABdhPJw+SF+y87IYH4zUOVA//TZ1O8MRBishh5hrpmpXE5ahu4Pz6OCR6M57X4TJqeDH/VCIi1y20A==
X-Received: by 2002:aca:1703:: with SMTP id j3mr4106112oii.116.1632237788408;
        Tue, 21 Sep 2021 08:23:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id h5sm279100oti.58.2021.09.21.08.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 08:23:07 -0700 (PDT)
Subject: Re: [PATCH bpf-next] seltests: bpf: test_tunnel: use ip neigh
To:     Jiri Benc <jbenc@redhat.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
References: <40f24b9d3f0f53b5c44471b452f9a11f4d13b7af.1632236133.git.jbenc@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2f9554d2-c9c7-5c37-7df0-d011d80d7460@gmail.com>
Date:   Tue, 21 Sep 2021 09:23:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <40f24b9d3f0f53b5c44471b452f9a11f4d13b7af.1632236133.git.jbenc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/21 8:59 AM, Jiri Benc wrote:
> The 'arp' command is deprecated and is another dependency of the selftest.
> Just use 'ip neigh', the test depends on iproute2 already.
> 
> Signed-off-by: Jiri Benc <jbenc@redhat.com>
> ---
>  tools/testing/selftests/bpf/test_tunnel.sh | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_tunnel.sh b/tools/testing/selftests/bpf/test_tunnel.sh
> index 1ccbe804e8e1..ca1372924023 100755
> --- a/tools/testing/selftests/bpf/test_tunnel.sh
> +++ b/tools/testing/selftests/bpf/test_tunnel.sh
> @@ -168,14 +168,15 @@ add_vxlan_tunnel()
>  	ip netns exec at_ns0 \
>  		ip link set dev $DEV_NS address 52:54:00:d9:01:00 up
>  	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24
> -	ip netns exec at_ns0 arp -s 10.1.1.200 52:54:00:d9:02:00
> +	ip netns exec at_ns0 \
> +		ip neigh add 10.1.1.200 lladdr 52:54:00:d9:02:00 dev $DEV_NS

I realize you are just following suit with this change, but ip can
change namespaces internally:

ip -netns at_ns0 neigh add 10.1.1.200 lladdr 52:54:00:d9:02:00 dev $DEV_NS

All of the 'ip netns exec ... ip ...' commands can be simplified.


>  	ip netns exec at_ns0 iptables -A OUTPUT -j MARK --set-mark 0x800FF
>  
>  	# root namespace
>  	ip link add dev $DEV type $TYPE external gbp dstport 4789
>  	ip link set dev $DEV address 52:54:00:d9:02:00 up
>  	ip addr add dev $DEV 10.1.1.200/24
> -	arp -s 10.1.1.100 52:54:00:d9:01:00
> +	ip neigh add 10.1.1.100 lladdr 52:54:00:d9:01:00 dev $DEV
>  }
>  
>  add_ip6vxlan_tunnel()
> 

