Return-Path: <netdev+bounces-6496-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED044716AB0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D2001C20C77
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8165F200B6;
	Tue, 30 May 2023 17:20:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFC814AAA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:20:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB59118
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685467208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RQxGUJXSqe6U0HVsXVsXEzRJSKpr5VU13S78c6VU45Q=;
	b=C08nV0aUErXoS8qTDw2ONpVp/zZw/ncekfhdE8W0cc54kBX8DVF0Ag6BrKyag+b5dd7q7F
	GM2tcatowjNDmsIOJbwqCOjO5LuIYiRQDO+oNDs9skW8ASppWXbruwBB7F9oHUzA/pF1/e
	uBNXxFh47BilCmX033+CIaxGovwhW5A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-77jfWZUsO0ay-hyIVXr8sA-1; Tue, 30 May 2023 13:20:06 -0400
X-MC-Unique: 77jfWZUsO0ay-hyIVXr8sA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A3B4802355;
	Tue, 30 May 2023 17:20:06 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.95])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7396F20296C8;
	Tue, 30 May 2023 17:20:03 +0000 (UTC)
From: Andrea Claudi <aclaudi@redhat.com>
To: netdev@vger.kernel.org
Cc: stephen@networkplumber.org,
	dsahern@gmail.com,
	leon@kernel.org
Subject: [PATCH iproute2-next] treewide: fix indentation
Date: Tue, 30 May 2023 19:19:53 +0200
Message-Id: <aa496abb20ac66d45db0dcf6456a0ea23508de09.1685466971.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace multiple whitespaces with tab where appropriate.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 bridge/vni.c   |  2 +-
 genl/ctrl.c    |  2 +-
 ip/ipaddress.c |  2 +-
 ip/ipmacsec.c  |  4 ++--
 ip/ipprefix.c  |  2 +-
 ip/ipvrf.c     |  2 +-
 lib/fs.c       |  2 +-
 lib/ll_types.c | 10 +++++-----
 rdma/dev.c     | 10 +++++-----
 tc/m_ipt.c     |  4 ++--
 tc/m_xt_old.c  |  4 ++--
 tc/q_fq.c      |  8 ++++----
 tc/q_htb.c     |  4 ++--
 tc/tc_core.c   |  2 +-
 14 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/bridge/vni.c b/bridge/vni.c
index 940f251c..96e6566f 100644
--- a/bridge/vni.c
+++ b/bridge/vni.c
@@ -33,7 +33,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: bridge vni { add | del } vni VNI\n"
 		"		[ { group | remote } IP_ADDRESS ]\n"
-	        "		[ dev DEV ]\n"
+		"		[ dev DEV ]\n"
 		"       bridge vni { show }\n"
 		"\n"
 		"Where:	VNI	:= 0-16777215\n"
diff --git a/genl/ctrl.c b/genl/ctrl.c
index 8d2e9448..d5b765cc 100644
--- a/genl/ctrl.c
+++ b/genl/ctrl.c
@@ -315,7 +315,7 @@ static int ctrl_list(int cmd, int argc, char **argv)
 
 		rtnl_dump_filter(&rth, print_ctrl2, stdout);
 
-        }
+	}
 
 	ret = 0;
 ctrl_done:
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 41055c43..cb2ac7e9 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1443,7 +1443,7 @@ static const struct ifa_flag_data_t* lookup_flag_data_by_name(const char* flag_n
 		if (strcmp(flag_name, ifa_flag_data[i].name) == 0)
 			return &ifa_flag_data[i];
 	}
-        return NULL;
+	return NULL;
 }
 
 static void print_ifa_flags(FILE *fp, const struct ifaddrmsg *ifa,
diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 8b0d5666..476a6d1d 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -1379,10 +1379,10 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (strcmp(*argv, "default") == 0)
 				cipher.id = MACSEC_DEFAULT_CIPHER_ID;
 			else if (strcmp(*argv, "gcm-aes-128") == 0 ||
-			         strcmp(*argv, "GCM-AES-128") == 0)
+				 strcmp(*argv, "GCM-AES-128") == 0)
 				cipher.id = MACSEC_CIPHER_ID_GCM_AES_128;
 			else if (strcmp(*argv, "gcm-aes-256") == 0 ||
-			         strcmp(*argv, "GCM-AES-256") == 0)
+				 strcmp(*argv, "GCM-AES-256") == 0)
 				cipher.id = MACSEC_CIPHER_ID_GCM_AES_256;
 			else if (strcmp(*argv, "gcm-aes-xpn-128") == 0 ||
 				 strcmp(*argv, "GCM-AES-XPN-128") == 0)
diff --git a/ip/ipprefix.c b/ip/ipprefix.c
index ddf77014..c5704e5a 100644
--- a/ip/ipprefix.c
+++ b/ip/ipprefix.c
@@ -60,7 +60,7 @@ int print_prefix(struct nlmsghdr *n, void *arg)
 
 	if (tb[PREFIX_ADDRESS]) {
 		fprintf(fp, "prefix %s/%u",
-		        rt_addr_n2a_rta(family, tb[PREFIX_ADDRESS]),
+			rt_addr_n2a_rta(family, tb[PREFIX_ADDRESS]),
 			prefix->prefix_len);
 	}
 	fprintf(fp, "dev %s ", ll_index_to_name(prefix->prefix_ifindex));
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index 0718bea8..d6b59adb 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -252,7 +252,7 @@ static int prog_load(int idx)
 	};
 
 	return bpf_program_load(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
-			        "GPL", bpf_log_buf, sizeof(bpf_log_buf));
+				"GPL", bpf_log_buf, sizeof(bpf_log_buf));
 }
 
 static int vrf_configure_cgroup(const char *path, int ifindex)
diff --git a/lib/fs.c b/lib/fs.c
index 22d4af75..63fc733e 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -41,7 +41,7 @@ static int name_to_handle_at(int dirfd, const char *pathname,
 	struct file_handle *handle, int *mount_id, int flags)
 {
 	return syscall(__NR_name_to_handle_at, dirfd, pathname, handle,
-	               mount_id, flags);
+		       mount_id, flags);
 }
 
 static int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
diff --git a/lib/ll_types.c b/lib/ll_types.c
index fa57ceb5..81d6cd9d 100644
--- a/lib/ll_types.c
+++ b/lib/ll_types.c
@@ -108,11 +108,11 @@ __PF(VOID,void)
 };
 #undef __PF
 
-        int i;
-        for (i=0; !numeric && i<sizeof(arphrd_names)/sizeof(arphrd_names[0]); i++) {
-                 if (arphrd_names[i].type == type)
+	int i;
+	for (i=0; !numeric && i<sizeof(arphrd_names)/sizeof(arphrd_names[0]); i++) {
+		if (arphrd_names[i].type == type)
 			return arphrd_names[i].name;
 	}
-        snprintf(buf, len, "[%d]", type);
-        return buf;
+	snprintf(buf, len, "[%d]", type);
+	return buf;
 }
diff --git a/rdma/dev.c b/rdma/dev.c
index f09c33bc..585bec54 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -191,13 +191,13 @@ static void dev_print_node_type(struct rd *rd, struct nlattr **tb)
 
 static void dev_print_dev_proto(struct rd *rd, struct nlattr **tb)
 {
-       const char *str;
+	const char *str;
 
-       if (!tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL])
-               return;
+	if (!tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL])
+		return;
 
-       str = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL]);
-       print_color_string(PRINT_ANY, COLOR_NONE, "protocol", "protocol %s ", str);
+	str = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL]);
+	print_color_string(PRINT_ANY, COLOR_NONE, "protocol", "protocol %s ", str);
 }
 
 static int dev_parse_cb(const struct nlmsghdr *nlh, void *data)
diff --git a/tc/m_ipt.c b/tc/m_ipt.c
index 465d1b80..3a4ccfac 100644
--- a/tc/m_ipt.c
+++ b/tc/m_ipt.c
@@ -409,8 +409,8 @@ static int parse_ipt(struct action_util *a, int *argc_p,
 	optind = 0;
 	free_opts(opts);
 	/* Clear flags if target will be used again */
-        m->tflags = 0;
-        m->used = 0;
+	m->tflags = 0;
+	m->used = 0;
 	/* Free allocated memory */
 	if (m->t)
 	    free(m->t);
diff --git a/tc/m_xt_old.c b/tc/m_xt_old.c
index efa084c5..c747154e 100644
--- a/tc/m_xt_old.c
+++ b/tc/m_xt_old.c
@@ -334,8 +334,8 @@ static int parse_ipt(struct action_util *a, int *argc_p,
 	optind = 0;
 	free_opts(opts);
 	/* Clear flags if target will be used again */
-        m->tflags = 0;
-        m->used = 0;
+	m->tflags = 0;
+	m->used = 0;
 	/* Free allocated memory */
 	if (m->t)
 	    free(m->t);
diff --git a/tc/q_fq.c b/tc/q_fq.c
index 0589800a..3277ebc7 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -23,7 +23,7 @@ static void explain(void)
 	fprintf(stderr,
 		"Usage: ... fq	[ limit PACKETS ] [ flow_limit PACKETS ]\n"
 		"		[ quantum BYTES ] [ initial_quantum BYTES ]\n"
-		"		[ maxrate RATE  ] [ buckets NUMBER ]\n"
+		"		[ maxrate RATE ] [ buckets NUMBER ]\n"
 		"		[ [no]pacing ] [ refill_delay TIME ]\n"
 		"		[ low_rate_threshold RATE ]\n"
 		"		[ orphan_mask MASK]\n"
@@ -243,13 +243,13 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	if (set_ce_threshold)
 		addattr_l(n, 1024, TCA_FQ_CE_THRESHOLD,
 			  &ce_threshold, sizeof(ce_threshold));
-    if (set_timer_slack)
+	if (set_timer_slack)
 		addattr_l(n, 1024, TCA_FQ_TIMER_SLACK,
 			  &timer_slack, sizeof(timer_slack));
-    if (set_horizon)
+	if (set_horizon)
 		addattr_l(n, 1024, TCA_FQ_HORIZON,
 			  &horizon, sizeof(horizon));
-    if (horizon_drop != 255)
+	if (horizon_drop != 255)
 		addattr_l(n, 1024, TCA_FQ_HORIZON_DROP,
 			  &horizon_drop, sizeof(horizon_drop));
 	addattr_nest_end(n, tail);
diff --git a/tc/q_htb.c b/tc/q_htb.c
index 31862ffb..63b9521b 100644
--- a/tc/q_htb.c
+++ b/tc/q_htb.c
@@ -49,8 +49,8 @@ static void explain(void)
 
 static void explain1(char *arg)
 {
-    fprintf(stderr, "Illegal \"%s\"\n", arg);
-    explain();
+	fprintf(stderr, "Illegal \"%s\"\n", arg);
+	explain();
 }
 
 static int htb_parse_opt(struct qdisc_util *qu, int argc,
diff --git a/tc/tc_core.c b/tc/tc_core.c
index 8276f6a1..871ceb45 100644
--- a/tc/tc_core.c
+++ b/tc/tc_core.c
@@ -170,7 +170,7 @@ int tc_calc_rtable_64(struct tc_ratespec *r, __u32 *rtab,
 		rtab[i] = tc_calc_xmittime(bps, sz);
 	}
 
-	r->cell_align =  -1;
+	r->cell_align = -1;
 	r->cell_log = cell_log;
 	r->linklayer = (linklayer & TC_LINKLAYER_MASK);
 	return cell_log;
-- 
2.40.1


