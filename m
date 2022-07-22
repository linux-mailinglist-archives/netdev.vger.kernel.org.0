Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EC257DF2C
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiGVJof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236869AbiGVJoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:44:20 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F7C7B5052;
        Fri, 22 Jul 2022 02:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=0Q8GP
        PDGmDxF2peYcEH/PdcCOMB27Z5qAxL7/GEvl9E=; b=pTezgVZrdI/97lhXhEtlE
        GPFO4KUN0l537iUxkz1Vm2Zt/I8X2GlniMP+8pcU4XQG97o6XYSJIGPNi/Ldq+Ng
        obnmtkZb8c7NXxSaevq2hE25maAHEuHeFYLb4Z26Ck2+nRQGYLU5C//WCboUhcpC
        LZmWXVTNLOVesvmk6u50d8=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp1 (Coremail) with SMTP id GdxpCgDn7_cbcNpiRBQqPw--.507S2;
        Fri, 22 Jul 2022 17:38:37 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     borntraeger@linux.ibm.com, svens@linux.ibm.com,
        wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] s390/qeth: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 17:38:34 +0800
Message-Id: <20220722093834.77864-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgDn7_cbcNpiRBQqPw--.507S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUWr1kXFWDKw43Ww15urg_yoWfJrX_K3
        y8KrsFyr4FkF1akw12qrW5ZrWF9348ua4fC39agrWfX34UCw1fXr1vvrs8Gw4UWFsrJFnx
        XF97Ww1F9w1UGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRCRRi7UUUUU==
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBDR5GZFaEKBvfNAAAs7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'the the' with 'the' in the comment.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
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
2.25.1

