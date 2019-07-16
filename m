Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC169FD8
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733078AbfGPA1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:27:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34902 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733037AbfGPA1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:27:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id s1so2194758pgr.2;
        Mon, 15 Jul 2019 17:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ujlozc7sfrUxPeKUrm0S8Clxvqj73QFe27MPPNoJ9z0=;
        b=V4fQaBp2BNjJfZExrLgIjteX7MQEvK8i5QWUGNgKriuNUAFLRng+2XtIinfyg4r+Qf
         IW/QDw0PtLJlPgsSnxQwkuYqSLz36DJ4lE2CuOGfFn1bfUgfZXc1lN2qzd62c2+w4afe
         YOiFTwa2xKp0buuN8snFH7POVzRovwxDDiG63WI0nkUJptKBH+Y/uSmM1Y5poCppPDJ0
         5C8vVl3qKdOpVlCsM3Mibi+UPbeyrXCphuhVswQA2neO90ROF87ENA3g+n0x/1mLut+K
         zuSAdRVIEuPxwp5RhZkmYRsdtEjF309CwhuuuLDGXhRs1Y/kCvCCT93/DTo3Ww+a/0Qq
         yppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ujlozc7sfrUxPeKUrm0S8Clxvqj73QFe27MPPNoJ9z0=;
        b=XYFB3tU4Aj3mKVBCfGatAAQmMUKqM/gboR4IfVxYdY+nmmOIKHuAVI5B/yS3LaGX7w
         utmjPjcZPXGdnjce2YaeEDVSTj3PcpjXlOr6rjtjpOKj07egOS/DH8j4jyu0PSNntrOx
         B9kKvV7GcCXhpAgdbNO1jOTeg7Rg9Txfixsl1sIRVlWOw8fJppynKHnk6y3VAPYHtqI6
         ZrhGnNzrTZs2/V6QEs4sg+JPvHU4AHsPTNOt/aRTa9egfdbSwWBMHWxxY8ONKY2j7MP3
         BrXWntNwLt+dsblsQk9DVJkPk4kdSiIRua8tiFG4ro5nOc+3Nz5mimXh/UF+ndhB0LUO
         s1ug==
X-Gm-Message-State: APjAAAXk4aJxZEx4phx7ajCuTcrZ2B0LDY/1l8dbn/YXEvb0/b6hD1fZ
        lEyk8OMQxSHknE4VY5xO2ydbc5jo
X-Google-Smtp-Source: APXvYqyh6wjBRMRLEySaYZ8fBh9munKSRxCWqsdsbNlw+b/Uk+2hN0a/E5fvDsVRCOmMeKGi7izc2g==
X-Received: by 2002:a63:24a:: with SMTP id 71mr5371246pgc.273.1563236823622;
        Mon, 15 Jul 2019 17:27:03 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id q24sm16775444pjp.14.2019.07.15.17.27.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:27:03 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next RFC 4/6] bpf: sync bpf.h to tools/
Date:   Mon, 15 Jul 2019 17:26:48 -0700
Message-Id: <20190716002650.154729-5-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
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
index f506c68b2612..abf4a85c76d1 100644
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
+ *		contains **sizeof**\ (**struct tcphdr**).
+ *
+ *	Return
+ *		On success, lower 32 bits hold the generated SYN cookie in
+ *		network order and the higher 32 bits hold the MSS value for that
+ *		cookie.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** SYN cookie cannot be issued due to error
+ *
+ *		**-ENOENT** SYN cookie should not be issued (no SYN flood)
+ *
+ *		**-ENOTSUPP** kernel configuration does not enable SYN cookies
+ *
+ *		**-EPROTONOSUPPORT** *sk* family is not AF_INET/AF_INET6
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
2.22.0.510.g264f2c817a-goog

