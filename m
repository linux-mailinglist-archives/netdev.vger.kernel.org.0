Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC50050D37F
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbiDXQdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235203AbiDXQcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:32:48 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A229F39D;
        Sun, 24 Apr 2022 09:29:48 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id C9B2730B294C;
        Sun, 24 Apr 2022 18:29:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:date:from
        :from:in-reply-to:message-id:mime-version:references:reply-to
        :subject:subject:to:to; s=felkmail; bh=2Oe7LSiwBmNwhJ/UY1qjyHq4V
        hkxUAYZ7Yp2XEydlQQ=; b=qmVZdLSEVIj2rkS904OFENQayxlVVa10ZOamW+B32
        Vjj/PaAjnUolrmq1663Bh1NvYjYvG6NJCQ+aJMH8rFHMWUDJdu92WsKtVX9fGAd8
        YSH09X2rKlYhCVSVnq4oixgjXtbO45NSExTE7etwK0wY9pOvv+NPgxLNzPsmCbhi
        KDWGIc1JgGLiD15o5YerALJZjDLJRWMeF/qlmsqx7YrpOe3AWpGPs+wUnEB1CpEC
        aYAIM4+Oe3fXHsTzDFIFdsFfJ0zKRCeerXTOmLHO6lfyTbdIEKOpMTvBuHDDI/ys
        yAjVBt5Q3+1pZcRclxJKZy0c8Yvoqxnx7dBD1r83+FLGQ==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 6C18930ADC00;
        Sun, 24 Apr 2022 18:29:46 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23OGTkoh030973;
        Sun, 24 Apr 2022 18:29:46 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23OGTknT030972;
        Sun, 24 Apr 2022 18:29:46 +0200
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v1 3/4] can: ctucanfd: Remove unused including <linux/version.h>
Date:   Sun, 24 Apr 2022 18:28:10 +0200
Message-Id: <0671ef23de7457202613acf8743540a571103a20.1650816929.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Eliminate the follow versioncheck warning:

./drivers/net/can/ctucanfd/ctucanfd_base.c: 34 linux/version.h not
needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index a1f6d37fca11..2ada097d1ede 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -31,7 +31,6 @@
 #include <linux/can/error.h>
 #include <linux/can/led.h>
 #include <linux/pm_runtime.h>
-#include <linux/version.h>
 
 #include "ctucanfd.h"
 #include "ctucanfd_kregs.h"
-- 
2.20.1


