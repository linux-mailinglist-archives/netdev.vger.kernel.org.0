Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7495730E95E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhBDBTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbhBDBTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 20:19:35 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A336FC061573;
        Wed,  3 Feb 2021 17:18:55 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id a7so1813437qkb.13;
        Wed, 03 Feb 2021 17:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BRSeNrAgqYoEdIAaT/E3XS8qfSyBH3EgUU59Y30fA1s=;
        b=ZAss0ce0fku95ORQy+ibGYidBLcsdTDqWw1eMlcT8L+29e0PCrsgRy09+VdAQlqD0t
         w3L03foqeCX4ms+DzBr8aiUcBbt79RQLUJXOA1KcYjYeM0eY9leq5l46BdyBpbaK2czN
         Sw/Vi5qOw3tFt38jA3WMg+9bnfxW+4nXwb/exiZ7LPLucW9BwNnqPm/lpjDjvNblnVxI
         4SdeLvCsHiOHYqWJ9ZUTtWdJWwknimfiy4oiGT4u5+Ju717WfjMx58y6VDVib36Ank9G
         dGOWolWB73ePrCudDeVnOyAmGMSyXyJX7OvEjjkfn9yF59rNDdw6oDHulKFlq8nn5R7W
         E99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BRSeNrAgqYoEdIAaT/E3XS8qfSyBH3EgUU59Y30fA1s=;
        b=sWaAL1gufs3fzMJRgs82amtxICxG04oYWgFZYgWTX3CkOjUKmjy0+/iGPJ0Pu6fBte
         bEp+hH6NkoVG9D/kv0LHN4JAu5YjsDVdq4PrYACyTG4IneuqHrP6KEVfNJnjDWVv0mPf
         7ujE3OwKjKKlKWaAv/yc1KiHnd+5A74hGLdzeHlTzoPJN5dY3eBqgJWSIDIA1Gccnqrc
         Fy4d3mdwU9sXdXf4e/6+95j7iSiDSIe+NivjFKa7+VShHZGH93jmxdM00RBcmfU5XGJX
         ErCtdRJ8DuVOjyg1jXF3Ubo5a5zZAPQJSsm7r193+IZ/JsKYMOyLsnOFNhV1mgLJWW2j
         kCDw==
X-Gm-Message-State: AOAM530/5pqnS4xcGGSCNlGTnn866ThKh3U4af0+FZ3zUjqaVGWnqFEC
        nPxDdJOKD3cfqTw1IUCG6RpyPnHnAeLU16Ct
X-Google-Smtp-Source: ABdhPJzLTf/Qhr+L0sRCIEXwIUmlTRpWottYJiVdVtcdEGcmSO+elbFSLDO2CoYMpAOeUN4YFWISQQ==
X-Received: by 2002:a37:be04:: with SMTP id o4mr5562190qkf.373.1612401534828;
        Wed, 03 Feb 2021 17:18:54 -0800 (PST)
Received: from localhost.localdomain ([138.199.13.179])
        by smtp.gmail.com with ESMTPSA id w28sm3007719qtv.93.2021.02.03.17.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 17:18:54 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH V2] drivers: net: ethernet: i825xx: Fix couple of spellings and get rid of blank lines too in the file ether1.c
Date:   Thu,  4 Feb 2021 06:48:21 +0530
Message-Id: <20210204011821.18356-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/initialsation/initialisation/
s/specifiing/specifying/

Plus get rid of few blank lines.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
Changes from V1:
   Fix typo in the subject line
   Give explanation of all the changes in changelog text

 drivers/net/ethernet/i825xx/ether1.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
index a0bfb509e002..850ea32091ed 100644
--- a/drivers/net/ethernet/i825xx/ether1.c
+++ b/drivers/net/ethernet/i825xx/ether1.c
@@ -20,7 +20,7 @@
  * 1.02	RMK	25/05/1997	Added code to restart RU if it goes not ready
  * 1.03	RMK	14/09/1997	Cleaned up the handling of a reset during the TX interrupt.
  *				Should prevent lockup.
- * 1.04 RMK	17/09/1997	Added more info when initialsation of chip goes wrong.
+ * 1.04 RMK	17/09/1997	Added more info when initialisation of chip goes wrong.
  *				TDR now only reports failure when chip reports non-zero
  *				TDR time-distance.
  * 1.05	RMK	31/12/1997	Removed calls to dev_tint for 2.1
@@ -117,7 +117,7 @@ ether1_outw_p (struct net_device *dev, unsigned short val, int addr, int svflgs)
  * Some inline assembler to allow fast transfers on to/off of the card.
  * Since this driver depends on some features presented by the ARM
  * specific architecture, and that you can't configure this driver
- * without specifiing ARM mode, this is not a problem.
+ * without specifying ARM mode, this is not a problem.
  *
  * This routine is essentially an optimised memcpy from the card's
  * onboard RAM to kernel memory.
@@ -885,7 +885,6 @@ ether1_recv_done (struct net_device *dev)
 		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_command, NORMALIRQS);
 		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_status, NORMALIRQS);
 		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_rbdoffset, NORMALIRQS);
-
 		priv(dev)->rx_tail = nexttail;
 		priv(dev)->rx_head = ether1_readw(dev, priv(dev)->rx_head, rfd_t, rfd_link, NORMALIRQS);
 	} while (1);
@@ -1028,10 +1027,8 @@ ether1_probe(struct expansion_card *ec, const struct ecard_id *id)
 	ret = register_netdev(dev);
 	if (ret)
 		goto free;
-
 	printk(KERN_INFO "%s: ether1 in slot %d, %pM\n",
 		dev->name, ec->slot_no, dev->dev_addr);
-
 	ecard_set_drvdata(ec, dev);
 	return 0;

@@ -1047,7 +1044,7 @@ static void ether1_remove(struct expansion_card *ec)
 {
 	struct net_device *dev = ecard_get_drvdata(ec);

-	ecard_set_drvdata(ec, NULL);
+	ecard_set_drvdata(ec, NULL);

 	unregister_netdev(dev);
 	free_netdev(dev);
--
2.26.2

