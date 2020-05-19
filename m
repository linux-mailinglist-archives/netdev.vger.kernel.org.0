Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1ECA1D9505
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgESLPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:15:53 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:4392 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgESLPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 07:15:53 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.7]) by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee25ec3bfd5b8d-512af; Tue, 19 May 2020 19:15:34 +0800 (CST)
X-RM-TRANSID: 2ee25ec3bfd5b8d-512af
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee45ec3bfd2858-c14a9;
        Tue, 19 May 2020 19:15:33 +0800 (CST)
X-RM-TRANSID: 2ee45ec3bfd2858-c14a9
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net/amd: Remove unnecessary spaces and tables in au1000_eth.c
Date:   Tue, 19 May 2020 19:16:19 +0800
Message-Id: <20200519111619.19644-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macros in au1000_eth.c have inconsistent spaces between the
macro name and the value. Thus sets all the macros to have a signal
space between the name and value.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/amd/au1000_eth.c | 172 +++++++++++++-------------
 1 file changed, 86 insertions(+), 86 deletions(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 089a4fbc6..75e9074d8 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -73,75 +73,75 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 /* AU1000 MAC registers and bits */
-#define MAC_CONTROL		0x0
-#  define MAC_RX_ENABLE		(1 << 2)
-#  define MAC_TX_ENABLE		(1 << 3)
-#  define MAC_DEF_CHECK		(1 << 5)
-#  define MAC_SET_BL(X)		(((X) & 0x3) << 6)
-#  define MAC_AUTO_PAD		(1 << 8)
-#  define MAC_DISABLE_RETRY	(1 << 10)
-#  define MAC_DISABLE_BCAST	(1 << 11)
-#  define MAC_LATE_COL		(1 << 12)
-#  define MAC_HASH_MODE		(1 << 13)
-#  define MAC_HASH_ONLY		(1 << 15)
-#  define MAC_PASS_ALL		(1 << 16)
-#  define MAC_INVERSE_FILTER	(1 << 17)
-#  define MAC_PROMISCUOUS	(1 << 18)
-#  define MAC_PASS_ALL_MULTI	(1 << 19)
-#  define MAC_FULL_DUPLEX	(1 << 20)
-#  define MAC_NORMAL_MODE	0
-#  define MAC_INT_LOOPBACK	(1 << 21)
-#  define MAC_EXT_LOOPBACK	(1 << 22)
-#  define MAC_DISABLE_RX_OWN	(1 << 23)
-#  define MAC_BIG_ENDIAN	(1 << 30)
-#  define MAC_RX_ALL		(1 << 31)
+#define MAC_CONTROL	0x0
+#define MAC_RX_ENABLE	(1 << 2)
+#define MAC_TX_ENABLE	(1 << 3)
+#define MAC_DEF_CHECK	(1 << 5)
+#define MAC_SET_BL(X)	(((X) & 0x3) << 6)
+#define MAC_AUTO_PAD	(1 << 8)
+#define MAC_DISABLE_RETRY	(1 << 10)
+#define MAC_DISABLE_BCAST	(1 << 11)
+#define MAC_LATE_COL	(1 << 12)
+#define MAC_HASH_MODE	(1 << 13)
+#define MAC_HASH_ONLY	(1 << 15)
+#define MAC_PASS_ALL	(1 << 16)
+#define MAC_INVERSE_FILTER	(1 << 17)
+#define MAC_PROMISCUOUS	(1 << 18)
+#define MAC_PASS_ALL_MULTI	(1 << 19)
+#define MAC_FULL_DUPLEX	(1 << 20)
+#define MAC_NORMAL_MODE	0
+#define MAC_INT_LOOPBACK	(1 << 21)
+#define MAC_EXT_LOOPBACK	(1 << 22)
+#define MAC_DISABLE_RX_OWN	(1 << 23)
+#define MAC_BIG_ENDIAN	(1 << 30)
+#define MAC_RX_ALL	(1 << 31)
 #define MAC_ADDRESS_HIGH	0x4
-#define MAC_ADDRESS_LOW		0x8
-#define MAC_MCAST_HIGH		0xC
-#define MAC_MCAST_LOW		0x10
-#define MAC_MII_CNTRL		0x14
-#  define MAC_MII_BUSY		(1 << 0)
-#  define MAC_MII_READ		0
-#  define MAC_MII_WRITE		(1 << 1)
-#  define MAC_SET_MII_SELECT_REG(X) (((X) & 0x1f) << 6)
-#  define MAC_SET_MII_SELECT_PHY(X) (((X) & 0x1f) << 11)
-#define MAC_MII_DATA		0x18
-#define MAC_FLOW_CNTRL		0x1C
-#  define MAC_FLOW_CNTRL_BUSY	(1 << 0)
-#  define MAC_FLOW_CNTRL_ENABLE (1 << 1)
-#  define MAC_PASS_CONTROL	(1 << 2)
-#  define MAC_SET_PAUSE(X)	(((X) & 0xffff) << 16)
-#define MAC_VLAN1_TAG		0x20
-#define MAC_VLAN2_TAG		0x24
+#define MAC_ADDRESS_LOW	0x8
+#define MAC_MCAST_HIGH	0xC
+#define MAC_MCAST_LOW	0x10
+#define MAC_MII_CNTRL	0x14
+#define MAC_MII_BUSY	(1 << 0)
+#define MAC_MII_READ	0
+#define MAC_MII_WRITE	(1 << 1)
+#define MAC_SET_MII_SELECT_REG(X) (((X) & 0x1f) << 6)
+#define MAC_SET_MII_SELECT_PHY(X) (((X) & 0x1f) << 11)
+#define MAC_MII_DATA	0x18
+#define MAC_FLOW_CNTRL	0x1C
+#define MAC_FLOW_CNTRL_BUSY	(1 << 0)
+#define MAC_FLOW_CNTRL_ENABLE (1 << 1)
+#define MAC_PASS_CONTROL	(1 << 2)
+#define MAC_SET_PAUSE(X)	(((X) & 0xffff) << 16)
+#define MAC_VLAN1_TAG	0x20
+#define MAC_VLAN2_TAG	0x24
 
 /* Ethernet Controller Enable */
-#  define MAC_EN_CLOCK_ENABLE	(1 << 0)
-#  define MAC_EN_RESET0		(1 << 1)
-#  define MAC_EN_TOSS		(0 << 2)
-#  define MAC_EN_CACHEABLE	(1 << 3)
-#  define MAC_EN_RESET1		(1 << 4)
-#  define MAC_EN_RESET2		(1 << 5)
-#  define MAC_DMA_RESET		(1 << 6)
+#define MAC_EN_CLOCK_ENABLE	(1 << 0)
+#define MAC_EN_RESET0	(1 << 1)
+#define MAC_EN_TOSS	(0 << 2)
+#define MAC_EN_CACHEABLE	(1 << 3)
+#define MAC_EN_RESET1	(1 << 4)
+#define MAC_EN_RESET2	(1 << 5)
+#define MAC_DMA_RESET	(1 << 6)
 
 /* Ethernet Controller DMA Channels */
 /* offsets from MAC_TX_RING_ADDR address */
 #define MAC_TX_BUFF0_STATUS	0x0
-#  define TX_FRAME_ABORTED	(1 << 0)
-#  define TX_JAB_TIMEOUT	(1 << 1)
-#  define TX_NO_CARRIER		(1 << 2)
-#  define TX_LOSS_CARRIER	(1 << 3)
-#  define TX_EXC_DEF		(1 << 4)
-#  define TX_LATE_COLL_ABORT	(1 << 5)
-#  define TX_EXC_COLL		(1 << 6)
-#  define TX_UNDERRUN		(1 << 7)
-#  define TX_DEFERRED		(1 << 8)
-#  define TX_LATE_COLL		(1 << 9)
-#  define TX_COLL_CNT_MASK	(0xF << 10)
-#  define TX_PKT_RETRY		(1 << 31)
+#define TX_FRAME_ABORTED	(1 << 0)
+#define TX_JAB_TIMEOUT	(1 << 1)
+#define TX_NO_CARRIER	(1 << 2)
+#define TX_LOSS_CARRIER	(1 << 3)
+#define TX_EXC_DEF	(1 << 4)
+#define TX_LATE_COLL_ABORT	(1 << 5)
+#define TX_EXC_COLL	(1 << 6)
+#define TX_UNDERRUN	(1 << 7)
+#define TX_DEFERRED	(1 << 8)
+#define TX_LATE_COLL	(1 << 9)
+#define TX_COLL_CNT_MASK	(0xF << 10)
+#define TX_PKT_RETRY	(1 << 31)
 #define MAC_TX_BUFF0_ADDR	0x4
-#  define TX_DMA_ENABLE		(1 << 0)
-#  define TX_T_DONE		(1 << 1)
-#  define TX_GET_DMA_BUFFER(X)	(((X) >> 2) & 0x3)
+#define TX_DMA_ENABLE	(1 << 0)
+#define TX_T_DONE	(1 << 1)
+#define TX_GET_DMA_BUFFER(X)	(((X) >> 2) & 0x3)
 #define MAC_TX_BUFF0_LEN	0x8
 #define MAC_TX_BUFF1_STATUS	0x10
 #define MAC_TX_BUFF1_ADDR	0x14
@@ -155,34 +155,34 @@ MODULE_VERSION(DRV_VERSION);
 
 /* offsets from MAC_RX_RING_ADDR */
 #define MAC_RX_BUFF0_STATUS	0x0
-#  define RX_FRAME_LEN_MASK	0x3fff
-#  define RX_WDOG_TIMER		(1 << 14)
-#  define RX_RUNT		(1 << 15)
-#  define RX_OVERLEN		(1 << 16)
-#  define RX_COLL		(1 << 17)
-#  define RX_ETHER		(1 << 18)
-#  define RX_MII_ERROR		(1 << 19)
-#  define RX_DRIBBLING		(1 << 20)
-#  define RX_CRC_ERROR		(1 << 21)
-#  define RX_VLAN1		(1 << 22)
-#  define RX_VLAN2		(1 << 23)
-#  define RX_LEN_ERROR		(1 << 24)
-#  define RX_CNTRL_FRAME	(1 << 25)
-#  define RX_U_CNTRL_FRAME	(1 << 26)
-#  define RX_MCAST_FRAME	(1 << 27)
-#  define RX_BCAST_FRAME	(1 << 28)
-#  define RX_FILTER_FAIL	(1 << 29)
-#  define RX_PACKET_FILTER	(1 << 30)
-#  define RX_MISSED_FRAME	(1 << 31)
-
-#  define RX_ERROR (RX_WDOG_TIMER | RX_RUNT | RX_OVERLEN |  \
+#define RX_FRAME_LEN_MASK	0x3fff
+#define RX_WDOG_TIMER	(1 << 14)
+#define RX_RUNT	(1 << 15)
+#define RX_OVERLEN	(1 << 16)
+#define RX_COLL	(1 << 17)
+#define RX_ETHER	(1 << 18)
+#define RX_MII_ERROR	(1 << 19)
+#define RX_DRIBBLING	(1 << 20)
+#define RX_CRC_ERROR	(1 << 21)
+#define RX_VLAN1	(1 << 22)
+#define RX_VLAN2	(1 << 23)
+#define RX_LEN_ERROR	(1 << 24)
+#define RX_CNTRL_FRAME	(1 << 25)
+#define RX_U_CNTRL_FRAME	(1 << 26)
+#define RX_MCAST_FRAME	(1 << 27)
+#define RX_BCAST_FRAME	(1 << 28)
+#define RX_FILTER_FAIL	(1 << 29)
+#define RX_PACKET_FILTER	(1 << 30)
+#define RX_MISSED_FRAME	(1 << 31)
+
+#define RX_ERROR (RX_WDOG_TIMER | RX_RUNT | RX_OVERLEN |  \
 		    RX_COLL | RX_MII_ERROR | RX_CRC_ERROR | \
 		    RX_LEN_ERROR | RX_U_CNTRL_FRAME | RX_MISSED_FRAME)
 #define MAC_RX_BUFF0_ADDR	0x4
-#  define RX_DMA_ENABLE		(1 << 0)
-#  define RX_T_DONE		(1 << 1)
-#  define RX_GET_DMA_BUFFER(X)	(((X) >> 2) & 0x3)
-#  define RX_SET_BUFF_ADDR(X)	((X) & 0xffffffc0)
+#define RX_DMA_ENABLE	(1 << 0)
+#define RX_T_DONE	(1 << 1)
+#define RX_GET_DMA_BUFFER(X)	(((X) >> 2) & 0x3)
+#define RX_SET_BUFF_ADDR(X)	((X) & 0xffffffc0)
 #define MAC_RX_BUFF1_STATUS	0x10
 #define MAC_RX_BUFF1_ADDR	0x14
 #define MAC_RX_BUFF2_STATUS	0x20
-- 
2.20.1.windows.1



