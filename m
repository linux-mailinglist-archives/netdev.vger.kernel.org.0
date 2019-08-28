Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF15A9FB88
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfH1HXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:23:15 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43158 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfH1HXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:23:13 -0400
Received: by mail-lf1-f65.google.com with SMTP id q27so1218563lfo.10
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xgrCk7yvwW4trCdUCW/zs7DHG7RiYoZiMv11DkUjyPY=;
        b=CY34KRJQleGuq9nuA1YAqUn8YS3HTbEn1q0twwhIGS9StLWMQAlJxzcVct2vWV3XI6
         GoFCz4YLy9TD8HxLRQ9ponUSE746YtDLvfsQ4QzpSoa91rGgTtT3qGGX8RQdb2IQdDZi
         7d3vtPqxCBEWoEg8hK8r4N2ooxEYs62JesMy8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xgrCk7yvwW4trCdUCW/zs7DHG7RiYoZiMv11DkUjyPY=;
        b=VckVf7qLEfxR1PBithw5su5p2tcKA9hcU80MTGXXdrZtHola+Q3ZBFP8H2cTDWpx4g
         RG6HYpVjw5q6m4IUTGsTG5912o7w1WE0/OgbglX63gH3qjahgxroGK8rXOelDPc9rN/f
         HAJM6ipuk0QDrEt8msdfiAL0ELI9XdxzgZp5s/AM0b2yehN+XqGPv9LiyyjzoDCo8vkL
         f1vfB4KApL9lvsjFhXccQuyZCqUaKXbNnQZNfrR5U06ATcYDAnWe8VoLyPlploasAGus
         FRfJHQMX4CwhJFxqq9PzDPsAY7/OUvJ9ixLWUi1KTmGmje2a+KwWp1+kS0o3revdRlOO
         Ts4w==
X-Gm-Message-State: APjAAAVflK9ZXcW5vGoY0crvT1mlBJRgqFlawhl3adTTNBvNvnpNngxt
        eKhwlgaYHEJcHwFC8p9UqSZqsQ==
X-Google-Smtp-Source: APXvYqyBX2F/tdBVnKxaVnZMkDjWIB0d0VTIsmFxa//brkhx8eda4TM8CK9LaEGkmf2RxMZ+K1RyJQ==
X-Received: by 2002:ac2:5637:: with SMTP id b23mr1729315lff.186.1566976991158;
        Wed, 28 Aug 2019 00:23:11 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j3sm593169lfp.34.2019.08.28.00.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:23:10 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFCv2 bpf-next 10/12] bpf: Sync linux/bpf.h to tools/
Date:   Wed, 28 Aug 2019 09:22:48 +0200
Message-Id: <20190828072250.29828-11-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828072250.29828-1-jakub@cloudflare.com>
References: <20190828072250.29828-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newly added program, context type and helper is used by tests in a
subsequent patch. Synchronize the header file.

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/include/uapi/linux/bpf.h | 58 +++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b5889257cc33..58ee3d24a430 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -173,6 +173,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	BPF_PROG_TYPE_INET_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -199,6 +200,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_RECVMSG,
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
+	BPF_INET_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -2747,6 +2749,33 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_redirect_lookup(struct bpf_inet_lookup_kern *ctx, struct bpf_map *sockarray, void *key, u64 flags)
+ *	Description
+ *		Select a socket referenced by *map* (of type
+ *		**BPF_MAP_TYPE_REUSEPORT_SOCKARRAY**) at index *key* to use as a
+ *		result of listening (TCP) or bound (UDP) socket lookup.
+ *
+ *		The IP family and L4 protocol in *ctx* object, populated from
+ *		the packet that triggered the lookup, must match the selected
+ *		socket's family and protocol. IP6_V6ONLY socket option is
+ *		honored.
+ *
+ *		To be used by **BPF_INET_LOOKUP** programs attached to the
+ *		network namespace. Program needs to return **BPF_REDIRECT**, the
+ *		helper's success return value, for the selected socket to be
+ *		actually used.
+ *
+ *	Return
+ *		**BPF_REDIRECT** on success, if the socket at index *key* was selected.
+ *
+ *		**-EINVAL** if *flags* are invalid (not zero).
+ *
+ *		**-ENOENT** if there is no socket at index *key*.
+ *
+ *		**-EPROTOTYPE** if *ctx->protocol* does not match the socket protocol.
+ *
+ *		**-EAFNOSUPPORT** if socket does not accept IP version in *ctx->family*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2859,7 +2888,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(redirect_lookup),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3116,6 +3146,32 @@ struct bpf_tcp_sock {
 	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
 };
 
+/* User accessible data for inet_lookup programs.
+ * New fields must be added at the end.
+ */
+struct bpf_inet_lookup {
+	__u32 family;		/* AF_INET, AF_INET6 */
+	__u32 protocol;		/* IPROTO_TCP, IPPROTO_UDP */
+	__u32 remote_ip4;	/* Allows 1,2,4-byte read but no write.
+				 * Stored in network byte order.
+				 */
+	__u32 local_ip4;	/* Allows 1,2,4-byte read and 4-byte write.
+				 * Stored in network byte order.
+				 */
+	__u32 remote_ip6[4];	/* Allows 1,2,4-byte read but no write.
+				 * Stored in network byte order.
+				 */
+	__u32 local_ip6[4];	/* Allows 1,2,4-byte read and 4-byte write.
+				 * Stored in network byte order.
+				 */
+	__u32 remote_port;	/* Allows 4-byte read but no write.
+				 * Stored in network byte order.
+				 */
+	__u32 local_port;	/* Allows 4-byte read and write.
+				 * Stored in host byte order.
+				 */
+};
+
 struct bpf_sock_tuple {
 	union {
 		struct {
-- 
2.20.1

