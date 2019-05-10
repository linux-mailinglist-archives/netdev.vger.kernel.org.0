Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFD319F92
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 16:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfEJOvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 10:51:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44091 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727472AbfEJOvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 10:51:43 -0400
Received: by mail-wr1-f66.google.com with SMTP id c5so8229923wrs.11
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 07:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IgVPPTDSefK79v634cC+o6PTcAAyiZEw7IAJeylnvQc=;
        b=iN4QmHwx0L0fysi39XCrojHwl1CWxZIj83BOCb4T46QY/5oJGDUUscMxqnwy+YPq/c
         lQ7yYTtXimjnfy4W5IscJRPNRGeP+KQF9Ax4syW+CegiXC+ur3wOsTPQjN14B5cJH9jg
         sT3COjE/JxI4ACg+rY3FBwuqVOGjD5JjNbfK+Us74CN671Eif8fxOq8A39TxOtY6AmNq
         dNIGxMHBcfFgCKNMA1TMOyA/A+bJPJVGvA9flrTK+vVI/lroa9sKf2TkGgIB5aPB6bBw
         kCS8EsPDp1E6r8c2o501qHIWReiidbvo/J79/m4MdXlRLR0WsBE6VU87xFRWiVUEWstQ
         tJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IgVPPTDSefK79v634cC+o6PTcAAyiZEw7IAJeylnvQc=;
        b=uUpXEGkR8gyew4y+I/EEdbq8LjqhtpS/23CpYwsMq/JAUArONByPqnvgeWZvH1btxH
         5GVWCKU03RpAiRbwDi+JbrzbEYd8VFe6L0Ayd4eoLN+4+1Wgoh0+wKPXZx0NZbZqfVBx
         a7/Gh1tFMGj+bb1ox5GNRwWZEpMoWW8We+pXu/Z5EHZU4kopa92MofI+YERsJ29ChiMk
         YtCwzxxP7TKsgIte36rxFzSLtuGy3CBeYnC73f+i+EF32Xbj1B0/NcAoaabiR0FWy8lr
         PBToela8LsAzj3DyDU6doe3+nWBsqhph09VOUYdWYW5DPdAps6L+kBqF2RPu4TIN4+9K
         E4BQ==
X-Gm-Message-State: APjAAAUE00+Uegf/VOZYTABFKAV3wHwhO1tjo2xj/r4+NKrORdBsgk4P
        hejo7EjPcI72gE080ccc21KVxA==
X-Google-Smtp-Source: APXvYqybP7YggEEqUSfoxvHKkdq8K9DbRfPQ8QwxA55hpUavnNJy1TP4r4r3+ns7HctbIsn6n97S4Q==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr7677961wrn.108.1557499900630;
        Fri, 10 May 2019 07:51:40 -0700 (PDT)
Received: from reblochon.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id p17sm7561027wrg.92.2019.05.10.07.51.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 07:51:39 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf 2/4] bpf: fix recurring typo in documentation for BPF helpers
Date:   Fri, 10 May 2019 15:51:23 +0100
Message-Id: <20190510145125.8416-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20190510145125.8416-1-quentin.monnet@netronome.com>
References: <20190510145125.8416-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Underlaying packet buffer" should be an "underlying" one, in the
warning about invalidated data and data_end pointers. Through
copy-and-paste, the typo occurred no fewer than 19 times in the
documentation. Let's fix it.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/uapi/linux/bpf.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 72336bac7573..989ef6b1c269 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -629,7 +629,7 @@ union bpf_attr {
  * 		**BPF_F_INVALIDATE_HASH** (set *skb*\ **->hash**, *skb*\
  * 		**->swhash** and *skb*\ **->l4hash** to 0).
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -654,7 +654,7 @@ union bpf_attr {
  * 		flexibility and can handle sizes larger than 2 or 4 for the
  * 		checksum to update.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -686,7 +686,7 @@ union bpf_attr {
  * 		flexibility and can handle sizes larger than 2 or 4 for the
  * 		checksum to update.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -741,7 +741,7 @@ union bpf_attr {
  * 		efficient, but it is handled through an action code where the
  * 		redirection happens only after the eBPF program has returned.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -806,7 +806,7 @@ union bpf_attr {
  * 		**ETH_P_8021Q** and **ETH_P_8021AD**, it is considered to
  * 		be **ETH_P_8021Q**.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -818,7 +818,7 @@ union bpf_attr {
  * 	Description
  * 		Pop a VLAN header from the packet associated to *skb*.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1168,7 +1168,7 @@ union bpf_attr {
  * 		All values for *flags* are reserved for future usage, and must
  * 		be left at zero.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1281,7 +1281,7 @@ union bpf_attr {
  * 		implicitly linearizes, unclones and drops offloads from the
  * 		*skb*.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1317,7 +1317,7 @@ union bpf_attr {
  * 		**bpf_skb_pull_data()** to effectively unclone the *skb* from
  * 		the very beginning in case it is indeed cloned.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1369,7 +1369,7 @@ union bpf_attr {
  * 		All values for *flags* are reserved for future usage, and must
  * 		be left at zero.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1384,7 +1384,7 @@ union bpf_attr {
  * 		can be used to prepare the packet for pushing or popping
  * 		headers.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1531,7 +1531,7 @@ union bpf_attr {
  *		  Use with ENCAP_L3/L4 flags to further specify the tunnel
  *		  type; **len** is the length of the inner MAC header.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1610,7 +1610,7 @@ union bpf_attr {
  * 		more flexibility as the user is free to store whatever meta
  * 		data they need.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1852,7 +1852,7 @@ union bpf_attr {
  * 		copied if necessary (i.e. if data was not linear and if start
  * 		and end pointers do not point to the same chunk).
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -1886,7 +1886,7 @@ union bpf_attr {
  * 		only possible to shrink the packet as of this writing,
  * 		therefore *delta* must be a negative integer.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -2072,7 +2072,7 @@ union bpf_attr {
  *		by bpf programs of types BPF_PROG_TYPE_LWT_IN and
  *		BPF_PROG_TYPE_LWT_XMIT.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -2087,7 +2087,7 @@ union bpf_attr {
  *		inside the outermost IPv6 Segment Routing Header can be
  *		modified through this helper.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -2103,7 +2103,7 @@ union bpf_attr {
  *		after the segments are accepted. *delta* can be as well
  *		positive (growing) as negative (shrinking).
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
@@ -2132,7 +2132,7 @@ union bpf_attr {
  *			encapsulation policy.
  *			Type of param: **struct ipv6_sr_hdr**.
  *
- * 		A call to this helper is susceptible to change the underlaying
+ * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
  * 		performed again, if the helper is used in combination with
-- 
2.14.1

