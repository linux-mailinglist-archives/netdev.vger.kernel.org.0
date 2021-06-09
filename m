Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC3B3A10DC
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238588AbhFIKKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:10:04 -0400
Received: from m12-14.163.com ([220.181.12.14]:40393 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234249AbhFIKKC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 06:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=CyN9y
        auZ9A10j7+vRszAOPbzX0M3IqT0uJAzoEoUjPs=; b=SzDGISK4rr1bh3Vb9uCNM
        LTso1KEBhdDNmM8KBcAHM74YHyybqAphNHh/ufM6vgcId5bpAwdx8nT6cvxYracp
        zBsxSmlygYWFb8gywnu6M0gS3MjFu2+Jb3eBuCObPWOWMsoOocR9TzpiFtmGd5dd
        3w70bL451kA8fc21w1pXDQ=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowAB3C2DiksBgXskzNw--.23263S2;
        Wed, 09 Jun 2021 18:07:31 +0800 (CST)
From:   13145886936@163.com
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] wext: fix a misspelling
Date:   Wed,  9 Jun 2021 03:07:24 -0700
Message-Id: <20210609100724.23376-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowAB3C2DiksBgXskzNw--.23263S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtryrtw15trWkKw1rtr15twb_yoW3CrX_Gr
        WxJw1kKFW8JrnavayUuw4xur4jy3y0qa1Fga9xtrySyw4DA3yDt3s5Cr4Utw429w4jyrWf
        C3Z5Jr45tF4fZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUekgA3UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiygOsg1QHMViXDgAAsF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix a misspelling.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/wireless/wext-compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index a8320dc59af7..7ef6fd26450c 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1183,7 +1183,7 @@ static int cfg80211_wext_siwpower(struct net_device *dev,
 		switch (wrq->flags & IW_POWER_MODE) {
 		case IW_POWER_ON:       /* If not specified */
 		case IW_POWER_MODE:     /* If set all mask */
-		case IW_POWER_ALL_R:    /* If explicitely state all */
+		case IW_POWER_ALL_R:    /* If explicitly state all */
 			ps = true;
 			break;
 		default:                /* Otherwise we ignore */
-- 
2.25.1

