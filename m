Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11521B9222
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 19:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgDZRkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 13:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726154AbgDZRkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 13:40:05 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A62C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 10:40:05 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k23so1098065ios.5
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 10:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=66zkJoqWrHYa6zsDO3w3CCCcGVppHXWqMfsgEbDqqv0=;
        b=nPM2Dgjbyb0zht6PpNECWOuhb0Qyw/9RXuAnAAEMHopbxz5ymBcAwaoTONLlyTjBn8
         X7/nSJU5cCv/6YjG1uon+51gnhr2BgFD78V7YrH2NXoobgY7CUjA7dK9xh6+O4OW9bas
         IFBwQGxKhuwXH3FnDPYSrSK+CONiNVNaKtucV0q0ptDtFvXQ0As2QLCkIkbdW5ZykkMo
         9VTS3l0Jt8k4c4P+Dy4ondLuIhDecXW+Bt6x6meFOeOw+hV8ndOipxXKkPG9pL9DOsBZ
         44+Eb1jBCRhSADGe99027LRz8BqGjVHbagwP5DISkI8lsOXpc8pLV1WyW19XH0HfsAwO
         oIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=66zkJoqWrHYa6zsDO3w3CCCcGVppHXWqMfsgEbDqqv0=;
        b=bJLFaxhYVU8UxQDrRUin8hqeV7cU16U71rXvR/2dqbTAL/5uEoHILf/UXNP6ydX/wA
         JIQuLTvTdvyt7DX+BTTyOh3hs7hmsV86/OQpRCQBr+v4O6EC8OA2Kc9uDfBCgbgzEo/E
         3HyBQhTskQfCYXP6snU7ivMMjsiD6feeTXUhE/swrzXm8Sefu0z9B93yKxAI6Oi0j/Ul
         bfVSofRK+XfPY+A4T/nJMZdbntNzzd+EHLhS++nW+aDQmjcu7BokHBol8V8BRXZIxW+A
         8pCwD2DpF6ZYXwqGGC57jvPWGXXdQgGFfOR41CIg6gxL0ln7c4JznbrQ5UukFRpqR7Q8
         5SZA==
X-Gm-Message-State: AGi0PuZOWoFpjAJlzMf6M1d3kDykQ8i30rLJ2F/HmYIMorl7LUSg86Pg
        SL1m5kOVTRf2V+Q6pq7/tbI=
X-Google-Smtp-Source: APiQypLJAXnyrki5HroOXzzNDKK/g6u+6iM50qS/upJObmVBY9OU5i9c9UufjiQkqv1tE++0cR9Ggg==
X-Received: by 2002:a5d:950d:: with SMTP id d13mr17327402iom.136.1587922804453;
        Sun, 26 Apr 2020 10:40:04 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id f1sm4146356iog.46.2020.04.26.10.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 10:40:03 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] selftests: net: add new testcases for
 nexthop API compat mode sysctl
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        bpoirier@cumulusnetworks.com
References: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
 <1587862128-24319-4-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fd7e0fa8-dc1b-b410-a327-f09cbe929c82@gmail.com>
Date:   Sun, 26 Apr 2020 11:40:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587862128-24319-4-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/20 6:48 PM, Roopa Prabhu wrote:
> @@ -253,6 +253,33 @@ check_route6()
>  	check_output "${out}" "${expected}"
>  }
>  
> +start_ip_monitor()
> +{
> +	local mtype=$1
> +
> +	# start the monitor in the background
> +	tmpfile=`mktemp /var/run/nexthoptestXXX`
> +	mpid=`($IP monitor $1 > $tmpfile & echo $!) 2>/dev/null`

&& echo?

also, that looks weird. shouldn't it be:
	mpid=($IP monitor ${mtype} > $tmpfile 2>&1 && echo $!)

you declare mtype but use $1.


> +	sleep 0.2
> +	echo "$mpid $tmpfile"
> +}
> +
> +stop_ip_monitor()
> +{
> +	local mpid=$1
> +	local tmpfile=$2
> +	local el=$3
> +
> +	# check the monitor results
> +	kill $mpid
> +	lines=`wc -l $tmpfile | cut "-d " -f1`

just for consistency with the rest of the script, use $(...) instead of
`...`

> +	test $lines -eq $el
> +	rc=$?
> +	rm -rf $tmpfile
> +
> +	return $rc
> +}
> +
>  ################################################################################
>  # basic operations (add, delete, replace) on nexthops and nexthop groups
>  #

...

> +ipv6_compat_mode()
> +{
> +	local rc
> +
> +	echo
> +	echo "IPv6 nexthop api compat mode test"
> +	echo "--------------------------------"
> +
> +	sysctl_nexthop_compat_mode_check "IPv6"
> +	if [ $? -eq $ksft_skip ]; then
> +		return $ksft_skip
> +	fi
> +
> +	run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
> +	run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
> +	run_cmd "$IP nexthop add id 122 group 62/63"
> +	ipmout=$(start_ip_monitor route)
> +
> +	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 122"
> +	# route add notification should contain expanded nexthops
> +	stop_ip_monitor $ipmout 3
> +	log_test $? 0 "IPv6 compat mode on - route add notification"
> +
> +	# route dump should contain expanded nexthops
> +	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium nexthop via 2001:db8:91::2 dev veth1 weight 1 nexthop via 2001:db8:91::3 dev veth1 weight 1"
> +	log_test $? 0 "IPv6 compat mode on - route dump"
> +
> +	# change in nexthop group should generate route notification
> +	run_cmd "$IP nexthop add id 64 via 2001:db8:91::4 dev veth1"
> +	ipmout=$(start_ip_monitor route)
> +	run_cmd "$IP nexthop replace id 122 group 62/64"
> +	stop_ip_monitor $ipmout 3
> +
> +	log_test $? 0 "IPv6 compat mode on - nexthop change"
> +
> +	# set compat mode off
> +	sysctl_nexthop_compat_mode_set 0 "IPv6"
> +
> +	run_cmd "$IP -6 ro del 2001:db8:101::1/128 nhid 122"
> +
> +	run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
> +	run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
> +	run_cmd "$IP nexthop add id 122 group 62/63"
> +	ipmout=$(start_ip_monitor route)
> +
> +	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 122"
> +	# route add notification should not contain expanded nexthops
> +	stop_ip_monitor $ipmout 1
> +	log_test $? 0 "IPv6 compat mode off - route add notification"
> +
> +	# route dump should not contain expanded nexthops
> +	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium"

here and above, remove the 'pref medium' from the string; it was moved
by a recent iproute2 change (from Donald) so for compat with old and new
iproute2 just drop it. See 493f3cc7ee02.



