Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBDC52FB80
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354943AbiEULOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353244AbiEULNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:13:51 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA2EF74B2;
        Sat, 21 May 2022 04:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lfkmiRjm0rrMRH5/qVszM4Nbsakjf+VgxH/LVjz5wvc=;
  b=N7ZFZHpoZF5kMF0I8jm8ws+3zweEwjnhZYpBt2bhpPPocUnCD1JpjWeT
   ASHxqX7uwDLUNLUvBn4Go3/TuLmQ2HpB2BD3mGe4m3zrLrKi+Xxs0By9K
   6OFHNBJUjtMBmtS2v0kZJpm12cLg4Gb14gd6/zhvqfY5WRls9EUq6RfS5
   c=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727986"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:12:06 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Ariel Elior <aelior@marvell.com>
Cc:     kernel-janitors@vger.kernel.org,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] qed: fix typos in comments
Date:   Sat, 21 May 2022 13:11:28 +0200
Message-Id: <20220521111145.81697-78-Julia.Lawall@inria.fr>
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
 drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.h      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h
index 9d5a0c9e1ca0..f6cd1b3efdfd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h
@@ -1282,7 +1282,7 @@ void qed_dbg_mcp_trace_set_meta_data(struct qed_hwfn *p_hwfn,
  * @results_buf_size: (OUT) required buffer size (in bytes) for the parsed
  *                    results.
  *
- * Return: Rrror if the parsing fails, ok otherwise.
+ * Return: Error if the parsing fails, ok otherwise.
  */
 enum dbg_status qed_get_mcp_trace_results_buf_size(struct qed_hwfn *p_hwfn,
 						   u32 *dump_buf,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.h b/drivers/net/ethernet/qlogic/qed/qed_vf.h
index 306b5f4bc632..2bd51a41ce8d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.h
@@ -225,7 +225,7 @@ struct pfvf_start_queue_resp_tlv {
 };
 
 /* Extended queue information - additional index for reference inside qzone.
- * If commmunicated between VF/PF, each TLV relating to queues should be
+ * If communicated between VF/PF, each TLV relating to queues should be
  * extended by one such [or have a future base TLV that already contains info].
  */
 struct vfpf_qid_tlv {

