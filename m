Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9006028CFF5
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 16:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388515AbgJMONp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 10:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388488AbgJMONp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 10:13:45 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6494C0613D5
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 07:13:44 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id fSDi2300E4C55Sk06SDiYz; Tue, 13 Oct 2020 16:13:43 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kSL3e-0006RP-HN; Tue, 13 Oct 2020 16:13:42 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kSL3e-0007QD-FW; Tue, 13 Oct 2020 16:13:42 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] can: Explain PDU in CAN_ISOTP help text
Date:   Tue, 13 Oct 2020 16:13:41 +0200
Message-Id: <20201013141341.28487-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The help text for the CAN_ISOTP config symbol uses the acronym "PDU".
However, this acronym is not explained here, nor in
Documentation/networking/can.rst.
Expand the acronym to make it easier for users to decide if they need to
enable the CAN_ISOTP option or not.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 net/can/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/can/Kconfig b/net/can/Kconfig
index 224e5e0283a986d9..7c9958df91d353c8 100644
--- a/net/can/Kconfig
+++ b/net/can/Kconfig
@@ -62,8 +62,9 @@ config CAN_ISOTP
 	  communication between CAN nodes via two defined CAN Identifiers.
 	  As CAN frames can only transport a small amount of data bytes
 	  (max. 8 bytes for 'classic' CAN and max. 64 bytes for CAN FD) this
-	  segmentation is needed to transport longer PDUs as needed e.g. for
-	  vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN traffic.
+	  segmentation is needed to transport longer Protocol Data Units (PDU)
+	  as needed e.g. for vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN
+	  traffic.
 	  This protocol driver implements data transfers according to
 	  ISO 15765-2:2016 for 'classic' CAN and CAN FD frame types.
 	  If you want to perform automotive vehicle diagnostic services (UDS),
-- 
2.17.1

