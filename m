Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B291E562BF9
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbiGAGrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbiGAGrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:47:33 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8B8F33A3F;
        Thu, 30 Jun 2022 23:47:31 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 0B6E11E80D21;
        Fri,  1 Jul 2022 14:46:03 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id naHQISC-u5cj; Fri,  1 Jul 2022 14:46:00 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id AC3A61E80D09;
        Fri,  1 Jul 2022 14:45:59 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     gregkh@linuxfoundation.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kunyu@nfschina.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH v2] net: usb: Fix typo in code
Date:   Fri,  1 Jul 2022 14:47:23 +0800
Message-Id: <20220701064723.2935-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <Yr6R/wsl+HlOwOEm@kroah.com>
References: <Yr6R/wsl+HlOwOEm@kroah.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the repeated ';' from code.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 drivers/net/usb/catc.c | 2 +-
 1 file changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index e7fe9c0f63a9..268c32521691 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -781,7 +781,7 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 			intf->altsetting->desc.bInterfaceNumber, 1)) {
 		dev_err(dev, "Can't set altsetting 1.\n");
 		ret = -EIO;
-		goto fail_mem;;
+		goto fail_mem;
 	}
 
 	netdev = alloc_etherdev(sizeof(struct catc));
-- 
2.18.2

