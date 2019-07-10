Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03556471D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfGJNib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:38:31 -0400
Received: from aws.guarana.org ([13.237.110.252]:53788 "EHLO aws.guarana.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbfGJNia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 09:38:30 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 09:38:29 EDT
Received: by aws.guarana.org (Postfix, from userid 1006)
        id E1A60BBE22; Wed, 10 Jul 2019 13:31:38 +0000 (UTC)
Date:   Wed, 10 Jul 2019 13:31:38 +0000
From:   Kevin Easton <kevin@guarana.org>
To:     linux-wireless@vger.kernel.org
Cc:     andreyknvl@google.com, davem@davemloft.net, kvalo@codeaurora.org,
        libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
        syzbot <syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: [PATCH] libertas: Add missing sentinel at end of if_usb.c fw_table
Message-ID: <20190710133138.GA31901@ip-172-31-14-16>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This sentinel tells the firmware loading process when to stop.

Reported-and-tested-by: syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com
Signed-off-by: Kevin Easton <kevin@guarana.org>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index f1622f0ff8c9..fe3142d85d1e 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -50,7 +50,8 @@ static const struct lbs_fw_table fw_table[] = {
 	{ MODEL_8388, "libertas/usb8388_v5.bin", NULL },
 	{ MODEL_8388, "libertas/usb8388.bin", NULL },
 	{ MODEL_8388, "usb8388.bin", NULL },
-	{ MODEL_8682, "libertas/usb8682.bin", NULL }
+	{ MODEL_8682, "libertas/usb8682.bin", NULL },
+	{ 0, NULL, NULL }
 };
 
 static const struct usb_device_id if_usb_table[] = {
-- 
2.11.0
 
