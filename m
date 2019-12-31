Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F3D12D890
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 13:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfLaMPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 07:15:05 -0500
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:47287 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbfLaMPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 07:15:05 -0500
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id 9B090C11CA;
        Tue, 31 Dec 2019 04:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1577794504;
        bh=onNcOtUEX/zIEEAvwaoCl+rxnLUnBOLHpAJdysmerrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=UsaSFHoQTho/5C/QoTDfr1epvsASQLmCpGsscrprTR0ZdqHQmakdY///I36nciJHg
         Wxy+4+nYn7XyoxJvp8qU9B4stSnf6Yl3cdZlfr0F3TT0nKsEyNLved8+/0KNgvXWps
         KFTukRamTzcm18MYv0u1boRIXeJGpSeAVRKu48A4=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, aroulin@cumulusnetworks.com
Subject: [PATCH iproute2-next v3 1/2] include/uapi: update bonding kernel header
Date:   Tue, 31 Dec 2019 04:15:01 -0800
Message-Id: <1577794502-8063-2-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1577794502-8063-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1577794502-8063-1-git-send-email-aroulin@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel now exports the LACP bond slave state definitions in the
uapi. This commit updates the iproute2 bonding uapi to include these
changes.

Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
---
 include/uapi/linux/if_bonding.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
index 6829213a..45f3750a 100644
--- a/include/uapi/linux/if_bonding.h
+++ b/include/uapi/linux/if_bonding.h
@@ -96,14 +96,14 @@
 #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
 
 /* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
-#define AD_STATE_LACP_ACTIVITY   0x1
-#define AD_STATE_LACP_TIMEOUT    0x2
-#define AD_STATE_AGGREGATION     0x4
-#define AD_STATE_SYNCHRONIZATION 0x8
-#define AD_STATE_COLLECTING      0x10
-#define AD_STATE_DISTRIBUTING    0x20
-#define AD_STATE_DEFAULTED       0x40
-#define AD_STATE_EXPIRED         0x80
+#define LACP_STATE_LACP_ACTIVITY   0x1
+#define LACP_STATE_LACP_TIMEOUT    0x2
+#define LACP_STATE_AGGREGATION     0x4
+#define LACP_STATE_SYNCHRONIZATION 0x8
+#define LACP_STATE_COLLECTING      0x10
+#define LACP_STATE_DISTRIBUTING    0x20
+#define LACP_STATE_DEFAULTED       0x40
+#define LACP_STATE_EXPIRED         0x80
 
 typedef struct ifbond {
 	__s32 bond_mode;
-- 
2.20.1

