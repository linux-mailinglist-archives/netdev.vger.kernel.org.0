Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182231ECD0D
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 12:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgFCJ7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 05:59:48 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:51815 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726592AbgFCJ7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 05:59:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8116F58016C;
        Wed,  3 Jun 2020 05:59:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 03 Jun 2020 05:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5CtbXa
        i3qCV4buHPMAUky/dX+8hNex8Q7YHICpdU9YQ=; b=BF8F5ext9Mjlm15IbC5thL
        Dza+kuGYRStwCOy+YJgkDX1Mx2ScRDNQ7aqhUZ2JvpNqqIxCL5zXyZ/DLhdRM0sp
        CG5nEpNcK5JQ3FvHeZwUJ8liEbzfRPAj3QyqlLnGoDIZSboL028BCxDNu5EcVZDt
        m3fmEY9g2tSA1j6Fd5IbKDuDJzv7t3/SDIHsTli1KbVLTqRBlBe4NGP07b6EBjNM
        DRBy3u1JLDHIQJE34yLfqbGRo3U1E78gOmAh45vQo0TgE7zh2vWWugXBs9HXMWBv
        vgebG8ZHOylCx4BMcmp7VSIaaI05vSWN4WCwLYDzEeYkflqYwMMV+ttfkOt4L6+A
        ==
X-ME-Sender: <xms:kHTXXkL3hBvcGSM1dW1dfI_B2rYOwjl8p2SXvPgPho2sphBzZtYKpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefledgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kHTXXkKvkKLAVlyHjhcxbipUEIGnurN9ZD6uP2bnNhUIgsgDV5ylSg>
    <xmx:kHTXXktDSPn9hamro8g8KILFODkL52ZEEpMuS87rNTWKqWGaMz9sVw>
    <xmx:kHTXXhZ1QWh-hTr-KdsnHuI7xMQa427xN1DQlhVspeeyTYCbbu-JuA>
    <xmx:kXTXXoQOWR7_xFEfWqrudN8820lvIkg9m33ADpbedLXjDVyDTEqV3A>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D00B33280060;
        Wed,  3 Jun 2020 05:59:43 -0400 (EDT)
Date:   Wed, 3 Jun 2020 12:59:41 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 2/6] net: marvell: prestera: Add PCI interface support
Message-ID: <20200603095941.GA1847993@splinter>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-3-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528151245.7592-3-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 06:12:41PM +0300, Vadym Kochan wrote:
>  drivers/net/ethernet/marvell/prestera/Kconfig |  11 +
>  .../net/ethernet/marvell/prestera/Makefile    |   2 +
>  .../ethernet/marvell/prestera/prestera_pci.c  | 825 ++++++++++++++++++
>  3 files changed, 838 insertions(+)
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
> index 76b68613ea7a..0848edb272a5 100644
> --- a/drivers/net/ethernet/marvell/prestera/Kconfig
> +++ b/drivers/net/ethernet/marvell/prestera/Kconfig
> @@ -11,3 +11,14 @@ config PRESTERA
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called prestera.
> +
> +config PRESTERA_PCI
> +	tristate "PCI interface driver for Marvell Prestera Switch ASICs family"
> +	depends on PCI && HAS_IOMEM && PRESTERA
> +	default m
> +	---help---
> +	  This is implementation of PCI interface support for Marvell Prestera
> +	  Switch ASICs family.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called prestera_pci.
> diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
> index 610d75032b78..2146714eab21 100644
> --- a/drivers/net/ethernet/marvell/prestera/Makefile
> +++ b/drivers/net/ethernet/marvell/prestera/Makefile
> @@ -2,3 +2,5 @@
>  obj-$(CONFIG_PRESTERA)	+= prestera.o
>  prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
>  			   prestera_rxtx.o
> +
> +obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> new file mode 100644
> index 000000000000..0ec07732b12e
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> @@ -0,0 +1,825 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> +/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/pci.h>
> +#include <linux/circ_buf.h>
> +#include <linux/firmware.h>
> +#include <linux/iopoll.h>
> +
> +#include "prestera.h"
> +
> +#define PRESTERA_MSG_MAX_SIZE 1500
> +
> +#define PRESTERA_SUPP_FW_MAJ_VER	2
> +#define PRESTERA_SUPP_FW_MIN_VER	0
> +
> +#define PRESTERA_FW_PATH \
> +	"mrvl/prestera/mvsw_prestera_fw-v" \
> +	__stringify(PRESTERA_SUPP_FW_MAJ_VER) \
> +	"." __stringify(PRESTERA_SUPP_FW_MIN_VER) ".img"
> +
> +#define PRESTERA_FW_HDR_MAGIC	0x351D9D06
> +#define PRESTERA_FW_DL_TIMEOUT	50000

#define PRESTERA_FW_DL_TIMEOUT_MS (50 * 1000)

> +#define PRESTERA_FW_BLK_SZ	1024
> +
> +#define PRESTERA_FW_VER_MAJ_MUL 1000000
> +#define PRESTERA_FW_VER_MIN_MUL 1000
> +
> +#define PRESTERA_FW_VER_MAJ(v)	((v) / PRESTERA_FW_VER_MAJ_MUL)
> +
> +#define PRESTERA_FW_VER_MIN(v) \
> +	(((v) - (PRESTERA_FW_VER_MAJ(v) * PRESTERA_FW_VER_MAJ_MUL)) / \
> +			PRESTERA_FW_VER_MIN_MUL)
> +
> +#define PRESTERA_FW_VER_PATCH(v) \
> +	((v) - (PRESTERA_FW_VER_MAJ(v) * PRESTERA_FW_VER_MAJ_MUL) - \
> +			(PRESTERA_FW_VER_MIN(v) * PRESTERA_FW_VER_MIN_MUL))
> +
> +struct prestera_fw_header {
> +	__be32 magic_number;
> +	__be32 version_value;
> +	u8 reserved[8];
> +} __packed;
> +
> +struct prestera_ldr_regs {
> +	u32 ldr_ready;
> +	u32 pad1;
> +
> +	u32 ldr_img_size;
> +	u32 ldr_ctl_flags;
> +
> +	u32 ldr_buf_offs;
> +	u32 ldr_buf_size;
> +
> +	u32 ldr_buf_rd;
> +	u32 pad2;
> +	u32 ldr_buf_wr;
> +
> +	u32 ldr_status;
> +} __packed __aligned(4);
> +
> +#define PRESTERA_LDR_REG_OFFSET(f)	offsetof(struct prestera_ldr_regs, f)
> +
> +#define PRESTERA_LDR_READY_MAGIC	0xf00dfeed
> +
> +#define PRESTERA_LDR_STATUS_IMG_DL	BIT(0)
> +#define PRESTERA_LDR_STATUS_START_FW	BIT(1)
> +#define PRESTERA_LDR_STATUS_INVALID_IMG	BIT(2)
> +#define PRESTERA_LDR_STATUS_NOMEM	BIT(3)
> +
> +#define PRESTERA_LDR_REG_BASE(fw)	((fw)->ldr_regs)
> +#define PRESTERA_LDR_REG_ADDR(fw, reg)	(PRESTERA_LDR_REG_BASE(fw) + (reg))
> +
> +#define prestera_ldr_write(fw, reg, val) \
> +	writel(val, PRESTERA_LDR_REG_ADDR(fw, reg))
> +#define prestera_ldr_read(fw, reg)	\
> +	readl(PRESTERA_LDR_REG_ADDR(fw, reg))
> +
> +/* fw loader registers */
> +#define PRESTERA_LDR_READY_REG		PRESTERA_LDR_REG_OFFSET(ldr_ready)
> +#define PRESTERA_LDR_IMG_SIZE_REG	PRESTERA_LDR_REG_OFFSET(ldr_img_size)
> +#define PRESTERA_LDR_CTL_REG		PRESTERA_LDR_REG_OFFSET(ldr_ctl_flags)
> +#define PRESTERA_LDR_BUF_SIZE_REG	PRESTERA_LDR_REG_OFFSET(ldr_buf_size)
> +#define PRESTERA_LDR_BUF_OFFS_REG	PRESTERA_LDR_REG_OFFSET(ldr_buf_offs)
> +#define PRESTERA_LDR_BUF_RD_REG		PRESTERA_LDR_REG_OFFSET(ldr_buf_rd)
> +#define PRESTERA_LDR_BUF_WR_REG		PRESTERA_LDR_REG_OFFSET(ldr_buf_wr)
> +#define PRESTERA_LDR_STATUS_REG		PRESTERA_LDR_REG_OFFSET(ldr_status)
> +
> +#define PRESTERA_LDR_CTL_DL_START	BIT(0)
> +
> +#define PRESTERA_EVT_QNUM_MAX	4
> +
> +struct prestera_fw_evtq_regs {
> +	u32 rd_idx;
> +	u32 pad1;
> +	u32 wr_idx;
> +	u32 pad2;
> +	u32 offs;
> +	u32 len;
> +};
> +
> +struct prestera_fw_regs {
> +	u32 fw_ready;
> +	u32 pad;
> +	u32 cmd_offs;
> +	u32 cmd_len;
> +	u32 evt_offs;
> +	u32 evt_qnum;
> +
> +	u32 cmd_req_ctl;
> +	u32 cmd_req_len;
> +	u32 cmd_rcv_ctl;
> +	u32 cmd_rcv_len;
> +
> +	u32 fw_status;
> +	u32 rx_status;
> +
> +	struct prestera_fw_evtq_regs evtq_list[PRESTERA_EVT_QNUM_MAX];
> +};
> +
> +#define PRESTERA_FW_REG_OFFSET(f)	offsetof(struct prestera_fw_regs, f)
> +
> +#define PRESTERA_FW_READY_MAGIC	0xcafebabe
> +
> +/* fw registers */
> +#define PRESTERA_FW_READY_REG		PRESTERA_FW_REG_OFFSET(fw_ready)
> +
> +#define PRESTERA_CMD_BUF_OFFS_REG	PRESTERA_FW_REG_OFFSET(cmd_offs)
> +#define PRESTERA_CMD_BUF_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_len)
> +#define PRESTERA_EVT_BUF_OFFS_REG	PRESTERA_FW_REG_OFFSET(evt_offs)
> +#define PRESTERA_EVT_QNUM_REG		PRESTERA_FW_REG_OFFSET(evt_qnum)
> +
> +#define PRESTERA_CMD_REQ_CTL_REG	PRESTERA_FW_REG_OFFSET(cmd_req_ctl)
> +#define PRESTERA_CMD_REQ_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_req_len)
> +
> +#define PRESTERA_CMD_RCV_CTL_REG	PRESTERA_FW_REG_OFFSET(cmd_rcv_ctl)
> +#define PRESTERA_CMD_RCV_LEN_REG	PRESTERA_FW_REG_OFFSET(cmd_rcv_len)
> +#define PRESTERA_FW_STATUS_REG		PRESTERA_FW_REG_OFFSET(fw_status)
> +#define PRESTERA_RX_STATUS_REG		PRESTERA_FW_REG_OFFSET(rx_status)
> +
> +/* PRESTERA_CMD_REQ_CTL_REG flags */
> +#define PRESTERA_CMD_F_REQ_SENT		BIT(0)
> +#define PRESTERA_CMD_F_REPL_RCVD	BIT(1)
> +
> +/* PRESTERA_CMD_RCV_CTL_REG flags */
> +#define PRESTERA_CMD_F_REPL_SENT	BIT(0)
> +
> +#define PRESTERA_EVTQ_REG_OFFSET(q, f)			\
> +	(PRESTERA_FW_REG_OFFSET(evtq_list) +		\
> +	 (q) * sizeof(struct prestera_fw_evtq_regs) +	\
> +	 offsetof(struct prestera_fw_evtq_regs, f))
> +
> +#define PRESTERA_EVTQ_RD_IDX_REG(q)	PRESTERA_EVTQ_REG_OFFSET(q, rd_idx)
> +#define PRESTERA_EVTQ_WR_IDX_REG(q)	PRESTERA_EVTQ_REG_OFFSET(q, wr_idx)
> +#define PRESTERA_EVTQ_OFFS_REG(q)	PRESTERA_EVTQ_REG_OFFSET(q, offs)
> +#define PRESTERA_EVTQ_LEN_REG(q)	PRESTERA_EVTQ_REG_OFFSET(q, len)
> +
> +#define PRESTERA_FW_REG_BASE(fw)	((fw)->dev.ctl_regs)
> +#define PRESTERA_FW_REG_ADDR(fw, reg)	PRESTERA_FW_REG_BASE(fw) + (reg)
> +
> +#define prestera_fw_write(fw, reg, val)	\
> +	writel(val, PRESTERA_FW_REG_ADDR(fw, reg))
> +#define prestera_fw_read(fw, reg) \
> +	readl(PRESTERA_FW_REG_ADDR(fw, reg))
> +
> +struct prestera_fw_evtq {
> +	u8 __iomem *addr;
> +	size_t len;
> +};
> +
> +struct prestera_fw {
> +	struct workqueue_struct *wq;
> +	struct prestera_device dev;
> +	struct pci_dev *pci_dev;
> +	u8 __iomem *ldr_regs;
> +	u8 __iomem *ldr_ring_buf;
> +	u32 ldr_buf_len;
> +	u32 ldr_wr_idx;
> +	struct mutex cmd_mtx; /* serialize access to dev->send_req */
> +	size_t cmd_mbox_len;
> +	u8 __iomem *cmd_mbox;
> +	struct prestera_fw_evtq evt_queue[PRESTERA_EVT_QNUM_MAX];
> +	u8 evt_qnum;
> +	struct work_struct evt_work;
> +	u8 __iomem *evt_buf;
> +	u8 *evt_msg;
> +};
> +
> +static int prestera_fw_load(struct prestera_fw *fw);
> +
> +static u32 prestera_fw_evtq_len(struct prestera_fw *fw, u8 qid)
> +{
> +	return fw->evt_queue[qid].len;
> +}
> +
> +static u32 prestera_fw_evtq_avail(struct prestera_fw *fw, u8 qid)
> +{
> +	u32 wr_idx = prestera_fw_read(fw, PRESTERA_EVTQ_WR_IDX_REG(qid));
> +	u32 rd_idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
> +
> +	return CIRC_CNT(wr_idx, rd_idx, prestera_fw_evtq_len(fw, qid));
> +}
> +
> +static void prestera_fw_evtq_rd_set(struct prestera_fw *fw,
> +				    u8 qid, u32 idx)
> +{
> +	u32 rd_idx = idx & (prestera_fw_evtq_len(fw, qid) - 1);
> +
> +	prestera_fw_write(fw, PRESTERA_EVTQ_RD_IDX_REG(qid), rd_idx);
> +}
> +
> +static u8 __iomem *prestera_fw_evtq_buf(struct prestera_fw *fw, u8 qid)
> +{
> +	return fw->evt_queue[qid].addr;
> +}
> +
> +static u32 prestera_fw_evtq_read32(struct prestera_fw *fw, u8 qid)
> +{
> +	u32 rd_idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
> +	u32 val;
> +
> +	val = readl(prestera_fw_evtq_buf(fw, qid) + rd_idx);
> +	prestera_fw_evtq_rd_set(fw, qid, rd_idx + 4);
> +	return val;
> +}
> +
> +static ssize_t prestera_fw_evtq_read_buf(struct prestera_fw *fw,
> +					 u8 qid, u8 *buf, size_t len)
> +{
> +	u32 idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
> +	u8 __iomem *evtq_addr = prestera_fw_evtq_buf(fw, qid);
> +	u32 *buf32 = (u32 *)buf;
> +	int i;
> +
> +	for (i = 0; i < len / 4; buf32++, i++) {
> +		*buf32 = readl_relaxed(evtq_addr + idx);
> +		idx = (idx + 4) & (prestera_fw_evtq_len(fw, qid) - 1);
> +	}
> +
> +	prestera_fw_evtq_rd_set(fw, qid, idx);
> +
> +	return i;
> +}
> +
> +static u8 prestera_fw_evtq_pick(struct prestera_fw *fw)
> +{
> +	int qid;
> +
> +	for (qid = 0; qid < fw->evt_qnum; qid++) {
> +		if (prestera_fw_evtq_avail(fw, qid) >= 4)
> +			return qid;
> +	}
> +
> +	return PRESTERA_EVT_QNUM_MAX;
> +}
> +
> +static void prestera_fw_evt_work_fn(struct work_struct *work)
> +{
> +	struct prestera_fw *fw;
> +	u8 *msg;
> +	u8 qid;
> +
> +	fw = container_of(work, struct prestera_fw, evt_work);
> +	msg = fw->evt_msg;
> +
> +	while ((qid = prestera_fw_evtq_pick(fw)) < PRESTERA_EVT_QNUM_MAX) {
> +		u32 idx;
> +		u32 len;
> +
> +		len = prestera_fw_evtq_read32(fw, qid);
> +		idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
> +
> +		WARN_ON(prestera_fw_evtq_avail(fw, qid) < len);
> +
> +		if (WARN_ON(len > PRESTERA_MSG_MAX_SIZE)) {
> +			prestera_fw_evtq_rd_set(fw, qid, idx + len);
> +			continue;
> +		}
> +
> +		prestera_fw_evtq_read_buf(fw, qid, msg, len);
> +
> +		if (fw->dev.recv_msg)
> +			fw->dev.recv_msg(&fw->dev, msg, len);
> +	}
> +}
> +
> +static int prestera_fw_wait_reg32(struct prestera_fw *fw, u32 reg, u32 cmp,
> +				  unsigned int waitms)
> +{
> +	u8 __iomem *addr = PRESTERA_FW_REG_ADDR(fw, reg);
> +	u32 val = 0;
> +
> +	return readl_poll_timeout(addr, val, cmp == val, 1000 * 10, waitms * 1000);
> +}
> +
> +static void prestera_pci_copy_to(u8 __iomem *dst, u8 *src, size_t len)
> +{
> +	u32 __iomem *dst32 = (u32 __iomem *)dst;
> +	u32 *src32 = (u32 *)src;
> +	int i;
> +
> +	for (i = 0; i < (len / 4); dst32++, src32++, i++)
> +		writel_relaxed(*src32, dst32);
> +}
> +
> +static void prestera_pci_copy_from(u8 *dst, u8 __iomem *src, size_t len)
> +{
> +	u32 *dst32 = (u32 *)dst;
> +	u32 __iomem *src32 = (u32 __iomem *)src;

The convention in the networking subsystem is to use reverse xmas tree
for local variables:

---
--
-

> +	int i;
> +
> +	for (i = 0; i < (len / 4); dst32++, src32++, i++)
> +		*dst32 = readl_relaxed(src32);
> +}
> +
> +static int prestera_fw_cmd_send(struct prestera_fw *fw,
> +				u8 *in_msg, size_t in_size,
> +				u8 *out_msg, size_t out_size,
> +				unsigned int waitms)
> +{
> +	u32 ret_size = 0;
> +	int err = 0;
> +
> +	if (!waitms)
> +		waitms = 30000;

Use a define instead of a magic number

> +
> +	if (ALIGN(in_size, 4) > fw->cmd_mbox_len)
> +		return -EMSGSIZE;
> +
> +	/* wait for finish previous reply from FW */
> +	err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG, 0, 30);
> +	if (err) {
> +		dev_err(fw->dev.dev, "finish reply from FW is timed out\n");
> +		return err;
> +	}
> +
> +	prestera_fw_write(fw, PRESTERA_CMD_REQ_LEN_REG, in_size);
> +	prestera_pci_copy_to(fw->cmd_mbox, in_msg, in_size);
> +
> +	prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REQ_SENT);
> +
> +	/* wait for reply from FW */
> +	err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG,
> +				     PRESTERA_CMD_F_REPL_SENT, waitms);
> +	if (err) {
> +		dev_err(fw->dev.dev, "reply from FW is timed out\n");
> +		goto cmd_exit;
> +	}
> +
> +	ret_size = prestera_fw_read(fw, PRESTERA_CMD_RCV_LEN_REG);
> +	if (ret_size > out_size) {
> +		dev_err(fw->dev.dev, "ret_size (%u) > out_len(%zu)\n",
> +			ret_size, out_size);
> +		err = -EMSGSIZE;
> +		goto cmd_exit;
> +	}
> +
> +	prestera_pci_copy_from(out_msg, fw->cmd_mbox + in_size, ret_size);
> +
> +cmd_exit:
> +	prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REPL_RCVD);
> +	return err;
> +}
> +
> +static int prestera_fw_send_req(struct prestera_device *dev,
> +				u8 *in_msg, size_t in_size, u8 *out_msg,
> +				size_t out_size, unsigned int waitms)
> +{
> +	struct prestera_fw *fw;
> +	ssize_t ret;
> +
> +	fw = container_of(dev, struct prestera_fw, dev);
> +
> +	mutex_lock(&fw->cmd_mtx);
> +	ret = prestera_fw_cmd_send(fw, in_msg, in_size, out_msg, out_size, waitms);
> +	mutex_unlock(&fw->cmd_mtx);
> +
> +	return ret;
> +}
> +
> +static int prestera_fw_init(struct prestera_fw *fw)
> +{
> +	u8 __iomem *base;
> +	int err;
> +	u8 qid;
> +
> +	fw->dev.send_req = prestera_fw_send_req;
> +	fw->ldr_regs = fw->dev.ctl_regs;
> +
> +	err = prestera_fw_load(fw);
> +	if (err && err != -ETIMEDOUT)
> +		return err;
> +
> +	err = prestera_fw_wait_reg32(fw, PRESTERA_FW_READY_REG,
> +				     PRESTERA_FW_READY_MAGIC, 20000);

Likewise

> +	if (err) {
> +		dev_err(fw->dev.dev, "FW is failed to start\n");

FW failed to start

> +		return err;
> +	}
> +
> +	base = fw->dev.ctl_regs;
> +
> +	fw->cmd_mbox = base + prestera_fw_read(fw, PRESTERA_CMD_BUF_OFFS_REG);
> +	fw->cmd_mbox_len = prestera_fw_read(fw, PRESTERA_CMD_BUF_LEN_REG);
> +	mutex_init(&fw->cmd_mtx);
> +
> +	fw->evt_buf = base + prestera_fw_read(fw, PRESTERA_EVT_BUF_OFFS_REG);
> +	fw->evt_qnum = prestera_fw_read(fw, PRESTERA_EVT_QNUM_REG);
> +	fw->evt_msg = kmalloc(PRESTERA_MSG_MAX_SIZE, GFP_KERNEL);
> +	if (!fw->evt_msg)
> +		return -ENOMEM;
> +
> +	for (qid = 0; qid < fw->evt_qnum; qid++) {
> +		u32 offs = prestera_fw_read(fw, PRESTERA_EVTQ_OFFS_REG(qid));
> +		struct prestera_fw_evtq *evtq = &fw->evt_queue[qid];
> +
> +		evtq->len = prestera_fw_read(fw, PRESTERA_EVTQ_LEN_REG(qid));
> +		evtq->addr = fw->evt_buf + offs;
> +	}
> +
> +	return 0;
> +}
> +
> +static void prestera_fw_uninit(struct prestera_fw *fw)
> +{
> +	kfree(fw->evt_msg);
> +}
> +
> +static irqreturn_t prestera_pci_irq_handler(int irq, void *dev_id)
> +{
> +	struct prestera_fw *fw = dev_id;
> +
> +	if (prestera_fw_read(fw, PRESTERA_RX_STATUS_REG)) {
> +		prestera_fw_write(fw, PRESTERA_RX_STATUS_REG, 0);
> +
> +		if (fw->dev.recv_pkt)
> +			fw->dev.recv_pkt(&fw->dev);
> +	}
> +
> +	queue_work(fw->wq, &fw->evt_work);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int prestera_ldr_wait_reg32(struct prestera_fw *fw,
> +				   u32 reg, u32 cmp, unsigned int waitms)
> +{
> +	u8 __iomem *addr = PRESTERA_LDR_REG_ADDR(fw, reg);
> +	u32 val = 0;
> +
> +	return readl_poll_timeout(addr, val, cmp == val, 1000 * 10, waitms * 1000);
> +}
> +
> +static u32 prestera_ldr_wait_buf(struct prestera_fw *fw, size_t len)
> +{
> +	u8 __iomem *addr = PRESTERA_LDR_REG_ADDR(fw, PRESTERA_LDR_BUF_RD_REG);
> +	u32 buf_len = fw->ldr_buf_len;
> +	u32 wr_idx = fw->ldr_wr_idx;
> +	u32 rd_idx = 0;
> +	int err;
> +
> +	err = readl_poll_timeout(addr, rd_idx,
> +				 CIRC_SPACE(wr_idx, rd_idx, buf_len) >= len,
> +				 1000, 100 * 1000);
> +	if (err)
> +		return err;

Return directly

> +
> +	return 0;
> +}
> +
> +static int prestera_ldr_wait_dl_finish(struct prestera_fw *fw)
> +{
> +	u8 __iomem *addr = PRESTERA_LDR_REG_ADDR(fw, PRESTERA_LDR_STATUS_REG);
> +	unsigned int waitus = PRESTERA_FW_DL_TIMEOUT * 1000;
> +	unsigned long mask = ~(PRESTERA_LDR_STATUS_IMG_DL);
> +	u32 val = 0;
> +	int err;
> +
> +	err = readl_poll_timeout(addr, val, val & mask, 1000 * 10, waitus);
> +	if (err) {
> +		dev_err(fw->dev.dev, "Timeout to load FW img [state=%d]",
> +			prestera_ldr_read(fw, PRESTERA_LDR_STATUS_REG));
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void prestera_ldr_wr_idx_move(struct prestera_fw *fw, unsigned int n)
> +{
> +	fw->ldr_wr_idx = (fw->ldr_wr_idx + (n)) & (fw->ldr_buf_len - 1);
> +}
> +
> +static void prestera_ldr_wr_idx_commit(struct prestera_fw *fw)
> +{
> +	prestera_ldr_write(fw, PRESTERA_LDR_BUF_WR_REG, fw->ldr_wr_idx);
> +}
> +
> +static u8 __iomem *prestera_ldr_wr_ptr(struct prestera_fw *fw)
> +{
> +	return fw->ldr_ring_buf + fw->ldr_wr_idx;
> +}
> +
> +static int prestera_ldr_send(struct prestera_fw *fw, const u8 *buf, size_t len)
> +{
> +	int err;
> +	int i;
> +
> +	err = prestera_ldr_wait_buf(fw, len);
> +	if (err) {
> +		dev_err(fw->dev.dev, "failed wait for sending firmware\n");
> +		return err;
> +	}
> +
> +	for (i = 0; i < len; i += 4) {
> +		writel_relaxed(*(u32 *)(buf + i), prestera_ldr_wr_ptr(fw));
> +		prestera_ldr_wr_idx_move(fw, 4);
> +	}
> +
> +	prestera_ldr_wr_idx_commit(fw);
> +	return 0;
> +}
> +
> +static int prestera_ldr_fw_send(struct prestera_fw *fw,
> +				const char *img, u32 fw_size)
> +{
> +	u32 status;
> +	u32 pos;
> +	int err;
> +
> +	err = prestera_ldr_wait_reg32(fw, PRESTERA_LDR_STATUS_REG,
> +				      PRESTERA_LDR_STATUS_IMG_DL, 5 * 1000);
> +	if (err) {
> +		dev_err(fw->dev.dev, "Loader is not ready to load image\n");
> +		return err;
> +	}
> +
> +	for (pos = 0; pos < fw_size; pos += PRESTERA_FW_BLK_SZ) {
> +		if (pos + PRESTERA_FW_BLK_SZ > fw_size)
> +			break;
> +
> +		err = prestera_ldr_send(fw, img + pos, PRESTERA_FW_BLK_SZ);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (pos < fw_size) {
> +		err = prestera_ldr_send(fw, img + pos, fw_size - pos);
> +		if (err)
> +			return err;
> +	}
> +
> +	err = prestera_ldr_wait_dl_finish(fw);
> +	if (err)
> +		return err;
> +
> +	status = prestera_ldr_read(fw, PRESTERA_LDR_STATUS_REG);
> +	if (status != PRESTERA_LDR_STATUS_START_FW) {
> +		switch (status) {
> +		case PRESTERA_LDR_STATUS_INVALID_IMG:
> +			dev_err(fw->dev.dev, "FW img has bad CRC\n");
> +			return -EINVAL;
> +		case PRESTERA_LDR_STATUS_NOMEM:
> +			dev_err(fw->dev.dev, "Loader has no enough mem\n");
> +			return -ENOMEM;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void prestera_fw_rev_parse(const struct prestera_fw_header *hdr,
> +				  struct prestera_fw_rev *rev)
> +{
> +	u32 version = be32_to_cpu(hdr->version_value);
> +
> +	rev->maj = PRESTERA_FW_VER_MAJ(version);
> +	rev->min = PRESTERA_FW_VER_MIN(version);
> +	rev->sub = PRESTERA_FW_VER_PATCH(version);
> +}
> +
> +static int prestera_fw_rev_check(struct prestera_fw *fw)
> +{
> +	struct prestera_fw_rev *rev = &fw->dev.fw_rev;
> +	u16 maj_supp = PRESTERA_SUPP_FW_MAJ_VER;
> +	u16 min_supp = PRESTERA_SUPP_FW_MIN_VER;
> +
> +	if (rev->maj == maj_supp && rev->min >= min_supp)
> +		return 0;
> +
> +	dev_err(fw->dev.dev, "Driver supports FW version only '%u.%u.x'",
> +		PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
> +
> +	return -EINVAL;
> +}
> +
> +static int prestera_fw_hdr_parse(struct prestera_fw *fw,
> +				 const struct firmware *img)
> +{
> +	struct prestera_fw_header *hdr = (struct prestera_fw_header *)img->data;
> +	struct prestera_fw_rev *rev = &fw->dev.fw_rev;
> +	u32 magic;
> +
> +	magic = be32_to_cpu(hdr->magic_number);
> +	if (magic != PRESTERA_FW_HDR_MAGIC) {
> +		dev_err(fw->dev.dev, "FW img hdr magic is invalid");
> +		return -EINVAL;
> +	}
> +
> +	prestera_fw_rev_parse(hdr, rev);
> +
> +	dev_info(fw->dev.dev, "FW version '%u.%u.%u'\n",
> +		 rev->maj, rev->min, rev->sub);
> +
> +	return prestera_fw_rev_check(fw);
> +}
> +
> +static int prestera_fw_load(struct prestera_fw *fw)
> +{
> +	size_t hlen = sizeof(struct prestera_fw_header);
> +	const struct firmware *f;
> +	int err;
> +
> +	err = prestera_ldr_wait_reg32(fw, PRESTERA_LDR_READY_REG,
> +				      PRESTERA_LDR_READY_MAGIC, 5 * 1000);
> +	if (err) {
> +		dev_err(fw->dev.dev, "waiting for FW loader is timed out");
> +		return err;
> +	}
> +
> +	fw->ldr_ring_buf = fw->ldr_regs +
> +		prestera_ldr_read(fw, PRESTERA_LDR_BUF_OFFS_REG);
> +
> +	fw->ldr_buf_len =
> +		prestera_ldr_read(fw, PRESTERA_LDR_BUF_SIZE_REG);
> +
> +	fw->ldr_wr_idx = 0;
> +
> +	err = request_firmware_direct(&f, PRESTERA_FW_PATH, &fw->pci_dev->dev);
> +	if (err) {
> +		dev_err(fw->dev.dev, "failed to request firmware file\n");
> +		return err;
> +	}
> +
> +	if (!IS_ALIGNED(f->size, 4)) {
> +		dev_err(fw->dev.dev, "FW image file is not aligned");
> +		release_firmware(f);
> +		return -EINVAL;
> +	}
> +
> +	err = prestera_fw_hdr_parse(fw, f);
> +	if (err) {
> +		dev_err(fw->dev.dev, "FW image header is invalid\n");
> +		release_firmware(f);
> +		return err;
> +	}
> +
> +	prestera_ldr_write(fw, PRESTERA_LDR_IMG_SIZE_REG, f->size - hlen);
> +	prestera_ldr_write(fw, PRESTERA_LDR_CTL_REG, PRESTERA_LDR_CTL_DL_START);
> +
> +	dev_info(fw->dev.dev, "Loading prestera FW image ...");
> +
> +	err = prestera_ldr_fw_send(fw, f->data + hlen, f->size - hlen);
> +
> +	release_firmware(f);
> +	return err;
> +}
> +
> +static int prestera_pci_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	const char *driver_name = pdev->driver->name;
> +	struct prestera_fw *fw;
> +	u8 __iomem *ctl_addr, *pp_addr;

Reverse xmas tree

> +	int err;
> +
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "pci_enable_device failed\n");
> +		goto err_pci_enable_device;

Why the goto? You have nothing to rollback.

> +	}
> +
> +	err = pci_request_regions(pdev, driver_name);
> +	if (err) {
> +		dev_err(&pdev->dev, "pci_request_regions failed\n");
> +		goto err_pci_request_regions;
> +	}
> +
> +	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(30))) {
> +		dev_err(&pdev->dev, "fail to set DMA mask\n");
> +		goto err_dma_mask;
> +	}
> +
> +	ctl_addr = pci_ioremap_bar(pdev, 2);
> +	if (!ctl_addr) {
> +		dev_err(&pdev->dev, "ioremap failed\n");
> +		err = -EIO;
> +		goto err_ctl_ioremap;
> +	}
> +
> +	pp_addr = pci_ioremap_bar(pdev, 4);
> +	if (!pp_addr) {
> +		dev_err(&pdev->dev, "ioremap failed\n");
> +		err = -EIO;
> +		goto err_pp_ioremap;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	fw = kzalloc(sizeof(*fw), GFP_KERNEL);
> +	if (!fw) {
> +		err = -ENOMEM;
> +		goto err_pci_dev_alloc;
> +	}
> +
> +	fw->pci_dev = pdev;
> +	fw->dev.dev = &pdev->dev;
> +	fw->dev.ctl_regs = ctl_addr;
> +	fw->dev.pp_regs = pp_addr;
> +
> +	fw->wq = alloc_workqueue("prestera_fw_wq", WQ_HIGHPRI, 1);
> +	if (!fw->wq)
> +		goto err_wq_alloc;
> +
> +	INIT_WORK(&fw->evt_work, prestera_fw_evt_work_fn);
> +
> +	err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "MSI IRQ init failed\n");
> +		goto err_irq_alloc;
> +	}
> +
> +	err = request_irq(pci_irq_vector(pdev, 0), prestera_pci_irq_handler,
> +			  0, driver_name, fw);
> +	if (err) {
> +		dev_err(&pdev->dev, "fail to request IRQ\n");
> +		goto err_request_irq;
> +	}
> +
> +	pci_set_drvdata(pdev, fw);
> +
> +	err = prestera_fw_init(fw);
> +	if (err)
> +		goto err_prestera_fw_init;
> +
> +	dev_info(fw->dev.dev, "Switch FW is ready\n");
> +
> +	err = prestera_device_register(&fw->dev);
> +	if (err)
> +		goto err_prestera_dev_register;
> +
> +	return 0;
> +
> +err_prestera_dev_register:
> +	prestera_fw_uninit(fw);
> +err_prestera_fw_init:
> +	free_irq(pci_irq_vector(pdev, 0), fw);
> +err_request_irq:
> +	pci_free_irq_vectors(pdev);
> +err_irq_alloc:
> +	destroy_workqueue(fw->wq);
> +err_wq_alloc:
> +	kfree(fw);
> +err_pci_dev_alloc:
> +	iounmap(pp_addr);
> +err_pp_ioremap:
> +	iounmap(ctl_addr);
> +err_ctl_ioremap:
> +err_dma_mask:
> +	pci_release_regions(pdev);
> +err_pci_request_regions:
> +	pci_disable_device(pdev);
> +err_pci_enable_device:
> +	return err;
> +}
> +
> +static void prestera_pci_remove(struct pci_dev *pdev)
> +{
> +	struct prestera_fw *fw = pci_get_drvdata(pdev);
> +
> +	free_irq(pci_irq_vector(pdev, 0), fw);
> +	pci_free_irq_vectors(pdev);
> +	prestera_device_unregister(&fw->dev);
> +	flush_workqueue(fw->wq);
> +	destroy_workqueue(fw->wq);

I believe you don't need to call flush_workqueue() before
destroy_workqueue()

> +	prestera_fw_uninit(fw);
> +	iounmap(fw->dev.pp_regs);
> +	iounmap(fw->dev.ctl_regs);
> +	pci_release_regions(pdev);
> +	pci_disable_device(pdev);
> +	kfree(fw);

Not symmetric with the error path above

> +}
> +
> +static const struct pci_device_id prestera_pci_devices[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
> +
> +static struct pci_driver prestera_pci_driver = {
> +	.name     = "Prestera DX",
> +	.id_table = prestera_pci_devices,
> +	.probe    = prestera_pci_probe,
> +	.remove   = prestera_pci_remove,
> +};
> +
> +static int __init prestera_pci_init(void)
> +{
> +	return pci_register_driver(&prestera_pci_driver);
> +}
> +
> +static void __exit prestera_pci_exit(void)
> +{
> +	pci_unregister_driver(&prestera_pci_driver);
> +}
> +
> +module_init(prestera_pci_init);
> +module_exit(prestera_pci_exit);
> +
> +MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_DESCRIPTION("Marvell Prestera switch PCI interface");
> -- 
> 2.17.1
> 
