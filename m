Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1F621CC09
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgGLXPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728594AbgGLXPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBu-004mPb-1J; Mon, 13 Jul 2020 01:15:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 12/20] net: nfc: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:08 +0200
Message-Id: <20200712231516.1139335-13-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/nfc/core.c     | 3 +--
 net/nfc/nci/core.c | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index c5f9c3ee82f8..eb377f87bcae 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -704,7 +704,6 @@ EXPORT_SYMBOL(nfc_tm_deactivated);
  * nfc_alloc_send_skb - allocate a skb for data exchange responses
  *
  * @size: size to allocate
- * @gfp: gfp flags
  */
 struct sk_buff *nfc_alloc_send_skb(struct nfc_dev *dev, struct sock *sk,
 				   unsigned int flags, unsigned int size,
@@ -749,7 +748,7 @@ EXPORT_SYMBOL(nfc_alloc_recv_skb);
  *
  * @dev: The nfc device that found the targets
  * @targets: array of nfc targets found
- * @ntargets: targets array size
+ * @n_targets: targets array size
  *
  * The device driver must call this function when one or many nfc targets
  * are found. After calling this function, the device driver must stop
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 7cd524884304..f7b7dc5fe84a 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1182,7 +1182,7 @@ EXPORT_SYMBOL(nci_free_device);
 /**
  * nci_register_device - register a nci device in the nfc subsystem
  *
- * @dev: The nci device to register
+ * @ndev: The nci device to register
  */
 int nci_register_device(struct nci_dev *ndev)
 {
@@ -1246,7 +1246,7 @@ EXPORT_SYMBOL(nci_register_device);
 /**
  * nci_unregister_device - unregister a nci device in the nfc subsystem
  *
- * @dev: The nci device to unregister
+ * @ndev: The nci device to unregister
  */
 void nci_unregister_device(struct nci_dev *ndev)
 {
-- 
2.27.0.rc2

