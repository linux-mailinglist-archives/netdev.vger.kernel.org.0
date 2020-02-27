Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5310717159B
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 12:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgB0LFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 06:05:14 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39235 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728855AbgB0LFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 06:05:14 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so2765281wrn.6
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 03:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fuh7Jlhq7Auma4dTR2bp9FSFR8cc78L8Wa2CMR2kVh0=;
        b=pJXpgGAbdnYb8twZF28X5WNiqlELlqPlxZZ83mam+JONULGoAh91k998Gq2ckHKc8C
         8rNKSVDuSvl4BwHgckH4bB6Hyf2HT4riSpFsM8k0LuO/av3khfg4/vp1lDnbdxfhx1CV
         r+AWYWdvm56+6wsBTXdzhCkEbU7nehY92OcAyvPpr1g2Ug6KZvCYbDoUmktz2Wlw+FBp
         GwwrMem56qRlsD8QgdPVieaQPKewgU93mlvEeiL5PDhumgxKOTaTfRhhodaVtYbGJU5f
         k3sLfBtajrbefsZuoXtLfXbcFEV8RVQuD+ygrzP87EeEOm/6nBcPu4GDpkEvybahi0Ne
         TvLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fuh7Jlhq7Auma4dTR2bp9FSFR8cc78L8Wa2CMR2kVh0=;
        b=VaeKg0XjZJ9NswKcfJAe2+QZdJAXh29a6kfnmutJK+YNi60mBT2ljH8kUJlrp3Tbcy
         RsQkOGYywn8kXVLVMGJAK4TNsO+JZ4jQ9cy5Fhs0/x0mBd2Fi7+pMYTVW8tfUc/pDyAw
         guy7VaXdGBKVx1OCxHB/ApjqKo3OqBE8h+V301RlHZDvhJxeFeB7rKqEsY9uiRRky1n4
         ZEwOcGQzTx2iCisE++fekM5Blb/3kSJZDANzZcKhrI3geCqyMQZWqihLpFZOwT1IXLDR
         6FTBOIjpqGivUVLVM96CH08XIKFHRJJdPGVLpkBnSMBKmo/FUGKHJqgZ+ywj5FS3+ZE1
         kpfQ==
X-Gm-Message-State: APjAAAVJKeN94DH0+zHOngisiZ4P64JYHjonNj40tbTm5idp4bdi7Du6
        qq3B8gHhjAaUm8UWcrlSU3szcwHFGwg=
X-Google-Smtp-Source: APXvYqzhhyXFFGXqWzABSvfJKjoE2XAR5bliUJmF2j121/maLiXCarRkf34+k9rdJEwQFe3p7mzE9g==
X-Received: by 2002:a05:6000:10c:: with SMTP id o12mr4341355wrx.106.1582801509188;
        Thu, 27 Feb 2020 03:05:09 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id u185sm7573443wmg.6.2020.02.27.03.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 03:05:08 -0800 (PST)
Date:   Thu, 27 Feb 2020 12:05:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [RFC net-next 2/3] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200227110507.GE26061@nanopsycho>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-3-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225163025.9430-3-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 25, 2020 at 05:30:55PM CET, vadym.kochan@plvision.eu wrote:
>Add PCI interface driver for Prestera Switch ASICs family devices, which
>provides:
>
>    - Firmware loading mechanism
>    - Requests & events handling to/from the firmware
>    - Access to the firmware on the bus level
>
>The firmware has to be loaded each time device is reset. The driver is
>loading it from:
>
>    /lib/firmware/marvell/prestera_fw_img.bin
>
>The firmware image version is located within internal header and consists
>of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has hard-coded
>minimum supported firmware version which it can work with:
>
>    MAJOR - reflects the support on ABI level between driver and loaded
>            firmware, this number should be the same for driver and loaded
>            firmware.
>
>    MINOR - this is the minimal supported version between driver and the
>            firmware.
>
>    PATCH - indicates only fixes, firmware ABI is not changed.
>
>Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
>Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
>---
> drivers/net/ethernet/marvell/prestera/Kconfig |  11 +
> .../net/ethernet/marvell/prestera/Makefile    |   2 +
> .../ethernet/marvell/prestera/prestera_pci.c  | 840 ++++++++++++++++++
> 3 files changed, 853 insertions(+)
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
>
>diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
>index d0b416dcb677..a4e52f7af8dd 100644
>--- a/drivers/net/ethernet/marvell/prestera/Kconfig
>+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
>@@ -11,3 +11,14 @@ config PRESTERA
> 
> 	  To compile this driver as a module, choose M here: the
> 	  module will be called prestera_sw.
>+
>+config PRESTERA_PCI
>+	tristate "PCI interface driver for Marvell Prestera Switch ASICs family"
>+	depends on PCI && HAS_IOMEM && PRESTERA
>+	default m
>+	---help---
>+	  This is implementation of PCI interface support for Marvell Prestera
>+	  Switch ASICs family.
>+
>+	  To compile this driver as a module, choose M here: the
>+	  module will be called prestera_pci.
>diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
>index 9446298fb7f4..5d9b579a0314 100644
>--- a/drivers/net/ethernet/marvell/prestera/Makefile
>+++ b/drivers/net/ethernet/marvell/prestera/Makefile
>@@ -1,3 +1,5 @@
> # SPDX-License-Identifier: GPL-2.0
> obj-$(CONFIG_PRESTERA)	+= prestera_sw.o
> prestera_sw-objs	:= prestera.o prestera_hw.o prestera_switchdev.o
>+
>+obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
>new file mode 100644
>index 000000000000..847a84e3684a
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
>@@ -0,0 +1,840 @@
>+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+ *
>+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
>+ *
>+ */
>+
>+#include <linux/module.h>
>+#include <linux/kernel.h>
>+#include <linux/device.h>
>+#include <linux/pci.h>
>+#include <linux/circ_buf.h>
>+#include <linux/firmware.h>
>+
>+#include "prestera.h"
>+
>+#define MVSW_FW_FILENAME	"marvell/mvsw_prestera_fw.img"
>+
>+#define MVSW_SUPP_FW_MAJ_VER 1
>+#define MVSW_SUPP_FW_MIN_VER 0
>+#define MVSW_SUPP_FW_PATCH_VER 0
>+
>+#define mvsw_wait_timeout(cond, waitms) \
>+({ \
>+	unsigned long __wait_end = jiffies + msecs_to_jiffies(waitms); \
>+	bool __wait_ret = false; \
>+	do { \
>+		if (cond) { \
>+			__wait_ret = true; \
>+			break; \
>+		} \
>+		cond_resched(); \
>+	} while (time_before(jiffies, __wait_end)); \
>+	__wait_ret; \
>+})
>+
>+#define MVSW_FW_HDR_MAGIC 0x351D9D06
>+#define MVSW_FW_DL_TIMEOUT 50000
>+#define MVSW_FW_BLK_SZ 1024
>+
>+#define FW_VER_MAJ_MUL 1000000
>+#define FW_VER_MIN_MUL 1000
>+
>+#define FW_VER_MAJ(v)	((v) / FW_VER_MAJ_MUL)
>+
>+#define FW_VER_MIN(v) \
>+	(((v) - (FW_VER_MAJ(v) * FW_VER_MAJ_MUL)) / FW_VER_MIN_MUL)

Add prefix.


>+
>+#define FW_VER_PATCH(v) \
>+	(v - (FW_VER_MAJ(v) * FW_VER_MAJ_MUL) - (FW_VER_MIN(v) * FW_VER_MIN_MUL))
>+
>+struct mvsw_pr_fw_header {
>+	__be32 magic_number;
>+	__be32 version_value;
>+	u8 reserved[8];
>+} __packed;
>+
>+struct mvsw_pr_ldr_regs {
>+	u32 ldr_ready;
>+	u32 pad1;
>+
>+	u32 ldr_img_size;
>+	u32 ldr_ctl_flags;
>+
>+	u32 ldr_buf_offs;
>+	u32 ldr_buf_size;
>+
>+	u32 ldr_buf_rd;
>+	u32 pad2;
>+	u32 ldr_buf_wr;
>+
>+	u32 ldr_status;
>+} __packed __aligned(4);
>+
>+#define MVSW_LDR_REG_OFFSET(f)	offsetof(struct mvsw_pr_ldr_regs, f)
>+
>+#define MVSW_LDR_READY_MAGIC	0xf00dfeed
>+
>+#define MVSW_LDR_STATUS_IMG_DL		BIT(0)
>+#define MVSW_LDR_STATUS_START_FW	BIT(1)
>+#define MVSW_LDR_STATUS_INVALID_IMG	BIT(2)
>+#define MVSW_LDR_STATUS_NOMEM		BIT(3)
>+
>+#define mvsw_ldr_write(fw, reg, val) \
>+	writel(val, (fw)->ldr_regs + (reg))
>+#define mvsw_ldr_read(fw, reg)	\
>+	readl((fw)->ldr_regs + (reg))
>+
>+/* fw loader registers */
>+#define MVSW_LDR_READY_REG	MVSW_LDR_REG_OFFSET(ldr_ready)
>+#define MVSW_LDR_IMG_SIZE_REG	MVSW_LDR_REG_OFFSET(ldr_img_size)
>+#define MVSW_LDR_CTL_REG	MVSW_LDR_REG_OFFSET(ldr_ctl_flags)
>+#define MVSW_LDR_BUF_SIZE_REG	MVSW_LDR_REG_OFFSET(ldr_buf_size)
>+#define MVSW_LDR_BUF_OFFS_REG	MVSW_LDR_REG_OFFSET(ldr_buf_offs)
>+#define MVSW_LDR_BUF_RD_REG	MVSW_LDR_REG_OFFSET(ldr_buf_rd)
>+#define MVSW_LDR_BUF_WR_REG	MVSW_LDR_REG_OFFSET(ldr_buf_wr)
>+#define MVSW_LDR_STATUS_REG	MVSW_LDR_REG_OFFSET(ldr_status)
>+
>+#define MVSW_LDR_CTL_DL_START	BIT(0)
>+
>+#define MVSW_LDR_WR_IDX_MOVE(fw, n) \
>+do { \
>+	typeof(fw) __fw = (fw); \
>+	(__fw)->ldr_wr_idx = ((__fw)->ldr_wr_idx + (n)) & \
>+				((__fw)->ldr_buf_len - 1); \
>+} while (0)
>+
>+#define MVSW_LDR_WR_IDX_COMMIT(fw) \
>+({ \
>+	typeof(fw) __fw = (fw); \
>+	mvsw_ldr_write((__fw), MVSW_LDR_BUF_WR_REG, \
>+		       (__fw)->ldr_wr_idx); \
>+})
>+
>+#define MVSW_LDR_WR_PTR(fw) \
>+({ \
>+	typeof(fw) __fw = (fw); \
>+	((__fw)->ldr_ring_buf + (__fw)->ldr_wr_idx); \
>+})
>+
>+#define MVSW_EVT_QNUM_MAX	4
>+
>+struct mvsw_pr_fw_evtq_regs {
>+	u32 rd_idx;
>+	u32 pad1;
>+	u32 wr_idx;
>+	u32 pad2;
>+	u32 offs;
>+	u32 len;
>+};
>+
>+struct mvsw_pr_fw_regs {
>+	u32 fw_ready;
>+	u32 pad;
>+	u32 cmd_offs;
>+	u32 cmd_len;
>+	u32 evt_offs;
>+	u32 evt_qnum;
>+
>+	u32 cmd_req_ctl;
>+	u32 cmd_req_len;
>+	u32 cmd_rcv_ctl;
>+	u32 cmd_rcv_len;
>+
>+	u32 fw_status;
>+
>+	struct mvsw_pr_fw_evtq_regs evtq_list[MVSW_EVT_QNUM_MAX];
>+};
>+
>+#define MVSW_FW_REG_OFFSET(f)	offsetof(struct mvsw_pr_fw_regs, f)
>+
>+#define MVSW_FW_READY_MAGIC	0xcafebabe
>+
>+/* fw registers */
>+#define MVSW_FW_READY_REG		MVSW_FW_REG_OFFSET(fw_ready)
>+
>+#define MVSW_CMD_BUF_OFFS_REG		MVSW_FW_REG_OFFSET(cmd_offs)
>+#define MVSW_CMD_BUF_LEN_REG		MVSW_FW_REG_OFFSET(cmd_len)
>+#define MVSW_EVT_BUF_OFFS_REG		MVSW_FW_REG_OFFSET(evt_offs)
>+#define MVSW_EVT_QNUM_REG		MVSW_FW_REG_OFFSET(evt_qnum)
>+
>+#define MVSW_CMD_REQ_CTL_REG		MVSW_FW_REG_OFFSET(cmd_req_ctl)
>+#define MVSW_CMD_REQ_LEN_REG		MVSW_FW_REG_OFFSET(cmd_req_len)
>+
>+#define MVSW_CMD_RCV_CTL_REG		MVSW_FW_REG_OFFSET(cmd_rcv_ctl)
>+#define MVSW_CMD_RCV_LEN_REG		MVSW_FW_REG_OFFSET(cmd_rcv_len)
>+#define MVSW_FW_STATUS_REG		MVSW_FW_REG_OFFSET(fw_status)
>+
>+/* MVSW_CMD_REQ_CTL_REG flags */
>+#define MVSW_CMD_F_REQ_SENT		BIT(0)
>+#define MVSW_CMD_F_REPL_RCVD		BIT(1)
>+
>+/* MVSW_CMD_RCV_CTL_REG flags */
>+#define MVSW_CMD_F_REPL_SENT		BIT(0)
>+
>+#define MVSW_EVTQ_REG_OFFSET(q, f)			\
>+	(MVSW_FW_REG_OFFSET(evtq_list) +		\
>+	 (q) * sizeof(struct mvsw_pr_fw_evtq_regs) +	\
>+	 offsetof(struct mvsw_pr_fw_evtq_regs, f))
>+
>+#define MVSW_EVTQ_RD_IDX_REG(q)		MVSW_EVTQ_REG_OFFSET(q, rd_idx)
>+#define MVSW_EVTQ_WR_IDX_REG(q)		MVSW_EVTQ_REG_OFFSET(q, wr_idx)
>+#define MVSW_EVTQ_OFFS_REG(q)		MVSW_EVTQ_REG_OFFSET(q, offs)
>+#define MVSW_EVTQ_LEN_REG(q)		MVSW_EVTQ_REG_OFFSET(q, len)
>+
>+#define mvsw_fw_write(fw, reg, val)	writel(val, (fw)->hw_regs + (reg))
>+#define mvsw_fw_read(fw, reg)		readl((fw)->hw_regs + (reg))
>+
>+struct mvsw_pr_fw_evtq {
>+	u8 __iomem *addr;
>+	size_t len;
>+};
>+
>+struct mvsw_pr_fw {
>+	struct workqueue_struct *wq;
>+	struct mvsw_pr_device dev;
>+	struct pci_dev *pci_dev;
>+	u8 __iomem *mem_addr;
>+
>+	u8 __iomem *ldr_regs;
>+	u8 __iomem *hw_regs;
>+
>+	u8 __iomem *ldr_ring_buf;
>+	u32 ldr_buf_len;
>+	u32 ldr_wr_idx;
>+
>+	/* serialize access to dev->send_req */
>+	struct mutex cmd_mtx;
>+	size_t cmd_mbox_len;
>+	u8 __iomem *cmd_mbox;
>+	struct mvsw_pr_fw_evtq evt_queue[MVSW_EVT_QNUM_MAX];
>+	u8 evt_qnum;
>+	struct work_struct evt_work;
>+	u8 __iomem *evt_buf;
>+	u8 *evt_msg;
>+};
>+
>+#define mvsw_fw_dev(fw)	((fw)->dev.dev)
>+
>+#define PRESTERA_DEVICE(id) PCI_VDEVICE(MARVELL, (id))
>+
>+static struct mvsw_pr_pci_match {

Again, have the prefix consistent.

I suggest "prestera_pci_" here for the whole code.


>+	struct pci_driver driver;
>+	const struct pci_device_id id;
>+	bool registered;
>+} mvsw_pci_devices[] = {
>+	{
>+		.driver = { .name = "AC3x 98DX326x", },
>+		.id = { PRESTERA_DEVICE(0xc804), 0 },
>+	},
>+	{{ }, { },}
>+};
>+
>+static int mvsw_pr_fw_load(struct mvsw_pr_fw *fw);
>+
>+static u32 mvsw_pr_fw_evtq_len(struct mvsw_pr_fw *fw, u8 qid)
>+{
>+	return fw->evt_queue[qid].len;
>+}
>+
>+static u32 mvsw_pr_fw_evtq_avail(struct mvsw_pr_fw *fw, u8 qid)
>+{
>+	u32 wr_idx = mvsw_fw_read(fw, MVSW_EVTQ_WR_IDX_REG(qid));
>+	u32 rd_idx = mvsw_fw_read(fw, MVSW_EVTQ_RD_IDX_REG(qid));
>+
>+	return CIRC_CNT(wr_idx, rd_idx, mvsw_pr_fw_evtq_len(fw, qid));
>+}
>+
>+static void mvsw_pr_fw_evtq_rd_set(struct mvsw_pr_fw *fw,
>+				   u8 qid, u32 idx)
>+{
>+	u32 rd_idx = idx & (mvsw_pr_fw_evtq_len(fw, qid) - 1);
>+
>+	mvsw_fw_write(fw, MVSW_EVTQ_RD_IDX_REG(qid), rd_idx);
>+}
>+
>+static u8 __iomem *mvsw_pr_fw_evtq_buf(struct mvsw_pr_fw *fw,
>+				       u8 qid)
>+{
>+	return fw->evt_queue[qid].addr;
>+}
>+
>+static u32 mvsw_pr_fw_evtq_read32(struct mvsw_pr_fw *fw, u8 qid)
>+{
>+	u32 rd_idx = mvsw_fw_read(fw, MVSW_EVTQ_RD_IDX_REG(qid));
>+	u32 val;
>+
>+	val = readl(mvsw_pr_fw_evtq_buf(fw, qid) + rd_idx);
>+	mvsw_pr_fw_evtq_rd_set(fw, qid, rd_idx + 4);
>+	return val;
>+}
>+
>+static ssize_t mvsw_pr_fw_evtq_read_buf(struct mvsw_pr_fw *fw,
>+					u8 qid, u8 *buf, size_t len)
>+{
>+	u32 idx = mvsw_fw_read(fw, MVSW_EVTQ_RD_IDX_REG(qid));
>+	u8 __iomem *evtq_addr = mvsw_pr_fw_evtq_buf(fw, qid);
>+	u32 *buf32 = (u32 *)buf;
>+	int i;
>+
>+	for (i = 0; i < len / 4; buf32++, i++) {
>+		*buf32 = readl_relaxed(evtq_addr + idx);
>+		idx = (idx + 4) & (mvsw_pr_fw_evtq_len(fw, qid) - 1);
>+	}
>+
>+	mvsw_pr_fw_evtq_rd_set(fw, qid, idx);
>+
>+	return i;
>+}
>+
>+static u8 mvsw_pr_fw_evtq_pick(struct mvsw_pr_fw *fw)
>+{
>+	int qid;
>+
>+	for (qid = 0; qid < fw->evt_qnum; qid++) {
>+		if (mvsw_pr_fw_evtq_avail(fw, qid) >= 4)
>+			return qid;
>+	}
>+
>+	return MVSW_EVT_QNUM_MAX;
>+}
>+
>+static void mvsw_pr_fw_evt_work_fn(struct work_struct *work)
>+{
>+	struct mvsw_pr_fw *fw;
>+	u8 *msg;
>+	u8 qid;
>+
>+	fw = container_of(work, struct mvsw_pr_fw, evt_work);
>+	msg = fw->evt_msg;
>+
>+	while ((qid = mvsw_pr_fw_evtq_pick(fw)) < MVSW_EVT_QNUM_MAX) {
>+		u32 idx;
>+		u32 len;
>+
>+		len = mvsw_pr_fw_evtq_read32(fw, qid);
>+		idx = mvsw_fw_read(fw, MVSW_EVTQ_RD_IDX_REG(qid));
>+
>+		WARN_ON(mvsw_pr_fw_evtq_avail(fw, qid) < len);
>+
>+		if (WARN_ON(len > MVSW_MSG_MAX_SIZE)) {
>+			mvsw_pr_fw_evtq_rd_set(fw, qid, idx + len);
>+			continue;
>+		}
>+
>+		mvsw_pr_fw_evtq_read_buf(fw, qid, msg, len);
>+
>+		if (fw->dev.recv_msg)
>+			fw->dev.recv_msg(&fw->dev, msg, len);
>+	}
>+}
>+
>+static int mvsw_pr_fw_wait_reg32(struct mvsw_pr_fw *fw,
>+				 u32 reg, u32 val, unsigned int wait)
>+{
>+	if (mvsw_wait_timeout(mvsw_fw_read(fw, reg) == val, wait))
>+		return 0;
>+
>+	return -EBUSY;
>+}
>+
>+static void mvsw_pci_copy_to(u8 __iomem *dst, u8 *src, size_t len)
>+{
>+	u32 __iomem *dst32 = (u32 __iomem *)dst;
>+	u32 *src32 = (u32 *)src;
>+	int i;
>+
>+	for (i = 0; i < (len / 4); dst32++, src32++, i++)
>+		writel_relaxed(*src32, dst32);
>+}
>+
>+static void mvsw_pci_copy_from(u8 *dst, u8 __iomem *src, size_t len)
>+{
>+	u32 *dst32 = (u32 *)dst;
>+	u32 __iomem *src32 = (u32 __iomem *)src;
>+	int i;
>+
>+	for (i = 0; i < (len / 4); dst32++, src32++, i++)
>+		*dst32 = readl_relaxed(src32);
>+}
>+
>+static int mvsw_pr_fw_cmd_send(struct mvsw_pr_fw *fw,
>+			       u8 *in_msg, size_t in_size,
>+			       u8 *out_msg, size_t out_size,
>+			       unsigned int wait)
>+{
>+	u32 ret_size = 0;
>+	int err = 0;
>+
>+	if (!wait)
>+		wait = 30000;
>+
>+	if (ALIGN(in_size, 4) > fw->cmd_mbox_len)
>+		return -EMSGSIZE;
>+
>+	/* wait for finish previous reply from FW */
>+	err = mvsw_pr_fw_wait_reg32(fw, MVSW_CMD_RCV_CTL_REG, 0, 30);
>+	if (err) {
>+		dev_err(mvsw_fw_dev(fw), "finish reply from FW is timed out\n");
>+		return err;
>+	}
>+
>+	mvsw_fw_write(fw, MVSW_CMD_REQ_LEN_REG, in_size);
>+	mvsw_pci_copy_to(fw->cmd_mbox, in_msg, in_size);
>+
>+	mvsw_fw_write(fw, MVSW_CMD_REQ_CTL_REG, MVSW_CMD_F_REQ_SENT);
>+
>+	/* wait for reply from FW */
>+	err = mvsw_pr_fw_wait_reg32(fw, MVSW_CMD_RCV_CTL_REG, MVSW_CMD_F_REPL_SENT,
>+				    wait);
>+	if (err) {
>+		dev_err(mvsw_fw_dev(fw), "reply from FW is timed out\n");
>+		goto cmd_exit;
>+	}
>+
>+	ret_size = mvsw_fw_read(fw, MVSW_CMD_RCV_LEN_REG);
>+	if (ret_size > out_size) {
>+		dev_err(mvsw_fw_dev(fw), "ret_size (%u) > out_len(%zu)\n",
>+			ret_size, out_size);
>+		err = -EMSGSIZE;
>+		goto cmd_exit;
>+	}
>+
>+	mvsw_pci_copy_from(out_msg, fw->cmd_mbox + in_size, ret_size);
>+
>+cmd_exit:
>+	mvsw_fw_write(fw, MVSW_CMD_REQ_CTL_REG, MVSW_CMD_F_REPL_RCVD);
>+	return err;
>+}
>+
>+static int mvsw_pr_fw_send_req(struct mvsw_pr_device *dev,
>+			       u8 *in_msg, size_t in_size, u8 *out_msg,
>+			       size_t out_size, unsigned int wait)
>+{
>+	struct mvsw_pr_fw *fw;
>+	ssize_t ret;
>+
>+	fw = container_of(dev, struct mvsw_pr_fw, dev);
>+
>+	mutex_lock(&fw->cmd_mtx);
>+	ret = mvsw_pr_fw_cmd_send(fw, in_msg, in_size, out_msg, out_size, wait);
>+	mutex_unlock(&fw->cmd_mtx);
>+
>+	return ret;
>+}
>+
>+static int mvsw_pr_fw_init(struct mvsw_pr_fw *fw)
>+{
>+	u8 __iomem *base;
>+	int err;
>+	u8 qid;
>+
>+	err = mvsw_pr_fw_load(fw);
>+	if (err && err != -ETIMEDOUT)
>+		return err;
>+
>+	err = mvsw_pr_fw_wait_reg32(fw, MVSW_FW_READY_REG,
>+				    MVSW_FW_READY_MAGIC, 20000);
>+	if (err) {
>+		dev_err(mvsw_fw_dev(fw), "FW is failed to start\n");
>+		return err;
>+	}
>+
>+	base = fw->mem_addr;
>+
>+	fw->cmd_mbox = base + mvsw_fw_read(fw, MVSW_CMD_BUF_OFFS_REG);
>+	fw->cmd_mbox_len = mvsw_fw_read(fw, MVSW_CMD_BUF_LEN_REG);
>+	mutex_init(&fw->cmd_mtx);
>+
>+	fw->evt_buf = base + mvsw_fw_read(fw, MVSW_EVT_BUF_OFFS_REG);
>+	fw->evt_qnum = mvsw_fw_read(fw, MVSW_EVT_QNUM_REG);
>+	fw->evt_msg = kmalloc(MVSW_MSG_MAX_SIZE, GFP_KERNEL);
>+	if (!fw->evt_msg)
>+		return -ENOMEM;
>+
>+	for (qid = 0; qid < fw->evt_qnum; qid++) {
>+		u32 offs = mvsw_fw_read(fw, MVSW_EVTQ_OFFS_REG(qid));
>+		struct mvsw_pr_fw_evtq *evtq = &fw->evt_queue[qid];
>+
>+		evtq->len = mvsw_fw_read(fw, MVSW_EVTQ_LEN_REG(qid));
>+		evtq->addr = fw->evt_buf + offs;
>+	}
>+
>+	return 0;
>+}
>+
>+static void mvsw_pr_fw_uninit(struct mvsw_pr_fw *fw)
>+{
>+	kfree(fw->evt_msg);
>+}
>+
>+static irqreturn_t mvsw_pci_irq_handler(int irq, void *dev_id)
>+{
>+	struct mvsw_pr_fw *fw = dev_id;
>+
>+	queue_work(fw->wq, &fw->evt_work);
>+
>+	return IRQ_HANDLED;
>+}
>+
>+static int mvsw_pr_ldr_wait_reg32(struct mvsw_pr_fw *fw,
>+				  u32 reg, u32 val, unsigned int wait)
>+{
>+	if (mvsw_wait_timeout(mvsw_ldr_read(fw, reg) == val, wait))
>+		return 0;
>+
>+	return -EBUSY;
>+}
>+
>+static u32 mvsw_pr_ldr_buf_avail(struct mvsw_pr_fw *fw)
>+{
>+	u32 rd_idx = mvsw_ldr_read(fw, MVSW_LDR_BUF_RD_REG);
>+
>+	return CIRC_SPACE(fw->ldr_wr_idx, rd_idx, fw->ldr_buf_len);
>+}
>+
>+static int mvsw_pr_ldr_send_buf(struct mvsw_pr_fw *fw, const u8 *buf,
>+				size_t len)
>+{
>+	int i;
>+
>+	if (!mvsw_wait_timeout(mvsw_pr_ldr_buf_avail(fw) >= len, 100)) {
>+		dev_err(mvsw_fw_dev(fw), "failed wait for sending firmware\n");
>+		return -EBUSY;
>+	}
>+
>+	for (i = 0; i < len; i += 4) {
>+		writel_relaxed(*(u32 *)(buf + i), MVSW_LDR_WR_PTR(fw));
>+		MVSW_LDR_WR_IDX_MOVE(fw, 4);
>+	}
>+
>+	MVSW_LDR_WR_IDX_COMMIT(fw);
>+	return 0;
>+}
>+
>+static int mvsw_pr_ldr_send(struct mvsw_pr_fw *fw,
>+			    const char *img, u32 fw_size)
>+{
>+	unsigned long mask;
>+	u32 status;
>+	u32 pos;
>+	int err;
>+
>+	if (mvsw_pr_ldr_wait_reg32(fw, MVSW_LDR_STATUS_REG,
>+				   MVSW_LDR_STATUS_IMG_DL, 1000)) {
>+		dev_err(mvsw_fw_dev(fw), "Loader is not ready to load image\n");
>+		return -EBUSY;
>+	}
>+
>+	for (pos = 0; pos < fw_size; pos += MVSW_FW_BLK_SZ) {
>+		if (pos + MVSW_FW_BLK_SZ > fw_size)
>+			break;
>+
>+		err = mvsw_pr_ldr_send_buf(fw, img + pos, MVSW_FW_BLK_SZ);
>+		if (err)
>+			return err;
>+	}
>+
>+	if (pos < fw_size) {
>+		err = mvsw_pr_ldr_send_buf(fw, img + pos, fw_size - pos);
>+		if (err)
>+			return err;
>+	}
>+
>+	/* Waiting for status IMG_DOWNLOADING to change to something else */
>+	mask = ~(MVSW_LDR_STATUS_IMG_DL);
>+
>+	if (!mvsw_wait_timeout(mvsw_ldr_read(fw, MVSW_LDR_STATUS_REG) & mask,
>+			       MVSW_FW_DL_TIMEOUT)) {
>+		dev_err(mvsw_fw_dev(fw), "Timeout to load FW img [state=%d]",
>+			mvsw_ldr_read(fw, MVSW_LDR_STATUS_REG));
>+		return -ETIMEDOUT;
>+	}
>+
>+	status = mvsw_ldr_read(fw, MVSW_LDR_STATUS_REG);
>+	if (status != MVSW_LDR_STATUS_START_FW) {
>+		switch (status) {
>+		case MVSW_LDR_STATUS_INVALID_IMG:
>+			dev_err(mvsw_fw_dev(fw), "FW img has bad crc\n");
>+			return -EINVAL;
>+		case MVSW_LDR_STATUS_NOMEM:
>+			dev_err(mvsw_fw_dev(fw), "Loader has no enough mem\n");
>+			return -ENOMEM;
>+		default:
>+			break;
>+		}
>+	}
>+
>+	return 0;
>+}
>+
>+static bool mvsw_pr_ldr_is_ready(struct mvsw_pr_fw *fw)
>+{
>+	return mvsw_ldr_read(fw, MVSW_LDR_READY_REG) == MVSW_LDR_READY_MAGIC;
>+}
>+
>+static void mvsw_pr_fw_rev_parse(const struct mvsw_pr_fw_header *hdr,
>+				 struct mvsw_fw_rev *rev)
>+{
>+	u32 version = be32_to_cpu(hdr->version_value);
>+
>+	rev->maj = FW_VER_MAJ(version);
>+	rev->min = FW_VER_MIN(version);
>+	rev->sub = FW_VER_PATCH(version);
>+}
>+
>+static int mvsw_pr_fw_rev_check(struct mvsw_pr_fw *fw)
>+{
>+	struct mvsw_fw_rev *rev = &fw->dev.fw_rev;
>+
>+	if (rev->maj == MVSW_SUPP_FW_MAJ_VER &&
>+	    rev->min >= MVSW_SUPP_FW_MIN_VER) {
>+		return 0;
>+	}
>+
>+	dev_err(mvsw_fw_dev(fw), "Driver supports FW version only '%u.%u.%u'",
>+		MVSW_SUPP_FW_MAJ_VER,
>+		MVSW_SUPP_FW_MIN_VER,
>+		MVSW_SUPP_FW_PATCH_VER);
>+
>+	return -EINVAL;
>+}
>+
>+static int mvsw_pr_fw_hdr_parse(struct mvsw_pr_fw *fw,
>+				const struct firmware *img)
>+{
>+	struct mvsw_pr_fw_header *hdr = (struct mvsw_pr_fw_header *)img->data;
>+	struct mvsw_fw_rev *rev = &fw->dev.fw_rev;
>+	u32 magic;
>+
>+	magic = be32_to_cpu(hdr->magic_number);
>+	if (magic != MVSW_FW_HDR_MAGIC) {
>+		dev_err(mvsw_fw_dev(fw), "FW img type is invalid");
>+		return -EINVAL;
>+	}
>+
>+	mvsw_pr_fw_rev_parse(hdr, rev);
>+
>+	dev_info(mvsw_fw_dev(fw), "FW version '%u.%u.%u'\n",
>+		 rev->maj, rev->min, rev->sub);
>+
>+	return mvsw_pr_fw_rev_check(fw);
>+}
>+
>+static int mvsw_pr_fw_load(struct mvsw_pr_fw *fw)
>+{
>+	size_t hlen = sizeof(struct mvsw_pr_fw_header);
>+	const struct firmware *f;
>+	bool has_ldr;
>+	int err;
>+
>+	has_ldr = mvsw_wait_timeout(mvsw_pr_ldr_is_ready(fw), 1000);
>+	if (!has_ldr) {
>+		dev_err(mvsw_fw_dev(fw), "waiting for FW loader is timed out");
>+		return -ETIMEDOUT;
>+	}
>+
>+	fw->ldr_ring_buf = fw->ldr_regs +
>+		mvsw_ldr_read(fw, MVSW_LDR_BUF_OFFS_REG);
>+
>+	fw->ldr_buf_len =
>+		mvsw_ldr_read(fw, MVSW_LDR_BUF_SIZE_REG);
>+
>+	fw->ldr_wr_idx = 0;
>+
>+	err = request_firmware_direct(&f, MVSW_FW_FILENAME, &fw->pci_dev->dev);
>+	if (err) {
>+		dev_err(mvsw_fw_dev(fw), "failed to request firmware file\n");
>+		return err;
>+	}
>+
>+	if (!IS_ALIGNED(f->size, 4)) {
>+		dev_err(mvsw_fw_dev(fw), "FW image file is not aligned");
>+		release_firmware(f);
>+		return -EINVAL;
>+	}
>+
>+	err = mvsw_pr_fw_hdr_parse(fw, f);
>+	if (err) {
>+		dev_err(mvsw_fw_dev(fw), "FW image header is invalid\n");
>+		release_firmware(f);
>+		return err;
>+	}
>+
>+	mvsw_ldr_write(fw, MVSW_LDR_IMG_SIZE_REG, f->size - hlen);
>+	mvsw_ldr_write(fw, MVSW_LDR_CTL_REG, MVSW_LDR_CTL_DL_START);
>+
>+	dev_info(mvsw_fw_dev(fw), "Loading prestera FW image ...");
>+
>+	err = mvsw_pr_ldr_send(fw, f->data + hlen, f->size - hlen);
>+
>+	release_firmware(f);
>+	return err;
>+}
>+
>+static int mvsw_pr_pci_probe(struct pci_dev *pdev,
>+			     const struct pci_device_id *id)
>+{
>+	const char *driver_name = pdev->driver->name;
>+	struct mvsw_pr_fw *fw;
>+	u8 __iomem *mem_addr;
>+	int err;
>+
>+	err = pci_enable_device(pdev);
>+	if (err) {
>+		dev_err(&pdev->dev, "pci_enable_device failed\n");
>+		goto err_pci_enable_device;
>+	}
>+
>+	err = pci_request_regions(pdev, driver_name);
>+	if (err) {
>+		dev_err(&pdev->dev, "pci_request_regions failed\n");
>+		goto err_pci_request_regions;
>+	}
>+
>+	mem_addr = pci_ioremap_bar(pdev, 2);
>+	if (!mem_addr) {
>+		dev_err(&pdev->dev, "ioremap failed\n");
>+		err = -EIO;
>+		goto err_ioremap;
>+	}
>+
>+	pci_set_master(pdev);
>+
>+	fw = kzalloc(sizeof(*fw), GFP_KERNEL);
>+	if (!fw) {
>+		err = -ENOMEM;
>+		goto err_pci_dev_alloc;
>+	}
>+
>+	fw->pci_dev = pdev;
>+	fw->dev.dev = &pdev->dev;
>+	fw->dev.send_req = mvsw_pr_fw_send_req;
>+	fw->mem_addr = mem_addr;
>+	fw->ldr_regs = mem_addr;
>+	fw->hw_regs = mem_addr;
>+
>+	fw->wq = alloc_workqueue("mvsw_fw_wq", WQ_HIGHPRI, 1);
>+	if (!fw->wq)
>+		goto err_wq_alloc;
>+
>+	INIT_WORK(&fw->evt_work, mvsw_pr_fw_evt_work_fn);
>+
>+	err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
>+	if (err < 0) {
>+		dev_err(&pdev->dev, "MSI IRQ init failed\n");
>+		goto err_irq_alloc;
>+	}
>+
>+	err = request_irq(pci_irq_vector(pdev, 0), mvsw_pci_irq_handler,
>+			  0, driver_name, fw);
>+	if (err) {
>+		dev_err(&pdev->dev, "fail to request IRQ\n");
>+		goto err_request_irq;
>+	}
>+
>+	pci_set_drvdata(pdev, fw);
>+
>+	err = mvsw_pr_fw_init(fw);
>+	if (err)
>+		goto err_mvsw_fw_init;
>+
>+	dev_info(mvsw_fw_dev(fw), "Prestera Switch FW is ready\n");
>+
>+	err = mvsw_pr_device_register(&fw->dev);
>+	if (err)
>+		goto err_mvsw_dev_register;
>+
>+	return 0;
>+
>+err_mvsw_dev_register:
>+	mvsw_pr_fw_uninit(fw);
>+err_mvsw_fw_init:
>+	free_irq(pci_irq_vector(pdev, 0), fw);
>+err_request_irq:
>+	pci_free_irq_vectors(pdev);
>+err_irq_alloc:
>+	destroy_workqueue(fw->wq);
>+err_wq_alloc:
>+	kfree(fw);
>+err_pci_dev_alloc:
>+	iounmap(mem_addr);
>+err_ioremap:
>+	pci_release_regions(pdev);
>+err_pci_request_regions:
>+	pci_disable_device(pdev);
>+err_pci_enable_device:
>+	return err;
>+}
>+
>+static void mvsw_pr_pci_remove(struct pci_dev *pdev)
>+{
>+	struct mvsw_pr_fw *fw = pci_get_drvdata(pdev);
>+
>+	free_irq(pci_irq_vector(pdev, 0), fw);
>+	pci_free_irq_vectors(pdev);
>+	mvsw_pr_device_unregister(&fw->dev);
>+	flush_workqueue(fw->wq);
>+	destroy_workqueue(fw->wq);
>+	mvsw_pr_fw_uninit(fw);
>+	iounmap(fw->mem_addr);
>+	pci_release_regions(pdev);
>+	pci_disable_device(pdev);
>+	kfree(fw);
>+}
>+
>+static int __init mvsw_pr_pci_init(void)
>+{
>+	struct mvsw_pr_pci_match *match;
>+	int err;
>+
>+	for (match = mvsw_pci_devices; match->driver.name; match++) {

Just use MODULE_DEVICE_TABLE(). See spectrum.c for example.


>+		match->driver.probe = mvsw_pr_pci_probe;
>+		match->driver.remove = mvsw_pr_pci_remove;
>+		match->driver.id_table = &match->id;
>+
>+		err = pci_register_driver(&match->driver);
>+		if (err) {
>+			pr_err("prestera_pci: failed to register %s\n",
>+			       match->driver.name);
>+			break;
>+		}
>+
>+		match->registered = true;
>+	}
>+
>+	if (err) {
>+		for (match = mvsw_pci_devices; match->driver.name; match++) {
>+			if (!match->registered)
>+				break;
>+
>+			pci_unregister_driver(&match->driver);
>+		}
>+
>+		return err;
>+	}
>+
>+	pr_info("prestera_pci: Registered Marvell Prestera PCI driver\n");

Avoid prints like this one.



>+	return 0;
>+}
>+
>+static void __exit mvsw_pr_pci_exit(void)
>+{
>+	struct mvsw_pr_pci_match *match;
>+
>+	for (match = mvsw_pci_devices; match->driver.name; match++) {
>+		if (!match->registered)
>+			break;
>+
>+		pci_unregister_driver(&match->driver);
>+	}
>+
>+	pr_info("prestera_pci: Unregistered Marvell Prestera PCI driver\n");
>+}
>+
>+module_init(mvsw_pr_pci_init);
>+module_exit(mvsw_pr_pci_exit);
>+
>+MODULE_AUTHOR("Marvell Semi.");

Again, wrong author.


>+MODULE_LICENSE("GPL");

Inconsistent with the header.


>+MODULE_DESCRIPTION("Marvell Prestera switch PCI interface");
>-- 
>2.17.1
>
