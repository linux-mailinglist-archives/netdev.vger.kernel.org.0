Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478ADCAE07
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388481AbfJCSTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:19:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45764 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387866AbfJCSTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:19:42 -0400
Received: by mail-qt1-f193.google.com with SMTP id c21so4874423qtj.12
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 11:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G3iEvgnSv/Zn1qpV02rngGpFgwiowE7sdJQXDj43d9o=;
        b=cjL/f+5vccVTD3ULNBd4tPYCyN16srWy3GDtPkAKEnGibJ9AaaX9lG3f32MWPXoY21
         1UltQW3RGixv4QPCSPvgrcYs4WTq5xJISp/MpQT5Rfrw05H5KSqAZh9g2tSUXbL0sQvC
         RsdJySAdmse817eCZC3NSgMuYqDF/lt2uHkEXCCWoqPNrxUGVp1otwZQyuWfOuz93zk5
         Hetn/AUMWGYO4ShVnlH1LQJeLu4S9o8sdtQPgsFVmDyv+duswjf+kS8fEUY3vm55iGQf
         6/SeeGVJCz6fjqQY5hNRx8DdqzvNSNynaTtwKtk6SCO6JlvDOIAoRGvbgZAUOi6AWr9q
         ywGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G3iEvgnSv/Zn1qpV02rngGpFgwiowE7sdJQXDj43d9o=;
        b=Oezx/LP2JbFBIekp4ZRa4baZhmUiR0jn8FTU02w8Oq/l1x1rwg3wzOcgLylnXQZnCX
         nymprSUiKD6ER5zZq/fUppV3s3mJVFnjunbDOpCEbqjj54RxToZrKtsLuS91lfyNPSwB
         EA2WjFBzakZZ9zA4WxC40W4oureOvW98H1Plm4PNSEeQiVcjxvXaxfxClzkuUOlCDEmX
         6yygNY1+BS27O5n/gjA3pDoBR1MMgwEhy60dgtBcfj0wfr0dGRSZ6HDt/DDVPNc2alMB
         wWvFq/6isNAKb0HYWM/d4GErUAaIbZ+OB9Ob8bsp3/XmSXlRS+Qd0jPNkgcrlGAhO5C4
         +p1A==
X-Gm-Message-State: APjAAAXNEGSAqcDatE1a/wEO4OO6saFnHY8pZgjv9Uic2QUj0YoEW7hB
        WVihFhj+3fUZRBmTOqhWOAyaHw==
X-Google-Smtp-Source: APXvYqxwE+6exZ3iYMLOWBshWW02vBSYC9CDKMkMifv+7nGG3aw5OHfjGfQ8HXPlb78v+SOoQd7Mlg==
X-Received: by 2002:ac8:6d03:: with SMTP id o3mr10825140qtt.97.1570126781256;
        Thu, 03 Oct 2019 11:19:41 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m91sm1592984qte.8.2019.10.03.11.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 11:19:40 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        atul.gupta@chelsio.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 2/6] net/tls: rename tls_device to tls_toe_device
Date:   Thu,  3 Oct 2019 11:18:55 -0700
Message-Id: <20191003181859.24958-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003181859.24958-1-jakub.kicinski@netronome.com>
References: <20191003181859.24958-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename struct tls_device to struct tls_toe_device to avoid
confusion with normal, non-TOE offload.

No functional changes.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/crypto/chelsio/chtls/chtls.h      |  4 ++--
 drivers/crypto/chelsio/chtls/chtls_main.c | 20 +++++++++----------
 include/net/tls_toe.h                     | 24 +++++++++++------------
 net/tls/tls_main.c                        | 14 ++++++-------
 4 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index e353c42fea91..d2bc655ab931 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -119,7 +119,7 @@ struct tls_scmd {
 };
 
 struct chtls_dev {
-	struct tls_device tlsdev;
+	struct tls_toe_device tlsdev;
 	struct list_head list;
 	struct cxgb4_lld_info *lldi;
 	struct pci_dev *pdev;
@@ -363,7 +363,7 @@ enum {
 #define TCP_PAGE(sk)   (sk->sk_frag.page)
 #define TCP_OFF(sk)    (sk->sk_frag.offset)
 
-static inline struct chtls_dev *to_chtls_dev(struct tls_device *tlsdev)
+static inline struct chtls_dev *to_chtls_dev(struct tls_toe_device *tlsdev)
 {
 	return container_of(tlsdev, struct chtls_dev, tlsdev);
 }
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index e6df5b95ed47..18996935d8ba 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -124,7 +124,7 @@ static void chtls_stop_listen(struct chtls_dev *cdev, struct sock *sk)
 	mutex_unlock(&notify_mutex);
 }
 
-static int chtls_inline_feature(struct tls_device *dev)
+static int chtls_inline_feature(struct tls_toe_device *dev)
 {
 	struct net_device *netdev;
 	struct chtls_dev *cdev;
@@ -140,7 +140,7 @@ static int chtls_inline_feature(struct tls_device *dev)
 	return 0;
 }
 
-static int chtls_create_hash(struct tls_device *dev, struct sock *sk)
+static int chtls_create_hash(struct tls_toe_device *dev, struct sock *sk)
 {
 	struct chtls_dev *cdev = to_chtls_dev(dev);
 
@@ -149,7 +149,7 @@ static int chtls_create_hash(struct tls_device *dev, struct sock *sk)
 	return 0;
 }
 
-static void chtls_destroy_hash(struct tls_device *dev, struct sock *sk)
+static void chtls_destroy_hash(struct tls_toe_device *dev, struct sock *sk)
 {
 	struct chtls_dev *cdev = to_chtls_dev(dev);
 
@@ -161,7 +161,7 @@ static void chtls_free_uld(struct chtls_dev *cdev)
 {
 	int i;
 
-	tls_unregister_device(&cdev->tlsdev);
+	tls_toe_unregister_device(&cdev->tlsdev);
 	kvfree(cdev->kmap.addr);
 	idr_destroy(&cdev->hwtid_idr);
 	for (i = 0; i < (1 << RSPQ_HASH_BITS); i++)
@@ -173,27 +173,27 @@ static void chtls_free_uld(struct chtls_dev *cdev)
 
 static inline void chtls_dev_release(struct kref *kref)
 {
+	struct tls_toe_device *dev;
 	struct chtls_dev *cdev;
-	struct tls_device *dev;
 
-	dev = container_of(kref, struct tls_device, kref);
+	dev = container_of(kref, struct tls_toe_device, kref);
 	cdev = to_chtls_dev(dev);
 	chtls_free_uld(cdev);
 }
 
 static void chtls_register_dev(struct chtls_dev *cdev)
 {
-	struct tls_device *tlsdev = &cdev->tlsdev;
+	struct tls_toe_device *tlsdev = &cdev->tlsdev;
 
-	strlcpy(tlsdev->name, "chtls", TLS_DEVICE_NAME_MAX);
+	strlcpy(tlsdev->name, "chtls", TLS_TOE_DEVICE_NAME_MAX);
 	strlcat(tlsdev->name, cdev->lldi->ports[0]->name,
-		TLS_DEVICE_NAME_MAX);
+		TLS_TOE_DEVICE_NAME_MAX);
 	tlsdev->feature = chtls_inline_feature;
 	tlsdev->hash = chtls_create_hash;
 	tlsdev->unhash = chtls_destroy_hash;
 	tlsdev->release = chtls_dev_release;
 	kref_init(&tlsdev->kref);
-	tls_register_device(tlsdev);
+	tls_toe_register_device(tlsdev);
 	cdev->cdev_state = CHTLS_CDEV_STATE_UP;
 }
 
diff --git a/include/net/tls_toe.h b/include/net/tls_toe.h
index 81b66c76b31f..b56d30a5bd6d 100644
--- a/include/net/tls_toe.h
+++ b/include/net/tls_toe.h
@@ -36,7 +36,7 @@
 
 struct sock;
 
-#define TLS_DEVICE_NAME_MAX		32
+#define TLS_TOE_DEVICE_NAME_MAX		32
 
 /*
  * This structure defines the routines for Inline TLS driver.
@@ -45,29 +45,29 @@ struct sock;
  *
  * @name: Its the name of registered Inline tls device
  * @dev_list: Inline tls device list
- * int (*feature)(struct tls_device *device);
+ * int (*feature)(struct tls_toe_device *device);
  *     Called to return Inline TLS driver capability
  *
- * int (*hash)(struct tls_device *device, struct sock *sk);
+ * int (*hash)(struct tls_toe_device *device, struct sock *sk);
  *     This function sets Inline driver for listen and program
  *     device specific functioanlity as required
  *
- * void (*unhash)(struct tls_device *device, struct sock *sk);
+ * void (*unhash)(struct tls_toe_device *device, struct sock *sk);
  *     This function cleans listen state set by Inline TLS driver
  *
  * void (*release)(struct kref *kref);
  *     Release the registered device and allocated resources
- * @kref: Number of reference to tls_device
+ * @kref: Number of reference to tls_toe_device
  */
-struct tls_device {
-	char name[TLS_DEVICE_NAME_MAX];
+struct tls_toe_device {
+	char name[TLS_TOE_DEVICE_NAME_MAX];
 	struct list_head dev_list;
-	int  (*feature)(struct tls_device *device);
-	int  (*hash)(struct tls_device *device, struct sock *sk);
-	void (*unhash)(struct tls_device *device, struct sock *sk);
+	int  (*feature)(struct tls_toe_device *device);
+	int  (*hash)(struct tls_toe_device *device, struct sock *sk);
+	void (*unhash)(struct tls_toe_device *device, struct sock *sk);
 	void (*release)(struct kref *kref);
 	struct kref kref;
 };
 
-void tls_register_device(struct tls_device *device);
-void tls_unregister_device(struct tls_device *device);
+void tls_toe_register_device(struct tls_toe_device *device);
+void tls_toe_unregister_device(struct tls_toe_device *device);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index a19c6a1e034a..a1203807a3ef 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -657,8 +657,8 @@ static void tls_hw_sk_destruct(struct sock *sk)
 
 static int tls_hw_prot(struct sock *sk)
 {
+	struct tls_toe_device *dev;
 	struct tls_context *ctx;
-	struct tls_device *dev;
 	int rc = 0;
 
 	spin_lock_bh(&device_spinlock);
@@ -688,7 +688,7 @@ static int tls_hw_prot(struct sock *sk)
 static void tls_hw_unhash(struct sock *sk)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
-	struct tls_device *dev;
+	struct tls_toe_device *dev;
 
 	spin_lock_bh(&device_spinlock);
 	list_for_each_entry(dev, &device_list, dev_list) {
@@ -707,7 +707,7 @@ static void tls_hw_unhash(struct sock *sk)
 static int tls_hw_hash(struct sock *sk)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
-	struct tls_device *dev;
+	struct tls_toe_device *dev;
 	int err;
 
 	err = ctx->sk_proto->hash(sk);
@@ -878,21 +878,21 @@ static size_t tls_get_info_size(const struct sock *sk)
 	return size;
 }
 
-void tls_register_device(struct tls_device *device)
+void tls_toe_register_device(struct tls_toe_device *device)
 {
 	spin_lock_bh(&device_spinlock);
 	list_add_tail(&device->dev_list, &device_list);
 	spin_unlock_bh(&device_spinlock);
 }
-EXPORT_SYMBOL(tls_register_device);
+EXPORT_SYMBOL(tls_toe_register_device);
 
-void tls_unregister_device(struct tls_device *device)
+void tls_toe_unregister_device(struct tls_toe_device *device)
 {
 	spin_lock_bh(&device_spinlock);
 	list_del(&device->dev_list);
 	spin_unlock_bh(&device_spinlock);
 }
-EXPORT_SYMBOL(tls_unregister_device);
+EXPORT_SYMBOL(tls_toe_unregister_device);
 
 static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.name			= "tls",
-- 
2.21.0

