Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2BD27F713
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 03:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbgJABM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 21:12:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37212 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgJABMz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 21:12:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNn9C-00Gzfw-PO; Thu, 01 Oct 2020 03:12:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 2/2] driver/net/ethernet: Sign up for W=1 as defined on 20200930
Date:   Thu,  1 Oct 2020 03:12:32 +0200
Message-Id: <20201001011232.4050282-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201001011232.4050282-1-andrew@lunn.ch>
References: <20201001011232.4050282-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make all Ethernet drivers be compiled with the equivalent of W=1
as defined today.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index f8f38dcb5f8a..8162b2f6ec81 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -3,6 +3,9 @@
 # Makefile for the Linux network Ethernet device drivers.
 #
 
+# Enable W=1, as defined on the given date
+subdir-ccflags-y := $(KBUILD_CFLAGS_W1_20200930)
+
 obj-$(CONFIG_NET_VENDOR_3COM) += 3com/
 obj-$(CONFIG_NET_VENDOR_8390) += 8390/
 obj-$(CONFIG_NET_VENDOR_ADAPTEC) += adaptec/
-- 
2.28.0

