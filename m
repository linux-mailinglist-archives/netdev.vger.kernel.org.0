Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0F45782E3
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbiGRM7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiGRM70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:59:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7440563D4;
        Mon, 18 Jul 2022 05:59:22 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Lmhnw4tg7zlVrx;
        Mon, 18 Jul 2022 20:57:40 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Jul 2022 20:59:20 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Jul 2022 20:59:20 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next v2 3/5] selftests: bpf: Unify memory address casting operation style
Date:   Mon, 18 Jul 2022 21:29:36 +0800
Message-ID: <20220718132938.1031864-4-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718132938.1031864-1-pulehui@huawei.com>
References: <20220718132938.1031864-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory addresses are conceptually unsigned, (unsigned long) casting
makes more sense, so let's make a change for conceptual uniformity
and there is no functional change.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/bench.c           |  4 +--
 .../selftests/bpf/prog_tests/bpf_obj_id.c     | 10 +++----
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  2 +-
 tools/testing/selftests/bpf/prog_tests/btf.c  |  4 +--
 .../bpf/prog_tests/core_read_macros.c         |  8 +++---
 .../selftests/bpf/prog_tests/hashmap.c        |  8 +++---
 .../selftests/bpf/prog_tests/ringbuf.c        |  4 +--
 .../selftests/bpf/prog_tests/ringbuf_multi.c  |  4 +--
 .../bpf/prog_tests/sockopt_inherit.c          |  2 +-
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 10 +++----
 tools/testing/selftests/bpf/progs/core_kern.c |  4 +--
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |  8 +++---
 tools/testing/selftests/bpf/progs/pyperf.h    |  4 +--
 .../testing/selftests/bpf/progs/skb_pkt_end.c |  4 +--
 .../selftests/bpf/progs/sockmap_parse_prog.c  |  8 +++---
 .../bpf/progs/sockmap_verdict_prog.c          |  4 +--
 .../bpf/progs/test_btf_skc_cls_ingress.c      |  8 +++---
 .../selftests/bpf/progs/test_check_mtu.c      | 16 +++++------
 .../selftests/bpf/progs/test_cls_redirect.c   |  8 +++---
 tools/testing/selftests/bpf/progs/test_l4lb.c |  6 ++--
 .../selftests/bpf/progs/test_l4lb_noinline.c  |  6 ++--
 .../selftests/bpf/progs/test_lwt_seg6local.c  | 10 +++----
 .../bpf/progs/test_migrate_reuseport.c        |  4 +--
 .../selftests/bpf/progs/test_pkt_access.c     |  8 +++---
 .../bpf/progs/test_queue_stack_map.h          |  4 +--
 .../selftests/bpf/progs/test_seg6_loop.c      |  8 +++---
 .../selftests/bpf/progs/test_sk_assign.c      |  8 +++---
 .../selftests/bpf/progs/test_sk_lookup_kern.c |  4 +--
 .../selftests/bpf/progs/test_sockmap_kern.h   | 12 ++++----
 .../selftests/bpf/progs/test_tc_dtime.c       |  2 +-
 .../testing/selftests/bpf/progs/test_tc_edt.c |  6 ++--
 .../selftests/bpf/progs/test_tc_neigh.c       |  2 +-
 .../selftests/bpf/progs/test_tc_neigh_fib.c   |  2 +-
 .../bpf/progs/test_tcp_check_syncookie_kern.c |  8 +++---
 .../selftests/bpf/progs/test_tunnel_kern.c    | 12 ++++----
 .../selftests/bpf/progs/test_verif_scale1.c   |  4 +--
 .../selftests/bpf/progs/test_verif_scale2.c   |  4 +--
 .../selftests/bpf/progs/test_verif_scale3.c   |  4 +--
 tools/testing/selftests/bpf/progs/test_xdp.c  | 20 ++++++-------
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  4 +--
 .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  4 +--
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |  4 +--
 .../bpf/progs/test_xdp_context_test_run.c     |  4 +--
 .../bpf/progs/test_xdp_devmap_helpers.c       |  4 +--
 .../bpf/progs/test_xdp_do_redirect.c          | 14 +++++-----
 .../selftests/bpf/progs/test_xdp_loop.c       | 20 ++++++-------
 .../selftests/bpf/progs/test_xdp_noinline.c   | 28 +++++++++----------
 .../bpf/progs/test_xdp_update_frags.c         |  4 +--
 .../selftests/bpf/progs/test_xdp_vlan.c       | 16 +++++------
 .../bpf/progs/test_xdp_with_devmap_helpers.c  |  4 +--
 .../bpf/progs/xdp_redirect_multi_kern.c       |  8 +++---
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 16 +++++------
 .../testing/selftests/bpf/progs/xdping_kern.c | 12 ++++----
 tools/testing/selftests/bpf/progs/xdpwall.c   |  4 +--
 54 files changed, 200 insertions(+), 200 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index c1f20a147462..d896521e1141 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -567,7 +567,7 @@ static void setup_benchmark()
 
 	for (i = 0; i < env.consumer_cnt; i++) {
 		err = pthread_create(&state.consumers[i], NULL,
-				     bench->consumer_thread, (void *)(long)i);
+				     bench->consumer_thread, (void *)(unsigned long)i);
 		if (err) {
 			fprintf(stderr, "failed to create consumer thread #%d: %d\n",
 				i, -errno);
@@ -586,7 +586,7 @@ static void setup_benchmark()
 
 	for (i = 0; i < env.producer_cnt; i++) {
 		err = pthread_create(&state.producers[i], NULL,
-				     bench->producer_thread, (void *)(long)i);
+				     bench->producer_thread, (void *)(unsigned long)i);
 		if (err) {
 			fprintf(stderr, "failed to create producer thread #%d: %d\n",
 				i, -errno);
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
index dbe56fa8582d..dbf526242ae4 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
@@ -133,7 +133,7 @@ void serial_test_bpf_obj_id(void)
 			  load_time < now - 60 || load_time > now + 60 ||
 			  prog_infos[i].created_by_uid != my_uid ||
 			  prog_infos[i].nr_map_ids != 1 ||
-			  *(int *)(long)prog_infos[i].map_ids != map_infos[i].id ||
+			  *(int *)(unsigned long)prog_infos[i].map_ids != map_infos[i].id ||
 			  strcmp((char *)prog_infos[i].name, expected_prog_name),
 			  "get-prog-info(fd)",
 			  "err %d errno %d i %d type %d(%d) info_len %u(%zu) "
@@ -152,7 +152,7 @@ void serial_test_bpf_obj_id(void)
 			  load_time, now,
 			  prog_infos[i].created_by_uid, my_uid,
 			  prog_infos[i].nr_map_ids, 1,
-			  *(int *)(long)prog_infos[i].map_ids, map_infos[i].id,
+			  *(int *)(unsigned long)prog_infos[i].map_ids, map_infos[i].id,
 			  prog_infos[i].name, expected_prog_name))
 			goto done;
 
@@ -225,7 +225,7 @@ void serial_test_bpf_obj_id(void)
 		bzero(&prog_info, sizeof(prog_info));
 		info_len = sizeof(prog_info);
 
-		saved_map_id = *(int *)((long)prog_infos[i].map_ids);
+		saved_map_id = *(int *)((unsigned long)prog_infos[i].map_ids);
 		prog_info.map_ids = prog_infos[i].map_ids;
 		prog_info.nr_map_ids = 2;
 		err = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &info_len);
@@ -233,12 +233,12 @@ void serial_test_bpf_obj_id(void)
 		prog_infos[i].xlated_prog_insns = 0;
 		CHECK(err || info_len != sizeof(struct bpf_prog_info) ||
 		      memcmp(&prog_info, &prog_infos[i], info_len) ||
-		      *(int *)(long)prog_info.map_ids != saved_map_id,
+		      *(int *)(unsigned long)prog_info.map_ids != saved_map_id,
 		      "get-prog-info(next_id->fd)",
 		      "err %d errno %d info_len %u(%zu) memcmp %d map_id %u(%u)\n",
 		      err, errno, info_len, sizeof(struct bpf_prog_info),
 		      memcmp(&prog_info, &prog_infos[i], info_len),
-		      *(int *)(long)prog_info.map_ids, saved_map_id);
+		      *(int *)(unsigned long)prog_info.map_ids, saved_map_id);
 		close(prog_fd);
 	}
 	CHECK(nr_id_found != nr_iters,
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index 2959a52ced06..ba0f3f7381be 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -140,7 +140,7 @@ static void do_test(const char *tcp_ca, const struct bpf_map *sk_stg_map)
 			goto done;
 	}
 
-	err = pthread_create(&srv_thread, NULL, server, (void *)(long)lfd);
+	err = pthread_create(&srv_thread, NULL, server, (void *)(unsigned long)lfd);
 	if (CHECK(err != 0, "pthread_create", "err:%d errno:%d\n", err, errno))
 		goto done;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 941b0100bafa..e852a9df779d 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -6564,8 +6564,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 		  info.nr_jited_line_info, jited_cnt,
 		  info.line_info_rec_size, rec_size,
 		  info.jited_line_info_rec_size, jited_rec_size,
-		  (void *)(long)info.line_info,
-		  (void *)(long)info.jited_line_info)) {
+		  (void *)(unsigned long)info.line_info,
+		  (void *)(unsigned long)info.jited_line_info)) {
 		err = -1;
 		goto done;
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/core_read_macros.c b/tools/testing/selftests/bpf/prog_tests/core_read_macros.c
index 96f5cf3c6fa2..1f51c00e8931 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_read_macros.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_read_macros.c
@@ -35,15 +35,15 @@ void test_core_read_macros(void)
 	bss->my_pid = getpid();
 
 	/* next pointers have to be set from the kernel side */
-	bss->k_probe_in.func = (void *)(long)0x1234;
-	bss->k_core_in.func = (void *)(long)0xabcd;
+	bss->k_probe_in.func = (void *)(unsigned long)0x1234;
+	bss->k_core_in.func = (void *)(unsigned long)0xabcd;
 
 	u_probe_in.next = &u_probe_in;
-	u_probe_in.func = (void *)(long)0x5678;
+	u_probe_in.func = (void *)(unsigned long)0x5678;
 	bss->u_probe_in = &u_probe_in;
 
 	u_core_in.next = &u_core_in;
-	u_core_in.func = (void *)(long)0xdbca;
+	u_core_in.func = (void *)(unsigned long)0xdbca;
 	bss->u_core_in = &u_core_in;
 
 	err = test_core_read_macros__attach(skel);
diff --git a/tools/testing/selftests/bpf/prog_tests/hashmap.c b/tools/testing/selftests/bpf/prog_tests/hashmap.c
index 4747ab18f97f..799d4cc147f6 100644
--- a/tools/testing/selftests/bpf/prog_tests/hashmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/hashmap.c
@@ -52,8 +52,8 @@ static void test_hashmap_generic(void)
 		return;
 
 	for (i = 0; i < ELEM_CNT; i++) {
-		const void *oldk, *k = (const void *)(long)i;
-		void *oldv, *v = (void *)(long)(1024 + i);
+		const void *oldk, *k = (const void *)(unsigned long)i;
+		void *oldv, *v = (void *)(unsigned long)(1024 + i);
 
 		err = hashmap__update(map, k, v, &oldk, &oldv);
 		if (CHECK(err != -ENOENT, "hashmap__update",
@@ -104,8 +104,8 @@ static void test_hashmap_generic(void)
 		goto cleanup;
 
 	for (i = 0; i < ELEM_CNT; i++) {
-		const void *oldk, *k = (const void *)(long)i;
-		void *oldv, *v = (void *)(long)(256 + i);
+		const void *oldk, *k = (const void *)(unsigned long)i;
+		void *oldv, *v = (void *)(unsigned long)(256 + i);
 
 		err = hashmap__add(map, k, v);
 		if (CHECK(err != -EEXIST, "hashmap__add",
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index 9a80fe8a6427..57e8e6b4d223 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -78,7 +78,7 @@ static void *poll_thread(void *input)
 {
 	long timeout = (long)input;
 
-	return (void *)(long)ring_buffer__poll(ringbuf, timeout);
+	return (void *)(unsigned long)ring_buffer__poll(ringbuf, timeout);
 }
 
 void test_ringbuf(void)
@@ -208,7 +208,7 @@ void test_ringbuf(void)
 	CHECK(cnt != 2, "cnt", "exp %d samples, got %d\n", 2, cnt);
 
 	/* start poll in background w/ long timeout */
-	err = pthread_create(&thread, NULL, poll_thread, (void *)(long)10000);
+	err = pthread_create(&thread, NULL, poll_thread, (void *)(unsigned long)10000);
 	if (CHECK(err, "bg_poll", "pthread_create failed: %d\n", err))
 		goto cleanup;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
index eb5f7f5aa81a..867f8b6f27d7 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
@@ -69,12 +69,12 @@ void test_ringbuf_multi(void)
 	skel->bss->pid = getpid();
 
 	ringbuf = ring_buffer__new(bpf_map__fd(skel->maps.ringbuf1),
-				   process_sample, (void *)(long)1, NULL);
+				   process_sample, (void *)(unsigned long)1, NULL);
 	if (CHECK(!ringbuf, "ringbuf_create", "failed to create ringbuf\n"))
 		goto cleanup;
 
 	err = ring_buffer__add(ringbuf, bpf_map__fd(skel->maps.ringbuf2),
-			      process_sample, (void *)(long)2);
+			      process_sample, (void *)(unsigned long)2);
 	if (CHECK(err, "ringbuf_add", "failed to add another ring\n"))
 		goto cleanup;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
index 8ed78a9383ba..c87611e1dc12 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
@@ -97,7 +97,7 @@ static void *server_thread(void *arg)
 
 	close(client_fd);
 
-	return (void *)(long)err;
+	return (void *)(unsigned long)err;
 }
 
 static int start_server(void)
diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index f266c757b3df..9cad8867d5e0 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -91,8 +91,8 @@ static __always_inline void *bpf_flow_dissect_get_header(struct __sk_buff *skb,
 							 __u16 hdr_size,
 							 void *buffer)
 {
-	void *data_end = (void *)(long)skb->data_end;
-	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
 	__u16 thoff = skb->flow_keys->thoff;
 	__u8 *hdr;
 
@@ -150,7 +150,7 @@ int _dissect(struct __sk_buff *skb)
 static __always_inline int parse_ip_proto(struct __sk_buff *skb, __u8 proto)
 {
 	struct bpf_flow_keys *keys = skb->flow_keys;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	struct icmphdr *icmp, _icmp;
 	struct gre_hdr *gre, _gre;
 	struct ethhdr *eth, _eth;
@@ -259,9 +259,9 @@ static __always_inline int parse_ipv6_proto(struct __sk_buff *skb, __u8 nexthdr)
 
 PROG(IP)(struct __sk_buff *skb)
 {
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	struct bpf_flow_keys *keys = skb->flow_keys;
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct iphdr *iph, _iph;
 	bool done = false;
 
diff --git a/tools/testing/selftests/bpf/progs/core_kern.c b/tools/testing/selftests/bpf/progs/core_kern.c
index 2715fe27d4cf..c7b4417ce0b6 100644
--- a/tools/testing/selftests/bpf/progs/core_kern.c
+++ b/tools/testing/selftests/bpf/progs/core_kern.c
@@ -74,8 +74,8 @@ struct bpf_testmod_test_read_ctx /* it exists in bpf_testmod */ {
 SEC("tc")
 int balancer_ingress(struct __sk_buff *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	void *ptr;
 	int ret = 0, nh_off, i = 0;
 
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
index 48cd14b43741..ddbf0e46b81e 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -116,8 +116,8 @@ __u64 test_get_skb_ifindex = 0;
 SEC("freplace/get_skb_ifindex")
 int new_get_skb_ifindex(int val, struct __sk_buff *skb, int var)
 {
-	void *data_end = (void *)(long)skb->data_end;
-	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
 	struct ipv6hdr ip6, *ip6p;
 	int ifindex = skb->ifindex;
 	__u32 eth_proto;
@@ -159,8 +159,8 @@ SEC("freplace/test_pkt_write_access_subprog")
 int new_test_pkt_write_access_subprog(struct __sk_buff *skb, __u32 off)
 {
 
-	void *data = (void *)(long)skb->data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	struct tcphdr *tcp;
 
 	if (off > sizeof(struct ethhdr) + sizeof(struct ipv6hdr))
diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/selftests/bpf/progs/pyperf.h
index 6c7b1fb268d6..8f70a7d53282 100644
--- a/tools/testing/selftests/bpf/progs/pyperf.h
+++ b/tools/testing/selftests/bpf/progs/pyperf.h
@@ -77,7 +77,7 @@ static void *get_thread_state(void *tls_base, PidData *pidData)
 	void* thread_state;
 	int key;
 
-	bpf_probe_read_user(&key, sizeof(key), (void*)(long)pidData->tls_key_addr);
+	bpf_probe_read_user(&key, sizeof(key), (void *)(unsigned long)pidData->tls_key_addr);
 	bpf_probe_read_user(&thread_state, sizeof(thread_state),
 			    tls_base + 0x310 + key * 0x10 + 0x08);
 	return thread_state;
@@ -241,7 +241,7 @@ int __on_event(struct bpf_raw_tracepoint_args *ctx)
 	void* thread_state_current = (void*)0;
 	bpf_probe_read_user(&thread_state_current,
 			    sizeof(thread_state_current),
-			    (void*)(long)pidData->current_state_addr);
+			    (void *)(unsigned long)pidData->current_state_addr);
 
 	struct task_struct* task = (struct task_struct*)bpf_get_current_task();
 	void* tls_base = (void*)task;
diff --git a/tools/testing/selftests/bpf/progs/skb_pkt_end.c b/tools/testing/selftests/bpf/progs/skb_pkt_end.c
index 992b7861003a..83475f1ba65f 100644
--- a/tools/testing/selftests/bpf/progs/skb_pkt_end.c
+++ b/tools/testing/selftests/bpf/progs/skb_pkt_end.c
@@ -6,7 +6,7 @@
 
 #define INLINE __always_inline
 
-#define skb_shorter(skb, len) ((void *)(long)(skb)->data + (len) > (void *)(long)skb->data_end)
+#define skb_shorter(skb, len) ((void *)(unsigned long)(skb)->data + (len) > (void *)(unsigned long)skb->data_end)
 
 #define ETH_IPV4_TCP_SIZE (14 + sizeof(struct iphdr) + sizeof(struct tcphdr))
 
@@ -18,7 +18,7 @@ static INLINE struct iphdr *get_iphdr(struct __sk_buff *skb)
 	if (skb_shorter(skb, ETH_IPV4_TCP_SIZE))
 		goto out;
 
-	eth = (void *)(long)skb->data;
+	eth = (void *)(unsigned long)skb->data;
 	ip = (void *)(eth + 1);
 
 out:
diff --git a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
index c9abfe3a11af..85f0bbb5b63b 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
@@ -5,8 +5,8 @@
 SEC("sk_skb1")
 int bpf_prog1(struct __sk_buff *skb)
 {
-	void *data_end = (void *)(long) skb->data_end;
-	void *data = (void *)(long) skb->data;
+	void *data_end = (void *)(unsigned long) skb->data_end;
+	void *data = (void *)(unsigned long) skb->data;
 	__u8 *d = data;
 	int err;
 
@@ -15,8 +15,8 @@ int bpf_prog1(struct __sk_buff *skb)
 		if (err)
 			return SK_DROP;
 
-		data_end = (void *)(long)skb->data_end;
-		data = (void *)(long)skb->data;
+		data_end = (void *)(unsigned long)skb->data_end;
+		data = (void *)(unsigned long)skb->data;
 		if (data + 10 > data_end)
 			return SK_DROP;
 	}
diff --git a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
index e2468a6d01a5..5f1b156d46bc 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
@@ -33,8 +33,8 @@ struct {
 SEC("sk_skb2")
 int bpf_prog2(struct __sk_buff *skb)
 {
-	void *data_end = (void *)(long) skb->data_end;
-	void *data = (void *)(long) skb->data;
+	void *data_end = (void *)(unsigned long) skb->data_end;
+	void *data = (void *)(unsigned long) skb->data;
 	__u32 lport = skb->local_port;
 	__u32 rport = skb->remote_port;
 	__u8 *d = data;
diff --git a/tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingress.c b/tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingress.c
index e2bea4da194b..d0437b888d1a 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingress.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingress.c
@@ -32,7 +32,7 @@ static void test_syncookie_helper(struct ipv6hdr *ip6h, struct tcphdr *th,
 		__s64 mss_cookie;
 		void *data_end;
 
-		data_end = (void *)(long)(skb->data_end);
+		data_end = (void *)(unsigned long)(skb->data_end);
 
 		if (th->doff * 4 != 40) {
 			LOG();
@@ -74,7 +74,7 @@ static int handle_ip6_tcp(struct ipv6hdr *ip6h, struct __sk_buff *skb)
 	struct tcphdr *th;
 	void *data_end;
 
-	data_end = (void *)(long)(skb->data_end);
+	data_end = (void *)(unsigned long)(skb->data_end);
 
 	th = (struct tcphdr *)(ip6h + 1);
 	if (th + 1 > data_end)
@@ -152,9 +152,9 @@ int cls_ingress(struct __sk_buff *skb)
 	struct ethhdr *eth;
 	void *data_end;
 
-	data_end = (void *)(long)(skb->data_end);
+	data_end = (void *)(unsigned long)(skb->data_end);
 
-	eth = (struct ethhdr *)(long)(skb->data);
+	eth = (struct ethhdr *)(unsigned long)(skb->data);
 	if (eth + 1 > data_end)
 		return TC_ACT_OK;
 
diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
index 2ec1de11a3ae..de13327f33b1 100644
--- a/tools/testing/selftests/bpf/progs/test_check_mtu.c
+++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
@@ -58,8 +58,8 @@ int xdp_use_helper(struct xdp_md *ctx)
 SEC("xdp")
 int xdp_exceed_mtu(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	__u32 ifindex = GLOBAL_USER_IFINDEX;
 	__u32 data_len = data_end - data;
 	int retval = XDP_ABORTED; /* Fail */
@@ -85,8 +85,8 @@ SEC("xdp")
 int xdp_minus_delta(struct xdp_md *ctx)
 {
 	int retval = XDP_PASS; /* Expected retval on successful test */
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	__u32 ifindex = GLOBAL_USER_IFINDEX;
 	__u32 data_len = data_end - data;
 	__u32 mtu_len = 0;
@@ -109,8 +109,8 @@ SEC("xdp")
 int xdp_input_len(struct xdp_md *ctx)
 {
 	int retval = XDP_PASS; /* Expected retval on successful test */
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	__u32 ifindex = GLOBAL_USER_IFINDEX;
 	__u32 data_len = data_end - data;
 
@@ -200,8 +200,8 @@ SEC("tc")
 int tc_exceed_mtu_da(struct __sk_buff *ctx)
 {
 	/* SKB Direct-Access variant */
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	__u32 ifindex = GLOBAL_USER_IFINDEX;
 	__u32 data_len = data_end - data;
 	int retval = BPF_DROP; /* Fail */
diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
index 2833ad722cb7..0d7a55e5a260 100644
--- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
@@ -501,8 +501,8 @@ static INLINING ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *e
 
 	buf_t pkt = {
 		.skb = skb,
-		.head = (uint8_t *)(long)skb->data,
-		.tail = (uint8_t *)(long)skb->data_end,
+		.head = (uint8_t *)(unsigned long)skb->data,
+		.tail = (uint8_t *)(unsigned long)skb->data_end,
 	};
 
 	encap_gre_t *encap_gre = buf_assign(&pkt, sizeof(encap_gre_t), NULL);
@@ -956,8 +956,8 @@ int cls_redirect(struct __sk_buff *skb)
 
 	buf_t pkt = {
 		.skb = skb,
-		.head = (uint8_t *)(long)skb->data,
-		.tail = (uint8_t *)(long)skb->data_end,
+		.head = (uint8_t *)(unsigned long)skb->data,
+		.tail = (uint8_t *)(unsigned long)skb->data_end,
 	};
 
 	encap = buf_assign(&pkt, sizeof(*encap), NULL);
diff --git a/tools/testing/selftests/bpf/progs/test_l4lb.c b/tools/testing/selftests/bpf/progs/test_l4lb.c
index c26057ec46dc..6b9b26af0b16 100644
--- a/tools/testing/selftests/bpf/progs/test_l4lb.c
+++ b/tools/testing/selftests/bpf/progs/test_l4lb.c
@@ -322,7 +322,7 @@ static __always_inline bool parse_tcp(void *data, __u64 off, void *data_end,
 static __always_inline int process_packet(void *data, __u64 off, void *data_end,
 					  bool is_ipv6, struct __sk_buff *skb)
 {
-	void *pkt_start = (void *)(long)skb->data;
+	void *pkt_start = (void *)(unsigned long)skb->data;
 	struct packet_description pckt = {};
 	struct eth_hdr *eth = pkt_start;
 	struct bpf_tunnel_key tkey = {};
@@ -451,8 +451,8 @@ static __always_inline int process_packet(void *data, __u64 off, void *data_end,
 SEC("tc")
 int balancer_ingress(struct __sk_buff *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct eth_hdr *eth = data;
 	__u32 eth_proto;
 	__u32 nh_off;
diff --git a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
index c8bc0c6947aa..43cab9da4d5d 100644
--- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
@@ -321,7 +321,7 @@ static __noinline bool parse_tcp(void *data, __u64 off, void *data_end,
 static __noinline int process_packet(void *data, __u64 off, void *data_end,
 				     bool is_ipv6, struct __sk_buff *skb)
 {
-	void *pkt_start = (void *)(long)skb->data;
+	void *pkt_start = (void *)(unsigned long)skb->data;
 	struct packet_description pckt = {};
 	struct eth_hdr *eth = pkt_start;
 	struct bpf_tunnel_key tkey = {};
@@ -450,8 +450,8 @@ static __noinline int process_packet(void *data, __u64 off, void *data_end,
 SEC("tc")
 int balancer_ingress(struct __sk_buff *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct eth_hdr *eth = data;
 	__u32 eth_proto;
 	__u32 nh_off;
diff --git a/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c b/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
index 48ff2b2ad5e7..6702d9ed8f5d 100644
--- a/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
+++ b/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
@@ -57,8 +57,8 @@ static __always_inline struct ip6_srh_t *get_srh(struct __sk_buff *skb)
 	struct ip6_t *ip;
 	uint8_t *ipver;
 
-	data_end = (void *)(long)skb->data_end;
-	cursor = (void *)(long)skb->data;
+	data_end = (void *)(unsigned long)skb->data_end;
+	cursor = (void *)(unsigned long)skb->data;
 	ipver = (uint8_t *)cursor;
 
 	if ((void *)ipver + sizeof(*ipver) > data_end)
@@ -123,7 +123,7 @@ int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
 	int offset_valid = 0;
 	int err;
 
-	srh_off = (char *)srh - (char *)(long)skb->data;
+	srh_off = (char *)srh - (char *)(unsigned long)skb->data;
 	// cur_off = end of segments, start of possible TLVs
 	cur_off = srh_off + sizeof(*srh) +
 		sizeof(struct ip6_addr_t) * (srh->first_segment + 1);
@@ -177,7 +177,7 @@ static __always_inline
 int add_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh, uint32_t tlv_off,
 	    struct sr6_tlv_t *itlv, uint8_t tlv_size)
 {
-	uint32_t srh_off = (char *)srh - (char *)(long)skb->data;
+	uint32_t srh_off = (char *)srh - (char *)(unsigned long)skb->data;
 	uint8_t len_remaining, new_pad;
 	uint32_t pad_off = 0;
 	uint32_t pad_size = 0;
@@ -221,7 +221,7 @@ static __always_inline
 int delete_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh,
 	       uint32_t tlv_off)
 {
-	uint32_t srh_off = (char *)srh - (char *)(long)skb->data;
+	uint32_t srh_off = (char *)srh - (char *)(unsigned long)skb->data;
 	uint8_t len_remaining, new_pad;
 	uint32_t partial_srh_len;
 	uint32_t pad_off = 0;
diff --git a/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
index 27df571abf5b..b76663ea5c33 100644
--- a/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
+++ b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
@@ -44,8 +44,8 @@ __be16 server_port;
 SEC("xdp")
 int drop_ack(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct ethhdr *eth = data;
 	struct tcphdr *tcp = NULL;
 
diff --git a/tools/testing/selftests/bpf/progs/test_pkt_access.c b/tools/testing/selftests/bpf/progs/test_pkt_access.c
index 5cd7c096f62d..dd3fbadcd5eb 100644
--- a/tools/testing/selftests/bpf/progs/test_pkt_access.c
+++ b/tools/testing/selftests/bpf/progs/test_pkt_access.c
@@ -79,8 +79,8 @@ int get_skb_ifindex(int val, struct __sk_buff *skb, int var)
 __attribute__ ((noinline))
 int test_pkt_write_access_subprog(struct __sk_buff *skb, __u32 off)
 {
-	void *data = (void *)(long)skb->data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	struct tcphdr *tcp = NULL;
 
 	if (off > sizeof(struct ethhdr) + sizeof(struct ipv6hdr))
@@ -97,8 +97,8 @@ int test_pkt_write_access_subprog(struct __sk_buff *skb, __u32 off)
 SEC("tc")
 int test_pkt_access(struct __sk_buff *skb)
 {
-	void *data_end = (void *)(long)skb->data_end;
-	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
 	struct ethhdr *eth = (struct ethhdr *)(data);
 	struct tcphdr *tcp = NULL;
 	__u8 proto = 255;
diff --git a/tools/testing/selftests/bpf/progs/test_queue_stack_map.h b/tools/testing/selftests/bpf/progs/test_queue_stack_map.h
index 648e8cab7a23..d22d89a096b0 100644
--- a/tools/testing/selftests/bpf/progs/test_queue_stack_map.h
+++ b/tools/testing/selftests/bpf/progs/test_queue_stack_map.h
@@ -27,8 +27,8 @@ struct {
 SEC("tc")
 int _test(struct __sk_buff *skb)
 {
-	void *data_end = (void *)(long)skb->data_end;
-	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
 	struct ethhdr *eth = (struct ethhdr *)(data);
 	__u32 value;
 	int err;
diff --git a/tools/testing/selftests/bpf/progs/test_seg6_loop.c b/tools/testing/selftests/bpf/progs/test_seg6_loop.c
index a7278f064368..001423c58e8f 100644
--- a/tools/testing/selftests/bpf/progs/test_seg6_loop.c
+++ b/tools/testing/selftests/bpf/progs/test_seg6_loop.c
@@ -57,8 +57,8 @@ static __always_inline struct ip6_srh_t *get_srh(struct __sk_buff *skb)
 	struct ip6_t *ip;
 	uint8_t *ipver;
 
-	data_end = (void *)(long)skb->data_end;
-	cursor = (void *)(long)skb->data;
+	data_end = (void *)(unsigned long)skb->data_end;
+	cursor = (void *)(unsigned long)skb->data;
 	ipver = (uint8_t *)cursor;
 
 	if ((void *)ipver + sizeof(*ipver) > data_end)
@@ -124,7 +124,7 @@ static __always_inline int is_valid_tlv_boundary(struct __sk_buff *skb,
 	int offset_valid = 0;
 	int err;
 
-	srh_off = (char *)srh - (char *)(long)skb->data;
+	srh_off = (char *)srh - (char *)(unsigned long)skb->data;
 	// cur_off = end of segments, start of possible TLVs
 	cur_off = srh_off + sizeof(*srh) +
 		sizeof(struct ip6_addr_t) * (srh->first_segment + 1);
@@ -180,7 +180,7 @@ static __always_inline int add_tlv(struct __sk_buff *skb,
 				   struct ip6_srh_t *srh, uint32_t tlv_off,
 				   struct sr6_tlv_t *itlv, uint8_t tlv_size)
 {
-	uint32_t srh_off = (char *)srh - (char *)(long)skb->data;
+	uint32_t srh_off = (char *)srh - (char *)(unsigned long)skb->data;
 	uint8_t len_remaining, new_pad;
 	uint32_t pad_off = 0;
 	uint32_t pad_size = 0;
diff --git a/tools/testing/selftests/bpf/progs/test_sk_assign.c b/tools/testing/selftests/bpf/progs/test_sk_assign.c
index 98c6493d9b91..c15daf8503f6 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_assign.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_assign.c
@@ -42,8 +42,8 @@ char _license[] SEC("license") = "GPL";
 static inline struct bpf_sock_tuple *
 get_tuple(struct __sk_buff *skb, bool *ipv4, bool *tcp)
 {
-	void *data_end = (void *)(long)skb->data_end;
-	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
 	struct bpf_sock_tuple *result;
 	struct ethhdr *eth;
 	__u64 tuple_len;
@@ -96,7 +96,7 @@ handle_udp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 	int ret;
 
 	tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
-	if ((void *)tuple + tuple_len > (void *)(long)skb->data_end)
+	if ((void *)tuple + tuple_len > (void *)(unsigned long)skb->data_end)
 		return TC_ACT_SHOT;
 
 	sk = bpf_sk_lookup_udp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
@@ -127,7 +127,7 @@ handle_tcp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 	int ret;
 
 	tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
-	if ((void *)tuple + tuple_len > (void *)(long)skb->data_end)
+	if ((void *)tuple + tuple_len > (void *)(unsigned long)skb->data_end)
 		return TC_ACT_SHOT;
 
 	sk = bpf_skc_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
index b502e5c92e33..058df49340b4 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
@@ -55,8 +55,8 @@ static struct bpf_sock_tuple *get_tuple(void *data, __u64 nh_off,
 SEC("?tc")
 int sk_lookup_success(struct __sk_buff *skb)
 {
-	void *data_end = (void *)(long)skb->data_end;
-	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
 	struct ethhdr *eth = (struct ethhdr *)(data);
 	struct bpf_sock_tuple *tuple;
 	struct bpf_sock *sk;
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
index 6c85b00f27b2..afc2015674b6 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
@@ -140,8 +140,8 @@ static inline void bpf_write_pass(struct __sk_buff *skb, int offset)
 	if (err)
 		return;
 
-	c = (char *)(long)skb->data;
-	data_end = (void *)(long)skb->data_end;
+	c = (char *)(unsigned long)skb->data;
+	data_end = (void *)(unsigned long)skb->data_end;
 
 	if (c + 5 + offset < data_end)
 		memcpy(c + offset, "PASS", 4);
@@ -309,8 +309,8 @@ int bpf_prog6(struct sk_msg_md *msg)
 SEC("sk_msg3")
 int bpf_prog8(struct sk_msg_md *msg)
 {
-	void *data_end = (void *)(long) msg->data_end;
-	void *data = (void *)(long) msg->data;
+	void *data_end = (void *)(unsigned long) msg->data_end;
+	void *data = (void *)(unsigned long) msg->data;
 	int ret = 0, *bytes, zero = 0;
 
 	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
@@ -326,8 +326,8 @@ int bpf_prog8(struct sk_msg_md *msg)
 SEC("sk_msg4")
 int bpf_prog9(struct sk_msg_md *msg)
 {
-	void *data_end = (void *)(long) msg->data_end;
-	void *data = (void *)(long) msg->data;
+	void *data_end = (void *)(unsigned long) msg->data_end;
+	void *data = (void *)(unsigned long) msg->data;
 	int ret = 0, *bytes, zero = 0;
 
 	bytes = bpf_map_lookup_elem(&sock_cork_bytes, &zero);
diff --git a/tools/testing/selftests/bpf/progs/test_tc_dtime.c b/tools/testing/selftests/bpf/progs/test_tc_dtime.c
index b596479a9ebe..8391b855f0be 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_dtime.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_dtime.c
@@ -25,7 +25,7 @@
  *            ns_fwd: Fowarding namespace
  */
 
-#define ctx_ptr(field)		(void *)(long)(field)
+#define ctx_ptr(field)		(void *)(unsigned long)(field)
 
 #define ip4_src			__bpf_htonl(0xac100164) /* 172.16.1.100 */
 #define ip4_dst			__bpf_htonl(0xac100264) /* 172.16.2.100 */
diff --git a/tools/testing/selftests/bpf/progs/test_tc_edt.c b/tools/testing/selftests/bpf/progs/test_tc_edt.c
index 950a70b61e74..1fa9dd6c4d03 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_edt.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_edt.c
@@ -64,7 +64,7 @@ static inline int throttle_flow(struct __sk_buff *skb)
 
 static inline int handle_tcp(struct __sk_buff *skb, struct tcphdr *tcp)
 {
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 
 	/* drop malformed packets */
 	if ((void *)(tcp + 1) > data_end)
@@ -78,8 +78,8 @@ static inline int handle_tcp(struct __sk_buff *skb, struct tcphdr *tcp)
 
 static inline int handle_ipv4(struct __sk_buff *skb)
 {
-	void *data_end = (void *)(long)skb->data_end;
-	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
 	struct iphdr *iph;
 	uint32_t ihl;
 
diff --git a/tools/testing/selftests/bpf/progs/test_tc_neigh.c b/tools/testing/selftests/bpf/progs/test_tc_neigh.c
index 3e32ea375ab4..6f0be523fcfb 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_neigh.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_neigh.c
@@ -15,7 +15,7 @@
 #include <bpf/bpf_endian.h>
 
 #ifndef ctx_ptr
-# define ctx_ptr(field)		(void *)(long)(field)
+# define ctx_ptr(field)		(void *)(unsigned long)(field)
 #endif
 
 #define ip4_src			0xac100164 /* 172.16.1.100 */
diff --git a/tools/testing/selftests/bpf/progs/test_tc_neigh_fib.c b/tools/testing/selftests/bpf/progs/test_tc_neigh_fib.c
index ec4cce19362d..62bc341def8e 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_neigh_fib.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_neigh_fib.c
@@ -15,7 +15,7 @@
 #include <bpf/bpf_endian.h>
 
 #ifndef ctx_ptr
-# define ctx_ptr(field)		(void *)(long)(field)
+# define ctx_ptr(field)		(void *)(unsigned long)(field)
 #endif
 
 #define AF_INET 2
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
index 6edebce563b5..075ca11e9216 100644
--- a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
@@ -151,16 +151,16 @@ static __always_inline void check_syncookie(void *ctx, void *data,
 SEC("tc")
 int check_syncookie_clsact(struct __sk_buff *skb)
 {
-	check_syncookie(skb, (void *)(long)skb->data,
-			(void *)(long)skb->data_end);
+	check_syncookie(skb, (void *)(unsigned long)skb->data,
+			(void *)(unsigned long)skb->data_end);
 	return TC_ACT_OK;
 }
 
 SEC("xdp")
 int check_syncookie_xdp(struct xdp_md *ctx)
 {
-	check_syncookie(ctx, (void *)(long)ctx->data,
-			(void *)(long)ctx->data_end);
+	check_syncookie(ctx, (void *)(unsigned long)ctx->data,
+			(void *)(unsigned long)ctx->data_end);
 	return XDP_PASS;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index 17f2f325b3f3..cdf00915668c 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -623,9 +623,9 @@ SEC("tc")
 int ipip_set_tunnel(struct __sk_buff *skb)
 {
 	struct bpf_tunnel_key key = {};
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct iphdr *iph = data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	int ret;
 
 	/* single length check */
@@ -668,9 +668,9 @@ SEC("tc")
 int ipip6_set_tunnel(struct __sk_buff *skb)
 {
 	struct bpf_tunnel_key key = {};
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct iphdr *iph = data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	int ret;
 
 	/* single length check */
@@ -717,9 +717,9 @@ SEC("tc")
 int ip6ip6_set_tunnel(struct __sk_buff *skb)
 {
 	struct bpf_tunnel_key key = {};
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct ipv6hdr *iph = data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	int ret;
 
 	/* single length check */
diff --git a/tools/testing/selftests/bpf/progs/test_verif_scale1.c b/tools/testing/selftests/bpf/progs/test_verif_scale1.c
index d38153dab3dd..dacf09ea9a91 100644
--- a/tools/testing/selftests/bpf/progs/test_verif_scale1.c
+++ b/tools/testing/selftests/bpf/progs/test_verif_scale1.c
@@ -8,8 +8,8 @@
 SEC("scale90_noinline")
 int balancer_ingress(struct __sk_buff *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	void *ptr;
 	int ret = 0, nh_off, i = 0;
 
diff --git a/tools/testing/selftests/bpf/progs/test_verif_scale2.c b/tools/testing/selftests/bpf/progs/test_verif_scale2.c
index f90ffcafd1e8..a537149900be 100644
--- a/tools/testing/selftests/bpf/progs/test_verif_scale2.c
+++ b/tools/testing/selftests/bpf/progs/test_verif_scale2.c
@@ -8,8 +8,8 @@
 SEC("tc")
 int balancer_ingress(struct __sk_buff *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	void *ptr;
 	int ret = 0, nh_off, i = 0;
 
diff --git a/tools/testing/selftests/bpf/progs/test_verif_scale3.c b/tools/testing/selftests/bpf/progs/test_verif_scale3.c
index 9beb5bf80373..ce360b20e0e6 100644
--- a/tools/testing/selftests/bpf/progs/test_verif_scale3.c
+++ b/tools/testing/selftests/bpf/progs/test_verif_scale3.c
@@ -8,8 +8,8 @@
 SEC("scale90_noinline32")
 int balancer_ingress(struct __sk_buff *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	void *ptr;
 	int ret = 0, nh_off, i = 0;
 
diff --git a/tools/testing/selftests/bpf/progs/test_xdp.c b/tools/testing/selftests/bpf/progs/test_xdp.c
index d7a9a74b7245..0681e27aec70 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp.c
@@ -77,8 +77,8 @@ static __always_inline void set_ethhdr(struct ethhdr *new_eth,
 
 static __always_inline int handle_ipv4(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct iptnl_info *tnl;
 	struct ethhdr *new_eth;
 	struct ethhdr *old_eth;
@@ -111,8 +111,8 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
 		return XDP_DROP;
 
-	data = (void *)(long)xdp->data;
-	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(unsigned long)xdp->data;
+	data_end = (void *)(unsigned long)xdp->data_end;
 
 	new_eth = data;
 	iph = data + sizeof(*new_eth);
@@ -150,8 +150,8 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
 
 static __always_inline int handle_ipv6(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct iptnl_info *tnl;
 	struct ethhdr *new_eth;
 	struct ethhdr *old_eth;
@@ -181,8 +181,8 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
 		return XDP_DROP;
 
-	data = (void *)(long)xdp->data;
-	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(unsigned long)xdp->data;
+	data_end = (void *)(unsigned long)xdp->data_end;
 
 	new_eth = data;
 	ip6h = data + sizeof(*new_eth);
@@ -211,8 +211,8 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
 SEC("xdp")
 int _xdp_tx_iptunnel(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct ethhdr *eth = data;
 	__u16 h_proto;
 
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
index 53b64c999450..737eb7c06d7c 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
@@ -5,8 +5,8 @@
 SEC("xdp")
 int _xdp_adjust_tail_grow(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	int data_len = bpf_xdp_get_buff_len(xdp);
 	int offset = 0;
 
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
index ca68c038357c..bcfe23707783 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
@@ -12,8 +12,8 @@
 SEC("xdp")
 int _xdp_adjust_tail_shrink(struct xdp_md *xdp)
 {
-	__u8 *data_end = (void *)(long)xdp->data_end;
-	__u8 *data = (void *)(long)xdp->data;
+	__u8 *data_end = (void *)(unsigned long)xdp->data_end;
+	__u8 *data = (void *)(unsigned long)xdp->data;
 	int offset = 0;
 
 	switch (bpf_xdp_get_buff_len(xdp)) {
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
index 3379d303f41a..28ac5b9740e6 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
@@ -45,8 +45,8 @@ SEC("fentry/FUNC")
 int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
 {
 	struct meta meta;
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 
 	meta.ifindex = xdp->rxq->dev->ifindex;
 	meta.pkt_len = bpf_xdp_get_buff_len((struct xdp_md *)xdp);
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_context_test_run.c b/tools/testing/selftests/bpf/progs/test_xdp_context_test_run.c
index d7b88cd05afd..928cb1a5c27b 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_context_test_run.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_context_test_run.c
@@ -5,8 +5,8 @@
 SEC("xdp")
 int xdp_context(struct xdp_md *xdp)
 {
-	void *data = (void *)(long)xdp->data;
-	__u32 *metadata = (void *)(long)xdp->data_meta;
+	void *data = (void *)(unsigned long)xdp->data;
+	__u32 *metadata = (void *)(unsigned long)xdp->data_meta;
 	__u32 ret;
 
 	if (metadata + 1 > data)
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
index 807bf895f42c..449a98c48510 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
@@ -9,8 +9,8 @@ SEC("xdp")
 int xdpdm_devlog(struct xdp_md *ctx)
 {
 	char fmt[] = "devmap redirect: dev %u -> dev %u len %u\n";
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	unsigned int len = data_end - data;
 
 	bpf_trace_printk(fmt, sizeof(fmt),
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
index 77a123071940..859fe17f46cb 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
@@ -15,9 +15,9 @@ volatile int retcode = XDP_REDIRECT;
 SEC("xdp")
 int xdp_redirect(struct xdp_md *xdp)
 {
-	__u32 *metadata = (void *)(long)xdp->data_meta;
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	__u32 *metadata = (void *)(unsigned long)xdp->data_meta;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 
 	__u8 *payload = data + HDR_SZ;
 	int ret = retcode;
@@ -72,8 +72,8 @@ static bool check_pkt(void *data, void *data_end)
 SEC("xdp")
 int xdp_count_pkts(struct xdp_md *xdp)
 {
-	void *data = (void *)(long)xdp->data;
-	void *data_end = (void *)(long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
 
 	if (check_pkt(data, data_end))
 		pkts_seen_xdp++;
@@ -88,8 +88,8 @@ int xdp_count_pkts(struct xdp_md *xdp)
 SEC("tc")
 int tc_count_pkts(struct __sk_buff *skb)
 {
-	void *data = (void *)(long)skb->data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 
 	if (check_pkt(data, data_end))
 		pkts_seen_tc++;
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_loop.c b/tools/testing/selftests/bpf/progs/test_xdp_loop.c
index c98fb44156f0..0a441452d656 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_loop.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_loop.c
@@ -73,8 +73,8 @@ static __always_inline void set_ethhdr(struct ethhdr *new_eth,
 
 static __always_inline int handle_ipv4(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct iptnl_info *tnl;
 	struct ethhdr *new_eth;
 	struct ethhdr *old_eth;
@@ -107,8 +107,8 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
 		return XDP_DROP;
 
-	data = (void *)(long)xdp->data;
-	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(unsigned long)xdp->data;
+	data_end = (void *)(unsigned long)xdp->data_end;
 
 	new_eth = data;
 	iph = data + sizeof(*new_eth);
@@ -146,8 +146,8 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
 
 static __always_inline int handle_ipv6(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct iptnl_info *tnl;
 	struct ethhdr *new_eth;
 	struct ethhdr *old_eth;
@@ -177,8 +177,8 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
 		return XDP_DROP;
 
-	data = (void *)(long)xdp->data;
-	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(unsigned long)xdp->data;
+	data_end = (void *)(unsigned long)xdp->data_end;
 
 	new_eth = data;
 	ip6h = data + sizeof(*new_eth);
@@ -207,8 +207,8 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
 SEC("xdp")
 int _xdp_tx_iptunnel(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct ethhdr *eth = data;
 	__u16 h_proto;
 
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index ba48fcb98ab2..a5976a470aa8 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -288,8 +288,8 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
 
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
 		return false;
-	data = (void *)(long)xdp->data;
-	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(unsigned long)xdp->data;
+	data_end = (void *)(unsigned long)xdp->data_end;
 	new_eth = data;
 	ip6h = data + sizeof(struct eth_hdr);
 	old_eth = data + sizeof(struct ipv6hdr);
@@ -336,8 +336,8 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
 	ip_suffix ^= pckt->flow.src;
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
 		return false;
-	data = (void *)(long)xdp->data;
-	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(unsigned long)xdp->data;
+	data_end = (void *)(unsigned long)xdp->data_end;
 	new_eth = data;
 	iph = data + sizeof(struct eth_hdr);
 	old_eth = data + sizeof(struct iphdr);
@@ -387,8 +387,8 @@ bool decap_v6(struct xdp_md *xdp, void **data, void **data_end, bool inner_v4)
 		new_eth->eth_proto = 56710;
 	if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct ipv6hdr)))
 		return false;
-	*data = (void *)(long)xdp->data;
-	*data_end = (void *)(long)xdp->data_end;
+	*data = (void *)(unsigned long)xdp->data;
+	*data_end = (void *)(unsigned long)xdp->data_end;
 	return true;
 }
 
@@ -405,8 +405,8 @@ bool decap_v4(struct xdp_md *xdp, void **data, void **data_end)
 	new_eth->eth_proto = 8;
 	if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
 		return false;
-	*data = (void *)(long)xdp->data;
-	*data_end = (void *)(long)xdp->data_end;
+	*data = (void *)(unsigned long)xdp->data;
+	*data_end = (void *)(unsigned long)xdp->data_end;
 	return true;
 }
 
@@ -789,8 +789,8 @@ static int process_packet(void *data, __u64 off, void *data_end,
 	data_stats->v1 += 1;
 	data_stats->v2 += pkt_bytes;
 
-	data = (void *)(long)xdp->data;
-	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(unsigned long)xdp->data;
+	data_end = (void *)(unsigned long)xdp->data_end;
 	if (data + 4 > data_end)
 		return XDP_DROP;
 	*(u32 *)data = dst->dst;
@@ -800,8 +800,8 @@ static int process_packet(void *data, __u64 off, void *data_end,
 SEC("xdp")
 int balancer_ingress_v4(struct xdp_md *ctx)
 {
-	void *data = (void *)(long)ctx->data;
-	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
 	struct eth_hdr *eth = data;
 	__u32 eth_proto;
 	__u32 nh_off;
@@ -819,8 +819,8 @@ int balancer_ingress_v4(struct xdp_md *ctx)
 SEC("xdp")
 int balancer_ingress_v6(struct xdp_md *ctx)
 {
-	void *data = (void *)(long)ctx->data;
-	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
 	struct eth_hdr *eth = data;
 	__u32 eth_proto;
 	__u32 nh_off;
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
index 2a3496d8e327..68621125bf86 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
@@ -13,8 +13,8 @@ int _version SEC("version") = 1;
 SEC("xdp.frags")
 int xdp_adjust_frags(struct xdp_md *xdp)
 {
-	__u8 *data_end = (void *)(long)xdp->data_end;
-	__u8 *data = (void *)(long)xdp->data;
+	__u8 *data_end = (void *)(unsigned long)xdp->data_end;
+	__u8 *data = (void *)(unsigned long)xdp->data;
 	__u8 val[16] = {};
 	__u32 offset;
 	int err;
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_vlan.c b/tools/testing/selftests/bpf/progs/test_xdp_vlan.c
index 134768f6b788..7dde447de0c4 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_vlan.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_vlan.c
@@ -105,8 +105,8 @@ bool parse_eth_frame(struct ethhdr *eth, void *data_end, struct parse_pkt *pkt)
 SEC("xdp_drop_vlan_4011")
 int  xdp_prognum0(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct parse_pkt pkt = { 0 };
 
 	if (!parse_eth_frame(data, data_end, &pkt))
@@ -147,8 +147,8 @@ Load prog with ip tool:
 SEC("xdp_vlan_change")
 int  xdp_prognum1(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct parse_pkt pkt = { 0 };
 
 	if (!parse_eth_frame(data, data_end, &pkt))
@@ -181,8 +181,8 @@ int  xdp_prognum1(struct xdp_md *ctx)
 SEC("xdp_vlan_remove_outer")
 int  xdp_prognum2(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct parse_pkt pkt = { 0 };
 	char *dest;
 
@@ -240,8 +240,8 @@ void shift_mac_4bytes_32bit(void *data)
 SEC("xdp_vlan_remove_outer2")
 int  xdp_prognum3(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct ethhdr *orig_eth = data;
 	struct parse_pkt pkt = { 0 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
index 4139a14f9996..536fcad4c0c9 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
@@ -31,8 +31,8 @@ SEC("xdp/devmap")
 int xdp_dummy_dm(struct xdp_md *ctx)
 {
 	char fmt[] = "devmap redirect: dev %u -> dev %u len %u\n";
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	unsigned int len = data_end - data;
 
 	bpf_trace_printk(fmt, sizeof(fmt),
diff --git a/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
index 97b26a30b59a..91847e37e182 100644
--- a/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
+++ b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
@@ -37,8 +37,8 @@ struct {
 SEC("xdp")
 int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	int if_index = ctx->ingress_ifindex;
 	struct ethhdr *eth = data;
 	__u16 h_proto;
@@ -73,8 +73,8 @@ int xdp_redirect_map_all_prog(struct xdp_md *ctx)
 SEC("xdp/devmap")
 int xdp_devmap_prog(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	__u32 key = ctx->egress_ifindex;
 	struct ethhdr *eth = data;
 	__u64 nh_off;
diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
index 736686e903f6..ae1563ba4af0 100644
--- a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
+++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
@@ -799,8 +799,8 @@ static __always_inline int syncookie_part2(void *ctx, void *data, void *data_end
 SEC("xdp")
 int syncookie_xdp(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct header_pointers hdr;
 	int ret;
 
@@ -808,8 +808,8 @@ int syncookie_xdp(struct xdp_md *ctx)
 	if (ret != XDP_TX)
 		return ret;
 
-	data_end = (void *)(long)ctx->data_end;
-	data = (void *)(long)ctx->data;
+	data_end = (void *)(unsigned long)ctx->data_end;
+	data = (void *)(unsigned long)ctx->data;
 
 	return syncookie_part2(ctx, data, data_end, &hdr, true);
 }
@@ -817,8 +817,8 @@ int syncookie_xdp(struct xdp_md *ctx)
 SEC("tc")
 int syncookie_tc(struct __sk_buff *skb)
 {
-	void *data_end = (void *)(long)skb->data_end;
-	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
 	struct header_pointers hdr;
 	int ret;
 
@@ -826,8 +826,8 @@ int syncookie_tc(struct __sk_buff *skb)
 	if (ret != XDP_TX)
 		return ret == XDP_PASS ? TC_ACT_OK : TC_ACT_SHOT;
 
-	data_end = (void *)(long)skb->data_end;
-	data = (void *)(long)skb->data;
+	data_end = (void *)(unsigned long)skb->data_end;
+	data = (void *)(unsigned long)skb->data;
 
 	ret = syncookie_part2(skb, data, data_end, &hdr, false);
 	switch (ret) {
diff --git a/tools/testing/selftests/bpf/progs/xdping_kern.c b/tools/testing/selftests/bpf/progs/xdping_kern.c
index 4ad73847b8a5..6792d98ca6ac 100644
--- a/tools/testing/selftests/bpf/progs/xdping_kern.c
+++ b/tools/testing/selftests/bpf/progs/xdping_kern.c
@@ -58,8 +58,8 @@ static __always_inline __u16 ipv4_csum(void *data_start, int data_size)
 
 static __always_inline int icmp_check(struct xdp_md *ctx, int type)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct ethhdr *eth = data;
 	struct icmphdr *icmph;
 	struct iphdr *iph;
@@ -89,8 +89,8 @@ static __always_inline int icmp_check(struct xdp_md *ctx, int type)
 SEC("xdp")
 int xdping_client(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct pinginfo *pinginfo = NULL;
 	struct ethhdr *eth = data;
 	struct icmphdr *icmph;
@@ -153,8 +153,8 @@ int xdping_client(struct xdp_md *ctx)
 SEC("xdp")
 int xdping_server(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct ethhdr *eth = data;
 	struct icmphdr *icmph;
 	struct iphdr *iph;
diff --git a/tools/testing/selftests/bpf/progs/xdpwall.c b/tools/testing/selftests/bpf/progs/xdpwall.c
index 7a891a0c3a39..ab1fd62f89c1 100644
--- a/tools/testing/selftests/bpf/progs/xdpwall.c
+++ b/tools/testing/selftests/bpf/progs/xdpwall.c
@@ -317,8 +317,8 @@ static __always_inline __u8 parse_ipv6_gue(struct pkt_info *info,
 SEC("xdp")
 int edgewall(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)(ctx->data_end);
-	void *data = (void *)(long)(ctx->data);
+	void *data_end = (void *)(unsigned long)(ctx->data_end);
+	void *data = (void *)(unsigned long)(ctx->data);
 	struct fw_match_info match_info = {};
 	struct pkt_info info = {};
 	__u8 parse_err = NO_ERR;
-- 
2.25.1

