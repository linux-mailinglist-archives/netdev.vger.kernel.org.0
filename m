Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B6F2ACAB2
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgKJBui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgKJBuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 20:50:37 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244EDC0613CF;
        Mon,  9 Nov 2020 17:50:37 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id g11so5649345pll.13;
        Mon, 09 Nov 2020 17:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4wlO6lP+LxvOe2FtWAL+yvuq/g+6nAeYqS/you3n11g=;
        b=NapWF29p63r3wkR27H2rZ8vZWZ1vlXowEZhbv3O4Ly6RMRMiU9z6s9iGpqAE7MRfmX
         U7ktzyGN3048PhqDyVtUejixXBPJS4mWlr1rxZ1xCgqams6jl6OUwbdx2qW3XUC6KXmK
         h18fdLvEz4lU6IBTRTA9EnRVxqdD/SCBFyfUAMxo2G6XDMZTZLnCGnAoxCqRoN2cYFPa
         l0gOX+JK7dnVXW5nBBjKDAD7+Rcy5CF5XEQypFWZmwYA4HDtIYdhRAxabGKxbn3gfks3
         354L7AARedkaEEouGsQch1uurnUmkjN9wjF+36HXQ0zaTZE7OVO4TIpChY11BJwmehC9
         sgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4wlO6lP+LxvOe2FtWAL+yvuq/g+6nAeYqS/you3n11g=;
        b=FTTBxGB4qHWzbcrmarCbAAdpNlBR78ssTbeWkJHQSdPeny57fHAlEuGqFyd+8aEX7R
         4zliqJuFFNLNmn+JMLNAihkyphP8JPeq8mq2akb2QM6GJceVGJe564vewU0/bhL2qJg8
         4Y2aQhY5DHpvXB7FYr5Q+S7blRxs36kjYq7gb3ggzitu8uWz6OS8Lb0biEVFdXoT1IvF
         Z04WD3rmRIPdOSpDb8Psc1j7qdEUP19V0YOWYKv8kQqK1FjCywGZt1dp61yap5q0SVBV
         GLljdW5vocp5pkawda3Fkoyw4QzJ4Mm2qBUyLFDEZqJyHd2ydXzqa/d33eSWZbJxEBZ9
         b9OQ==
X-Gm-Message-State: AOAM530leId1H3tZKLaet+LWFTbLi6+41+OhgScWO5AYCNRZWQNszG48
        0m1CLC8YjDemZ1yFMlDWuawmpZg3Z+8g1Q==
X-Google-Smtp-Source: ABdhPJzkr1cAq+9M083nlfH+7tXD30hEYWi3noB2tQPu3XeqArg0U92o2o06yf+Eqy/VOsK/uUVBww==
X-Received: by 2002:a17:902:ed01:b029:d6:bb79:d46a with SMTP id b1-20020a170902ed01b02900d6bb79d46amr15419801pld.76.1604973036405;
        Mon, 09 Nov 2020 17:50:36 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z13sm7956783pff.167.2020.11.09.17.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 17:50:36 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf 2/2] samples/bpf: remove unused test_ipip.sh
Date:   Tue, 10 Nov 2020 09:50:13 +0800
Message-Id: <20201110015013.1570716-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201110015013.1570716-1-liuhangbin@gmail.com>
References: <20201106090117.3755588-1-liuhangbin@gmail.com>
 <20201110015013.1570716-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcbpf2_kern.o and related kernel sections are moved to bpf
selftest folder since b05cd7404323 ("samples/bpf: remove the bpf tunnel
testsuite."). Remove this one as well.

Fixes: b05cd7404323 ("samples/bpf: remove the bpf tunnel testsuite.")
Acked-by: Martin KaFai Lau <kafai@fb.com>
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

