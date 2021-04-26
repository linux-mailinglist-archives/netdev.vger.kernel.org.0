Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FDE36BC64
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 01:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhDZX7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 19:59:53 -0400
Received: from m12-13.163.com ([220.181.12.13]:51729 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhDZX7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 19:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Pj5yLG1cBLVU5iC8Na
        7OQPbY3S9U7b89hUWwACed168=; b=AH6sSiAmv9+EcPUt+XyBmW5lN+Xa6+CtNE
        AcSpnQoHaplRN+ecv5/uML7CtMqlHykfXgSp29Xtai35cjI9ks7PDaVXy6iOC0OY
        POTfEqKtDsg6Q5yrXSlTJ8nuJSriyMEoC25kPlecblSLPjIRh8B9nYpTrbks9HQb
        YEgFT4kDA=
Received: from localhost.localdomain (unknown [101.229.16.77])
        by smtp9 (Coremail) with SMTP id DcCowAAHK328U4dg9aovHw--.40188S2;
        Tue, 27 Apr 2021 07:59:00 +0800 (CST)
From:   qhjindev <qhjin_dev@163.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, gustavoars@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qhjin_dev@163.com
Subject: [PATCH] fddi/skfp: fix typo
Date:   Tue, 27 Apr 2021 07:57:52 +0800
Message-Id: <20210426235752.30816-1-qhjin_dev@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DcCowAAHK328U4dg9aovHw--.40188S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF18XryrtF4UJF15ur43GFg_yoWxCrb_ua
        1UGFnxZrWUCrsIqa1Fk3Z3A345KF4q934kA34agrW3AFnFyw1ay348Wr4xCrs8Zw45uF9r
        CrZ8JF18A3sxKjkaLaAFLSUrUUUU8b8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRNfOz7UUUUU==
X-Originating-IP: [101.229.16.77]
X-CM-SenderInfo: ptkmx0hbgh4qqrwthudrp/1tbiPQSAHFSIkMer8wAAs2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

change 'privae' to 'private'

Signed-off-by: qhjindev <qhjin_dev@163.com>
---
 drivers/net/fddi/skfp/h/smc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/h/smc.h b/drivers/net/fddi/skfp/h/smc.h
index 706fa619b703..3814a2ff64ae 100644
--- a/drivers/net/fddi/skfp/h/smc.h
+++ b/drivers/net/fddi/skfp/h/smc.h
@@ -228,7 +228,7 @@ struct s_phy {
 	u_char timer1_exp ;
 	u_char timer2_exp ;
 	u_char pcm_pad1[1] ;
-	int	cem_pst ;	/* CEM privae state; used for dual homing */
+	int	cem_pst ;	/* CEM private state; used for dual homing */
 	struct lem_counter lem ;
 #ifdef	AMDPLC
 	struct s_plc	plc ;
-- 
2.17.1


