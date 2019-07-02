Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBB35D409
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfGBQOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:14:20 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:35816 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfGBQOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:14:20 -0400
Received: by mail-pl1-f201.google.com with SMTP id bb9so613160plb.2
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iX08Cq+hAin5aRe+l7YkBpA1Amc/tSXA9bkkEMMN9As=;
        b=BkjxXUjYGgNYTb5UC+1dEi/UQspXS8PFMNKqFhmzJLfVaU6e0W+VkX3C/NWWAsh862
         y5fDKAxnwY7TfTMeslC43t1s1+ihAZyGhWLpy7BZUx7uCeizWp1crJTy59ve1wOJXPZP
         ylXXdNO4fhamkUVT6YzSOEave/ju/LI/IXMcn3osvKmZrtpvuaxS+r0JSzHHnEBQJ33N
         ObkJm3MWmnv2Gezlq0Gct04xCIvnNjW7iKZm+Q55frBNXe29+rmv0qg0syMR670mumHW
         XMD2pwYjJAFH51Ef8gZ5v23wPxLYx1dx928m3hT+hxVaSZ44ClEjAebQ2bo2Sbk1pa1I
         +IHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iX08Cq+hAin5aRe+l7YkBpA1Amc/tSXA9bkkEMMN9As=;
        b=lVRYQeN/oK9S/FQAbuTgiuQ3FRUMnclaQtYVMUiuffCBz2GnNBuXOi648qlRkUtYtI
         RrEttX18B/YFfr5HyfDMbC9hMQgF1THhN2ZbOTAyUw1YtFkKUl3U3i/4Bk6gW1OdiWy7
         HC2ACPAnMjMpOpn78LVKWhSm/s33d1Gs+0ECrwxcvlkQnP2iR4eDNl55w35GBlzHBSkU
         E5YNYUUmQmJTyJEkEjZUcnbLsahcN4h+uN3ljp42BtIlk+Kfrk3YtTrWPEAXsfA+s5En
         whp35tuAk6AvD+nzJ6CP4xfaBylxoNwpBuuMQSZMTRIc1orThe3637SEhDVjgri5IEZO
         NFEw==
X-Gm-Message-State: APjAAAXVWftuYlIAwe9UZviNV9tk10a3yeBxiP0b/bxbW+130BivwPcd
        LIbLvZuvJun4K3M72p2zsZWwvsMUs3clLbBH4Pp1zYVuPyaAx4/e/US/Q0b+AX6AEs4SOVTsX3f
        qPkoxvt91ZgV6I5vcK+x1JxrcRm1OGjkukhikc9iSfL0AU0c3Iu1sQA==
X-Google-Smtp-Source: APXvYqy0bc8bLkSqe4UG+op8kQb2Bc7TmnVBqvF5K7BLjKJbDKJSjmmJhKu3rSO3Kgf+d+RDedYIXXw=
X-Received: by 2002:a63:5c19:: with SMTP id q25mr32067737pgb.215.1562084059019;
 Tue, 02 Jul 2019 09:14:19 -0700 (PDT)
Date:   Tue,  2 Jul 2019 09:14:00 -0700
In-Reply-To: <20190702161403.191066-1-sdf@google.com>
Message-Id: <20190702161403.191066-6-sdf@google.com>
Mime-Version: 1.0
References: <20190702161403.191066-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 5/8] bpf/tools: sync bpf.h
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync new bpf_tcp_sock fields and new BPF_PROG_TYPE_SOCK_OPS RTT callback.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Priyaranjan Jha <priyarjha@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a396b516a2b2..cecf42c871d4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1767,6 +1767,7 @@ union bpf_attr {
  * 		* **BPF_SOCK_OPS_RTO_CB_FLAG** (retransmission time out)
  * 		* **BPF_SOCK_OPS_RETRANS_CB_FLAG** (retransmission)
  * 		* **BPF_SOCK_OPS_STATE_CB_FLAG** (TCP state change)
+ * 		* **BPF_SOCK_OPS_RTT_CB_FLAG** (every RTT)
  *
  * 		Therefore, this function can be used to clear a callback flag by
  * 		setting the appropriate bit to zero. e.g. to disable the RTO
@@ -3069,6 +3070,12 @@ struct bpf_tcp_sock {
 				 * sum(delta(snd_una)), or how many bytes
 				 * were acked.
 				 */
+	__u32 dsack_dups;	/* RFC4898 tcpEStatsStackDSACKDups
+				 * total number of DSACK blocks received
+				 */
+	__u32 delivered;	/* Total data packets delivered incl. rexmits */
+	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
+	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
 };
 
 struct bpf_sock_tuple {
@@ -3311,7 +3318,8 @@ struct bpf_sock_ops {
 #define BPF_SOCK_OPS_RTO_CB_FLAG	(1<<0)
 #define BPF_SOCK_OPS_RETRANS_CB_FLAG	(1<<1)
 #define BPF_SOCK_OPS_STATE_CB_FLAG	(1<<2)
-#define BPF_SOCK_OPS_ALL_CB_FLAGS       0x7		/* Mask of all currently
+#define BPF_SOCK_OPS_RTT_CB_FLAG	(1<<3)
+#define BPF_SOCK_OPS_ALL_CB_FLAGS       0xF		/* Mask of all currently
 							 * supported cb flags
 							 */
 
@@ -3366,6 +3374,8 @@ enum {
 	BPF_SOCK_OPS_TCP_LISTEN_CB,	/* Called on listen(2), right after
 					 * socket transition to LISTEN state.
 					 */
+	BPF_SOCK_OPS_RTT_CB,		/* Called on every RTT.
+					 */
 };
 
 /* List of TCP states. There is a build check in net/ipv4/tcp.c to detect
-- 
2.22.0.410.gd8fdbe21b5-goog

