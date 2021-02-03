Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4222F30DDEF
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbhBCPST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbhBCPQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:16:52 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C787C06178A;
        Wed,  3 Feb 2021 07:16:12 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id z22so17791679qto.7;
        Wed, 03 Feb 2021 07:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5pltjfRAaouHc3Aucq2cv9tUaJbxPSooufzqa+GiXhU=;
        b=oq1VCvardTfv5A0hJqiD/uMtvbOnCiB0kEzmYQOIMI0mgmUg2dsAqZNI8igw74lLih
         5UCt8mR18gnqUxVVJ33gS16PLO6/yicvIVMFhzzl5Y01j0l6cVEhdWpClcOmpdQ3CeO2
         WtXquPGU8y+/3VbxtsNx2DfGN1o5ucf5KILEaVPEnk+KdXta6MIg2EuID4aQjSFNjd1a
         1gt/MuD3prZbjGfQ2KwCvbApz0GW0nmx0z3c3yn7LSpDrOOxuf0hjgJ9gDokdiNjQo3n
         fiCYBUCGsxcsd03wtXnzhHWGF+eJncCpsUtLqbvKZOLpl9Jgkyr2+qua+xrx1N3pzjnH
         k25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5pltjfRAaouHc3Aucq2cv9tUaJbxPSooufzqa+GiXhU=;
        b=MgIZsAeqo/yG1s/d7oGUNmrJp5g9zvljwOYzVHTtJA1dXgykdd/yvauhHevEoMkBLD
         swTUToUTBR99b1AkgD7VZ0RCEyp7pvzTzIhDTVjaZbmI6nPj2yCy88HxvJfltZuQpPLS
         /iJ5fBYXfTiai9LVuzw3Ke2ptQUI6lTdnOdAJLOjXAlUAARmwguTPboptsr5esPu72u7
         m9ElrpQHUgY/t5Xeeh3BVDB/JVhsRmnuT4jqAbs4oIAaEn+yCxrX/wlYzPSx+XfEyZhj
         yiPOIRMhl88q3iFQkqdw8merj0B3Z6VizVxMKWtvMs2lDKln3PZ5lN/9dSM3WXJy/Q0M
         J33A==
X-Gm-Message-State: AOAM531uv2bUHl3KHVQ6kz3XLt0MX2koKlg2h+NV2bhELwQseM33Dwd+
        LPLxigqC8eLKJL1U7hgzN14=
X-Google-Smtp-Source: ABdhPJwjtCCuFji6UQVslC56esu2ZbrtDyNd8foJQsqR5XhHxpjsq8svRnHeGiWxsIPcPspx0OdKRA==
X-Received: by 2002:ac8:590b:: with SMTP id 11mr2909055qty.114.1612365371581;
        Wed, 03 Feb 2021 07:16:11 -0800 (PST)
Received: from localhost.localdomain ([156.146.36.139])
        by smtp.gmail.com with ESMTPSA id o5sm1843509qko.85.2021.02.03.07.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 07:16:10 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: net: ehternet: i825xx:  Fix couple of spellings in the file ether1.c
Date:   Wed,  3 Feb 2021 20:45:47 +0530
Message-Id: <20210203151547.13273-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/initialsation/initialisation/
s/specifiing/specifying/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/i825xx/ether1.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
index a0bfb509e002..0233fb6e222d 100644
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
@@ -885,7 +885,7 @@ ether1_recv_done (struct net_device *dev)
 		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_command, NORMALIRQS);
 		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_status, NORMALIRQS);
 		ether1_writew(dev, 0, priv(dev)->rx_tail, rfd_t, rfd_rbdoffset, NORMALIRQS);
-
+
 		priv(dev)->rx_tail = nexttail;
 		priv(dev)->rx_head = ether1_readw(dev, priv(dev)->rx_head, rfd_t, rfd_link, NORMALIRQS);
 	} while (1);
@@ -1031,7 +1031,7 @@ ether1_probe(struct expansion_card *ec, const struct ecard_id *id)

 	printk(KERN_INFO "%s: ether1 in slot %d, %pM\n",
 		dev->name, ec->slot_no, dev->dev_addr);
-
+
 	ecard_set_drvdata(ec, dev);
 	return 0;

@@ -1047,7 +1047,7 @@ static void ether1_remove(struct expansion_card *ec)
 {
 	struct net_device *dev = ecard_get_drvdata(ec);

-	ecard_set_drvdata(ec, NULL);
+	ecard_set_drvdata(ec, NULL);

 	unregister_netdev(dev);
 	free_netdev(dev);
--
2.26.2

