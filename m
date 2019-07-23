Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6A270E11
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 02:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbfGWAVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 20:21:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33864 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387634AbfGWAUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 20:20:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so18168415pfo.1;
        Mon, 22 Jul 2019 17:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Xv1l4ZE6yrpvBzeQ0rNzLhkCrVRQ5YT3cae9HZbEjU=;
        b=uhujTcc8BuaCAOvpE+vYnYwSsAjF38zFuOWJ9H3vnhepxzAldtMC0pF6OyoidoDAtB
         jpu3Vxzb5tqwAZxwZr78S4aq3fRSMrL0JEaZffUI3siPhESLjLOLQQpkXEb3tERpqzfR
         KLXhlgJ1w5o415G01Pw3taOSieBsRtvUI/2/GxpzT5j26ylEQ7Q/mWCU6vcqbFYAg0n/
         0IT88jk/hVh1hY+saVYBYynPVAmfv2MtiBRkdPsnYYIgmo1gyfvzOjsegu/cwSmVCfdL
         pr9CZ2JOv3Ma+dpWzk/HjA9pFRPjFuZdrbOXa9puYsuf2uuhBfvcsS7yLZhLQaAwuRr5
         xLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Xv1l4ZE6yrpvBzeQ0rNzLhkCrVRQ5YT3cae9HZbEjU=;
        b=OogfTUmBzd5P0oZi6+8JL4JCJuNxYXHClyvdQNDSkI0GIPkT9fsXfTz1/pnr58x3K2
         SoJ+x4+KhOzHyQ6YNPicVyEwxJx+2LU/iX0SlAo8tP26HnM0WiSVyjtu6P1pb8tNf8jJ
         7qedOIFa7HHE+xXYglflgTrH6KwTuRHC1r0kR+w+lvc5Rre9P0atYMs+0XAUvAefgIX9
         NkEAAF33Ygras18CgN/rxF/CC5Em40534KH0XajZJEV8JKRoZUxBIWIsVNI/mzH/X924
         2bGhVqEDGGTlQumomAyjJV1Vs/Y/V5LsgArJeUgaMvAZNMP/D62Zsqm35uDna6qtSpdE
         Q2zw==
X-Gm-Message-State: APjAAAVvhhVg24+gxIkFCpnNYL98PZi8UtR9Z1SQbE9fTme484seri0z
        /h1Mpz48evDpwipiqpYK86Q5+sIo
X-Google-Smtp-Source: APXvYqyIWrBA5i5YNLtxnWD/FqSWdu/btyZcOrQS5rRHbis6PL8iBx4pZjrJibQu7skHoNkf7ZduMg==
X-Received: by 2002:a17:90a:17c4:: with SMTP id q62mr80939583pja.104.1563841251617;
        Mon, 22 Jul 2019 17:20:51 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id k64sm21718423pge.65.2019.07.22.17.20.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 17:20:51 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next 4/6] bpf: sync bpf.h to tools/
Date:   Mon, 22 Jul 2019 17:20:40 -0700
Message-Id: <20190723002042.105927-5-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

Sync updated documentation for bpf_redirect_map.

Sync the bpf_tcp_gen_syncookie helper function definition with the one
in tools/uapi.

Signed-off-by: Petar Penkov <ppenkov@google.com>
---
 tools/include/uapi/linux/bpf.h | 37 +++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f506c68b2612..20baee7b2219 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1571,8 +1571,11 @@ union bpf_attr {
  * 		but this is only implemented for native XDP (with driver
  * 		support) as of this writing).
  *
- * 		All values for *flags* are reserved for future usage, and must
- * 		be left at zero.
+ * 		The lower two bits of *flags* are used as the return code if
+ * 		the map lookup fails. This is so that the return value can be
+ * 		one of the XDP program return codes up to XDP_TX, as chosen by
+ * 		the caller. Any higher bits in the *flags* argument must be
+ * 		unset.
  *
  * 		When used to redirect packets to net devices, this helper
  * 		provides a high performance increase over **bpf_redirect**\ ().
@@ -2710,6 +2713,33 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * s64 bpf_tcp_gen_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Try to issue a SYN cookie for the packet with corresponding
+ *		IP/TCP headers, *iph* and *th*, on the listening socket in *sk*.
+ *
+ *		*iph* points to the start of the IPv4 or IPv6 header, while
+ *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
+ *		**sizeof**\ (**struct ip6hdr**).
+ *
+ *		*th* points to the start of the TCP header, while *th_len*
+ *		contains the length of the TCP header.
+ *
+ *	Return
+ *		On success, lower 32 bits hold the generated SYN cookie in
+ *		followed by 16 bits which hold the MSS value for that cookie,
+ *		and the top 16 bits are unused.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** SYN cookie cannot be issued due to error
+ *
+ *		**-ENOENT** SYN cookie should not be issued (no SYN flood)
+ *
+ *		**-ENOTSUPP** kernel configuration does not enable SYN cookies
+ *
+ *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2821,7 +2851,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(tcp_gen_syncookie),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.22.0.657.g960e92d24f-goog

