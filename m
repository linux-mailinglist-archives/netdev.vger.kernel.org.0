Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169A3579F56
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243526AbiGSNNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243500AbiGSNNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:13:32 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D965120B1;
        Tue, 19 Jul 2022 05:30:18 -0700 (PDT)
X-QQ-mid: bizesmtp82t1658233738tg1qho8c
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 19 Jul 2022 20:28:57 +0800 (CST)
X-QQ-SSF: 01000000002000F0U000C00A0000020
X-QQ-FEAT: DoD8xN2rKozhiQNtJHhOlHcWfNXQgthF76gR62nSuR1BQTbE1ZbBHWLk/AJ8s
        3j545u/dr3eNqhYXeYVm2v+4KNQyOOWslAx7CTrKPP2O1NvncR0wIt3AhiBw+gAbYWOUkx8
        CvjypKcwNVCjo9V4rrUuk9rWeXRoSUTSeiK3uFPh2aMVQGxlMejZiQIqtVxSaipvo03yHDK
        lhFAzTAsZOdbEeSnc/tHCCDnDYtpwh/mesTjJiZ3PXQsdAAwTIpShY0osvIQds5KVrNm226
        W3xgeqWdhka821B6mpJ5ukHNT4uDC7ypa8iKpfBIrxL9iLWl4lo6Gq9jzOZ7xJ7pKaLV67k
        +ACoW+kbIpHJbWEUv0jYSZtT4fNudrcdmJLjEYso2+fB2R5i3XpGatvKFRVGCFnBkasWU1N
        AtDwevQ/f8k=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     svens@linux.ibm.com
Cc:     wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] s390/net: Fix comment typo
Date:   Sat, 16 Jul 2022 12:27:00 +0800
Message-Id: <20220716042700.39915-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/s390/net/qeth_core_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9e54fe76a9b2..35d4b398c197 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3565,7 +3565,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 			if (!atomic_read(&queue->set_pci_flags_count)) {
 				/*
 				 * there's no outstanding PCI any more, so we
-				 * have to request a PCI to be sure the the PCI
+				 * have to request a PCI to be sure the PCI
 				 * will wake at some time in the future then we
 				 * can flush packed buffers that might still be
 				 * hanging around, which can happen if no
-- 
2.35.1

