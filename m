Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D353A93E1
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhFPHay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:30:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4805 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbhFPH3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:07 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4c7n0GHXzXg0M;
        Wed, 16 Jun 2021 15:21:57 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 02/15] net: cosa: add blank line after declarations
Date:   Wed, 16 Jun 2021 15:23:28 +0800
Message-ID: <1623828221-48349-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
References: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 297ea34..372dffc 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -995,6 +995,7 @@ static int cosa_fasync(struct inode *inode, struct file *file, int on)
 static inline int cosa_reset(struct cosa_data *cosa)
 {
 	char idstring[COSA_MAX_ID_STRING];
+
 	if (cosa->usage > 1)
 		pr_info("cosa%d: WARNING: reset requested with cosa->usage > 1 (%d). Odd things may happen.\n",
 			cosa->num, cosa->usage);
@@ -1109,6 +1110,7 @@ static inline int cosa_start(struct cosa_data *cosa, int address)
 static inline int cosa_getidstr(struct cosa_data *cosa, char __user *string)
 {
 	int l = strlen(cosa->id_string)+1;
+
 	if (copy_to_user(string, cosa->id_string, l))
 		return -EFAULT;
 	return l;
@@ -1118,6 +1120,7 @@ static inline int cosa_getidstr(struct cosa_data *cosa, char __user *string)
 static inline int cosa_gettype(struct cosa_data *cosa, char __user *string)
 {
 	int l = strlen(cosa->type)+1;
+
 	if (copy_to_user(string, cosa->type, l))
 		return -EFAULT;
 	return l;
@@ -1127,6 +1130,7 @@ static int cosa_ioctl_common(struct cosa_data *cosa,
 	struct channel_data *channel, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
+
 	switch (cmd) {
 	case COSAIORSET:	/* Reset the device */
 		if (!capable(CAP_NET_ADMIN))
@@ -1172,6 +1176,7 @@ static int cosa_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	int rv;
 	struct channel_data *chan = dev_to_chan(dev);
+
 	rv = cosa_ioctl_common(chan->cosa, chan, cmd,
 			       (unsigned long)ifr->ifr_data);
 	if (rv != -ENOIOCTLCMD)
@@ -1356,6 +1361,7 @@ static int cosa_dma_able(struct channel_data *chan, char *buf, int len)
 {
 	static int count;
 	unsigned long b = (unsigned long)buf;
+
 	if (b+len >= MAX_DMA_ADDRESS)
 		return 0;
 	if ((b^ (b+len)) & 0x10000) {
@@ -1468,6 +1474,7 @@ static int readmem(struct cosa_data *cosa, char __user *microcode, int length, i
 	while (length--) {
 		char c;
 		int i;
+
 		if ((i=get_wait_data(cosa)) == -1) {
 			pr_info("0x%04x bytes remaining\n", length);
 			return -11;
@@ -1545,6 +1552,7 @@ static int get_wait_data(struct cosa_data *cosa)
 		/* read data and return them */
 		if (cosa_getstatus(cosa) & SR_RX_RDY) {
 			short r;
+
 			r = cosa_getdata8(cosa);
 #if 0
 			pr_info("get_wait_data returning after %d retries\n",
@@ -1568,6 +1576,7 @@ static int get_wait_data(struct cosa_data *cosa)
 static int put_wait_data(struct cosa_data *cosa, int data)
 {
 	int retries = 1000;
+
 	while (--retries) {
 		/* read data and return them */
 		if (cosa_getstatus(cosa) & SR_TX_RDY) {
@@ -1659,6 +1668,7 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 	if (!test_bit(IRQBIT, &cosa->rxtx)) {
 		/* flow control, see the comment above */
 		int i=0;
+
 		if (!cosa->txbitmap) {
 			pr_warn("%s: No channel wants data in TX IRQ. Expect DMA timeout.\n",
 				cosa->name);
@@ -1743,6 +1753,7 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 	if (cosa->busmaster) {
 		unsigned long addr = virt_to_bus(cosa->txbuf);
 		int count=0;
+
 		pr_info("busmaster IRQ\n");
 		while (!(cosa_getstatus(cosa)&SR_TX_RDY)) {
 			count++;
@@ -1873,6 +1884,7 @@ static inline void rx_interrupt(struct cosa_data *cosa, int status)
 static inline void eot_interrupt(struct cosa_data *cosa, int status)
 {
 	unsigned long flags, flags1;
+
 	spin_lock_irqsave(&cosa->lock, flags);
 	flags1 = claim_dma_lock();
 	disable_dma(cosa->dma);
@@ -1880,6 +1892,7 @@ static inline void eot_interrupt(struct cosa_data *cosa, int status)
 	release_dma_lock(flags1);
 	if (test_bit(TXBIT, &cosa->rxtx)) {
 		struct channel_data *chan = cosa->chan+cosa->txchan;
+
 		if (chan->tx_done)
 			if (chan->tx_done(chan, cosa->txsize))
 				clear_bit(chan->num, &cosa->txbitmap);
@@ -1887,6 +1900,7 @@ static inline void eot_interrupt(struct cosa_data *cosa, int status)
 #ifdef DEBUG_DATA
 	{
 		int i;
+
 		pr_info("cosa%dc%d: done rx(0x%x)",
 			cosa->num, cosa->rxchan->num, cosa->rxsize);
 		for (i=0; i<cosa->rxsize; i++)
@@ -1970,6 +1984,7 @@ static irqreturn_t cosa_interrupt(int irq, void *cosa_)
 static void debug_status_in(struct cosa_data *cosa, int status)
 {
 	char *s;
+
 	switch (status & SR_CMD_FROM_SRP_MASK) {
 	case SR_UP_REQUEST:
 		s = "RX_REQ";
-- 
2.8.1

