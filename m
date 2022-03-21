Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199D84E3493
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiCUXlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiCUXls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:41:48 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74D23D491;
        Mon, 21 Mar 2022 16:40:21 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 2EA9530AE004;
        Tue, 22 Mar 2022 00:33:22 +0100 (CET)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 7581E30ADC00;
        Tue, 22 Mar 2022 00:33:21 +0100 (CET)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 22LNXLfP014302;
        Tue, 22 Mar 2022 00:33:21 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 22LNXLcA014301;
        Tue, 22 Mar 2022 00:33:21 +0100
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v8 1/7] dt-bindings: vendor-prefix: add prefix for the Czech Technical University in Prague.
Date:   Tue, 22 Mar 2022 00:32:28 +0100
Message-Id: <ff3a7216114fcd83530e70b994ef0e4277ddf000.1647904780.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Czech Technical University in Prague (CTU) is one of
the biggest and oldest (founded 1707) technical universities
in Europe. The abbreviation in Czech language is ČVUT according
to official name in Czech language

  České vysoké učení technické v Praze

The English translation

  The Czech Technical University in Prague

The university pages in English

  https://www.cvut.cz/en

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 294093d45a230..7fa538d5046a4 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -277,6 +277,8 @@ patternProperties:
     description: Hangzhou C-SKY Microsystems Co., Ltd
   "^csq,.*":
     description: Shenzen Chuangsiqi Technology Co.,Ltd.
+  "^ctu,.*":
+    description: Czech Technical University in Prague
   "^cubietech,.*":
     description: Cubietech, Ltd.
   "^cui,.*":
-- 
2.20.1


