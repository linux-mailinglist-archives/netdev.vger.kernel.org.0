Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7812A3B69
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 05:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgKCE3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 23:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgKCE3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 23:29:32 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF04C0617A6;
        Mon,  2 Nov 2020 20:29:30 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 13so13093547pfy.4;
        Mon, 02 Nov 2020 20:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6qHVwtlAd61oaJp9Jvx1oOixpRZ1DO0jhxpOgEhnGx8=;
        b=sEcfBMqmFVuMx1dBm201Cj0bYF9se9er6Ag2TB4B9YtEzPfT6KyGDjI7vaUys5+cQU
         cNrPwls4LPB7Pw4OSERy/y8yJy+16ibqTvopGInnxprybxSxqTmaWr9PSJO0uiIWz6Jg
         L9J5uAONgcd/lAWu/n7FsaKHnWQgB7C2qJWFVgwJ32rSCIYN8f1gHjH6cy+j8Ezyi4cQ
         OWseHHrCJ8dxekyyE28eodQOkLC6y36I7lLMdDSIoLz636IdhCnX4a66tyEbRmXs4O7o
         7jELS983inPYFBhBnEse4VAVHQCujlxIzsikGIjDo2yeM3AFMXaAyZYfTFPMPfBNsQOf
         jmVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6qHVwtlAd61oaJp9Jvx1oOixpRZ1DO0jhxpOgEhnGx8=;
        b=rvreFEy/t2ZikBmnZ9pZ/n+asPkcJjPMTH9u+TX/Mc/qcPdAxPMp9egC99yQLApNVx
         vNmhqwNXe4bM5rSXW4I/3uWFFmhfnB3t1hdYjVJd3JhV0yCplzUMLAkbmhSjlgb28T6Y
         exIQCxTGtr7nf6V5f7dRad+zV6HPt+O0buVVruysxk/2X09WJZFhP+e8Ct6yJU8vOlEi
         Xk+az1cX5jdmnbsM1sYszC5xup009/eyvuze7lKMr4tVq5cqpuzTuUqKYQkouF1zaZkF
         OOiJwHfyyleSgklDMP2GEVAIODoCsQ3I2FAyZHUJNogTIWWuy9hPJJx5XS8y5+bnY3Gy
         FtIA==
X-Gm-Message-State: AOAM5328wl/q6Cq17uht4lVukSg2a6ipDXUoN6YTAM6upLQ6X6V6bpcg
        SKPVgm9euUCadBPDCb5PT3Mh9m+Mg5+uHJvB
X-Google-Smtp-Source: ABdhPJwkYfdeoZ9ZOW3h9qf/rKOK7qb2rOm/HP7ALveEmJwXPElU5XlM23C6cx+Kkqm6PPJSsy6Nkg==
X-Received: by 2002:a17:90a:ab86:: with SMTP id n6mr1825041pjq.82.1604377770106;
        Mon, 02 Nov 2020 20:29:30 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm13683279pgq.58.2020.11.02.20.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 20:29:29 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next 2/2] selftest/bpf: remove unused bpf tunnel testing code
Date:   Tue,  3 Nov 2020 12:29:08 +0800
Message-Id: <20201103042908.2825734-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103042908.2825734-1-liuhangbin@gmail.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
ip6ip6 test") we added some bpf tunnel tests. In commit 933a741e3b82
("selftests/bpf: bpf tunnel test.") when we moved it to the current
folder, we forgot to remove test_ipip.sh in sample folder.

Since we simplify the original ipip tests and removed iperf tests, there
is not need for TCP checks. ip6ip6 and ipip6 are using the same underlay
network, we can remove ip6ip6 section too.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 samples/bpf/test_ipip.sh                      | 179 ------------------
 .../selftests/bpf/progs/test_tunnel_kern.c    |  87 +--------
 2 files changed, 3 insertions(+), 263 deletions(-)
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
diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index f48dbfe24ddc..ef033ba1e81c 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -15,7 +15,6 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/types.h>
-#include <linux/tcp.h>
 #include <linux/socket.h>
 #include <linux/pkt_cls.h>
 #include <linux/erspan.h>
@@ -528,30 +527,17 @@ int _ipip_set_tunnel(struct __sk_buff *skb)
 	struct bpf_tunnel_key key = {};
 	void *data = (void *)(long)skb->data;
 	struct iphdr *iph = data;
-	struct tcphdr *tcp = data + sizeof(*iph);
 	void *data_end = (void *)(long)skb->data_end;
 	int ret;
 
 	/* single length check */
-	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
+	if (data + sizeof(*iph) > data_end) {
 		ERROR(1);
 		return TC_ACT_SHOT;
 	}
 
+	key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
 	key.tunnel_ttl = 64;
-	if (iph->protocol == IPPROTO_ICMP) {
-		key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
-	} else {
-		if (iph->protocol != IPPROTO_TCP || iph->ihl != 5)
-			return TC_ACT_SHOT;
-
-		if (tcp->dest == bpf_htons(5200))
-			key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
-		else if (tcp->dest == bpf_htons(5201))
-			key.remote_ipv4 = 0xac100165; /* 172.16.1.101 */
-		else
-			return TC_ACT_SHOT;
-	}
 
 	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key), 0);
 	if (ret < 0) {
@@ -585,12 +571,11 @@ int _ipip6_set_tunnel(struct __sk_buff *skb)
 	struct bpf_tunnel_key key = {};
 	void *data = (void *)(long)skb->data;
 	struct iphdr *iph = data;
-	struct tcphdr *tcp = data + sizeof(*iph);
 	void *data_end = (void *)(long)skb->data_end;
 	int ret;
 
 	/* single length check */
-	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
+	if (data + sizeof(*iph) > data_end) {
 		ERROR(1);
 		return TC_ACT_SHOT;
 	}
@@ -628,72 +613,6 @@ int _ipip6_get_tunnel(struct __sk_buff *skb)
 	return TC_ACT_OK;
 }
 
-SEC("ip6ip6_set_tunnel")
-int _ip6ip6_set_tunnel(struct __sk_buff *skb)
-{
-	struct bpf_tunnel_key key = {};
-	void *data = (void *)(long)skb->data;
-	struct ipv6hdr *iph = data;
-	struct tcphdr *tcp = data + sizeof(*iph);
-	void *data_end = (void *)(long)skb->data_end;
-	int ret;
-
-	/* single length check */
-	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
-		ERROR(1);
-		return TC_ACT_SHOT;
-	}
-
-	key.remote_ipv6[0] = bpf_htonl(0x2401db00);
-	key.tunnel_ttl = 64;
-
-	if (iph->nexthdr == 58 /* NEXTHDR_ICMP */) {
-		key.remote_ipv6[3] = bpf_htonl(1);
-	} else {
-		if (iph->nexthdr != 6 /* NEXTHDR_TCP */) {
-			ERROR(iph->nexthdr);
-			return TC_ACT_SHOT;
-		}
-
-		if (tcp->dest == bpf_htons(5200)) {
-			key.remote_ipv6[3] = bpf_htonl(1);
-		} else if (tcp->dest == bpf_htons(5201)) {
-			key.remote_ipv6[3] = bpf_htonl(2);
-		} else {
-			ERROR(tcp->dest);
-			return TC_ACT_SHOT;
-		}
-	}
-
-	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
-				     BPF_F_TUNINFO_IPV6);
-	if (ret < 0) {
-		ERROR(ret);
-		return TC_ACT_SHOT;
-	}
-
-	return TC_ACT_OK;
-}
-
-SEC("ip6ip6_get_tunnel")
-int _ip6ip6_get_tunnel(struct __sk_buff *skb)
-{
-	int ret;
-	struct bpf_tunnel_key key;
-	char fmt[] = "remote ip6 %x::%x\n";
-
-	ret = bpf_skb_get_tunnel_key(skb, &key, sizeof(key),
-				     BPF_F_TUNINFO_IPV6);
-	if (ret < 0) {
-		ERROR(ret);
-		return TC_ACT_SHOT;
-	}
-
-	bpf_trace_printk(fmt, sizeof(fmt), bpf_htonl(key.remote_ipv6[0]),
-			 bpf_htonl(key.remote_ipv6[3]));
-	return TC_ACT_OK;
-}
-
 SEC("xfrm_get_state")
 int _xfrm_get_state(struct __sk_buff *skb)
 {
-- 
2.25.4

