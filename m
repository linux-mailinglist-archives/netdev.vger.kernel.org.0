Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01669211FD7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgGBJY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbgGBJYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:39 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCCFC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id w6so28471345ejq.6
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3bSpGEFWynhqkY85qsplbaX/55c/sszNhOOsxHciCGM=;
        b=DPO0/u7TYVlbmPPky9lgED13ACU7duG0w5flTmcIOAdcyJJlzwpLwnCd+r8aZwgHZt
         h4iCb9vIdgcKXv8L4BdaGzX+6Gh3yEkXRZnUJUmYEZqSfzcvgS1/SN+MBeSzz9C8U31A
         VjCdq3Ha+3UI08gT7yYJUc6wwlTJskXozfMOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3bSpGEFWynhqkY85qsplbaX/55c/sszNhOOsxHciCGM=;
        b=KuZUkXpaIjdO89Voo90g/m1QOJMoUCupaM0rXs/0qaOUvFqb7j6iti2F7+kvdWKyId
         kouUK7+L+9XOIexVD1GEdUqcgRTZWGbR1UZ5CcVzp5tR6shr8iFKiSQE8a+NGfHn56Yd
         OmJMKIlzQutxh/HAzVmp/5C0ZVqnngHuemogw/bALPhKs4WdBKBJunhrOm8Mnbgsj2cb
         CvuiovpFKWkrDlOJVGznzXvA3PSl0oRTOcKP+q2DRNuwUGAFHweO2N/yjzoULFKrBBiY
         ePgO0/e0E2FBhN4drbfs+Jm/jGgjZJfu5j44cI/ZcwM279kaKa6SdpHIfQmklTfPjIji
         /Y1Q==
X-Gm-Message-State: AOAM531I+ib7tlQ+BIFs8ahHiy4kpA7QKCrZ1zDgekUl6YVdlQFSWn+U
        a6aPd88upAVITbZmgCqQQ0px+A==
X-Google-Smtp-Source: ABdhPJzOavD9RSmOFAEgkRzi04T+vmCI8wxfCTZN+crvROSMy/fCD72yOsU7hByBWWt8FBHHfDvKGw==
X-Received: by 2002:a17:906:1386:: with SMTP id f6mr26934725ejc.66.1593681877631;
        Thu, 02 Jul 2020 02:24:37 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q21sm6359603ejc.112.2020.07.02.02.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:37 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v3 11/16] bpf: Sync linux/bpf.h to tools/
Date:   Thu,  2 Jul 2020 11:24:11 +0200
Message-Id: <20200702092416.11961-12-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newly added program, context type and helper is used by tests in a
subsequent patch. Synchronize the header file.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v3:
    - Update after changes to bpf.h in earlier patch.
    
    v2:
    - Update after changes to bpf.h in earlier patch.

 tools/include/uapi/linux/bpf.h | 74 ++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0cb8ec948816..8dd6e6ce5de9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -189,6 +189,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_STRUCT_OPS,
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
+	BPF_PROG_TYPE_SK_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -226,6 +227,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
+	BPF_SK_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3067,6 +3069,10 @@ union bpf_attr {
  *
  * long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
  *	Description
+ *		Helper is overloaded depending on BPF program type. This
+ *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
+ *		**BPF_PROG_TYPE_SCHED_ACT** programs.
+ *
  *		Assign the *sk* to the *skb*. When combined with appropriate
  *		routing configuration to receive the packet towards the socket,
  *		will cause *skb* to be delivered to the specified socket.
@@ -3092,6 +3098,53 @@ union bpf_attr {
  *		**-ESOCKTNOSUPPORT** if the socket type is not supported
  *		(reuseport).
  *
+ * int bpf_sk_assign(struct bpf_sk_lookup *ctx, struct bpf_sock *sk, u64 flags)
+ *	Description
+ *		Helper is overloaded depending on BPF program type. This
+ *		description applies to **BPF_PROG_TYPE_SK_LOOKUP** programs.
+ *
+ *		Select the *sk* as a result of a socket lookup.
+ *
+ *		For the operation to succeed passed socket must be compatible
+ *		with the packet description provided by the *ctx* object.
+ *
+ *		L4 protocol (**IPPROTO_TCP** or **IPPROTO_UDP**) must
+ *		be an exact match. While IP family (**AF_INET** or
+ *		**AF_INET6**) must be compatible, that is IPv6 sockets
+ *		that are not v6-only can be selected for IPv4 packets.
+ *
+ *		Only TCP listeners and UDP unconnected sockets can be
+ *		selected.
+ *
+ *		*flags* argument can combination of following values:
+ *
+ *		* **BPF_SK_LOOKUP_F_REPLACE** to override the previous
+ *		  socket selection, potentially done by a BPF program
+ *		  that ran before us.
+ *
+ *		* **BPF_SK_LOOKUP_F_NO_REUSEPORT** to skip
+ *		  load-balancing within reuseport group for the socket
+ *		  being selected.
+ *
+ *	Return
+ *		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EAFNOSUPPORT** if socket family (*sk->family*) is
+ *		  not compatible with packet family (*ctx->family*).
+ *
+ *		* **-EEXIST** if socket has been already selected,
+ *		  potentially by another program, and
+ *		  **BPF_SK_LOOKUP_F_REPLACE** flag was not specified.
+ *
+ *		* **-EINVAL** if unsupported flags were specified.
+ *
+ *		* **-EPROTOTYPE** if socket L4 protocol
+ *		  (*sk->protocol*) doesn't match packet protocol
+ *		  (*ctx->protocol*).
+ *
+ *		* **-ESOCKTNOSUPPORT** if socket is not in allowed
+ *		  state (TCP listening or UDP unconnected).
+ *
  * u64 bpf_ktime_get_boot_ns(void)
  * 	Description
  * 		Return the time elapsed since system boot, in nanoseconds.
@@ -3569,6 +3622,12 @@ enum {
 	BPF_RINGBUF_HDR_SZ		= 8,
 };
 
+/* BPF_FUNC_sk_assign flags in bpf_sk_lookup context. */
+enum {
+	BPF_SK_LOOKUP_F_REPLACE		= (1ULL << 0),
+	BPF_SK_LOOKUP_F_NO_REUSEPORT	= (1ULL << 1),
+};
+
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
 	BPF_ADJ_ROOM_NET,
@@ -4298,4 +4357,19 @@ struct bpf_pidns_info {
 	__u32 pid;
 	__u32 tgid;
 };
+
+/* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
+struct bpf_sk_lookup {
+	__u32 family;		/* Protocol family (AF_INET, AF_INET6) */
+	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
+	__u32 remote_ip4;	/* Network byte order */
+	__u32 remote_ip6[4];	/* Network byte order */
+	__u32 remote_port;	/* Network byte order */
+	__u32 local_ip4;	/* Network byte order */
+	__u32 local_ip6[4];	/* Network byte order */
+	__u32 local_port;	/* Host byte order */
+
+	__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.25.4

