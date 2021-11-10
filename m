Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C8044C319
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhKJOmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbhKJOmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 09:42:31 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68671C061764
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 06:39:43 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id j2so2639591qkl.7
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 06:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:in-reply-to:content-transfer-encoding;
        bh=SUV2g9kexi4b8cxnYKfdwvSey92lSD1M7ifK2Li4DRU=;
        b=wN8NzoaGJEtePlnpUCPJDuvktR7M4HCT6ICSwh32fAzdyXi9IltRxuGHzNeKZDRi57
         TJE4yP9V+5kvmEe2ZvkievsYlpYqJXEy3sWDm0jpbJR4zwxytqKs04eVtYztKtX8gbmX
         cF1sOcNcjyunlVQ9BXEvxsoLEufM+I+UDUh5modT7TzrCGzlPzSPrRCwf1RAR4SVBVMn
         PWIJH/KFPlPwRNjUWud/u7XnhKUmlWOe2bal07/u+BI2smMlkhmvEVVhWpXUbkNXxFwu
         AY/SFqYGuFKlVfAifoB9JTyGOXJce1saPQsoYLPx3Dx9BLmwFW9pWME4Dx8jqFMgnlUt
         fi0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=SUV2g9kexi4b8cxnYKfdwvSey92lSD1M7ifK2Li4DRU=;
        b=my8lxjqVyvD8doB/Rdfr89lwMM01gyXy2sW2c8B0fPMIclNv2SJ935/gtgXMUZ4Q+K
         XAGn0hauVTlkbVxs5kW8gcjtMieyahSfn57+KqnN+qQsPgAoNJcveXXN2lPBFUK2OmBH
         bYr93u3kEaCAtd8C+Ir49ozWAKYaBkv4JQeCjTo1MDfeRUiK+7qDYEQ3UL9Hb0hYklSa
         s6710aRtBAlPnfSB6SYMr5CWNEGchhxoHkp4fgYctNSe01g38IHREyveIn157NQTWhlv
         JUq/LJ7q1ZSvvGRGmJ7skktK79pAeyVzQNTuPEJADE1caiYOnygT3ejbHAM/GobVaQBK
         FYVA==
X-Gm-Message-State: AOAM531amj+3K3o5j/BRC59aKY88UoLKwKtbDoCFeXA+dWxHjqqEglZa
        Vbnl1YAZSEY2N29HR7Y08L0WpQ==
X-Google-Smtp-Source: ABdhPJyp2X6nNdq0VUdkGGphFH+5wK01QWBz+QpKmFoCUlgheEm7yDHm0sOfkoGVb7x2+dEtrxU8LA==
X-Received: by 2002:a05:620a:1585:: with SMTP id d5mr217276qkk.96.1636555182492;
        Wed, 10 Nov 2021 06:39:42 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id v19sm55012qtk.6.2021.11.10.06.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 06:39:41 -0800 (PST)
Message-ID: <25844618-b63d-251b-f8e1-1f0c045b87f3@mojatatu.com>
Date:   Wed, 10 Nov 2021 09:39:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] selftests: forwarding: Fix packet matching in
 mirroring selftests
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
References: <401162bba655a1f925b929f6a7f19f6429fc044e.1636474515.git.petrm@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, komachi.yoshiki@gmail.com,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <401162bba655a1f925b929f6a7f19f6429fc044e.1636474515.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TBH, the bigger question is why that patch was even applied to begin
with and not much of a discussion that happened.

While it makes sense to look at outer header - every other script
out in the wild (including your selftests) assumed inner header.
Now we have to deal with fallout - which is frustrating.
Or the patch could be simply reverted.

IMO: We could have introduced a construct like outer_ip_src/dst/proto
on tc to handle the new semantics while keeping the old assumptions
in place.

cheers,
jamal


On 2021-11-09 11:17, Petr Machata wrote:
> In commit 6de6e46d27ef ("cls_flower: Fix inability to match GRE/IPIP
> packets"), cls_flower was fixed to match an outer packet of a tunneled
> packet as would be expected, rather than dissecting to the inner packet and
> matching on that.
> 
> This fix uncovered several issues in packet matching in mirroring
> selftests:
> 
> - in mirror_gre_bridge_1d_vlan.sh and mirror_gre_vlan_bridge_1q.sh, the
>    vlan_ethtype match is copied around as "ip", even as some of the tests
>    are running over ip6gretap. This is fixed by using an "ipv6" for
>    vlan_ethtype in the ip6gretap tests.
> 
> - in mirror_gre_changes.sh, a filter to count GRE packets is set up to
>    match TTL of 50. This used to trigger in the offloaded datapath, where
>    the envelope TTL was matched, but not in the software datapath, which
>    considered TTL of the inner packet. Now that both match consistently, all
>    the packets were double-counted. This is fixed by marking the filter as
>    skip_hw, leaving only the SW datapath component active.
> 
> Fixes: 6de6e46d27ef ("cls_flower: Fix inability to match GRE/IPIP packets")
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>   .../net/forwarding/mirror_gre_bridge_1d_vlan.sh     |  2 +-
>   .../selftests/net/forwarding/mirror_gre_changes.sh  |  2 +-
>   .../net/forwarding/mirror_gre_vlan_bridge_1q.sh     | 13 +++++++------
>   .../testing/selftests/net/forwarding/mirror_lib.sh  |  3 ++-
>   .../testing/selftests/net/forwarding/mirror_vlan.sh |  4 ++--
>   5 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
> index f8cda822c1ce..1b27f2b0f196 100755
> --- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
> +++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
> @@ -80,7 +80,7 @@ test_gretap()
>   
>   test_ip6gretap()
>   {
> -	test_vlan_match gt6 'skip_hw vlan_id 555 vlan_ethtype ip' \
> +	test_vlan_match gt6 'skip_hw vlan_id 555 vlan_ethtype ipv6' \
>   			"mirror to ip6gretap"
>   }
>   
> diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh b/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh
> index 472bd023e2a5..aff88f78e339 100755
> --- a/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh
> +++ b/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh
> @@ -74,7 +74,7 @@ test_span_gre_ttl()
>   
>   	mirror_install $swp1 ingress $tundev "matchall $tcflags"
>   	tc filter add dev $h3 ingress pref 77 prot $prot \
> -		flower ip_ttl 50 action pass
> +		flower skip_hw ip_ttl 50 action pass
>   
>   	mirror_test v$h1 192.0.2.1 192.0.2.2 $h3 77 0
>   
> diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
> index 880e3ab9d088..c8a9b5bd841f 100755
> --- a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
> +++ b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
> @@ -141,7 +141,7 @@ test_gretap()
>   
>   test_ip6gretap()
>   {
> -	test_vlan_match gt6 'skip_hw vlan_id 555 vlan_ethtype ip' \
> +	test_vlan_match gt6 'skip_hw vlan_id 555 vlan_ethtype ipv6' \
>   			"mirror to ip6gretap"
>   }
>   
> @@ -218,6 +218,7 @@ test_ip6gretap_forbidden_egress()
>   test_span_gre_untagged_egress()
>   {
>   	local tundev=$1; shift
> +	local ul_proto=$1; shift
>   	local what=$1; shift
>   
>   	RET=0
> @@ -225,7 +226,7 @@ test_span_gre_untagged_egress()
>   	mirror_install $swp1 ingress $tundev "matchall $tcflags"
>   
>   	quick_test_span_gre_dir $tundev ingress
> -	quick_test_span_vlan_dir $h3 555 ingress
> +	quick_test_span_vlan_dir $h3 555 ingress "$ul_proto"
>   
>   	h3_addr_add_del del $h3.555
>   	bridge vlan add dev $swp3 vid 555 pvid untagged
> @@ -233,7 +234,7 @@ test_span_gre_untagged_egress()
>   	sleep 5
>   
>   	quick_test_span_gre_dir $tundev ingress
> -	fail_test_span_vlan_dir $h3 555 ingress
> +	fail_test_span_vlan_dir $h3 555 ingress "$ul_proto"
>   
>   	h3_addr_add_del del $h3
>   	bridge vlan add dev $swp3 vid 555
> @@ -241,7 +242,7 @@ test_span_gre_untagged_egress()
>   	sleep 5
>   
>   	quick_test_span_gre_dir $tundev ingress
> -	quick_test_span_vlan_dir $h3 555 ingress
> +	quick_test_span_vlan_dir $h3 555 ingress "$ul_proto"
>   
>   	mirror_uninstall $swp1 ingress
>   
> @@ -250,12 +251,12 @@ test_span_gre_untagged_egress()
>   
>   test_gretap_untagged_egress()
>   {
> -	test_span_gre_untagged_egress gt4 "mirror to gretap"
> +	test_span_gre_untagged_egress gt4 ip "mirror to gretap"
>   }
>   
>   test_ip6gretap_untagged_egress()
>   {
> -	test_span_gre_untagged_egress gt6 "mirror to ip6gretap"
> +	test_span_gre_untagged_egress gt6 ipv6 "mirror to ip6gretap"
>   }
>   
>   test_span_gre_fdb_roaming()
> diff --git a/tools/testing/selftests/net/forwarding/mirror_lib.sh b/tools/testing/selftests/net/forwarding/mirror_lib.sh
> index 6406cd76a19d..3e8ebeff3019 100644
> --- a/tools/testing/selftests/net/forwarding/mirror_lib.sh
> +++ b/tools/testing/selftests/net/forwarding/mirror_lib.sh
> @@ -115,13 +115,14 @@ do_test_span_vlan_dir_ips()
>   	local dev=$1; shift
>   	local vid=$1; shift
>   	local direction=$1; shift
> +	local ul_proto=$1; shift
>   	local ip1=$1; shift
>   	local ip2=$1; shift
>   
>   	# Install the capture as skip_hw to avoid double-counting of packets.
>   	# The traffic is meant for local box anyway, so will be trapped to
>   	# kernel.
> -	vlan_capture_install $dev "skip_hw vlan_id $vid vlan_ethtype ip"
> +	vlan_capture_install $dev "skip_hw vlan_id $vid vlan_ethtype $ul_proto"
>   	mirror_test v$h1 $ip1 $ip2 $dev 100 $expect
>   	mirror_test v$h2 $ip2 $ip1 $dev 100 $expect
>   	vlan_capture_uninstall $dev
> diff --git a/tools/testing/selftests/net/forwarding/mirror_vlan.sh b/tools/testing/selftests/net/forwarding/mirror_vlan.sh
> index 9ab2ce77b332..0b44e148235e 100755
> --- a/tools/testing/selftests/net/forwarding/mirror_vlan.sh
> +++ b/tools/testing/selftests/net/forwarding/mirror_vlan.sh
> @@ -85,9 +85,9 @@ test_tagged_vlan_dir()
>   	RET=0
>   
>   	mirror_install $swp1 $direction $swp3.555 "matchall $tcflags"
> -	do_test_span_vlan_dir_ips 10 "$h3.555" 111 "$direction" \
> +	do_test_span_vlan_dir_ips 10 "$h3.555" 111 "$direction" ip \
>   				  192.0.2.17 192.0.2.18
> -	do_test_span_vlan_dir_ips  0 "$h3.555" 555 "$direction" \
> +	do_test_span_vlan_dir_ips  0 "$h3.555" 555 "$direction" ip \
>   				  192.0.2.17 192.0.2.18
>   	mirror_uninstall $swp1 $direction
>   
> 

