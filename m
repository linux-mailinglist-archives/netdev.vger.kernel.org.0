Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F682959A0
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508905AbgJVHwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508877AbgJVHwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:52:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AECC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 00:52:30 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVVOZ-00085i-KL; Thu, 22 Oct 2020 09:52:23 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVVOU-00036W-Oz; Thu, 22 Oct 2020 09:52:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH v3 0/2] convert flexcan to the yaml
Date:   Thu, 22 Oct 2020 09:52:16 +0200
Message-Id: <20201022075218.11880-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v3:
- can-controller.yaml: add "additionalProperties: true"
- fsl,flexcan.yaml: remove maxItems and not needed type definition

changes v2:
- add can-controller.yaml for common patterns
- use phandle-array instead of uint32-array
- Drop the outer 'items' in fsl,stop-mode
- use can@ instead of flexcan@

Oleksij Rempel (2):
  dt-bindings: can: add can-controller.yaml
  dt-bindings: can: flexcan: convert fsl,*flexcan bindings to yaml

 .../bindings/net/can/can-controller.yaml      |  18 +++
 .../bindings/net/can/fsl,flexcan.yaml         | 135 ++++++++++++++++++
 .../bindings/net/can/fsl-flexcan.txt          |  57 --------
 3 files changed, 153 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/can-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt

-- 
2.28.0

