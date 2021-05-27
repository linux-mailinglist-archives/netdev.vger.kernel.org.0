Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3723929F4
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235733AbhE0IuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbhE0It4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E365FC06138F
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgj-00026H-3C
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:21 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9F8BB62D414
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BC08962D3DC;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id df9f728d;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Ayoub Kaanich <kayoub5@live.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [net-next 03/21] can: uapi: update CAN-FD frame description
Date:   Thu, 27 May 2021 10:45:14 +0200
Message-Id: <20210527084532.1384031-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since an early version of the CAN-FD specification the bit that
defines a CAN-FD frame on the wire, has been renamed from Extended
Data Length (EDL) to FD Frame (FDF).

To avoid confusion, update the struct canfd_frame description in the
UAPI headers accordingly.

Link: https://lore.kernel.org/r/20210517113727.77597-1-mkl@pengutronix.de
Suggested-by: Ayoub Kaanich <kayoub5@live.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/can.h b/include/uapi/linux/can.h
index c7535352fef6..ac5d7a31671f 100644
--- a/include/uapi/linux/can.h
+++ b/include/uapi/linux/can.h
@@ -123,8 +123,8 @@ struct can_frame {
 /*
  * defined bits for canfd_frame.flags
  *
- * The use of struct canfd_frame implies the Extended Data Length (EDL) bit to
- * be set in the CAN frame bitstream on the wire. The EDL bit switch turns
+ * The use of struct canfd_frame implies the FD Frame (FDF) bit to
+ * be set in the CAN frame bitstream on the wire. The FDF bit switch turns
  * the CAN controllers bitstream processor into the CAN FD mode which creates
  * two new options within the CAN FD frame specification:
  *
-- 
2.30.2


