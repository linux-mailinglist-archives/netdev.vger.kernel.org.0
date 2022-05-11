Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2FF52331D
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242024AbiEKM3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiEKM3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:29:09 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B551FD847;
        Wed, 11 May 2022 05:29:05 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id E29D83F616;
        Wed, 11 May 2022 12:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1652272143;
        bh=BmDFlIfQNeKeHtrDmolTavZYGTvT+TUesJSYirKtAaI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=ERQih4Y3mFWFLZjpVZZlfw3n4PzKo5NAB/s8126P5SHo+sXYQ1blcPlSPNR+suBUM
         Za5ott4oG9OtIZkfIXF0/pPjYbhu2qIvRiRCush0P4RWmhsgQNmOAFbD7Qt4l4cTEn
         tQVLI8nyCBY8uYzamON/EI/TX1jPYhosRV2hxfBnCUxJ1UfWrMln9V/3Fy+f9IVqap
         5EDnPcKXnCyKtsEN5xrzmVCVgI9SoHNrwLqYlswCgKpLyr3RuK8fio3CqV+zyhf5X4
         lnOACtB0VjI033GbmDPLeHlVcIC1eSzVFpz/OcHg2G9qYjd6gKCR2GbUNojGCryHoL
         laBC9RbMCbMLA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] igb: Remove duplicate defines
Date:   Wed, 11 May 2022 20:28:04 +0800
Message-Id: <20220511122806.2146847-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

