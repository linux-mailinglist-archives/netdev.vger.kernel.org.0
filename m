Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BC920C4A9
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 00:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgF0WH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 18:07:57 -0400
Received: from mout.gmx.net ([212.227.15.19]:41353 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgF0WH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 18:07:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1593295669;
        bh=UJuIpU8M5WelugvBE8y6nZROVTEO+Thz9X5boT7lmgQ=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=iPVvbyb2WmX6SpYQEVRSp5v0UV9xnfr6IfbGB6dh1/i3GjxVqmXRfc7TFLK1RY+dN
         MmFqhec2tfPCubXBmmEY5/yJjnmDVc5GtNvh/bRFNH5EbWco3d6RJ9zTBlYNjF3Vbi
         3HqqvJ/iVwp+z+9Tw7LEh6cJUyaCpCdQyfi+02lY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([84.154.212.52]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1My32L-1iuCmx3acp-00zUzm; Sun, 28
 Jun 2020 00:07:48 +0200
Date:   Sun, 28 Jun 2020 00:07:47 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] 8390: Fix coding-style issues
Message-ID: <20200627220747.GA27510@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:2QD+qHa9NFweVDXjcXSNaswC5Fu3QeoHUJ4UTgCXTaqFJ0Mqtmp
 1MS/5KdxhL3T9wY5wpH0dsVBXgXjgcTYp0Y8ZLpU1plrTAlzKHOW6HbvtT6z/8ZRKNxC5L6
 8/R9g8tTXl0GXHN2gbshA6KUdx2LwwFM93MEVuEGzjwDpQPy7aeTIHtmtlN0RCXWgh9F5yc
 vhrp2dluE9vKo01xxZZXA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Rbesp5PPb1I=:/KNq3WCCbxj4qlnUsl7R7P
 a/isblyqMsmWWdZb+KXxhsbMKNB4pI5svAIaDsb8N8OXGKG7kdqbrKyCnD9SlK4ZukBPBBKOx
 PTin7e9jurtqXzT6BOPXTWVrncCyAkg61Jv0o2WmJIgl5Rg1pUv2CASFAfh6ucjDFC+1SMXZq
 nckaODRwBi1M+mtWcyqaB1dL8xZihVHhuM9Hzr3o9bAbBM7zcutCUl+7g2OqFRCy486GbXBlT
 vedBwwPiNsVsIIc6JOPMsGqYfu7JjQB+7ShonoY0HW1sgt/DY6d7LIv0IP8sg1WYXBxAmELco
 PUa+9f3QnYOW7yM4tFskLSYNzRTPM9AQ4kS68u9GjAkeSTXiFFESiloJpNDhlv6JjhJrvkVUE
 tP4owNoCzuKbl2Mxj8qFRolYZFU4VB6Rew/HQert3WFIQY7XK0aijGUcknBBFdNxEZ5uOHmW6
 JWWCUSJLEfyZHl+CLUSY04JPi2btQUL1HxNyaRCoUNZhrO0bli3m99vLu6I79jstuHPEW0A4d
 gsyv/inSTP8IaEg3D0a1bqgi1Ns7B02gmqh7S1osb/bkFJx+U1q1qfIUn8vm1ba67jyWRwlEY
 CSptYhb5/5MYPGhW9tCAsgy/cdnoH2wZCXYoRN33iR/QnCF8UFcQYyTiihiJKAahxFAsOv4vk
 8EianaZNJEq3WXI3xjrlkB/K3W2xtBQeWMqAjnZPk0/LPtR1+85wrAj9thiRgnoKMkuhSyo43
 DPb0qAKx4o0LJ5Y4F9Q9FbGuxzOrI/booKaI3dpFRjRZv4NwHHw5l/HrdQXf5w3TvndJngF+W
 c6p8eQM1wU8fmQV7ftYnF/5RJ4y8zV09iPd1Q4Y3w0ZbxtxUmER3ghHayCeez81Ksv4b3mteF
 9gX6nUqZoD0a7UlS5bIY2xTId8d0qu38wAxR/ScoOFW2KQnxTb2JNzjU/rC8EfEk8i9tpFSp0
 PznA39oUdht/RTCbIb5Kc2keixZOjkQFgevrWQErLF0iEYfkBChs4fAGEveyzc/dkUavPGKDX
 GL+YKNQ7s0+kpD8zCffaUdCye3IiEtr5d0Kmnis/qcTU05FC6CeNzBbmF6ohQCKJW/vf2H4Ld
 DBKY5uiACWIZKjlD+xKJTa4iFAWDrcy3JzlR4E7xtGKjxVTrdwwYi8BhAxlKDxD8ALEy9DYGW
 sTb3zCGJI5InsLAa4krf+4C25aNtNnZJNKAN5+IOrQA6j9MwIHqzw/7M4QjIfK15JWu9A=
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some coding-style issues, including one which
made the function pointers in the struct ei_device
hard to understand.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/8390.h | 61 +++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390.h b/drivers/net/ethernet/8390/=
8390.h
index 529c728f334a..e52264465998 100644
=2D-- a/drivers/net/ethernet/8390/8390.h
+++ b/drivers/net/ethernet/8390/8390.h
@@ -1,8 +1,10 @@
 /* Generic NS8390 register definitions. */
+
 /* This file is part of Donald Becker's 8390 drivers, and is distributed
-   under the same license. Auto-loading of 8390.o only in v2.2 - Paul G.
-   Some of these names and comments originated from the Crynwr
-   packet drivers, which are distributed under the GPL. */
+ * under the same license. Auto-loading of 8390.o only in v2.2 - Paul G.
+ * Some of these names and comments originated from the Crynwr
+ * packet drivers, which are distributed under the GPL.
+ */

 #ifndef _8390_h
 #define _8390_h
@@ -16,9 +18,9 @@

 /* The 8390 specific per-packet-header format. */
 struct e8390_pkt_hdr {
-  unsigned char status; /* status */
-  unsigned char next;   /* pointer to next packet. */
-  unsigned short count; /* header + packet length in bytes */
+	unsigned char status; /* status */
+	unsigned char next;   /* pointer to next packet. */
+	unsigned short count; /* header + packet length in bytes */
 };

 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -66,18 +68,24 @@ static inline struct net_device *alloc_eip_netdev(void=
)
 /* You have one of these per-board */
 struct ei_device {
 	const char *name;
-	void (*reset_8390)(struct net_device *);
-	void (*get_8390_hdr)(struct net_device *, struct e8390_pkt_hdr *, int);
-	void (*block_output)(struct net_device *, int, const unsigned char *, in=
t);
-	void (*block_input)(struct net_device *, int, struct sk_buff *, int);
+	void (*reset_8390)(struct net_device *dev);
+	void (*get_8390_hdr)(struct net_device *dev,
+			     struct e8390_pkt_hdr *hdr, int ring_page);
+	void (*block_output)(struct net_device *dev, int count,
+			     const unsigned char *buf, int start_page);
+	void (*block_input)(struct net_device *dev, int count,
+			    struct sk_buff *skb, int ring_offset);
 	unsigned long rmem_start;
 	unsigned long rmem_end;
 	void __iomem *mem;
 	unsigned char mcfilter[8];
 	unsigned open:1;
-	unsigned word16:1;  		/* We have the 16-bit (vs 8-bit) version of the ca=
rd. */
-	unsigned bigendian:1;		/* 16-bit big endian mode. Do NOT */
-					/* set this on random 8390 clones! */
+	unsigned word16:1;		/* We have the 16-bit (vs 8-bit)
+					 * version of the card.
+					 */
+	unsigned bigendian:1;		/* 16-bit big endian mode. Do NOT
+					 * set this on random 8390 clones!
+					 */
 	unsigned txing:1;		/* Transmit Active */
 	unsigned irqlock:1;		/* 8390's intrs disabled when '1'. */
 	unsigned dmaing:1;		/* Remote DMA Active */
@@ -115,12 +123,16 @@ struct ei_device {
 #define E8390_RXCONFIG		(ei_status.rxcr_base | 0x04)
 #define E8390_RXOFF		(ei_status.rxcr_base | 0x20)
 #else
-#define E8390_RXCONFIG		0x4	/* EN0_RXCR: broadcasts, no multicast,errors =
*/
-#define E8390_RXOFF		0x20	/* EN0_RXCR: Accept no packets */
+/* EN0_RXCR: broadcasts, no multicast,errors */
+#define E8390_RXCONFIG		0x4
+/* EN0_RXCR: Accept no packets */
+#define E8390_RXOFF		0x20
 #endif

-#define E8390_TXCONFIG		0x00	/* EN0_TXCR: Normal transmit mode */
-#define E8390_TXOFF		0x02	/* EN0_TXCR: Transmitter off */
+/* EN0_TXCR: Normal transmit mode */
+#define E8390_TXCONFIG		0x00
+/* EN0_TXCR: Transmitter off */
+#define E8390_TXOFF		0x02


 /*  Register accessed at EN_CMD, the 8390 base addr.  */
@@ -134,17 +146,16 @@ struct ei_device {
 #define E8390_PAGE1	0x40	/* using the two high-order bits */
 #define E8390_PAGE2	0x80	/* Page 3 is invalid. */

-/*
- *	Only generate indirect loads given a machine that needs them.
- *      - removed AMIGA_PCMCIA from this list, handled as ISA io now
- *	- the _p for generates no delay by default 8390p.c overrides this.
+/* Only generate indirect loads given a machine that needs them.
+ * - removed AMIGA_PCMCIA from this list, handled as ISA io now
+ * - the _p for generates no delay by default 8390p.c overrides this.
  */

 #ifndef ei_inb
 #define ei_inb(_p)	inb(_p)
-#define ei_outb(_v,_p)	outb(_v,_p)
+#define ei_outb(_v, _p)	outb(_v, _p)
 #define ei_inb_p(_p)	inb(_p)
-#define ei_outb_p(_v,_p) outb(_v,_p)
+#define ei_outb_p(_v, _p) outb(_v, _p)
 #endif

 #ifndef EI_SHIFT
@@ -153,9 +164,9 @@ struct ei_device {

 #define E8390_CMD	EI_SHIFT(0x00)  /* The command register (for all pages)=
 */
 /* Page 0 register offsets. */
-#define EN0_CLDALO	EI_SHIFT(0x01)	/* Low byte of current local dma addr  =
RD */
+#define EN0_CLDALO	EI_SHIFT(0x01)	/* Low byte of current local dma addr R=
D */
 #define EN0_STARTPG	EI_SHIFT(0x01)	/* Starting page of ring bfr WR */
-#define EN0_CLDAHI	EI_SHIFT(0x02)	/* High byte of current local dma addr =
 RD */
+#define EN0_CLDAHI	EI_SHIFT(0x02)	/* High byte of current local dma addr =
RD */
 #define EN0_STOPPG	EI_SHIFT(0x02)	/* Ending page +1 of ring bfr WR */
 #define EN0_BOUNDARY	EI_SHIFT(0x03)	/* Boundary page of ring bfr RD WR */
 #define EN0_TSR		EI_SHIFT(0x04)	/* Transmit status reg RD */
=2D-
2.20.1

