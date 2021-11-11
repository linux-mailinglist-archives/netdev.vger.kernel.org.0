Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E670C44DB31
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 18:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhKKRmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 12:42:32 -0500
Received: from relay05.th.seeweb.it ([5.144.164.166]:59073 "EHLO
        relay05.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhKKRmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 12:42:32 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2021 12:42:31 EST
Received: from localhost.localdomain (83.6.165.118.neoplus.adsl.tpnet.pl [83.6.165.118])
        by m-r2.th.seeweb.it (Postfix) with ESMTPA id 415D63F1EA;
        Thu, 11 Nov 2021 18:34:11 +0100 (CET)
From:   Konrad Dybcio <konrad.dybcio@somainline.org>
To:     ~postmarketos/upstreaming@lists.sr.ht
Cc:     martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        marijn.suijten@somainline.org, jamipkettunen@somainline.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/ipa: ipa_resource: Fix wrong for loop range
Date:   Thu, 11 Nov 2021 18:34:00 +0100
Message-Id: <20211111173401.551408-1-konrad.dybcio@somainline.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The destrination group count was mistakenly assigned to both dst and src loops.
Fix it to make IPA probe and work again.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
---
 drivers/net/ipa/ipa_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index e3da95d69409..06cec7199382 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -52,7 +52,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 				return false;
 	}
 
-	group_count = data->rsrc_group_src_count;
+	group_count = data->rsrc_group_dst_count;
 	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
 		return false;
 
-- 
2.33.0

