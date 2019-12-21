Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF71E12896E
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 15:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfLUOO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 09:14:59 -0500
Received: from smtp7.web4u.cz ([81.91.87.87]:51178 "EHLO mx-8.mail.web4u.cz"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbfLUOO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 09:14:58 -0500
Received: from mx-8.mail.web4u.cz (localhost [127.0.0.1])
        by mx-8.mail.web4u.cz (Postfix) with ESMTP id D0A3D203715;
        Sat, 21 Dec 2019 15:07:59 +0100 (CET)
Received: from thor.pikron.com (unknown [89.102.8.6])
        (Authenticated sender: ppisa@pikron.com)
        by mx-8.mail.web4u.cz (Postfix) with ESMTPA id 0D78C2036F8;
        Sat, 21 Dec 2019 15:07:59 +0100 (CET)
From:   pisa@cmp.felk.cvut.cz
To:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com, Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v3 1/6] dt-bindings: vendor-prefix: add prefix for Czech Technical University in Prague.
Date:   Sat, 21 Dec 2019 15:07:30 +0100
Message-Id: <af3f3bef1a82dff51316fdbcba518e5658808ed8.1576922226.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
X-W4U-Auth: 0a68a86f2ad0e130bf77c748cfe62e4e10ad1703
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 967e78c5ec0a..dedb10f1b250 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -215,6 +215,8 @@ patternProperties:
     description: Hangzhou C-SKY Microsystems Co., Ltd
   "^csq,.*":
     description: Shenzen Chuangsiqi Technology Co.,Ltd.
+  "^ctu,.*":
+    description: Czech Technical University in Prague
   "^cubietech,.*":
     description: Cubietech, Ltd.
   "^cypress,.*":
-- 
2.11.0

