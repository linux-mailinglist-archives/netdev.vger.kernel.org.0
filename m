Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FCD791A8
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbfG2Q7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:59:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36347 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfG2Q7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:59:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so28556806pgm.3;
        Mon, 29 Jul 2019 09:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ksAzpj+KHDgXM/KyHUhWdINlogi/v++p7bhxJ+uB+bY=;
        b=KZcbmtfU13yKDgR+wr4hrSs3l1bzNUqaysOi4UcdhaPa+nOtHqJh+BlLkYZPfBOODV
         4b4QtCCt20bE+3gR1SzIxrVZ8nqvBANg06ig9tbiG4YyP8qTtEBLJp8K2pSE8rQrES60
         IB6/yqYIVHU6n6sggJZ735/Y8Rxr23I6Byd6Qbe0L527ZmWlHYjYNxe9Rta6Ft1hRHAM
         E17kzQvP5J3op9BAIw7tIpZeamPHCZIEi2/SRaZkcc5cphDapp0+zICqTJdq8VdyaRq4
         levzJMW+nU804yxGlSiON88C8TeBWWQTDQwpM5+LnFGOqdgpQ5D5qIQIpmCIYtQxeXyj
         0Dwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ksAzpj+KHDgXM/KyHUhWdINlogi/v++p7bhxJ+uB+bY=;
        b=f4DpqsAMV+BV+jVXAHSQdOIasoVJDqdpL+1HrNreskLiiata6KhGxoUZ3CqrcjIYOy
         kOSHuyOE7Ji3I6At/f+AzQIQtrB/uUNEIo3OVPZbr9LpHfNuqsyNlmiycAjWhMjVMlKL
         lFCgBWdsk/ckDi6DMlT5whnQYe/CYzDdE2rPjdssJ1fX6DH6yammPu/bNBhNEtDXJj5R
         HB9vO8lVhG/NlfoU/NXvrAvqm0MiEY9hRuZEsdSmIhkMvW5BBvJRXBjQQP69DN3aQs3q
         /jsQRdGITYaNUCRIodONBhci8bIli0AJZySUumI5q18lUuNz74nd1JaRFSGFrdaVGNM7
         BUBg==
X-Gm-Message-State: APjAAAWMSvwcZCVKNFpJQ+x9mEjpzyBhV81baSlsHHgFgB61DVrGzSOB
        yR+GQyu2pKOoXjVpeE6CI2fKNb5R
X-Google-Smtp-Source: APXvYqzSCNm51zetNwMUIh16uDoEJvr4tHpnbscqVUF01ity5U3L4R9PQyuX+CGHtBcOyaeCRqQZAw==
X-Received: by 2002:a65:56c1:: with SMTP id w1mr103441040pgs.395.1564419573929;
        Mon, 29 Jul 2019 09:59:33 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id i198sm60784651pgd.44.2019.07.29.09.59.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:59:33 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        toke@redhat.com, Petar Penkov <ppenkov@google.com>
Subject: [bpf-next,v2 4/6] bpf: sync bpf.h to tools/
Date:   Mon, 29 Jul 2019 09:59:16 -0700
Message-Id: <20190729165918.92933-5-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
In-Reply-To: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
References: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
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
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/include/uapi/linux/bpf.h | 37 +++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3d7fc67ec1b8..5a54f1011db8 100644
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
+ *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
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
2.22.0.709.g102302147b-goog

