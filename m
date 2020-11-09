Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B12D2AB43D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgKIKCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgKIKCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:02:12 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA995C0613D3;
        Mon,  9 Nov 2020 02:02:12 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id t13so7737619ilp.2;
        Mon, 09 Nov 2020 02:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EQ7E7yH7knGfXa8L78Wzfx6uu8dmAvOU2LSv4iVHx1M=;
        b=R7tV5kYyLHL3fwLuB5osXpJ0YTp3qY42EJVKZXucac3PvMQwvt/VwsUjvvv7fM+YHx
         JJyPU1BW1v7zzK4EvAxyhWk5o9wBhXnBRrr0bEOl0dMM7Ms9h0BlmOHwo2zsHtRVKmhw
         MzePWlxx0ABQrvpU/mRA7Gff4Feq5ylHsjreNxHi8AYedIKX80rMGhMX/B0nP/RysZZi
         iZGNQ92S5bT/0fTUTDJg5hEodcjhFgiE/HhGm0efeD10p4GXYz/cY27lnpjYn1eQ150l
         o4vv92WnXQS6Zw2SLDhSCqcIxZDVLwUNFZ9IjMoB7JZ/Nu75TTADHpvLdd0cLuiqCBCZ
         lmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EQ7E7yH7knGfXa8L78Wzfx6uu8dmAvOU2LSv4iVHx1M=;
        b=dfyske1kvErDw4/7DdzR7nKUydZjI3/OCd+srCAvPSiIlbjppoaAxyU5snTywzrNON
         NV8oLf0hOZWDs3KhMCslPKA1J+Pxrpz5wxb4dCkyl6X717ozZgfKgAG1C+eBaUjRkbKM
         JRr1LytvoUa/3FxWXn5rqRyUz3SNFTFFXleS3uKf1Pvc4D8RjgPmYk4VwwIn+JtzI5Yx
         ISi8fk9fIUsEyUyZLXNbAxe97bDOoVgUFStZVgnGihU+nApQpLKEG1ZMGECjcNOZxCsa
         3jZl6+SvXb2f1QRrRZFBHfA2hFkZ8ZpYAoiLpRs1GDDjvkhvkvFvxxVMrwi3TeeoS2Ri
         HV3w==
X-Gm-Message-State: AOAM532otuJHo9kixUpgKPpDBCRHZZFuhdUwSB538yLqQBkm16l13SYB
        2xBwtyYcw3G8Qp01qpcLQOA=
X-Google-Smtp-Source: ABdhPJxX5qcAr7BiC72J/O0abvVqel/IdJ0Bz07Vo5V1p44JG7GbZORq8T+PGQtc6RQtFDdb5I0lWA==
X-Received: by 2002:a92:cd0e:: with SMTP id z14mr9225485iln.135.1604916131989;
        Mon, 09 Nov 2020 02:02:11 -0800 (PST)
Received: from localhost.localdomain ([156.146.54.75])
        by smtp.gmail.com with ESMTPSA id u1sm6606527ilb.74.2020.11.09.02.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 02:02:11 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     bfields@fieldses.org, chuck.lever@oracle.com,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        davem@davemloft.net, kuba@kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: sunrpc: xprtsock.c: Corrected few spellings ,in comments
Date:   Mon,  9 Nov 2020 15:24:05 +0530
Message-Id: <20201109095404.25154-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few trivial and rudimentary spell corrections.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/sunrpc/xprtsock.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 343c6396b297..90792afea6c8 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -828,7 +828,7 @@ xs_stream_record_marker(struct xdr_buf *xdr)
  *   EAGAIN:	The socket was blocked, please call again later to
  *		complete the request
  * ENOTCONN:	Caller needs to invoke connect logic then call again
- *    other:	Some other error occured, the request was not sent
+ *    other:	Some other error occurred, the request was not sent
  */
 static int xs_local_send_request(struct rpc_rqst *req)
 {
@@ -1664,7 +1664,7 @@ static int xs_bind(struct sock_xprt *transport, struct socket *sock)
 	 * This ensures that we can continue to establish TCP
 	 * connections even when all local ephemeral ports are already
 	 * a part of some TCP connection.  This makes no difference
-	 * for UDP sockets, but also doens't harm them.
+	 * for UDP sockets, but also doesn't harm them.
 	 *
 	 * If we're asking for any reserved port (i.e. port == 0 &&
 	 * transport->xprt.resvport == 1) xs_get_srcport above will
@@ -2380,7 +2380,7 @@ static void xs_error_handle(struct work_struct *work)
 }

 /**
- * xs_local_print_stats - display AF_LOCAL socket-specifc stats
+ * xs_local_print_stats - display AF_LOCAL socket-specific stats
  * @xprt: rpc_xprt struct containing statistics
  * @seq: output file
  *
@@ -2409,7 +2409,7 @@ static void xs_local_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
 }

 /**
- * xs_udp_print_stats - display UDP socket-specifc stats
+ * xs_udp_print_stats - display UDP socket-specific stats
  * @xprt: rpc_xprt struct containing statistics
  * @seq: output file
  *
@@ -2433,7 +2433,7 @@ static void xs_udp_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
 }

 /**
- * xs_tcp_print_stats - display TCP socket-specifc stats
+ * xs_tcp_print_stats - display TCP socket-specific stats
  * @xprt: rpc_xprt struct containing statistics
  * @seq: output file
  *
--
2.26.2

