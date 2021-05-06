Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8DE3759D2
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 19:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbhEFR5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 13:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbhEFR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 13:57:12 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2763BC06138D
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 10:56:03 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:f434:20f9:aa9e:b80c])
        by laurent.telenet-ops.be with bizsmtp
        id 1Vvy2500U0ZPnBx01VvyXi; Thu, 06 May 2021 19:56:02 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1leiEA-003NT5-31; Thu, 06 May 2021 19:55:58 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1leiE9-00HHNK-Bk; Thu, 06 May 2021 19:55:57 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-can@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/2] dt-bindings: can: renesas: Convert to json-schema
Date:   Thu,  6 May 2021 19:55:52 +0200
Message-Id: <cover.1620323639.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

This patch series converts the DT bindings for the Renesas R-Car CAN and
CAN FD controllers found in Renesas SoCs to json-schema.

Thanks for your comments!

Geert Uytterhoeven (2):
  dt-bindings: can: rcar_can: Convert to json-schema
  dt-bindings: can: rcar_canfd: Convert to json-schema

 .../devicetree/bindings/net/can/rcar_can.txt  |  80 ----------
 .../bindings/net/can/rcar_canfd.txt           | 107 --------------
 .../bindings/net/can/renesas,rcar-can.yaml    | 139 ++++++++++++++++++
 .../bindings/net/can/renesas,rcar-canfd.yaml  | 122 +++++++++++++++
 4 files changed, 261 insertions(+), 187 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_can.txt
 delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_canfd.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-can.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml

-- 
2.25.1

