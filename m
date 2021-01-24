Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951F830191C
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 02:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbhAXBLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 20:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbhAXBLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 20:11:31 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54ADCC0613D6
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 17:10:51 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id d7so1463876otf.3
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 17:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+eo7rks3vzKyPA4L5I2+0NUPG0fMGwuCrryfsIH1N8U=;
        b=AJmLdg8a0gaKBqMInyyHaaWyjnSY5/l9IWgNfataJ/G2UTzGoGNDv+r9qUMvVnxNz5
         Wr9Hh5X+TO3rlZBdGCtgImKbCc/g1HO98jpprwTwNuM5aubxXoyAFv1ICYS00Y0xL1SV
         /Bd/8rgnRPedZ1jsMwvlF+/7NlsfrAS9Pu1bsCe/5NaLj3qTrWbqZ40VnyqJ8ladkjTD
         z+Kx8JeNEYXBkemxbbiGU5wAVWK07xYPZGgQQRtyhFIYLChBBKbaUHV78+CVVTgQoVjT
         VGD0ORgX9Lgy10apcnG/lcq8gARW26taIiNnToG3CmDOLvZW2V29YIJGJmJSKgGqftc7
         8kNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+eo7rks3vzKyPA4L5I2+0NUPG0fMGwuCrryfsIH1N8U=;
        b=S0vk7vIVxOSU30OxWsvZoo8EGh9v+fSxuOvvFWh5Vqd3P/P4njekn309nMm2PGB6bc
         j43J16mev6Xm0nPhO30h1HrOfG2o2VcL2qjIGrC8mbx63gOWxGQ3ufWf7Fb8ZIH6n63k
         DlI0Rv3M1ZRQxpGK9LIxPtPdm4X52JWAh2faKcnid4Kv8FrNX88eM3OlpyYkPE/CkbPw
         zmCaVbtWPTFs1ooryDFb7x55iFy+MIw/EAVnx0aPxtYDJyY1Tfm+ekI3ONEz61tiLTnY
         iTbc+QwoQhwoCiOBvS7rfc32eLx0k/UHd+odVbBMWtcmsajcZz5TX5Fq4QDaIwRtUg30
         DmpA==
X-Gm-Message-State: AOAM5302wR4gvd1saB8SYzlizuCMgH1P5LqxROk13rKve5S6zvKcOVl/
        DWH870HrNvIgJP1v7kStypAHPheFFhA=
X-Google-Smtp-Source: ABdhPJyhpZOtkLBDOXc7HXr+YCxeHZIIb9rDcVrvizbp7x9vibznTnQjFCGSxqhCSXuE3LQpFYMDrA==
X-Received: by 2002:a9d:6393:: with SMTP id w19mr7894213otk.204.1611450650555;
        Sat, 23 Jan 2021 17:10:50 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id t24sm2485568oou.4.2021.01.23.17.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 17:10:48 -0800 (PST)
Subject: Re: [PATCH net-next] selftests: add IPv4 unicast extensions tests
To:     Seth David Schoen <schoen@loyalty.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>, John Gilmore <gnu@toad.com>
References: <20210120190523.GX24989@frotz.zork.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <37fe3248-4c1c-d68d-9343-e09264984ace@gmail.com>
Date:   Sat, 23 Jan 2021 18:10:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210120190523.GX24989@frotz.zork.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Seth:

Tests look fine. Some nits below about coding style - and checkpatch.

On 1/20/21 12:05 PM, Seth David Schoen wrote:
> diff --git a/tools/testing/selftests/net/unicast_extensions.sh b/tools/testing/selftests/net/unicast_extensions.sh
> new file mode 100755
> index 000000000000..9ca99d53b0a8
> --- /dev/null
> +++ b/tools/testing/selftests/net/unicast_extensions.sh
> @@ -0,0 +1,230 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# By Seth Schoen (c) 2021, for the IPv4 Unicast Extensions Project
> +# Thanks to David Ahern for help and advice on nettest modifications.
> +
> +# Self-tests for IPv4 address extensions: the kernel's ability to accept
> +# certain traditionally unused or unallocated IPv4 addresses. For each kind
> +# of address, we test for interface assignment, ping, TCP, and forwarding.
> +# Must be run as root (to manipulate network namespaces and virtual
> +# interfaces).
> +
> +# Things we test for here:
> +
> +# * Currently the kernel accepts addresses in 0/8 and 240/4 as valid.
> +
> +# * Notwithstanding that, 0.0.0.0 and 255.255.255.255 cannot be assigned.
> +
> +# * Currently the kernel DOES NOT accept unicast use of the lowest
> +#   host in an IPv4 subnet (e.g. 192.168.100.0/32 in 192.168.100.0/24).
> +#   This is treated as a second broadcast address, for compatibility
> +#   with 4.2BSD (!).
> +
> +# * Currently the kernel DOES NOT accept unicast use of any of 127/8.
> +
> +# * Currently the kernel DOES NOT accept unicast use of any of 224/4.
> +
> +# These tests provide an easy way to flip the expected result of any
> +# of these behaviors for testing kernel patches that change them.
> +

In the above, start all blank lines with '#' just for consistency - ie.,
no blank line gaps.

> +# nettest can be run from PATH or from same directory as this selftest
> +if ! which nettest >/dev/null; then
> +	PATH=$PWD:$PATH
> +	if ! which nettest >/dev/null; then
> +		echo "'nettest' command not found; skipping tests"
> +	        exit 0
> +	fi
> +fi
> +
> +result=0
> +
> +hide_output(){ exec 3>&1 4>&2 >/dev/null 2>/dev/null; }
> +show_output(){ exec >&3 2>&4; }
> +
> +show_result(){
> +if [ $1 -eq 0 ]; then
> +	printf "TEST: %-60s  [ OK ]\n" "${2}"
> +else
> +	printf "TEST: %-60s  [FAIL]\n" "${2}"
> +	result=1
> +fi
> +}
> +
> +_do_segmenttest(){
> +# Perform a simple set of link tests between a pair of
> +# IP addresses on a shared (virtual) segment, using
> +# ping and nettest.
> +# foo --- bar
> +# Arguments: ip_a ip_b prefix_length test_description
> +#
> +# Caller must set up foo-ns and bar-ns namespaces
> +# containing linked veth devices foo and bar,
> +# respectively.
> +
> +

remove the extra line.

> +ip -n foo-ns address add $1/$3 dev foo || return 1
> +ip -n foo-ns link set foo up || return 1
> +ip -n bar-ns address add $2/$3 dev bar || return 1
> +ip -n bar-ns link set bar up || return 1
> +
> +ip netns exec foo-ns timeout 2 ping -c 1 $2 || return 1
> +ip netns exec bar-ns timeout 2 ping -c 1 $1 || return 1
> +
> +nettest -B -N bar-ns -O foo-ns -r $1 || return 1
> +nettest -B -N foo-ns -O bar-ns -r $2 || return 1
> +
> +return 0
> +}

Indent all lines within the function 1 tab stop (except blank lines -
nothing on those). Same for functions below.

> +
> +_do_route_test(){
> +# Perform a simple set of gateway tests.
> +#
> +# [foo] <---> [foo1]-[bar1] <---> [bar]   /prefix
> +#  host          gateway          host
> +#
> +# Arguments: foo_ip foo1_ip bar1_ip bar_ip prefix_len test_description
> +# Displays test result and returns success or failure.
> +
> +# Caller must set up foo-ns, bar-ns, and router-ns
> +# containing linked veth devices foo-foo1, bar1-bar
> +# (foo in foo-ns, foo1 and bar1 in router-ns, and
> +# bar in bar-ns).
> +
> +ip -n foo-ns address add $1/$5 dev foo || return 1
> +ip -n foo-ns link set foo up || return 1
> +ip -n foo-ns route add default via $2 || return 1
> +
> +ip -n bar-ns address add $4/$5 dev bar || return 1
> +ip -n bar-ns link set bar up || return 1
> +ip -n bar-ns route add default via $3 || return 1
> +
> +ip -n router-ns address add $2/$5 dev foo1 || return 1
> +ip -n router-ns link set foo1 up || return 1
> +
> +ip -n router-ns address add $3/$5 dev bar1 || return 1
> +ip -n router-ns link set bar1 up || return 1
> +
> +echo 1 | ip netns exec router-ns tee /proc/sys/net/ipv4/ip_forward
> +
> +ip netns exec foo-ns timeout 2 ping -c 1 $2 || return 1
> +ip netns exec foo-ns timeout 2 ping -c 1 $4 || return 1
> +ip netns exec bar-ns timeout 2 ping -c 1 $3 || return 1
> +ip netns exec bar-ns timeout 2 ping -c 1 $1 || return 1
> +
> +nettest -B -N bar-ns -O foo-ns -r $1 || return 1
> +nettest -B -N foo-ns -O bar-ns -r $4 || return 1
> +
> +return 0
> +}
> +

extra newline

> +segmenttest(){
> +# Sets up veth link and tries to connect over it.
> +# Arguments: ip_a ip_b prefix_len test_description
> +hide_output
> +ip netns add foo-ns
> +ip netns add bar-ns
> +ip link add foo netns foo-ns type veth peer name bar netns bar-ns
> +
> +test_result=0
> +_do_segmenttest "$@" || test_result=1
> +
> +ip netns pids foo-ns | xargs -r kill -9
> +ip netns pids bar-ns | xargs -r kill -9
> +ip netns del foo-ns
> +ip netns del bar-ns
> +show_output
> +
> +# inverted tests will expect failure instead of success
> +[ -n "$expect_failure" ] && test_result=`expr 1 - $test_result`
> +
> +show_result $test_result "$4"
> +}
> +
> +

extra newline

> +route_test(){
> +# Sets up a simple gateway and tries to connect through it.
> +# [foo] <---> [foo1]-[bar1] <---> [bar]   /prefix
> +# Arguments: foo_ip foo1_ip bar1_ip bar_ip prefix_len test_description
> +# Returns success or failure.
> +
> +hide_output
> +ip netns add foo-ns
> +ip netns add bar-ns
> +ip netns add router-ns
> +ip link add foo netns foo-ns type veth peer name foo1 netns router-ns
> +ip link add bar netns bar-ns type veth peer name bar1 netns router-ns
> +
> +test_result=0
> +_do_route_test "$@" || test_result=1
> +
> +ip netns pids foo-ns | xargs -r kill -9
> +ip netns pids bar-ns | xargs -r kill -9
> +ip netns pids router-ns | xargs -r kill -9
> +ip netns del foo-ns
> +ip netns del bar-ns
> +ip netns del router-ns
> +
> +show_output
> +
> +# inverted tests will expect failure instead of success
> +[ -n "$expect_failure" ] && test_result=`expr 1 - $test_result`
> +show_result $test_result "$6"
> +}
> +
> +echo "#############################################################################"
> +echo "Unicast address extensions tests (behavior of reserved IPv4 addresses)"
> +echo "#############################################################################"
> +
> +# Test support for 240/4
> +segmenttest 240.1.2.1   240.1.2.4    24 "assign and ping within 240/4 (1 of 2) (is allowed)"
> +segmenttest 250.100.2.1 250.100.30.4 16 "assign and ping within 240/4 (2 of 2) (is allowed)"
> +
> +# Test support for 0/8
> +segmenttest 0.1.2.17    0.1.2.23  24 "assign and ping within 0/8 (1 of 2) (is allowed)"
> +segmenttest 0.77.240.17 0.77.2.23 16 "assign and ping within 0/8 (2 of 2) (is allowed)"
> +
> +# Even 255.255/16 is OK!
> +segmenttest 255.255.3.1 255.255.50.77 16 "assign and ping inside 255.255/16 (is allowed)"
> +
> +# Or 255.255.255/24
> +segmenttest 255.255.255.1 255.255.255.254 24 "assign and ping inside 255.255.255/24 (is allowed)"
> +
> +# Routing between different networks
> +route_test 240.5.6.7 240.5.6.1  255.1.2.1    255.1.2.3      24 "route between 240.5.6/24 and 255.1.2/24 (is allowed)"
> +route_test 0.200.6.7 0.200.38.1 245.99.101.1 245.99.200.111 16 "route between 0.200/16 and 245.99/16 (is allowed)"
> +
> +# ==============================================
> +# ==== TESTS THAT CURRENTLY EXPECT FAILURE =====
> +# ==============================================
> +expect_failure=true
> +# It should still not be possible to use 0.0.0.0 or 255.255.255.255
> +# as a unicast address.  Thus, these tests expect failure.
> +segmenttest 0.0.1.5       0.0.0.0         16 "assigning 0.0.0.0 (is forbidden)"
> +segmenttest 255.255.255.1 255.255.255.255 16 "assigning 255.255.255.255 (is forbidden)"
> +# Test support for not having all of 127 be loopback
> +# Currently Linux does not allow this, so this should fail too
> +segmenttest 127.99.4.5 127.99.4.6 16 "assign and ping inside 127/8 (is forbidden)"
> +# Test support for lowest host
> +# Currently Linux does not allow this, so this should fail too
> +segmenttest 5.10.15.20 5.10.15.0 24 "assign and ping lowest host (is forbidden)"

Put newlines after tests and before the next comment - some whitespace
makes this more readable.

> +# Routing using lowest host as a gateway/endpoint
> +# Currently Linux does not allow this, so this should fail too
> +route_test 192.168.42.1 192.168.42.0 9.8.7.6 9.8.7.0 24 "routing using lowest host (is forbidden)"
> +
> +# Test support for unicast use of class D
> +# Currently Linux does not allow this, so this should fail too
> +segmenttest 225.1.2.3 225.1.2.200 24 "assign and ping class D address (is forbidden)"

same here

> +# Routing using class D as a gateway
> +route_test 225.1.42.1 225.1.42.2 9.8.7.6 9.8.7.1 24 "routing using class D (is forbidden)"
> +
> +# Routing using 127/8
> +# Currently Linux does not allow this, so this should fail too
> +route_test 127.99.2.3 127.99.2.4 200.1.2.3 200.1.2.4 24 "routing using 127/8 (is forbidden)"
> +
> +unset expect_failure
> +# =====================================================
> +# ==== END OF TESTS THAT CURRENTLY EXPECT FAILURE =====
> +# =====================================================
> +
> +exit ${result}
> 


Also, you should run scripts/checkpatch.pl on the patch before sending
-- this version has a lot of warnings - mostly trailing white space due
to carriage returns vs newline. Might be due to your mail client.
