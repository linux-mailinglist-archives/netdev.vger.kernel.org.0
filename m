Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57212454CB
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgHOWpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgHOWpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 18:45:42 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A138C0045A2
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:44:35 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 07FJhfIN067970;
        Sat, 15 Aug 2020 21:43:41 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 07FJheDu000365;
        Sat, 15 Aug 2020 21:43:40 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 07FJheoD000364;
        Sat, 15 Aug 2020 21:43:40 +0200
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
        Petr Porazil <porazil@pikron.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v5 1/6] dt-bindings: vendor-prefix: add prefix for the Czech Technical University in Prague.
Date:   Sat, 15 Aug 2020 21:43:03 +0200
Message-Id: <8d0674796f3c4ecfd6fcd66ae79bc3aeb93ace22.1597518433.git.ppisa@pikron.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1597518433.git.ppisa@pikron.com>
References: <cover.1597518433.git.ppisa@pikron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 07FJhfIN067970
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-0.497, required 6, autolearn=not spam, BAYES_00 -0.50,
        KHOP_HELO_FCRDNS 0.00, SPF_HELO_NONE 0.00, SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1598125428.62396@UvFMhKMCQNfAchC8J5Jejg
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
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
2.20.1

