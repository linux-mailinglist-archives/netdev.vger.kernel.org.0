Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9BA3074A3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhA1LXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:23:30 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35405 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhA1LX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:23:29 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jlu@pengutronix.de>)
        id 1l55Ll-0004w1-SD; Thu, 28 Jan 2021 12:20:33 +0100
Received: from jlu by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <jlu@pengutronix.de>)
        id 1l55Lk-0007op-Gr; Thu, 28 Jan 2021 12:20:32 +0100
From:   Jan Luebbe <jlu@pengutronix.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel@pengutronix.de, Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH] docs: networking: timestamping: fix section title markup
Date:   Thu, 28 Jan 2021 12:19:30 +0100
Message-Id: <20210128111930.29473-1-jlu@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This section was missed during the conversion to ReST, so convert it in the
same style as the surrounding section titles.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
 Documentation/networking/timestamping.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index 03f7beade470..f682e88fa87e 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -55,7 +55,8 @@ struct __kernel_sock_timeval format.
 SO_TIMESTAMP_OLD returns incorrect timestamps after the year 2038
 on 32 bit machines.
 
-1.2 SO_TIMESTAMPNS (also SO_TIMESTAMPNS_OLD and SO_TIMESTAMPNS_NEW):
+1.2 SO_TIMESTAMPNS (also SO_TIMESTAMPNS_OLD and SO_TIMESTAMPNS_NEW)
+-------------------------------------------------------------------
 
 This option is identical to SO_TIMESTAMP except for the returned data type.
 Its struct timespec allows for higher resolution (ns) timestamps than the
-- 
2.29.2

