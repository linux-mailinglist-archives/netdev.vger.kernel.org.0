Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E810ACAE0E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388727AbfJCSTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:19:51 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35634 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388630AbfJCSTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:19:47 -0400
Received: by mail-qt1-f195.google.com with SMTP id m15so4970905qtq.2
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 11:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F8G4IBswBjxBsJFHpUVO/1AaagCDKoeUnSETOs15G9o=;
        b=rvVjpl91XpHG9c71ZvNaEmrlYk5pFJHFQYwSM08kNpV2yKFpdpCMvKUN7N5+ij1eIh
         atZl3PROmzE4FwTwpTi7U81kM7bH2w+rmSDrqI6ardJC2ITjtbzySaeX80KHldaSxz+5
         5Ljnw0vAgkdkdOf0TCPRQ90hEebPfFCxpVSM5rdyAx0t+6fuuWR7pjrWVW9TTc5ndajV
         jKlh7oOg17rjl3Sfcosh1WaGlyoq7Hrla2Fftb7YELwijl5qpOKNas4WrGOeatXAZyx5
         mBDrOHU7I975Ss0Hr8Wl8JY9oq2E9FJ2u9pDA6vLtQJCfLyiyDvTZk/rlQJ8AZj+25M3
         b44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F8G4IBswBjxBsJFHpUVO/1AaagCDKoeUnSETOs15G9o=;
        b=fgKD9xY2Qy82Isp0dgCe+FZoQQxHddRhkVs+tbn6NPUtqdcb2VD2pydXo27GoXy0hX
         A16OeR4KQBItM62/eWImUcZDiLClj4i5h17MVr0cs/+kM+RL6QBoeluH+uCA3HhP6nmz
         SpSWhyZTEVm8yRDDBJW/ekwcj7x7fNlqX7c0SVAK1jD7ItKNxaQBWkpfXM/Xkx7G2B6x
         9ty4h/r6n9O4mXmYG1OhpI7lhhVIs/GQTv2zJgvn+mgbVgACoFrOblHWENMCnlls407j
         AYJN6EP6dyxg3LuIr412V3iqooaJyiFHuuBY+gUCszBhivtgVaigezkJPthMZxKZ5g8x
         kqfw==
X-Gm-Message-State: APjAAAUW9ehWO4DQ7C+maMMNjXsRvyzfIsTfhxZ/DYBgt38sa+7y5tYR
        XUhVnOpBa2w2z1VNRroq2xtgMQ==
X-Google-Smtp-Source: APXvYqzTupVgHWF6q1MmZts/PO12UpNVMNcwWWrnQHc44B5coVJJVB0Q2b/xO7ZNWOBQF/Zcmbh9Sg==
X-Received: by 2002:ac8:748e:: with SMTP id v14mr11347225qtq.371.1570126786794;
        Thu, 03 Oct 2019 11:19:46 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m91sm1592984qte.8.2019.10.03.11.19.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 11:19:46 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        atul.gupta@chelsio.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 5/6] net/tls: rename tls_hw_* functions tls_toe_*
Date:   Thu,  3 Oct 2019 11:18:58 -0700
Message-Id: <20191003181859.24958-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003181859.24958-1-jakub.kicinski@netronome.com>
References: <20191003181859.24958-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tls_hw_* functions are quite confusingly named, since they
are related to the TOE-offload, not TLS_HW offload which doesn't
require TOE. Rename them.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/net/tls_toe.h |  6 +++---
 net/tls/tls_main.c    |  6 +++---
 net/tls/tls_toe.c     | 12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/tls_toe.h b/include/net/tls_toe.h
index 3bb39c795aed..b3aa7593ce2c 100644
--- a/include/net/tls_toe.h
+++ b/include/net/tls_toe.h
@@ -69,9 +69,9 @@ struct tls_toe_device {
 	struct kref kref;
 };
 
-int tls_hw_prot(struct sock *sk);
-int tls_hw_hash(struct sock *sk);
-void tls_hw_unhash(struct sock *sk);
+int tls_toe_bypass(struct sock *sk);
+int tls_toe_hash(struct sock *sk);
+void tls_toe_unhash(struct sock *sk);
 
 void tls_toe_register_device(struct tls_toe_device *device);
 void tls_toe_unregister_device(struct tls_toe_device *device);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 9d0cf14b2f7e..483dda6c3155 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -681,8 +681,8 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 #endif
 
 	prot[TLS_HW_RECORD][TLS_HW_RECORD] = *base;
-	prot[TLS_HW_RECORD][TLS_HW_RECORD].hash		= tls_hw_hash;
-	prot[TLS_HW_RECORD][TLS_HW_RECORD].unhash	= tls_hw_unhash;
+	prot[TLS_HW_RECORD][TLS_HW_RECORD].hash		= tls_toe_hash;
+	prot[TLS_HW_RECORD][TLS_HW_RECORD].unhash	= tls_toe_unhash;
 }
 
 static int tls_init(struct sock *sk)
@@ -692,7 +692,7 @@ static int tls_init(struct sock *sk)
 
 	tls_build_proto(sk);
 
-	if (tls_hw_prot(sk))
+	if (tls_toe_bypass(sk))
 		return 0;
 
 	/* The TLS ulp is currently supported only for TCP sockets
diff --git a/net/tls/tls_toe.c b/net/tls/tls_toe.c
index 89a7014a05f7..7e1330f19165 100644
--- a/net/tls/tls_toe.c
+++ b/net/tls/tls_toe.c
@@ -41,7 +41,7 @@
 static LIST_HEAD(device_list);
 static DEFINE_SPINLOCK(device_spinlock);
 
-static void tls_hw_sk_destruct(struct sock *sk)
+static void tls_toe_sk_destruct(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tls_context *ctx = tls_get_ctx(sk);
@@ -52,7 +52,7 @@ static void tls_hw_sk_destruct(struct sock *sk)
 	tls_ctx_free(sk, ctx);
 }
 
-int tls_hw_prot(struct sock *sk)
+int tls_toe_bypass(struct sock *sk)
 {
 	struct tls_toe_device *dev;
 	struct tls_context *ctx;
@@ -66,7 +66,7 @@ int tls_hw_prot(struct sock *sk)
 				goto out;
 
 			ctx->sk_destruct = sk->sk_destruct;
-			sk->sk_destruct = tls_hw_sk_destruct;
+			sk->sk_destruct = tls_toe_sk_destruct;
 			ctx->rx_conf = TLS_HW_RECORD;
 			ctx->tx_conf = TLS_HW_RECORD;
 			update_sk_prot(sk, ctx);
@@ -79,7 +79,7 @@ int tls_hw_prot(struct sock *sk)
 	return rc;
 }
 
-void tls_hw_unhash(struct sock *sk)
+void tls_toe_unhash(struct sock *sk)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
 	struct tls_toe_device *dev;
@@ -98,7 +98,7 @@ void tls_hw_unhash(struct sock *sk)
 	ctx->sk_proto->unhash(sk);
 }
 
-int tls_hw_hash(struct sock *sk)
+int tls_toe_hash(struct sock *sk)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
 	struct tls_toe_device *dev;
@@ -118,7 +118,7 @@ int tls_hw_hash(struct sock *sk)
 	spin_unlock_bh(&device_spinlock);
 
 	if (err)
-		tls_hw_unhash(sk);
+		tls_toe_unhash(sk);
 	return err;
 }
 
-- 
2.21.0

