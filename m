Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1473048C8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbhAZFjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbhAZDgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 22:36:19 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9E4C061756
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 19:35:39 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id q1so31058689ion.8
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 19:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=KPMmSa9BxwYroeQc6hGK8p4o/77Q8i/rBe+oWa9SzBU=;
        b=iTESOiJInOKSIlWKMsvZ5A3ZbT7fYzJHq8eoapx1PGU5gt3OHXnyCFXIi0DQ8kuD/8
         PIhcMREjKQqadkA4Xnq1UBl1vBmtj9Dko9WyF7Mm6nIITeQfRrTokr98oxdobusz2iqN
         PPKmkHDdI+dM4uwuZF121A801o/H0regML9OifXdr3l2ow7wzOV3wdK5vn7zlg50NuKl
         tB+z+EUimLyy0kVpdGyCM/4fYQm7wb9H0WkSMt7v3uwvAB5St7Yc790Hds+Iwpzr+hgL
         0ETGvhW8FfNotOv9UJ6LDMNoXx8d6SStjhXkU0X1Kqq3tk4ISf3tiqbNZOVGtcMUmaoB
         C+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=KPMmSa9BxwYroeQc6hGK8p4o/77Q8i/rBe+oWa9SzBU=;
        b=JCe/1ZPl9Rh9jnMBcikCdKTGpf5MszTL4cDlp09Eq2BvOagw6GTzsxsaZzdKegG4i+
         Kl2wwxKIUuBqEoMNG38VK9b6S1ulk3UuzUVUuYkEMVbY7PIsF+uh3XFlwoxRIPSBqM6G
         J5HTce7uEgxWtS9SVNER2ylwdIXzmflnfqjCauA2/UseNOuX/WHpwx/kfVB3+26wNCt/
         q9xpHcHjxcQanMdGwoHpRLag3wFifYfI3elD7UQfZO641Wbl5KlYIt14v6rztKGPLpGB
         g1iTFpDKtyfqPgeqaL+rV/TNlK5Ei+ve9mRO8IhKg1dDSIpg1rATwOfhVbcp5RKOoBi4
         cllg==
X-Gm-Message-State: AOAM532uBJ9oU8rM+j37BbhjmkByJsotynUdDz9RYEAgH4PyDvZgPd69
        sA4pInSpl3U0bP3YMuLdGfIdfBln7+UCes9ml+k=
X-Google-Smtp-Source: ABdhPJx+cCVnN5ZwW3l1oS0o6lbyTkz/WGabPZtln5wb+a9QNINTvoTgl7AKzceiDvGpWTd9MxKUZUaq3jGSYZfbiUo=
X-Received: by 2002:a92:d44d:: with SMTP id r13mr2891188ilm.0.1611632138755;
 Mon, 25 Jan 2021 19:35:38 -0800 (PST)
MIME-Version: 1.0
References: <20210125233847.GK24989@frotz.zork.net>
In-Reply-To: <20210125233847.GK24989@frotz.zork.net>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 25 Jan 2021 19:35:27 -0800
Message-ID: <CAA93jw74dn1CvoCeMfRKz40Kj2hmDuDUcSFpAeLuPX5nkmzkdA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] selftests: add IPv4 unicast extensions tests
To:     Seth David Schoen <schoen@loyalty.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>, John Gilmore <gnu@toad.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 3:44 PM Seth David Schoen <schoen@loyalty.org> wrot=
e:
>
> Add selftests for kernel behavior with regard to various classes of
> unallocated/reserved IPv4 addresses, checking whether or not these
> addresses can be assigned as unicast addresses on links and used in
> routing.
>
> Expect the current kernel behavior at the time of this patch. That is:
>
> * 0/8 and 240/4 may be used as unicast, with the exceptions of 0.0.0.0
>   and 255.255.255.255;
> * the lowest host in a subnet may only be used as a broadcast address;
> * 127/8 may not be used as unicast (the route_localnet option, which is
>   disabled by default, still leaves it treated slightly specially);
> * 224/4 may not be used as unicast.
> ---
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../selftests/net/unicast_extensions.sh       | 228 ++++++++++++++++++
>  2 files changed, 229 insertions(+)
>  create mode 100755 tools/testing/selftests/net/unicast_extensions.sh
>
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
> index fa5fa425d148..25f198bec0b2 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -22,6 +22,7 @@ TEST_PROGS +=3D devlink_port_split.py
>  TEST_PROGS +=3D drop_monitor_tests.sh
>  TEST_PROGS +=3D vrf_route_leaking.sh
>  TEST_PROGS +=3D bareudp.sh
> +TEST_PROGS +=3D unicast_extensions.sh
>  TEST_PROGS_EXTENDED :=3D in_netns.sh
>  TEST_GEN_FILES =3D  socket nettest
>  TEST_GEN_FILES +=3D psock_fanout psock_tpacket msg_zerocopy reuseport_ad=
dr_any
> diff --git a/tools/testing/selftests/net/unicast_extensions.sh b/tools/te=
sting/selftests/net/unicast_extensions.sh
> new file mode 100755
> index 000000000000..936600082bba
> --- /dev/null
> +++ b/tools/testing/selftests/net/unicast_extensions.sh
> @@ -0,0 +1,228 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# By Seth Schoen (c) 2021, for the IPv4 Unicast Extensions Project
> +# Thanks to David Ahern for help and advice on nettest modifications.
> +#
> +# Self-tests for IPv4 address extensions: the kernel's ability to accept
> +# certain traditionally unused or unallocated IPv4 addresses. For each k=
ind
> +# of address, we test for interface assignment, ping, TCP, and forwardin=
g.
> +# Must be run as root (to manipulate network namespaces and virtual
> +# interfaces).
> +#
> +# Things we test for here:
> +#
> +# * Currently the kernel accepts addresses in 0/8 and 240/4 as valid.
> +#
> +# * Notwithstanding that, 0.0.0.0 and 255.255.255.255 cannot be assigned=
.
> +#
> +# * Currently the kernel DOES NOT accept unicast use of the lowest
> +#   host in an IPv4 subnet (e.g. 192.168.100.0/32 in 192.168.100.0/24).
> +#   This is treated as a second broadcast address, for compatibility
> +#   with 4.2BSD (!).
> +#
> +# * Currently the kernel DOES NOT accept unicast use of any of 127/8.
> +#
> +# * Currently the kernel DOES NOT accept unicast use of any of 224/4.
> +#
> +# These tests provide an easy way to flip the expected result of any
> +# of these behaviors for testing kernel patches that change them.
> +
> +# nettest can be run from PATH or from same directory as this selftest
> +if ! which nettest >/dev/null; then
> +       PATH=3D$PWD:$PATH
> +       if ! which nettest >/dev/null; then
> +               echo "'nettest' command not found; skipping tests"
> +               exit 0
> +       fi
> +fi
> +
> +result=3D0
> +
> +hide_output(){ exec 3>&1 4>&2 >/dev/null 2>/dev/null; }
> +show_output(){ exec >&3 2>&4; }
> +
> +show_result(){
> +       if [ $1 -eq 0 ]; then
> +               printf "TEST: %-60s  [ OK ]\n" "${2}"
> +       else
> +               printf "TEST: %-60s  [FAIL]\n" "${2}"
> +               result=3D1
> +       fi
> +}
> +
> +_do_segmenttest(){
> +       # Perform a simple set of link tests between a pair of
> +       # IP addresses on a shared (virtual) segment, using
> +       # ping and nettest.
> +       # foo --- bar
> +       # Arguments: ip_a ip_b prefix_length test_description
> +       #
> +       # Caller must set up foo-ns and bar-ns namespaces
> +       # containing linked veth devices foo and bar,
> +       # respectively.
> +
> +       ip -n foo-ns address add $1/$3 dev foo || return 1
> +       ip -n foo-ns link set foo up || return 1
> +       ip -n bar-ns address add $2/$3 dev bar || return 1
> +       ip -n bar-ns link set bar up || return 1
> +
> +       ip netns exec foo-ns timeout 2 ping -c 1 $2 || return 1
> +       ip netns exec bar-ns timeout 2 ping -c 1 $1 || return 1
> +
> +       nettest -B -N bar-ns -O foo-ns -r $1 || return 1
> +       nettest -B -N foo-ns -O bar-ns -r $2 || return 1
> +
> +       return 0
> +}
> +
> +_do_route_test(){
> +       # Perform a simple set of gateway tests.
> +       #
> +       # [foo] <---> [foo1]-[bar1] <---> [bar]   /prefix
> +       #  host          gateway          host
> +       #
> +       # Arguments: foo_ip foo1_ip bar1_ip bar_ip prefix_len test_descri=
ption
> +       # Displays test result and returns success or failure.
> +
> +       # Caller must set up foo-ns, bar-ns, and router-ns
> +       # containing linked veth devices foo-foo1, bar1-bar
> +       # (foo in foo-ns, foo1 and bar1 in router-ns, and
> +       # bar in bar-ns).
> +
> +       ip -n foo-ns address add $1/$5 dev foo || return 1
> +       ip -n foo-ns link set foo up || return 1
> +       ip -n foo-ns route add default via $2 || return 1
> +       ip -n bar-ns address add $4/$5 dev bar || return 1
> +       ip -n bar-ns link set bar up || return 1
> +       ip -n bar-ns route add default via $3 || return 1
> +       ip -n router-ns address add $2/$5 dev foo1 || return 1
> +       ip -n router-ns link set foo1 up || return 1
> +       ip -n router-ns address add $3/$5 dev bar1 || return 1
> +       ip -n router-ns link set bar1 up || return 1
> +
> +       echo 1 | ip netns exec router-ns tee /proc/sys/net/ipv4/ip_forwar=
d
> +
> +       ip netns exec foo-ns timeout 2 ping -c 1 $2 || return 1
> +       ip netns exec foo-ns timeout 2 ping -c 1 $4 || return 1
> +       ip netns exec bar-ns timeout 2 ping -c 1 $3 || return 1
> +       ip netns exec bar-ns timeout 2 ping -c 1 $1 || return 1
> +
> +       nettest -B -N bar-ns -O foo-ns -r $1 || return 1
> +       nettest -B -N foo-ns -O bar-ns -r $4 || return 1
> +
> +       return 0
> +}
> +
> +segmenttest(){
> +       # Sets up veth link and tries to connect over it.
> +       # Arguments: ip_a ip_b prefix_len test_description
> +       hide_output
> +       ip netns add foo-ns
> +       ip netns add bar-ns
> +       ip link add foo netns foo-ns type veth peer name bar netns bar-ns
> +
> +       test_result=3D0
> +       _do_segmenttest "$@" || test_result=3D1
> +
> +       ip netns pids foo-ns | xargs -r kill -9
> +       ip netns pids bar-ns | xargs -r kill -9
> +       ip netns del foo-ns
> +       ip netns del bar-ns
> +       show_output
> +
> +       # inverted tests will expect failure instead of success
> +       [ -n "$expect_failure" ] && test_result=3D`expr 1 - $test_result`
> +
> +       show_result $test_result "$4"
> +}
> +
> +route_test(){
> +       # Sets up a simple gateway and tries to connect through it.
> +       # [foo] <---> [foo1]-[bar1] <---> [bar]   /prefix
> +       # Arguments: foo_ip foo1_ip bar1_ip bar_ip prefix_len test_descri=
ption
> +       # Returns success or failure.
> +
> +       hide_output
> +       ip netns add foo-ns
> +       ip netns add bar-ns
> +       ip netns add router-ns
> +       ip link add foo netns foo-ns type veth peer name foo1 netns route=
r-ns
> +       ip link add bar netns bar-ns type veth peer name bar1 netns route=
r-ns
> +
> +       test_result=3D0
> +       _do_route_test "$@" || test_result=3D1
> +
> +       ip netns pids foo-ns | xargs -r kill -9
> +       ip netns pids bar-ns | xargs -r kill -9
> +       ip netns pids router-ns | xargs -r kill -9
> +       ip netns del foo-ns
> +       ip netns del bar-ns
> +       ip netns del router-ns
> +
> +       show_output
> +
> +       # inverted tests will expect failure instead of success
> +       [ -n "$expect_failure" ] && test_result=3D`expr 1 - $test_result`
> +       show_result $test_result "$6"
> +}
> +
> +echo "##################################################################=
#########"
> +echo "Unicast address extensions tests (behavior of reserved IPv4 addres=
ses)"
> +echo "##################################################################=
#########"
> +#
> +# Test support for 240/4
> +segmenttest 240.1.2.1   240.1.2.4    24 "assign and ping within 240/4 (1=
 of 2) (is allowed)"
> +segmenttest 250.100.2.1 250.100.30.4 16 "assign and ping within 240/4 (2=
 of 2) (is allowed)"
> +#
> +# Test support for 0/8
> +segmenttest 0.1.2.17    0.1.2.23  24 "assign and ping within 0/8 (1 of 2=
) (is allowed)"
> +segmenttest 0.77.240.17 0.77.2.23 16 "assign and ping within 0/8 (2 of 2=
) (is allowed)"
> +#
> +# Even 255.255/16 is OK!
> +segmenttest 255.255.3.1 255.255.50.77 16 "assign and ping inside 255.255=
/16 (is allowed)"
> +#
> +# Or 255.255.255/24
> +segmenttest 255.255.255.1 255.255.255.254 24 "assign and ping inside 255=
.255.255/24 (is allowed)"
> +#
> +# Routing between different networks
> +route_test 240.5.6.7 240.5.6.1  255.1.2.1    255.1.2.3      24 "route be=
tween 240.5.6/24 and 255.1.2/24 (is allowed)"
> +route_test 0.200.6.7 0.200.38.1 245.99.101.1 245.99.200.111 16 "route be=
tween 0.200/16 and 245.99/16 (is allowed)"
> +#
> +# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +# =3D=3D=3D=3D TESTS THAT CURRENTLY EXPECT FAILURE =3D=3D=3D=3D=3D
> +# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +expect_failure=3Dtrue
> +# It should still not be possible to use 0.0.0.0 or 255.255.255.255
> +# as a unicast address.  Thus, these tests expect failure.
> +segmenttest 0.0.1.5       0.0.0.0         16 "assigning 0.0.0.0 (is forb=
idden)"
> +segmenttest 255.255.255.1 255.255.255.255 16 "assigning 255.255.255.255 =
(is forbidden)"
> +#
> +# Test support for not having all of 127 be loopback
> +# Currently Linux does not allow this, so this should fail too
> +segmenttest 127.99.4.5 127.99.4.6 16 "assign and ping inside 127/8 (is f=
orbidden)"
> +#
> +# Test support for lowest host
> +# Currently Linux does not allow this, so this should fail too
> +segmenttest 5.10.15.20 5.10.15.0 24 "assign and ping lowest host (is for=
bidden)"
> +#
> +# Routing using lowest host as a gateway/endpoint
> +# Currently Linux does not allow this, so this should fail too
> +route_test 192.168.42.1 192.168.42.0 9.8.7.6 9.8.7.0 24 "routing using l=
owest host (is forbidden)"
> +#
> +# Test support for unicast use of class D
> +# Currently Linux does not allow this, so this should fail too
> +segmenttest 225.1.2.3 225.1.2.200 24 "assign and ping class D address (i=
s forbidden)"
> +#
> +# Routing using class D as a gateway
> +route_test 225.1.42.1 225.1.42.2 9.8.7.6 9.8.7.1 24 "routing using class=
 D (is forbidden)"
> +#
> +# Routing using 127/8
> +# Currently Linux does not allow this, so this should fail too
> +route_test 127.99.2.3 127.99.2.4 200.1.2.3 200.1.2.4 24 "routing using 1=
27/8 (is forbidden)"
> +#
> +unset expect_failure
> +# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +# =3D=3D=3D=3D END OF TESTS THAT CURRENTLY EXPECT FAILURE =3D=3D=3D=3D=
=3D
> +# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +exit ${result}
> --
> 2.25.1
>

Acked-By: Dave Taht <dave.taht@gmail.com>

--=20
"For a successful technology, reality must take precedence over public
relations, for Mother Nature cannot be fooled" - Richard Feynman

dave@taht.net <Dave T=C3=A4ht> CTO, TekLibre, LLC Tel: 1-831-435-0729
