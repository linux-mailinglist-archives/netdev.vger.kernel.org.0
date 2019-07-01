Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDDB5C121
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfGAQbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:31:12 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:42539 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbfGAQbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:31:11 -0400
Received: by mail-qk1-f202.google.com with SMTP id 199so8763639qkj.9
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=99mTW3U5MG0x4k0yihAasMZW449IUPn2l499+3n8rIo=;
        b=jTlvOrgVM4EB5KSvEq8GksBYrbfLdKpnaB8sMRETY8j+uh0pyzvyXTEIFQjWrR43O2
         kkMeZzgTGw4d8RXOeWTfTYlonlKmwtru+Ko3mjorqUWL/9qJSeuX2b4ls5qXuO4GDi0e
         FjUu39qLfMgj+S+xKJ8zmlmyrRpIKa2UZoJeRMfKVWkhnlFd+B93biWA6YvdbW1krDun
         v4ETtrKptgJHXDXOm0UF21zi5XBNY7cfyCjra48CJxGOcAUsmLw8cUmIed41CrXM82fn
         opdY4UMQzVJhHlQDjCYjZ4dnV/TwE4bG32+PCzv/BJLPMNCXZ6jCwwGAAq6PYEc8yciS
         toGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=99mTW3U5MG0x4k0yihAasMZW449IUPn2l499+3n8rIo=;
        b=iryyud2sv0Lnda0tJYy3ARe5g1aoEiIYoCQf4LVHt9w0TlfQPqJnr3kSP1j5qIJBmf
         vM+5ZhoTEdCK8g0JUiWk8cImzi9Iz7xd5JO72WfJaC0y6Bwy5JUSOw2XmkUJROeBF2vz
         MulIWM5lfhB15Gf/TCQeJ5OrK4jalmEaV3SWbRzcVQAZcgqHk0b4qZD3x/x0a5kVszIe
         SUCpz7mVeKNHz+W7u6Bz0QTmfp8YyYxI9Lav/hrPvJx5Tln//VMZ4XxDm9cNBMzRiLo2
         FxJP60JBnVPyBR542vM6y8cl5h4+mteCU2YOzR+ghcnoSFWTti9CnyIdodKuegPzPOav
         FpsA==
X-Gm-Message-State: APjAAAUAxs/tzXIWyYyAfqHo1x44bHi3aSk0P8jsGx91IFoXRBBF/B7H
        /ZDjeZXl7G76PpKlLKnGC6at1e64aXb51e6LW+29zCf6M85r7JXkzBOwY6tyiZxMVnT7E2aDMHO
        TSYaP61DPwYrJxMDn0hbCKgrf0KA0vGOrRG4F2+P13A5QswmRnGcNOA==
X-Google-Smtp-Source: APXvYqwM/vbkWM+2ra9nL5IMBIo5fxtYezBf87T1+He8no/wXbuvlSrdr75gIblJ/nysWwe6nhWDj7M=
X-Received: by 2002:ac8:1ba9:: with SMTP id z38mr21589602qtj.176.1561998670513;
 Mon, 01 Jul 2019 09:31:10 -0700 (PDT)
Date:   Mon,  1 Jul 2019 09:31:02 -0700
In-Reply-To: <20190701163103.237550-1-sdf@google.com>
Message-Id: <20190701163103.237550-3-sdf@google.com>
Mime-Version: 1.0
References: <20190701163103.237550-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 2/3] bpf: sync bpf.h to tools/
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync user_ip6 & msg_src_ip6 comments.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a396b516a2b2..586867fe6102 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3237,7 +3237,7 @@ struct bpf_sock_addr {
 	__u32 user_ip4;		/* Allows 1,2,4-byte read and 4-byte write.
 				 * Stored in network byte order.
 				 */
-	__u32 user_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
+	__u32 user_ip6[4];	/* Allows 1,2,4-byte read an 4,8-byte write.
 				 * Stored in network byte order.
 				 */
 	__u32 user_port;	/* Allows 4-byte read and write.
@@ -3249,7 +3249,7 @@ struct bpf_sock_addr {
 	__u32 msg_src_ip4;	/* Allows 1,2,4-byte read an 4-byte write.
 				 * Stored in network byte order.
 				 */
-	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
+	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read an 4,8-byte write.
 				 * Stored in network byte order.
 				 */
 	__bpf_md_ptr(struct bpf_sock *, sk);
-- 
2.22.0.410.gd8fdbe21b5-goog

