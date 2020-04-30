Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0F91C0187
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgD3QGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 828CB2498C;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=mwXQTjF7850lNOTbqQXXAQp2gqoDNDy9E2jrpxLqrgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yB8ol5IgG7UroXTG2SVA7rWHMrtG995xZoXka+QB8+UxaIP/9uI6F6nToa51TzyYd
         878WdFKxDgov9pvpNZTtd90JsrriVTFj7+3v1L/P26S3jnpqNS9oy2x7oDeFOmhF8/
         SHgYgm5NCCOM1n9b42ArrtjVuV6p2M+WL4eKeVN8=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxGb-Qq; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 31/37] docs: networking: convert strparser.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:26 +0200
Message-Id: <ebd753137781aa0d28d6eda54d31d8072d56daea.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../{strparser.txt => strparser.rst}          | 85 +++++++++++++------
 2 files changed, 60 insertions(+), 26 deletions(-)
 rename Documentation/networking/{strparser.txt => strparser.rst} (80%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index d19ddcbe66e5..e5a705024c6a 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -104,6 +104,7 @@ Contents:
    secid
    seg6-sysctl
    skfp
+   strparser
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/strparser.txt b/Documentation/networking/strparser.rst
similarity index 80%
rename from Documentation/networking/strparser.txt
rename to Documentation/networking/strparser.rst
index a7d354ddda7b..6cab1f74ae05 100644
--- a/Documentation/networking/strparser.txt
+++ b/Documentation/networking/strparser.rst
@@ -1,4 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
 Stream Parser (strparser)
+=========================
 
 Introduction
 ============
@@ -34,8 +38,10 @@ that is called when a full message has been completed.
 Functions
 =========
 
-strp_init(struct strparser *strp, struct sock *sk,
-	  const struct strp_callbacks *cb)
+     ::
+
+	strp_init(struct strparser *strp, struct sock *sk,
+		const struct strp_callbacks *cb)
 
      Called to initialize a stream parser. strp is a struct of type
      strparser that is allocated by the upper layer. sk is the TCP
@@ -43,31 +49,41 @@ strp_init(struct strparser *strp, struct sock *sk,
      callback mode; in general mode this is set to NULL. Callbacks
      are called by the stream parser (the callbacks are listed below).
 
-void strp_pause(struct strparser *strp)
+     ::
+
+	void strp_pause(struct strparser *strp)
 
      Temporarily pause a stream parser. Message parsing is suspended
      and no new messages are delivered to the upper layer.
 
-void strp_unpause(struct strparser *strp)
+     ::
+
+	void strp_unpause(struct strparser *strp)
 
      Unpause a paused stream parser.
 
-void strp_stop(struct strparser *strp);
+     ::
+
+	void strp_stop(struct strparser *strp);
 
      strp_stop is called to completely stop stream parser operations.
      This is called internally when the stream parser encounters an
      error, and it is called from the upper layer to stop parsing
      operations.
 
-void strp_done(struct strparser *strp);
+     ::
+
+	void strp_done(struct strparser *strp);
 
      strp_done is called to release any resources held by the stream
      parser instance. This must be called after the stream processor
      has been stopped.
 
-int strp_process(struct strparser *strp, struct sk_buff *orig_skb,
-		 unsigned int orig_offset, size_t orig_len,
-		 size_t max_msg_size, long timeo)
+     ::
+
+	int strp_process(struct strparser *strp, struct sk_buff *orig_skb,
+			 unsigned int orig_offset, size_t orig_len,
+			 size_t max_msg_size, long timeo)
 
     strp_process is called in general mode for a stream parser to
     parse an sk_buff. The number of bytes processed or a negative
@@ -75,7 +91,9 @@ int strp_process(struct strparser *strp, struct sk_buff *orig_skb,
     consume the sk_buff. max_msg_size is maximum size the stream
     parser will parse. timeo is timeout for completing a message.
 
-void strp_data_ready(struct strparser *strp);
+    ::
+
+	void strp_data_ready(struct strparser *strp);
 
     The upper layer calls strp_tcp_data_ready when data is ready on
     the lower socket for strparser to process. This should be called
@@ -83,7 +101,9 @@ void strp_data_ready(struct strparser *strp);
     maximum messages size is the limit of the receive socket
     buffer and message timeout is the receive timeout for the socket.
 
-void strp_check_rcv(struct strparser *strp);
+    ::
+
+	void strp_check_rcv(struct strparser *strp);
 
     strp_check_rcv is called to check for new messages on the socket.
     This is normally called at initialization of a stream parser
@@ -94,7 +114,9 @@ Callbacks
 
 There are six callbacks:
 
-int (*parse_msg)(struct strparser *strp, struct sk_buff *skb);
+    ::
+
+	int (*parse_msg)(struct strparser *strp, struct sk_buff *skb);
 
     parse_msg is called to determine the length of the next message
     in the stream. The upper layer must implement this function. It
@@ -107,14 +129,16 @@ int (*parse_msg)(struct strparser *strp, struct sk_buff *skb);
 
     The return values of this function are:
 
-    >0 : indicates length of successfully parsed message
-    0  : indicates more data must be received to parse the message
-    -ESTRPIPE : current message should not be processed by the
-          kernel, return control of the socket to userspace which
-          can proceed to read the messages itself
-    other < 0 : Error in parsing, give control back to userspace
-          assuming that synchronization is lost and the stream
-          is unrecoverable (application expected to close TCP socket)
+    =========    ===========================================================
+    >0           indicates length of successfully parsed message
+    0            indicates more data must be received to parse the message
+    -ESTRPIPE    current message should not be processed by the
+		 kernel, return control of the socket to userspace which
+		 can proceed to read the messages itself
+    other < 0    Error in parsing, give control back to userspace
+		 assuming that synchronization is lost and the stream
+		 is unrecoverable (application expected to close TCP socket)
+    =========    ===========================================================
 
     In the case that an error is returned (return value is less than
     zero) and the parser is in receive callback mode, then it will set
@@ -123,7 +147,9 @@ int (*parse_msg)(struct strparser *strp, struct sk_buff *skb);
     the current message, then the error set on the attached socket is
     ENODATA since the stream is unrecoverable in that case.
 
-void (*lock)(struct strparser *strp)
+    ::
+
+	void (*lock)(struct strparser *strp)
 
     The lock callback is called to lock the strp structure when
     the strparser is performing an asynchronous operation (such as
@@ -131,14 +157,18 @@ void (*lock)(struct strparser *strp)
     function is to lock_sock for the associated socket. In general
     mode the callback must be set appropriately.
 
-void (*unlock)(struct strparser *strp)
+    ::
+
+	void (*unlock)(struct strparser *strp)
 
     The unlock callback is called to release the lock obtained
     by the lock callback. In receive callback mode the default
     function is release_sock for the associated socket. In general
     mode the callback must be set appropriately.
 
-void (*rcv_msg)(struct strparser *strp, struct sk_buff *skb);
+    ::
+
+	void (*rcv_msg)(struct strparser *strp, struct sk_buff *skb);
 
     rcv_msg is called when a full message has been received and
     is queued. The callee must consume the sk_buff; it can
@@ -152,7 +182,9 @@ void (*rcv_msg)(struct strparser *strp, struct sk_buff *skb);
     the length of the message. skb->len - offset may be greater
     then full_len since strparser does not trim the skb.
 
-int (*read_sock_done)(struct strparser *strp, int err);
+    ::
+
+	int (*read_sock_done)(struct strparser *strp, int err);
 
      read_sock_done is called when the stream parser is done reading
      the TCP socket in receive callback mode. The stream parser may
@@ -160,7 +192,9 @@ int (*read_sock_done)(struct strparser *strp, int err);
      to occur when exiting the loop. If the callback is not set (NULL
      in strp_init) a default function is used.
 
-void (*abort_parser)(struct strparser *strp, int err);
+     ::
+
+	void (*abort_parser)(struct strparser *strp, int err);
 
      This function is called when stream parser encounters an error
      in parsing. The default function stops the stream parser and
@@ -204,4 +238,3 @@ Author
 ======
 
 Tom Herbert (tom@quantonium.net)
-
-- 
2.25.4

