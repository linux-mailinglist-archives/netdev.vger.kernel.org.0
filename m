Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D80E3FA7C8
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 23:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhH1WAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 18:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbhH1WAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 18:00:01 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC8DC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:59:10 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ia27so22009792ejc.10
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VGnmtlcjHUezYqG96iu1zumTRfdJVY6I+SlOl6TspFc=;
        b=b9C9DZe/Gr7J38HXGyE+4Q4WNiJZQ2DuAGzYAq+F/6l1BpHVG61iOVm2RDaxwfVz51
         cy+8UO03ngvmVDKtkxblxhmbWoPBxo81GMuJ2Mhey0XVJMtkepEUMCYu2t8VigG8S00F
         BKptRpHIAAO+nwvMQFWQYLnu/FQTOb6UXEK1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VGnmtlcjHUezYqG96iu1zumTRfdJVY6I+SlOl6TspFc=;
        b=hTogaYAwuSP/AjKqYqSw6LkCu86ZPezCx4Kt0lFUXLSfO400su65xkvb3LNkEffli1
         9IKm1qXdGPv+YqRx2dnoYbF+OGKt4J1jdHXWdkNoQ5v5zNYNPZ1sd13GgdIRCpqIdxmu
         OWEBrKWCGiksyvkFTnc+P52FN0NgxzmLdSQzXfZfenhkEJqjpYDJ8k7O4U760X7MQaEb
         mbV/+EspBI178LHIjgeVO/Nrume4B7pVHAY0A+Pg5iRimuErETIR+y6IyJkmcefnJj5F
         U5qX8GR2t8sGWf3Dhxsg0fdT78tqvHW3lcscqtYfQSkInu9gZglF0nBnWYA1+yCJQaPL
         Mvkg==
X-Gm-Message-State: AOAM533BIOFC0wX7y5GE4OKzjR5/skPZ4CTB1fijXRStkrfjOrEumDP3
        tTx/B4bWE9NoQOQayFif4ONG9Q==
X-Google-Smtp-Source: ABdhPJxJ/xzXitYNU0BJWFn2zkqnov3w7ZXSB70b04AEnaAZU0tM24kx5Lubj+mRL/BSzytvP8OW/Q==
X-Received: by 2002:a17:907:10cc:: with SMTP id rv12mr16822955ejb.423.1630187948500;
        Sat, 28 Aug 2021 14:59:08 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cf11sm5361239edb.65.2021.08.28.14.59.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Aug 2021 14:59:07 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next 10/11] bnxt_en: remove legacy HWRM interface
Date:   Sat, 28 Aug 2021 17:58:29 -0400
Message-Id: <1630187910-22252-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
References: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a063c105caa5b5e8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000a063c105caa5b5e8

From: Edwin Peer <edwin.peer@broadcom.com>

There are no longer any callers relying on the old API.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 18 +----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 -
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 77 -------------------
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.h    | 10 ---
 4 files changed, 1 insertion(+), 106 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f5175f53f39b..3e0edd04a071 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3956,29 +3956,13 @@ static int bnxt_alloc_vnic_attributes(struct bnxt *bp)
 
 static void bnxt_free_hwrm_resources(struct bnxt *bp)
 {
-	struct pci_dev *pdev = bp->pdev;
-
-	if (bp->hwrm_cmd_resp_addr) {
-		dma_free_coherent(&pdev->dev, PAGE_SIZE, bp->hwrm_cmd_resp_addr,
-				  bp->hwrm_cmd_resp_dma_addr);
-		bp->hwrm_cmd_resp_addr = NULL;
-	}
-
 	dma_pool_destroy(bp->hwrm_dma_pool);
 	bp->hwrm_dma_pool = NULL;
 }
 
 static int bnxt_alloc_hwrm_resources(struct bnxt *bp)
 {
-	struct pci_dev *pdev = bp->pdev;
-
-	bp->hwrm_cmd_resp_addr = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
-						   &bp->hwrm_cmd_resp_dma_addr,
-						   GFP_KERNEL);
-	if (!bp->hwrm_cmd_resp_addr)
-		return -ENOMEM;
-
-	bp->hwrm_dma_pool = dma_pool_create("bnxt_hwrm", &pdev->dev,
+	bp->hwrm_dma_pool = dma_pool_create("bnxt_hwrm", &bp->pdev->dev,
 					    BNXT_HWRM_DMA_SIZE,
 					    BNXT_HWRM_DMA_ALIGN, 0);
 	if (!bp->hwrm_dma_pool)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index abad4c4774f8..8414182fe953 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1881,8 +1881,6 @@ struct bnxt {
 	u16			hwrm_cmd_seq;
 	u16                     hwrm_cmd_kong_seq;
 	u16			hwrm_intr_seq_id;
-	void			*hwrm_cmd_resp_addr;
-	dma_addr_t		hwrm_cmd_resp_dma_addr;
 	struct dma_pool		*hwrm_dma_pool;
 
 	struct rtnl_link_stats64	net_stats_prev;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index b246a0dd3011..92529b466127 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -24,17 +24,6 @@
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
 
-void bnxt_hwrm_cmd_hdr_init(struct bnxt *bp, void *request, u16 req_type,
-			    u16 cmpl_ring, u16 target_id)
-{
-	struct input *req = request;
-
-	req->req_type = cpu_to_le16(req_type);
-	req->cmpl_ring = cpu_to_le16(cmpl_ring);
-	req->target_id = cpu_to_le16(target_id);
-	req->resp_addr = cpu_to_le64(bp->hwrm_cmd_resp_dma_addr);
-}
-
 static u64 hwrm_calc_sentinel(struct bnxt_hwrm_ctx *ctx, u16 req_type)
 {
 	return (((u64)ctx) + req_type) ^ BNXT_HWRM_SENTINEL;
@@ -587,72 +576,6 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	return rc;
 }
 
-static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
-				 int timeout, bool silent)
-{
-	struct bnxt_hwrm_ctx default_ctx = {0};
-	struct bnxt_hwrm_ctx *ctx = &default_ctx;
-	struct input *req = msg;
-	int rc;
-
-	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
-	    msg_len > BNXT_HWRM_MAX_REQ_LEN) {
-		rc = __hwrm_req_init(bp, (void **)&req,
-				     le16_to_cpu(req->req_type), msg_len);
-		if (rc)
-			return rc;
-		memcpy(req, msg, msg_len); /* also copies resp_addr */
-		ctx = __hwrm_ctx(bp, (u8 *)req);
-		/* belts and brances, NULL ctx shouldn't be possible here */
-		if (!ctx)
-			return -ENOMEM;
-	}
-
-	ctx->req = req;
-	ctx->req_len = msg_len;
-	ctx->resp = bp->hwrm_cmd_resp_addr;
-	/* global response is not reallocated __GFP_ZERO between requests */
-	ctx->flags = BNXT_HWRM_INTERNAL_RESP_DIRTY;
-	ctx->timeout = timeout ?: DFLT_HWRM_CMD_TIMEOUT;
-	if (silent)
-		ctx->flags |= BNXT_HWRM_CTX_SILENT;
-
-	/* will consume req if allocated with __hwrm_req_init() */
-	return __hwrm_send(bp, ctx);
-}
-
-int _hwrm_send_message(struct bnxt *bp, void *msg, u32 msg_len, int timeout)
-{
-	return bnxt_hwrm_do_send_msg(bp, msg, msg_len, timeout, false);
-}
-
-int _hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 msg_len,
-			      int timeout)
-{
-	return bnxt_hwrm_do_send_msg(bp, msg, msg_len, timeout, true);
-}
-
-int hwrm_send_message(struct bnxt *bp, void *msg, u32 msg_len, int timeout)
-{
-	int rc;
-
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, msg, msg_len, timeout);
-	mutex_unlock(&bp->hwrm_cmd_lock);
-	return rc;
-}
-
-int hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 msg_len,
-			     int timeout)
-{
-	int rc;
-
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = bnxt_hwrm_do_send_msg(bp, msg, msg_len, timeout, true);
-	mutex_unlock(&bp->hwrm_cmd_lock);
-	return rc;
-}
-
 /**
  * hwrm_req_send() - Execute an HWRM command.
  * @bp: The driver context.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index b3af7a88e2c7..39032cf66258 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -114,11 +114,6 @@ static inline bool bnxt_kong_hwrm_message(struct bnxt *bp, struct input *req)
 		 le16_to_cpu(req->target_id) == HWRM_TARGET_ID_KONG));
 }
 
-static inline void *bnxt_get_hwrm_resp_addr(struct bnxt *bp, void *req)
-{
-	return bp->hwrm_cmd_resp_addr;
-}
-
 static inline u16 bnxt_get_hwrm_seq_id(struct bnxt *bp, u16 dst)
 {
 	u16 seq_id;
@@ -130,11 +125,6 @@ static inline u16 bnxt_get_hwrm_seq_id(struct bnxt *bp, u16 dst)
 	return seq_id;
 }
 
-void bnxt_hwrm_cmd_hdr_init(struct bnxt *, void *, u16, u16, u16);
-int _hwrm_send_message(struct bnxt *bp, void *msg, u32 len, int timeout);
-int _hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 len, int timeout);
-int hwrm_send_message(struct bnxt *bp, void *msg, u32 len, int timeout);
-int hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 len, int timeout);
 int __hwrm_req_init(struct bnxt *bp, void **req, u16 req_type, u32 req_len);
 #define hwrm_req_init(bp, req, req_type) \
 	__hwrm_req_init((bp), (void **)&(req), (req_type), sizeof(*(req)))
-- 
2.18.1


--000000000000a063c105caa5b5e8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKxNjSmEGfb6yjvBwtP09dG/HROl2QZg
iphNuHKnrp7hMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
ODIxNTkwOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQALh/MhmEhn4gIEX5AQ8b/Xt/1282LIlgae+yZ9UDDW8U54veLC
sH+EoyKkJCZ56GTJCa1X1QqxcExLWIreHhjgLzUPDvh3MW/06UMQGt/w/ezw+ZMpcIkzJkdsA+vT
3hmAKzcqKVZ7tJSiwvrk6xrfiDjt6rfBSWZ6jD8yr/CsMSjYNYGike7DV8fcRvXYhdWZqOxtuq6R
pWwJ3ZcYZs2BuJuoHe8bOTIOpVOP2AzGZWBpvPEEWNJMtSO/ycK16NeOYRwfJTqOaR3AJHmHCxfe
PR87Iw5LwW4GICQSJOiAAru7UyXncFmhya3Vr1JNpMf6ehuXQJTxEd7r/egA9vVN
--000000000000a063c105caa5b5e8--
