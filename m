Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D2046C354
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 20:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240736AbhLGTLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 14:11:24 -0500
Received: from spf.hitachienergy.com ([138.225.1.74]:53542 "EHLO
        inet10.abb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231668AbhLGTLX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 14:11:23 -0500
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 1B7J7j3Z023126;
        Tue, 7 Dec 2021 20:07:45 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id 4371865A5AEE;
        Tue,  7 Dec 2021 20:07:45 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>
Subject: [v3 1/2] Docs/devicetree: add serdes.yaml
Date:   Tue,  7 Dec 2021 20:07:29 +0100
Message-Id: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a yaml file to document configurable properties for serdes
interfaces. Fow now only the property serdes-tx-amplitude-millivolt is
present.

Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
---
 Documentation/devicetree/bindings/net/serdes.yaml | 22 +++++++++++++++++=
+++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/serdes.yaml

diff --git a/Documentation/devicetree/bindings/net/serdes.yaml b/Document=
ation/devicetree/bindings/net/serdes.yaml
new file mode 100644
index 00000000..8a71403
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/serdes.yaml
@@ -0,0 +1,22 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/serdes.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Serdes
+
+maintainers:
+  - Holger Brunck <holger.brunck@hitachienergy.com>
+
+description:
+  Bindings for Serdes interfaces
+
+properties:
+  serdes-tx-amplitude-millivolt:
+    type: object
+    description:
+      Tx output amplitude of serdes interface in millivolts.
+
+additionalProperties: false
+
--=20
1.8.3.1

