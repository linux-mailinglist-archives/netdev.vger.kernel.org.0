Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8344A634B
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbiBASMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241811AbiBASKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:10:37 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3995EC06174A;
        Tue,  1 Feb 2022 10:09:59 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CD51020003;
        Tue,  1 Feb 2022 18:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643738998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yXIa3ExOVBkzifV8ouWzWmNKHpEdLShDhSj8hkfZVbU=;
        b=TqW1v46NxKCARFvm4bPGdfVVhMb5QTmoR6krIXSMC2q+6dEF073SIzRKMyNewGdyfXe9BM
        H4Ju2cY+MG0Ilemzpn3vkrqIql/H6a9LzwiIKn+SlqUIvL2nnQXgKeWVGztsvMupy93S+l
        JMa9hiKSh/a6ogHT+L4DKO/leKiWCI3D9YKzQKZ8V5NAJS02sbUiJ1ddPMFN6WK9Rog+Sj
        3qMJPo6s0Nh6BLt7Ur0aC471Z3s84ss5TMzcH4lTxY+z6f8XFqu0IbSJJBHgGtBf6F0swj
        +vij1GiRHDmr2ZcwAnMUsp20z48Ml0j/GDFN1neSrI5azzsYxtEMkfF0OpNK8w==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v3] net: ieee802154: Provide a kdoc to the address structure
Date:   Tue,  1 Feb 2022 19:09:56 +0100
Message-Id: <20220201180956.93581-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Girault <david.girault@qorvo.com>

Give this structure a header to better explain its content.

Signed-off-by: David Girault <david.girault@qorvo.com>
[miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
                            reword the comment]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---

Changes since v2:
* Stopped moving the structure location, we can keep it there, just add
  the kdoc.

 include/net/cfg802154.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 49b4bcc24032..85f9e8417688 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -227,6 +227,16 @@ static inline void wpan_phy_net_set(struct wpan_phy *wpan_phy, struct net *net)
 	write_pnet(&wpan_phy->_net, net);
 }
 
+/**
+ * struct ieee802154_addr - IEEE802.15.4 device address
+ * @mode: Address mode from frame header. Can be one of:
+ *        - @IEEE802154_ADDR_NONE
+ *        - @IEEE802154_ADDR_SHORT
+ *        - @IEEE802154_ADDR_LONG
+ * @pan_id: The PAN ID this address belongs to
+ * @short_addr: address if @mode is @IEEE802154_ADDR_SHORT
+ * @extended_addr: address if @mode is @IEEE802154_ADDR_LONG
+ */
 struct ieee802154_addr {
 	u8 mode;
 	__le16 pan_id;
-- 
2.27.0

