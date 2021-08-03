Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383103DEB5C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhHCK4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:56:37 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:43394
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235204AbhHCK4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 06:56:36 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 678F63F237;
        Tue,  3 Aug 2021 10:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627988177;
        bh=yxPaty2Fj2e6kypVOL8AW6aRDjC9TLR/sMRLnpj4poI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=H53X2GtdV+4IPOVm9WB60IjnnvAqmFQ4jGNoetu4mPD0YXwNfpEnCOx1mL8FanQVW
         fVRgKudX22XjAR/Fmhsm0O0ZB4LlHSr5inwn7I2MTU7WDPM+3IK6rRHIl8Pxf1VKJg
         2LjgFG0/TebLRWPnSVyDVFqngtKHgtkSU3OuyFmbcNo9xQhAqHmgxTYi2YH97BOgUr
         kQTNnqGma/Af0Oz/UtBJiddtzdd0nqok21xxozfJT0WHxw3/JdW4yU56zu77csz2fn
         r0vxxmguvTkHjvfqYEic5kepyTfEiArIh2O9/23yo/9YGKKL/eZmfSaO6o9pLZHfwo
         NB3RV7jXQhdWA==
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-af: Fix spelling mistake "Makesure" -> "Make sure"
Date:   Tue,  3 Aug 2021 11:56:17 +0100
Message-Id: <20210803105617.338546-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a NL_SET_ERR_MSG_MOD message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index f95573a66ed4..6f963b2f54a7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1397,7 +1397,7 @@ static int rvu_af_dl_dwrr_mtu_validate(struct devlink *devlink, u32 id,
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Changing DWRR MTU is not supported when there are active NIXLFs");
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Makesure none of the PF/VF interfaces are initialized and retry");
+				   "Make sure none of the PF/VF interfaces are initialized and retry");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.31.1

