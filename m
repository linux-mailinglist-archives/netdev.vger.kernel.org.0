Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AF6533BC7
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiEYLbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiEYLb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:31:29 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371BC77F34;
        Wed, 25 May 2022 04:31:28 -0700 (PDT)
Received: from HP-EliteBook-840-G7.. (1-171-87-66.dynamic-ip.hinet.net [1.171.87.66])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id F10703F165;
        Wed, 25 May 2022 11:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1653478285;
        bh=BmDFlIfQNeKeHtrDmolTavZYGTvT+TUesJSYirKtAaI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=pRQ406eTMOuz4yuL4zmc4uUjumHmaZePHZCc/n+zE7FQtE0E3QPq+yyk5tAdT8UGz
         9j5j+5xG695h3ORKgUR+cdewUFXXC0On//JQzJ5Jvipvlcbd9KKy5Nwfa7R0geMpq/
         Sa8CR4DuwhGjZhWJeBQZieKbXjD4msrU+IYDaFGQHRjKbh8L2Fn+E8KWv6hyj3mfs+
         JCPKa5pWQgwGZ6+XKJYQa21gA+WmBSw2ZWkUnTqQYqwiFNcFFgYMqsq53GTzu+YIL/
         5GItUNJTuhIqfnNNPXRVdM+us4gMM5VrM6089xAKSgD+DkxyQs7i5iQNChtM+jEMFa
         NsAx17Mt72OdA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     mateusz.palczewski@intel.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] igb: Remove duplicate defines
Date:   Wed, 25 May 2022 19:31:12 +0800
Message-Id: <20220525113113.171746-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need to define same thing twice.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/igb/e1000_defines.h | 3 ---
 drivers/net/ethernet/intel/igb/e1000_regs.h    | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_defines.h b/drivers/net/ethernet/intel/igb/e1000_defines.h
index ca5429774994e..fa028928482fc 100644
--- a/drivers/net/ethernet/intel/igb/e1000_defines.h
+++ b/drivers/net/ethernet/intel/igb/e1000_defines.h
@@ -1033,9 +1033,6 @@
 #define E1000_VFTA_ENTRY_MASK                0x7F
 #define E1000_VFTA_ENTRY_BIT_SHIFT_MASK      0x1F
 
-/* DMA Coalescing register fields */
-#define E1000_PCIEMISC_LX_DECISION      0x00000080 /* Lx power on DMA coal */
-
 /* Tx Rate-Scheduler Config fields */
 #define E1000_RTTBCNRC_RS_ENA		0x80000000
 #define E1000_RTTBCNRC_RF_DEC_MASK	0x00003FFF
diff --git a/drivers/net/ethernet/intel/igb/e1000_regs.h b/drivers/net/ethernet/intel/igb/e1000_regs.h
index 9cb49980ec2d1..eb9f6da9208a6 100644
--- a/drivers/net/ethernet/intel/igb/e1000_regs.h
+++ b/drivers/net/ethernet/intel/igb/e1000_regs.h
@@ -116,7 +116,6 @@
 #define E1000_DMCRTRH	0x05DD0 /* Receive Packet Rate Threshold */
 #define E1000_DMCCNT	0x05DD4 /* Current Rx Count */
 #define E1000_FCRTC	0x02170 /* Flow Control Rx high watermark */
-#define E1000_PCIEMISC	0x05BB8 /* PCIE misc config register */
 
 /* TX Rate Limit Registers */
 #define E1000_RTTDQSEL	0x3604 /* Tx Desc Plane Queue Select - WO */
-- 
2.34.1

