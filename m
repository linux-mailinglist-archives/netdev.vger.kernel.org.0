Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDC721A94F
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgGIUtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:49:35 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:52806 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgGIUte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:49:34 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 00206BC0D9;
        Thu,  9 Jul 2020 20:49:31 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     kda@linux-powerpc.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] SUNDANCE NETWORK DRIVER: Replace HTTP links with HTTPS ones
Date:   Thu,  9 Jul 2020 22:49:25 +0200
Message-Id: <20200709204925.27287-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely or at least not HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.


 drivers/net/ethernet/dlink/sundance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index dc566fcc3ba9..ebaca07f7873 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -18,7 +18,7 @@
 	http://www.scyld.com/network/sundance.html
 	[link no longer provides useful info -jgarzik]
 	Archives of the mailing list are still available at
-	http://www.beowulf.org/pipermail/netdrivers/
+	https://www.beowulf.org/pipermail/netdrivers/
 
 */
 
-- 
2.27.0

