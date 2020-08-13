Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F7B2441A5
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 01:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHMXOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 19:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMXN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 19:13:59 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05CEC061757;
        Thu, 13 Aug 2020 16:13:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id s23so5702610qtq.12;
        Thu, 13 Aug 2020 16:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aCaQeqxDH2mZLoOQajrAorvIOsXMPAEPhcKMCIoXKvI=;
        b=Gx/yafdoWcR30MKc5hXZC78jMsi0zA187YY+ZcK0x8dZZEodDSXDW8dI0LTc9I7Ihu
         GYhShZ9JAAYrN6pTrR6CDE86uQMDBVLfuIm9QGXBato4G2QxXijFCsMHpaxjn+vcD66z
         Eec8Pco0/qdpPuMl1hT3Qi/LN+TCd6lxBJlkulPao0e7QYBvMX132Hrh0G150XQoqpA8
         p8r9YxAq4Yn5wTMx8h9ls+U43y1hppIwYWaeIR9NO4kw4XFglvD57Im096hEVrxK8+je
         7XSqZsYWrgmbhs28zBt2jpCeQBGaFIak2SnnPgpWt+tWUGNidDOU5FAgtNnEHr/FStb1
         ctcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aCaQeqxDH2mZLoOQajrAorvIOsXMPAEPhcKMCIoXKvI=;
        b=X+w+HWMmRqD42bYJQFI7UdXtu+KdDF8MU6uhZQ1wB/KXXmQXsNc6W3367m23k0xMar
         FcbZcKNjtvvHUDm2FxXKuTXyG/LP1Zx4aHtYhhgOA2Dc4M6OOKUq0L+E1Q33QLKmqK4p
         5ZtafF5lBDIh5+jR5BSh+kU9FAyVVKiH5f4/N1zF5w6nuwOTIF6F255EqHPhzf6sOctE
         q9qfAyBXdofzgTHtaKrYpO05oQrmWxKZ1G35VfLLMj/QurRGz0McO2GTPk6Idzr655z1
         kFgsaZ+77GZ+S9nUm8oO+feHkMQ2FZuOQT6967lW9cHZ+DTFsx01b6YyYygB65pgc7zM
         jUcw==
X-Gm-Message-State: AOAM530SvVA2jxBByWPR/wUZfc6l7BBGQR+vjTv4W9DnbjO9jDZSth5z
        uGarVo2rf1BM+juhwB+h9Ff8jSs6IeE=
X-Google-Smtp-Source: ABdhPJwm9r+iOm7RWB36kQ+v8uyA1SSWuMSMTOJC53tuSfMeCGWsjl767WpeRRqx5CbQey+APZc8wg==
X-Received: by 2002:ac8:445a:: with SMTP id m26mr7539859qtn.253.1597360437795;
        Thu, 13 Aug 2020 16:13:57 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:1557:417:a433:9b3f? ([2601:282:803:7700:1557:417:a433:9b3f])
        by smtp.googlemail.com with ESMTPSA id x50sm8795396qtb.10.2020.08.13.16.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 16:13:57 -0700 (PDT)
Subject: Re: [PATCH 1/3] selftests: Add VRF icmp error route lookup test
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Michael Jeanson <mjeanson@efficios.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200811195003.1812-1-mathieu.desnoyers@efficios.com>
 <20200811195003.1812-2-mathieu.desnoyers@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <49f26c7d-b8aa-57e7-02c6-424bec9c3845@gmail.com>
Date:   Thu, 13 Aug 2020 17:13:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200811195003.1812-2-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/20 1:50 PM, Mathieu Desnoyers wrote:
> +run_cmd()
> +{
> +	local cmd="$*"
> +	local out
> +	local rc
> +
> +	if [ "$VERBOSE" = "1" ]; then
> +		echo "COMMAND: $cmd"
> +	fi
> +
> +	out=$(eval $cmd 2>&1)
> +	rc=$?
> +	if [ "$VERBOSE" = "1" ] && [ -n "$out" ]; then
> +		echo "$out"
> +	fi
> +
> +	[ "$VERBOSE" = "1" ] && echo
> +
> +	return $rc
> +}
> +

...

> +ipv6_ping()
> +{
> +	log_section "IPv6: VRF ICMP error route lookup ping"
> +
> +	setup
> +
> +	# verify connectivity
> +	if ! check_connectivity6; then
> +		echo "Error: Basic connectivity is broken"
> +		ret=1
> +		return
> +	fi
> +
> +	if [ "$VERBOSE" = "1" ]; then
> +		echo "Command to check for ICMP ttl exceeded:"
> +		run_cmd ip netns exec h1 "${ping6}" -t1 -c1 -W2 ${H2_N2_IP6}
> +	fi
> +
> +	ip netns exec h1 "${ping6}" -t1 -c1 -W2 ${H2_N2_IP6} | grep -q "Time exceeded: Hop limit"

run_cmd runs the command and if VERBOSE is set to 1 shows the command to
the user. Something is off with this script and passing the -v arg -- I
do not get a command list. This applies to the whole script.

Since you need to check for output, I suggest modifying run_cmd to
search the output for the given string.


> +	log_test $? 0 "Ping received ICMP ttl exceeded"
> +}
> +################################################################################

missing newline between '}' and '####'

> +# usage
> +
> +usage()
> +{
> +        cat <<EOF
> +usage: ${0##*/} OPTS
> +
> +	-4          IPv4 tests only
> +	-6          IPv6 tests only
> +	-p          Pause on fail
> +	-v          verbose mode (show commands and output)
> +EOF
> +}
> +
> +################################################################################
> +# main
> +
> +# Some systems don't have a ping6 binary anymore
> +command -v ping6 > /dev/null 2>&1 && ping6=$(command -v ping6) || ping6=$(command -v ping)
> +
> +TESTS_IPV4="ipv4_ping ipv4_traceroute"
> +TESTS_IPV6="ipv6_ping ipv6_traceroute"
> +
> +ret=0
> +nsuccess=0
> +nfail=0
> +setup=0
> +
> +while getopts :46pvh o
> +do
> +	case $o in
> +		4) TESTS=ipv4;;
> +		6) TESTS=ipv6;;
> +                p) PAUSE_ON_FAIL=yes;;
> +                v) VERBOSE=1;;
> +		h) usage; exit 0;;
> +                *) usage; exit 1;;

indentation issues; not using tabs

> +	esac
> +done
> +
> +#
> +# show user test config
> +#
> +if [ -z "$TESTS" ]; then
> +        TESTS="$TESTS_IPV4 $TESTS_IPV6"
> +elif [ "$TESTS" = "ipv4" ]; then
> +        TESTS="$TESTS_IPV4"
> +elif [ "$TESTS" = "ipv6" ]; then
> +        TESTS="$TESTS_IPV6"
> +fi
> +
> +for t in $TESTS
> +do
> +	case $t in
> +	ipv4_ping|ping)             ipv4_ping;;
> +	ipv4_traceroute|traceroute) ipv4_traceroute;;
> +
> +	ipv6_ping|ping)             ipv6_ping;;
> +	ipv6_traceroute|traceroute) ipv6_traceroute;;
> +
> +	# setup namespaces and config, but do not run any tests
> +	setup)                      setup; exit 0;;

you don't allow '-t setup' so you can remove this part

> +
> +	help)                       echo "Test names: $TESTS"; exit 0;;
> +	esac
> +done
> +
> +cleanup
> +
> +printf "\nTests passed: %3d\n" ${nsuccess}
> +printf "Tests failed: %3d\n"   ${nfail}
> +
> +exit $ret
> 

