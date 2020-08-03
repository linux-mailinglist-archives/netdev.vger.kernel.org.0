Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C3023AC85
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgHCSjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCSjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:39:48 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2E4AC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:39:47 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 073IcuPL033386;
        Mon, 3 Aug 2020 20:38:56 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 073Ictfi004171;
        Mon, 3 Aug 2020 20:38:55 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 073IctFg004169;
        Mon, 3 Aug 2020 20:38:55 +0200
From:   pisa@cmp.felk.cvut.cz
To:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        mkl@pengutronix.de, socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, c.emde@osadl.org, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.jerabek01@gmail.com, ondrej.ille@gmail.com,
        jnovak@fel.cvut.cz, jara.beran@gmail.com, porazil@pikron.com,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v4 1/6] dt-bindings: vendor-prefix: add prefix for the Czech Technical University in Prague.
Date:   Mon,  3 Aug 2020 20:34:49 +0200
Message-Id: <3b6869aa7a48b61f8a800d141d164b70222e33af.1596408856.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
References: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 073IcuPL033386
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.098, required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.40,
        SPF_HELO_NONE 0.00, SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1597084737.56782@nw6tP7bx/TslGXiyZRmK2Q
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

Following text added to make checkpatch happy.

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

