Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1627A52FB15
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354911AbiEULM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354423AbiEULMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:39 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BCA36162;
        Sat, 21 May 2022 04:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QPe3ISczFAZ0adoqqo0AJShVG8SLHWNRbndX3z8Gar0=;
  b=AokhO/x5DIoEIEyYm2gzM5fRtI2t65E1IYgOXBDboAEiA1Tdf9FQ5ZhX
   WYJX3h5/HO7gYYed+4JaugSIeLWw0JPZGF+gnSLFkb010j53edy5lelMu
   0h9CK41J4JA7XAqsxoiW1QWb/sQIwV34wJbWj4Jm+sXmwvfSmI3Hz0aA6
   c=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727940"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:59 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Ariel Elior <aelior@marvell.com>
Cc:     kernel-janitors@vger.kernel.org,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: qed: fix typos in comments
Date:   Sat, 21 May 2022 13:10:53 +0200
Message-Id: <20220521111145.81697-43-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spelling mistakes (triple letters) in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 include/linux/qed/qed_fcoe_if.h    |    4 ++--
 include/linux/qed/qed_iscsi_if.h   |    4 ++--
 include/linux/qed/qed_nvmetcp_if.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/qed/qed_fcoe_if.h b/include/linux/qed/qed_fcoe_if.h
index 16752eca5cbd..90e3045b2dcb 100644
--- a/include/linux/qed/qed_fcoe_if.h
+++ b/include/linux/qed/qed_fcoe_if.h
@@ -76,7 +76,7 @@ void qed_fcoe_set_pf_params(struct qed_dev *cdev,
  * @fill_dev_info:	fills FCoE specific information
  *			@param cdev
  *			@param info
- *			@return 0 on sucesss, otherwise error value.
+ *			@return 0 on success, otherwise error value.
  * @register_ops:	register FCoE operations
  *			@param cdev
  *			@param ops - specified using qed_iscsi_cb_ops
@@ -96,7 +96,7 @@ void qed_fcoe_set_pf_params(struct qed_dev *cdev,
  *				connection.
  *			@param p_doorbell - qed will fill the address of the
  *				doorbell.
- *			return 0 on sucesss, otherwise error value.
+ *			return 0 on success, otherwise error value.
  * @release_conn:	release a previously acquired fcoe connection
  *			@param cdev
  *			@param handle - the connection handle.
diff --git a/include/linux/qed/qed_iscsi_if.h b/include/linux/qed/qed_iscsi_if.h
index 494cdc3cd840..fbf7973ae9ba 100644
--- a/include/linux/qed/qed_iscsi_if.h
+++ b/include/linux/qed/qed_iscsi_if.h
@@ -133,7 +133,7 @@ struct qed_iscsi_cb_ops {
  * @fill_dev_info:	fills iSCSI specific information
  *			@param cdev
  *			@param info
- *			@return 0 on sucesss, otherwise error value.
+ *			@return 0 on success, otherwise error value.
  * @register_ops:	register iscsi operations
  *			@param cdev
  *			@param ops - specified using qed_iscsi_cb_ops
@@ -152,7 +152,7 @@ struct qed_iscsi_cb_ops {
  *				connection.
  *			@param p_doorbell - qed will fill the address of the
  *				doorbell.
- *			@return 0 on sucesss, otherwise error value.
+ *			@return 0 on success, otherwise error value.
  * @release_conn:	release a previously acquired iscsi connection
  *			@param cdev
  *			@param handle - the connection handle.
diff --git a/include/linux/qed/qed_nvmetcp_if.h b/include/linux/qed/qed_nvmetcp_if.h
index 1d51df347560..bbfbfba51f37 100644
--- a/include/linux/qed/qed_nvmetcp_if.h
+++ b/include/linux/qed/qed_nvmetcp_if.h
@@ -132,7 +132,7 @@ struct nvmetcp_task_params {
  *				connection.
  *			@param p_doorbell - qed will fill the address of the
  *				doorbell.
- *			@return 0 on sucesss, otherwise error value.
+ *			@return 0 on success, otherwise error value.
  * @release_conn:	release a previously acquired nvmetcp connection
  *			@param cdev
  *			@param handle - the connection handle.

