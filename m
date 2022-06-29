Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DAD56031C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiF2Oes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbiF2Oep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:34:45 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C702EA28;
        Wed, 29 Jun 2022 07:34:40 -0700 (PDT)
X-QQ-mid: bizesmtp65t1656513261tfud432q
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 22:34:18 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: ZHWZeLXy+8dy2IPb5OrWCa7omzZetmReOw5KuLhq7YQxXkAo7SR+PHOoaDvKU
        tUFDiqbQI3GkZT6YgApcsrxmjwJb4uLxtqV5Bv53DZuEAfYK8/CmwXTobt/862lIH1d+uJd
        1Z0J5647yZEtbmnfxYC6RUG6d81i9snZXXXqzVaQXlTNYO0Y12vsqTKcoxlfu2J24kqdCfs
        wym840SOmrv5ONKjCnXGJUb4XvOdRfvOUg9Mb1m/ZtPVov2lPVJtJV7nTFhahNiEOIKUUql
        bwMfSz+tTaBFQM9yexG53DRBM2ZNOpoWzKhb856YeuRIVmIpdG0/cNW1oh4QY+Kzparago+
        j2OEtkB5XTeVNml37g=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/ixgbevf:fix repeated words in comments
Date:   Wed, 29 Jun 2022 22:34:01 +0800
Message-Id: <20220629143401.20380-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'slot'.
Delete the redundant word 'we'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 55b87bc3a938..2f12fbe229c1 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4787,7 +4787,7 @@ static pci_ers_result_t ixgbevf_io_error_detected(struct pci_dev *pdev,
 		pci_disable_device(pdev);
 	rtnl_unlock();
 
-	/* Request a slot slot reset. */
+	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c
index 68fc32e36e88..1641d00d8ed3 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -964,7 +964,7 @@ int ixgbevf_get_queues(struct ixgbe_hw *hw, unsigned int *num_tcs,
 	if (!err) {
 		msg[0] &= ~IXGBE_VT_MSGTYPE_CTS;
 
-		/* if we we didn't get an ACK there must have been
+		/* if we didn't get an ACK there must have been
 		 * some sort of mailbox error so we should treat it
 		 * as such
 		 */
-- 
2.36.1

