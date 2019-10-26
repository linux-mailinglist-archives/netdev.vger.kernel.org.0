Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFE9E6002
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 01:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfJZXil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 19:38:41 -0400
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:59082 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbfJZXil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 19:38:41 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Oct 2019 19:38:41 EDT
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id 51CBAC11F3;
        Sat, 26 Oct 2019 16:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1572132599;
        bh=pkAz0WE/s3tl8F7pNQZuqYUs/GdCWf2SFOKTiyO+onc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=KEZA+X0BWeWAWQvD/+EC2cFpdchP3ecRcje7CV7j5Ik1/NErkrNndTpUN5IUve059
         D4pY6AszJheJOxQlwqmXKhzVW0GoTnkLvdsRb/PRlhiBkLXl4KV9JaLGZF9R3dLllV
         q/1+VAT7ts38DRIHPjdffFj0UlrvOxNkCNmgvDX8=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net
Subject: [PATCH iproute2-next 2/3] include/uapi: update bonding kernel header
Date:   Sat, 26 Oct 2019 16:29:53 -0700
Message-Id: <1572132594-2006-3-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572132594-2006-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1572132594-2006-1-git-send-email-aroulin@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel now exports the 802.3ad bond slave state definitions
in uapi. This commit updates the iproute2 bonding uapi to include
these changes.

Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 include/uapi/linux/if_bonding.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
index 790585f0..6829213a 100644
--- a/include/uapi/linux/if_bonding.h
+++ b/include/uapi/linux/if_bonding.h
@@ -95,6 +95,16 @@
 #define BOND_XMIT_POLICY_ENCAP23	3 /* encapsulated layer 2+3 */
 #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
 
+/* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
+#define AD_STATE_LACP_ACTIVITY   0x1
+#define AD_STATE_LACP_TIMEOUT    0x2
+#define AD_STATE_AGGREGATION     0x4
+#define AD_STATE_SYNCHRONIZATION 0x8
+#define AD_STATE_COLLECTING      0x10
+#define AD_STATE_DISTRIBUTING    0x20
+#define AD_STATE_DEFAULTED       0x40
+#define AD_STATE_EXPIRED         0x80
+
 typedef struct ifbond {
 	__s32 bond_mode;
 	__s32 num_slaves;
-- 
2.20.1

