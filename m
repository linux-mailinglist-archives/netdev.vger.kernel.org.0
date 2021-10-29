Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9BC440118
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhJ2RUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229826AbhJ2RUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 13:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7396B61039;
        Fri, 29 Oct 2021 17:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635527901;
        bh=nZFDpmWPBTpHlDlFHPqqWfC2kacDIvw63RN0hsLnjzA=;
        h=From:To:Cc:Subject:Date:From;
        b=a5cdaEKCcrB7jOVVY08mprAT/4waGlgwKEGMzPBxhbmrgKuFkBljWBGJUVdC5MzHV
         vWaHOgG7xnI1Me+QR0Je4pDmqWoRLDCdUEEslW/Z1lcJDq5HTT8g1OwTE44F7qbP5g
         r6VFbvpJaKyMiUJbrZ1dgTkDRuudblTOatFuhX7gZhjGbtgrijdE6wrnlysLrH5Y/P
         WCOgh84GZhmVeIrLXpeGVX/WpdV66YhgjAIEXqNUO6W4kpsNs6GUKyr3FIKBsVrP6v
         pxgcltZI1OXfkeuTuprgjC8qz9CI6s0lRIEaJms2q1F/XUaNRmXnEbSt6W+J+rPypV
         y95UINJeu/99A==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] bnxt_en: Remove not used other ULP define
Date:   Fri, 29 Oct 2021 20:18:15 +0300
Message-Id: <3a8ea720b28ec4574648012d2a00208f1144eff5.1635527693.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is only one bnxt ULP in the upstream kernel and definition
for other ULP can be safely removed.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
This is not intrusive version of this patch [1] that will allow us
remove all this indirection.

[1] https://lore.kernel.org/linux-rdma/20210401065715.565226-6-leon@kernel.org/
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 6b4d2556a6df..54d59f681b86 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -11,8 +11,7 @@
 #define BNXT_ULP_H
 
 #define BNXT_ROCE_ULP	0
-#define BNXT_OTHER_ULP	1
-#define BNXT_MAX_ULP	2
+#define BNXT_MAX_ULP	1
 
 #define BNXT_MIN_ROCE_CP_RINGS	2
 #define BNXT_MIN_ROCE_STAT_CTXS	1
-- 
2.31.1

