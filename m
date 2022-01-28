Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3133349FAB7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 14:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244905AbiA1Nbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 08:31:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48160 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241847AbiA1Nbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 08:31:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FE1E61D5F;
        Fri, 28 Jan 2022 13:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6191C340E0;
        Fri, 28 Jan 2022 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643376711;
        bh=EFR6Kg0UXJbjuRcpfM/NVS76aRO/EAxx5ngmeX3msx8=;
        h=From:To:Cc:Subject:Date:From;
        b=vFk+WdGzoPSXW6/pnGUYbyAqhvyjiHu42IYz3umuwX9vreC78WguKyXI8yivFNqsr
         1NQXbp7jeDOamslbK1FzaAR8SJo28D0KaRQAw0aeBgnuhqjh/M0HG20HF8dNjuzcTu
         9Ca5qpq8+YU8ZuL2sf2pS+jv1zoqxZfp9YtCe6gRYGLFxMzvy8jtIyViQgSLoiXNVJ
         kkfbDPS/BCX89+yd+Ob96Xghn7A9X0Ec4Tcu2dHLXW/Svg7dNrHBka3jqs9TzfXq/3
         zSUrSO+ls5Jf/ple8ic8AbUzv5+cjLz+Icz3SyBs48jXqHiY+yJF2okDzqTxgtnSVt
         dlY6CQ9j1nQjg==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     robh+dt@kernel.org
Cc:     dinguyen@kernel.org, mkl@pengutronix.de, wg@grandegger.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] dt-bindings: net: can: fix dtbs warning
Date:   Fri, 28 Jan 2022 07:31:42 -0600
Message-Id: <20220128133142.2135718-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mute the warning from "make dtbs_check":

Documentation/devicetree/bindings/net/can/bosch,m_can.example.dt.yaml:
can@20e8000: bosch,mram-cfg: [[0, 0, 0, 32, 0, 0, 0, 1]] is too short

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 401ab7cdb379..035964a8609c 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -101,6 +101,7 @@ properties:
       - description: Tx Buffers 0-32 elements / 0-576 words
         minimum: 0
         maximum: 32
+    minItems: 1
 
   power-domains:
     description:
-- 
2.25.1

