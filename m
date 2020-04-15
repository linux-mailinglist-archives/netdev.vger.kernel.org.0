Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C641AB1FB
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441862AbgDOTrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:47:23 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42385 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406326AbgDOTrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:47:21 -0400
Received: from cust-69a1f852 ([IPv6:fc0c:c154:b0a8:48a5:61f4:988:bf85:2ed5])
        by smtp-cloud8.xs4all.net with ESMTPA
        id Oo0Ajtd1blKa1Oo0BjOFiZ; Wed, 15 Apr 2020 21:47:17 +0200
From:   Antony Antony <antony@phenome.org>
To:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Antony Antony <antony@phenome.org>
Subject: [PATCH] xfrm: fix error in comment
Date:   Wed, 15 Apr 2020 21:47:10 +0200
Message-Id: <20200415194710.32449-1-antony@phenome.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNYxtaTiqbVG89tJkOzqcJizboVuz29auV9T/O2blYDfamt8YERjtHyTTQV01epHkNURSQWQL8wPwJKo7Vw9scHPWOYmDSv1Be0mb4uhVIFHCCPmezzf
 Yc9Eeu7eWiO0w3uyEPkczsSFpsGUTSOWgMunzjXcenMQMJzfqbPVimETTGQw+TeA2IC/Fo5y4URXmqP1oc1aiBcOw7eqWgkOmMY/T3J/d9BC6J7vMeEwM6if
 MFw/DPzvy2ASrhhA3xz+fGRuvTf9IEBmxdprmrYP6YVjqcVb9cfd9rLgSb2Y9mT+E8uXCunKaL/uI/PhzqYZ9VYxraxKu7SYMStpmqTiB0nBRox2mVw/nMfo
 f0WX6lC+
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/xfrm_state_offload/xfrm_user_offload/

Fixes: d77e38e612a ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Antony Antony <antony@phenome.org>
---
 include/uapi/linux/xfrm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 5f3b9fec7b5f..ff7cfdc6cb44 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -304,7 +304,7 @@ enum xfrm_attr_type_t {
 	XFRMA_PROTO,		/* __u8 */
 	XFRMA_ADDRESS_FILTER,	/* struct xfrm_address_filter */
 	XFRMA_PAD,
-	XFRMA_OFFLOAD_DEV,	/* struct xfrm_state_offload */
+	XFRMA_OFFLOAD_DEV,	/* struct xfrm_user_offload */
 	XFRMA_SET_MARK,		/* __u32 */
 	XFRMA_SET_MARK_MASK,	/* __u32 */
 	XFRMA_IF_ID,		/* __u32 */
-- 
2.21.1

