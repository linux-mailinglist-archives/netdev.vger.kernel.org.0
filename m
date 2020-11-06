Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D512A91FC
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgKFJBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgKFJBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:01:38 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C49C0613CF;
        Fri,  6 Nov 2020 01:01:37 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id q10so739477pfn.0;
        Fri, 06 Nov 2020 01:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y6Ip03Pfznm48ULMAJI84GFnY85ptZ5Ix/i5BaAtOGI=;
        b=WITGD6BwKAj6aqRWuu1qoR1boYaS/CAlAbHRhgj0i+P9iYPEPKiJmZxJW+ke6Hex1i
         OnYPgZLqBhv0Qc0A8xXGCUYoMIv4FWrpz5OSeYcoYFabXP8xkESPRro8cAJm6zIt8Dd2
         R+jX9egFNWDSqC9z20IBeQSzCar+qabwuABHzqjvn7XIZAwlp6FDhbkH5I4gMSZWx/4V
         VpiMDLtBt3A57U7lXjS7tBFk3Ilx4hgKYNeefHHuIYpj0dvAXwdLbG3Pe9yR+6GsRe47
         Hqiu3FK6akINVxegiFbl9qL4aq/Yc/gNhENLtp9G9D7a5QHTcbhUrw4LIAY7c6maD05V
         BFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6Ip03Pfznm48ULMAJI84GFnY85ptZ5Ix/i5BaAtOGI=;
        b=mwEElPGwTrLvCposSFN8/SOWwJErOfGlUKCz46Kpk80wzMS4+yYWZqjEoj/FtKSnQD
         gaiFSXW8c07N6X+HHZq2JBuy94KL2Yb2X3Q1E/f7Aldi6a7q0Y9lmQecQ3GxC/Q5xetR
         tHRT3V71m+xkpQ/+/qyGZuqIL3BZDhBIF2OUBdVX9fiBIIR22ixXfoCS47rp796TLv38
         cTuoAxJLyflC40SCdEF85wzjwlx2SwTpyiToHsbNhjljuvAW8xVDdAXNXaMXPjYBIo8n
         uY2xw6mjNUSkeVzjM1VaoNmbgtL1dAxqQjAA57mO05jkzOUVbzmPvV4LFuyi7utMa/+k
         bRWA==
X-Gm-Message-State: AOAM531ZIrC0tc0vepOIqX9WHDCu5pymIW05+HlXTiAzgXA+4292/eC4
        lbSH2UT9MZuXUakwADYdyrlMmzA4fvUanCZe
X-Google-Smtp-Source: ABdhPJx+8w8yCrLew6MOhoybm02iCFCBefVhlvIcfgC9+zvhQ7OJGQmPCsm2mQ+Rn7L+DyimXncliw==
X-Received: by 2002:a17:90a:fa93:: with SMTP id cu19mr1485451pjb.117.1604653296626;
        Fri, 06 Nov 2020 01:01:36 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g3sm985530pgl.55.2020.11.06.01.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 01:01:36 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 2/2] samples/bpf: remove unused test_ipip.sh
Date:   Fri,  6 Nov 2020 17:01:17 +0800
Message-Id: <20201106090117.3755588-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106090117.3755588-1-liuhangbin@gmail.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201106090117.3755588-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcbpf2_kern.o and related kernel sections are moved to bpf
selftest folder since b05cd7404323 ("samples/bpf: remove the bpf tunnel
testsuite."). Remove this one as well.

Fixes: b05cd7404323 ("samples/bpf: remove the bpf tunnel testsuite.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---

v2: move test_tunnel_kern.c changes to patch 01
---
 samples/bpf/test_ipip.sh | 179 ---------------------------------------
 1 file changed, 179 deletions(-)
 delete mode 100755 samples/bpf/test_ipip.sh

diff --git a/samples/bpf/test_ipip.sh b/samples/bpf/test_ipip.sh
deleted file mode 100755
index 9e507c305c6e..000000000000
--- a/samples/bpf/test_ipip.sh
+++ /dev/null
@@ -1,179 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-function config_device {
-	ip netns add at_ns0
-	ip netns add at_ns1
-	ip netns add at_ns2
-	ip link add veth0 type veth peer name veth0b
-	ip link add veth1 type veth peer name veth1b
-	ip link add veth2 type veth peer name veth2b
-	ip link set veth0b up
-	ip link set veth1b up
-	ip link set veth2b up
-	ip link set dev veth0b mtu 1500
-	ip link set dev veth1b mtu 1500
-	ip link set dev veth2b mtu 1500
-	ip link set veth0 netns at_ns0
-	ip link set veth1 netns at_ns1
-	ip link set veth2 netns at_ns2
-	ip netns exec at_ns0 ip addr add 172.16.1.100/24 dev veth0
-	ip netns exec at_ns0 ip addr add 2401:db00::1/64 dev veth0 nodad
-	ip netns exec at_ns0 ip link set dev veth0 up
-	ip netns exec at_ns1 ip addr add 172.16.1.101/24 dev veth1
-	ip netns exec at_ns1 ip addr add 2401:db00::2/64 dev veth1 nodad
-	ip netns exec at_ns1 ip link set dev veth1 up
-	ip netns exec at_ns2 ip addr add 172.16.1.200/24 dev veth2
-	ip netns exec at_ns2 ip addr add 2401:db00::3/64 dev veth2 nodad
-	ip netns exec at_ns2 ip link set dev veth2 up
-	ip link add br0 type bridge
-	ip link set br0 up
-	ip link set dev br0 mtu 1500
-	ip link set veth0b master br0
-	ip link set veth1b master br0
-	ip link set veth2b master br0
-}
-
-function add_ipip_tunnel {
-	ip netns exec at_ns0 \
-		ip link add dev $DEV_NS type ipip local 172.16.1.100 remote 172.16.1.200
-	ip netns exec at_ns0 ip link set dev $DEV_NS up
-	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24
-	ip netns exec at_ns1 \
-		ip link add dev $DEV_NS type ipip local 172.16.1.101 remote 172.16.1.200
-	ip netns exec at_ns1 ip link set dev $DEV_NS up
-	# same inner IP address in at_ns0 and at_ns1
-	ip netns exec at_ns1 ip addr add dev $DEV_NS 10.1.1.100/24
-
-	ip netns exec at_ns2 ip link add dev $DEV type ipip external
-	ip netns exec at_ns2 ip link set dev $DEV up
-	ip netns exec at_ns2 ip addr add dev $DEV 10.1.1.200/24
-}
-
-function add_ipip6_tunnel {
-	ip netns exec at_ns0 \
-		ip link add dev $DEV_NS type ip6tnl mode ipip6 local 2401:db00::1/64 remote 2401:db00::3/64
-	ip netns exec at_ns0 ip link set dev $DEV_NS up
-	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24
-	ip netns exec at_ns1 \
-		ip link add dev $DEV_NS type ip6tnl mode ipip6 local 2401:db00::2/64 remote 2401:db00::3/64
-	ip netns exec at_ns1 ip link set dev $DEV_NS up
-	# same inner IP address in at_ns0 and at_ns1
-	ip netns exec at_ns1 ip addr add dev $DEV_NS 10.1.1.100/24
-
-	ip netns exec at_ns2 ip link add dev $DEV type ip6tnl mode ipip6 external
-	ip netns exec at_ns2 ip link set dev $DEV up
-	ip netns exec at_ns2 ip addr add dev $DEV 10.1.1.200/24
-}
-
-function add_ip6ip6_tunnel {
-	ip netns exec at_ns0 \
-		ip link add dev $DEV_NS type ip6tnl mode ip6ip6 local 2401:db00::1/64 remote 2401:db00::3/64
-	ip netns exec at_ns0 ip link set dev $DEV_NS up
-	ip netns exec at_ns0 ip addr add dev $DEV_NS 2601:646::1/64
-	ip netns exec at_ns1 \
-		ip link add dev $DEV_NS type ip6tnl mode ip6ip6 local 2401:db00::2/64 remote 2401:db00::3/64
-	ip netns exec at_ns1 ip link set dev $DEV_NS up
-	# same inner IP address in at_ns0 and at_ns1
-	ip netns exec at_ns1 ip addr add dev $DEV_NS 2601:646::1/64
-
-	ip netns exec at_ns2 ip link add dev $DEV type ip6tnl mode ip6ip6 external
-	ip netns exec at_ns2 ip link set dev $DEV up
-	ip netns exec at_ns2 ip addr add dev $DEV 2601:646::2/64
-}
-
-function attach_bpf {
-	DEV=$1
-	SET_TUNNEL=$2
-	GET_TUNNEL=$3
-	ip netns exec at_ns2 tc qdisc add dev $DEV clsact
-	ip netns exec at_ns2 tc filter add dev $DEV egress bpf da obj tcbpf2_kern.o sec $SET_TUNNEL
-	ip netns exec at_ns2 tc filter add dev $DEV ingress bpf da obj tcbpf2_kern.o sec $GET_TUNNEL
-}
-
-function test_ipip {
-	DEV_NS=ipip_std
-	DEV=ipip_bpf
-	config_device
-#	tcpdump -nei br0 &
-	cat /sys/kernel/debug/tracing/trace_pipe &
-
-	add_ipip_tunnel
-	attach_bpf $DEV ipip_set_tunnel ipip_get_tunnel
-
-	ip netns exec at_ns0 ping -c 1 10.1.1.200
-	ip netns exec at_ns2 ping -c 1 10.1.1.100
-	ip netns exec at_ns0 iperf -sD -p 5200 > /dev/null
-	ip netns exec at_ns1 iperf -sD -p 5201 > /dev/null
-	sleep 0.2
-	# tcp check _same_ IP over different tunnels
-	ip netns exec at_ns2 iperf -c 10.1.1.100 -n 5k -p 5200
-	ip netns exec at_ns2 iperf -c 10.1.1.100 -n 5k -p 5201
-	cleanup
-}
-
-# IPv4 over IPv6 tunnel
-function test_ipip6 {
-	DEV_NS=ipip_std
-	DEV=ipip_bpf
-	config_device
-#	tcpdump -nei br0 &
-	cat /sys/kernel/debug/tracing/trace_pipe &
-
-	add_ipip6_tunnel
-	attach_bpf $DEV ipip6_set_tunnel ipip6_get_tunnel
-
-	ip netns exec at_ns0 ping -c 1 10.1.1.200
-	ip netns exec at_ns2 ping -c 1 10.1.1.100
-	ip netns exec at_ns0 iperf -sD -p 5200 > /dev/null
-	ip netns exec at_ns1 iperf -sD -p 5201 > /dev/null
-	sleep 0.2
-	# tcp check _same_ IP over different tunnels
-	ip netns exec at_ns2 iperf -c 10.1.1.100 -n 5k -p 5200
-	ip netns exec at_ns2 iperf -c 10.1.1.100 -n 5k -p 5201
-	cleanup
-}
-
-# IPv6 over IPv6 tunnel
-function test_ip6ip6 {
-	DEV_NS=ipip_std
-	DEV=ipip_bpf
-	config_device
-#	tcpdump -nei br0 &
-	cat /sys/kernel/debug/tracing/trace_pipe &
-
-	add_ip6ip6_tunnel
-	attach_bpf $DEV ip6ip6_set_tunnel ip6ip6_get_tunnel
-
-	ip netns exec at_ns0 ping -6 -c 1 2601:646::2
-	ip netns exec at_ns2 ping -6 -c 1 2601:646::1
-	ip netns exec at_ns0 iperf -6sD -p 5200 > /dev/null
-	ip netns exec at_ns1 iperf -6sD -p 5201 > /dev/null
-	sleep 0.2
-	# tcp check _same_ IP over different tunnels
-	ip netns exec at_ns2 iperf -6c 2601:646::1 -n 5k -p 5200
-	ip netns exec at_ns2 iperf -6c 2601:646::1 -n 5k -p 5201
-	cleanup
-}
-
-function cleanup {
-	set +ex
-	pkill iperf
-	ip netns delete at_ns0
-	ip netns delete at_ns1
-	ip netns delete at_ns2
-	ip link del veth0
-	ip link del veth1
-	ip link del veth2
-	ip link del br0
-	pkill tcpdump
-	pkill cat
-	set -ex
-}
-
-cleanup
-echo "Testing IP tunnels..."
-test_ipip
-test_ipip6
-test_ip6ip6
-echo "*** PASS ***"
-- 
2.25.4

