Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6161C7101
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgEFMzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728760AbgEFMzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:37 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B721C061A41
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:37 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y3so2100989wrt.1
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YelX9xe5NPz/K8++I+zq6dls9u4E670M00sFKh/zNQA=;
        b=oGYr+6TtS+u83oUfmFGux8JeqLf5MF/hTMXNwAQxCJh5b+m9Lh/rEtqqxApbsWwoOQ
         fAHvMZQGtx3uDeuFOlv2KlOO2Yfepf71r5I5nryZj677yPXJa5+vxUxiZ/6pl3NIBHhs
         EZigWlFkL8PwFwgbnEHno7kUcPjBYME/wBGgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YelX9xe5NPz/K8++I+zq6dls9u4E670M00sFKh/zNQA=;
        b=YO34Q5N3j1hN/Eg4AwfCaJuNGkBc/w+VbniSBUseY+3MSeEMGyhgChp0JDUmTIGYk0
         T/c63bR6YFK5PY97scuRXpb7sU3iyK5EOUReqn9G7pymrfZVNIvpbMSgO79nmvFrSDtU
         jTcYV4nmsiTgMOYZBZfqYY2dojaCFyhjVXZsd9AqZL6xtwD2UprUFnqnBq3n63v9Heg4
         /Lg3LO8Tu8lm4qF7AXzEbLcj6Tl3jJ6AGpIfWU9xrgOYrBhbKm6FPt+s06DPXN6Baflc
         6XQiGjA31NEHtHxGsQWkgcIf5oVm21s44Nd5JUW23CFqdYROzZ8OAnSxaHi2x7BtmZIY
         n/Kg==
X-Gm-Message-State: AGi0PubhM20D2vtawVJ6UaObC1SkuX0OQJ2pZ5Rf0p16ym95GieTnT0r
        FVtpY3WNdVlNXKlPskT2cJQjNKRZOGE=
X-Google-Smtp-Source: APiQypLAo8p0umAKOJxB6sZm2MVMxMPDzD3jqIFBkRqQ0HAwMrmZ02D7TOaa64S9IKbcrj7xrZ/Qzw==
X-Received: by 2002:a5d:6a85:: with SMTP id s5mr9299102wru.122.1588769735238;
        Wed, 06 May 2020 05:55:35 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id i74sm2668726wri.49.2020.05.06.05.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:34 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 13/17] bpf: Sync linux/bpf.h to tools/
Date:   Wed,  6 May 2020 14:55:09 +0200
Message-Id: <20200506125514.1020829-14-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
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
 tools/include/uapi/linux/bpf.h | 53 ++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b3643e27e264..e4c61b63d4bc 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -187,6 +187,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_STRUCT_OPS,
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
+	BPF_PROG_TYPE_SK_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -218,6 +219,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_SK_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3041,6 +3043,10 @@ union bpf_attr {
  *
  * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
  *	Description
+ *		Helper is overloaded depending on BPF program type. This
+ *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
+ *		**BPF_PROG_TYPE_SCHED_ACT** programs.
+ *
  *		Assign the *sk* to the *skb*. When combined with appropriate
  *		routing configuration to receive the packet towards the socket,
  *		will cause *skb* to be delivered to the specified socket.
@@ -3061,6 +3067,39 @@ union bpf_attr {
  *					call from outside of TC ingress.
  *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
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
+ *		L4 protocol (*IPPROTO_TCP* or *IPPROTO_UDP*) must be an exact
+ *		match. While IP family (*AF_INET* or *AF_INET6*) must be
+ *		compatible, that is IPv6 sockets that are not v6-only can be
+ *		selected for IPv4 packets.
+ *
+ *		Only full sockets can be selected. However, there is no need to
+ *		call bpf_fullsock() before passing a socket as an argument to
+ *		this helper.
+ *
+ *		The *flags* argument must be zero.
+ *	Return
+ *		0 on success, or a negative errno in case of failure.
+ *
+ *		**-EAFNOSUPPORT** is socket family (*sk->family*) is not
+ *		compatible with packet family (*ctx->family*).
+ *
+ *		**-EINVAL** if unsupported flags were specified.
+ *
+ *		**-EPROTOTYPE** if socket L4 protocol (*sk->protocol*) doesn't
+ *		match packet protocol (*ctx->protocol*).
+ *
+ *		**-ESOCKTNOSUPPORT** if socket is not a full socket.
+ *
  * u64 bpf_ktime_get_boot_ns(void)
  * 	Description
  * 		Return the time elapsed since system boot, in nanoseconds.
@@ -4012,4 +4051,18 @@ struct bpf_pidns_info {
 	__u32 pid;
 	__u32 tgid;
 };
+
+/* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
+struct bpf_sk_lookup {
+	__u32 family;		/* AF_INET, AF_INET6 */
+	__u32 protocol;		/* IPPROTO_TCP, IPPROTO_UDP */
+	/* IP addresses allows 1, 2, and 4 bytes access */
+	__u32 src_ip4;
+	__u32 src_ip6[4];
+	__u32 src_port;		/* network byte order */
+	__u32 dst_ip4;
+	__u32 dst_ip6[4];
+	__u32 dst_port;		/* host byte order */
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.25.3

