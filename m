Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25584105615
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKUPzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:55:13 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59419 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfKUPzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:55:10 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=leda.hi.pengutronix.de)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <rsc@pengutronix.de>)
        id 1iXonT-0002x5-0a; Thu, 21 Nov 2019 16:55:07 +0100
Received: by leda.hi.pengutronix.de (Postfix, from userid 1006)
        id C40F42C877E8; Thu, 21 Nov 2019 16:55:05 +0100 (CET)
From:   Robert Schwebel <r.schwebel@pengutronix.de>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Robert Schwebel <r.schwebel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 5/5] docs: networking: nfc: change to rst format
Date:   Thu, 21 Nov 2019 16:55:03 +0100
Message-Id: <20191121155503.52019-5-r.schwebel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121155503.52019-1-r.schwebel@pengutronix.de>
References: <20191121155503.52019-1-r.schwebel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the sphinx syntax has been fixed, change the document from txt
to rst and add it to the index.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
---
 Documentation/networking/{nfc.txt => nfc.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/networking/{nfc.txt => nfc.rst} (100%)

diff --git a/Documentation/networking/nfc.txt b/Documentation/networking/nfc.rst
similarity index 100%
rename from Documentation/networking/nfc.txt
rename to Documentation/networking/nfc.rst
-- 
2.24.0

