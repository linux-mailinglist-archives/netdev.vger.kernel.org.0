Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A2925ADB7
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgIBOrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:47:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10800 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727968AbgIBONA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 10:13:00 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3C1D969AD3882C8F39D0;
        Wed,  2 Sep 2020 22:12:54 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 2 Sep 2020
 22:12:45 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <amitkarwar@gmail.com>, <ganapathi.bhat@nxp.com>,
        <huxinming820@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] mwifiex: sdio: Fix -Wunused-const-variable warnings
Date:   Wed, 2 Sep 2020 22:11:55 +0800
Message-ID: <20200902141155.30144-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These variables only used in sdio.c, move them to .c file
can silence these warnings:

In file included from drivers/net/wireless/marvell/mwifiex//main.h:59:0,
                 from drivers/net/wireless/marvell/mwifiex//cfp.c:24:
drivers/net/wireless/marvell/mwifiex//sdio.h:705:41: warning: ‘mwifiex_sdio_sd8801’ defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
                                         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex//sdio.h:689:41: warning: ‘mwifiex_sdio_sd8987’ defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8987 = {
                                         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex//sdio.h:674:41: warning: ‘mwifiex_sdio_sd8887’ defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
                                         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex//sdio.h:658:41: warning: ‘mwifiex_sdio_sd8997’ defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
                                         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex//sdio.h:642:41: warning: ‘mwifiex_sdio_sd8977’ defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
                                         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex//sdio.h:627:41: warning: ‘mwifiex_sdio_sd8897’ defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
                                         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex//sdio.h:612:41: warning: ‘mwifiex_sdio_sd8797’ defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
                                         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex//sdio.h:597:41: warning: ‘mwifiex_sdio_sd8787’ defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
                                         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex//sdio.h:582:41: warning: ‘mwifiex_sdio_sd8786’ defined but not used [-Wunused-const-variable=]
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
                                         ^~~~~~~~~~~~~~~~~~~

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 427 ++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sdio.h | 427 --------------------
 2 files changed, 427 insertions(+), 427 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a042965962a2..69911c728eb1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -35,6 +35,433 @@ static void mwifiex_sdio_work(struct work_struct *work);
 
 static struct mwifiex_if_ops sdio_ops;
 
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
+	.start_rd_port = 1,
+	.start_wr_port = 1,
+	.base_0_reg = 0x0040,
+	.base_1_reg = 0x0041,
+	.poll_reg = 0x30,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK,
+	.host_int_rsr_reg = 0x1,
+	.host_int_mask_reg = 0x02,
+	.host_int_status_reg = 0x03,
+	.status_reg_0 = 0x60,
+	.status_reg_1 = 0x61,
+	.sdio_int_mask = 0x3f,
+	.data_port_mask = 0x0000fffe,
+	.io_port_0_reg = 0x78,
+	.io_port_1_reg = 0x79,
+	.io_port_2_reg = 0x7A,
+	.max_mp_regs = 64,
+	.rd_bitmap_l = 0x04,
+	.rd_bitmap_u = 0x05,
+	.wr_bitmap_l = 0x06,
+	.wr_bitmap_u = 0x07,
+	.rd_len_p0_l = 0x08,
+	.rd_len_p0_u = 0x09,
+	.card_misc_cfg_reg = 0x6c,
+	.func1_dump_reg_start = 0x0,
+	.func1_dump_reg_end = 0x9,
+	.func1_scratch_reg = 0x60,
+	.func1_spec_reg_num = 5,
+	.func1_spec_reg_table = {0x28, 0x30, 0x34, 0x38, 0x3c},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0x60,
+	.base_1_reg = 0x61,
+	.poll_reg = 0x50,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x1,
+	.host_int_status_reg = 0x03,
+	.host_int_mask_reg = 0x02,
+	.status_reg_0 = 0xc0,
+	.status_reg_1 = 0xc1,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xD8,
+	.io_port_1_reg = 0xD9,
+	.io_port_2_reg = 0xDA,
+	.max_mp_regs = 184,
+	.rd_bitmap_l = 0x04,
+	.rd_bitmap_u = 0x05,
+	.rd_bitmap_1l = 0x06,
+	.rd_bitmap_1u = 0x07,
+	.wr_bitmap_l = 0x08,
+	.wr_bitmap_u = 0x09,
+	.wr_bitmap_1l = 0x0a,
+	.wr_bitmap_1u = 0x0b,
+	.rd_len_p0_l = 0x0c,
+	.rd_len_p0_u = 0x0d,
+	.card_misc_cfg_reg = 0xcc,
+	.card_cfg_2_1_reg = 0xcd,
+	.cmd_rd_len_0 = 0xb4,
+	.cmd_rd_len_1 = 0xb5,
+	.cmd_rd_len_2 = 0xb6,
+	.cmd_rd_len_3 = 0xb7,
+	.cmd_cfg_0 = 0xb8,
+	.cmd_cfg_1 = 0xb9,
+	.cmd_cfg_2 = 0xba,
+	.cmd_cfg_3 = 0xbb,
+	.fw_dump_host_ready = 0xee,
+	.fw_dump_ctrl = 0xe2,
+	.fw_dump_start = 0xe3,
+	.fw_dump_end = 0xea,
+	.func1_dump_reg_start = 0x0,
+	.func1_dump_reg_end = 0xb,
+	.func1_scratch_reg = 0xc0,
+	.func1_spec_reg_num = 8,
+	.func1_spec_reg_table = {0x4C, 0x50, 0x54, 0x55, 0x58,
+				 0x59, 0x5c, 0x5d},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8977 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0xF8,
+	.base_1_reg = 0xF9,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+		CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0xE8,
+	.status_reg_1 = 0xE9,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_ctrl = 0xf0,
+	.fw_dump_start = 0xf1,
+	.fw_dump_end = 0xf8,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0xe8,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D,
+				 0x60, 0x61, 0x62, 0x64,
+				 0x65, 0x66, 0x68, 0x69,
+				 0x6a},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0xF8,
+	.base_1_reg = 0xF9,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0xE8,
+	.status_reg_1 = 0xE9,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_ctrl = 0xf0,
+	.fw_dump_start = 0xf1,
+	.fw_dump_end = 0xf8,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0xe8,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D,
+				 0x60, 0x61, 0x62, 0x64,
+				 0x65, 0x66, 0x68, 0x69,
+				 0x6a},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0x6C,
+	.base_1_reg = 0x6D,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0x90,
+	.status_reg_1 = 0x91,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0x90,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
+				 0x61, 0x62, 0x64, 0x65, 0x66,
+				 0x68, 0x69, 0x6a},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8987 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0xF8,
+	.base_1_reg = 0xF9,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0xE8,
+	.status_reg_1 = 0xE9,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_ctrl = 0xf9,
+	.fw_dump_start = 0xf1,
+	.fw_dump_end = 0xf8,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0xE8,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
+				 0x61, 0x62, 0x64, 0x65, 0x66,
+				 0x68, 0x69, 0x6a},
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
+	.firmware = SD8786_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
+	.can_ext_scan = false,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
+	.firmware = SD8787_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
+	.firmware = SD8797_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
+	.firmware = SD8897_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8897,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
+	.firmware = SD8977_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8977,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
+	.firmware = SD8997_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8997,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
+	.firmware = SD8887_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8887,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = false,
+	.can_auto_tdls = true,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8987 = {
+	.firmware = SD8987_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8987,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
+	.can_auto_tdls = true,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
+	.firmware = SD8801_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
 static struct memory_type_mapping generic_mem_type_map[] = {
 	{"DUMP", NULL, 0, 0xDD},
 };
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index 8b476b007c5e..dec534a6ddb1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -290,433 +290,6 @@ struct mwifiex_sdio_device {
 	bool can_ext_scan;
 };
 
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
-	.start_rd_port = 1,
-	.start_wr_port = 1,
-	.base_0_reg = 0x0040,
-	.base_1_reg = 0x0041,
-	.poll_reg = 0x30,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK,
-	.host_int_rsr_reg = 0x1,
-	.host_int_mask_reg = 0x02,
-	.host_int_status_reg = 0x03,
-	.status_reg_0 = 0x60,
-	.status_reg_1 = 0x61,
-	.sdio_int_mask = 0x3f,
-	.data_port_mask = 0x0000fffe,
-	.io_port_0_reg = 0x78,
-	.io_port_1_reg = 0x79,
-	.io_port_2_reg = 0x7A,
-	.max_mp_regs = 64,
-	.rd_bitmap_l = 0x04,
-	.rd_bitmap_u = 0x05,
-	.wr_bitmap_l = 0x06,
-	.wr_bitmap_u = 0x07,
-	.rd_len_p0_l = 0x08,
-	.rd_len_p0_u = 0x09,
-	.card_misc_cfg_reg = 0x6c,
-	.func1_dump_reg_start = 0x0,
-	.func1_dump_reg_end = 0x9,
-	.func1_scratch_reg = 0x60,
-	.func1_spec_reg_num = 5,
-	.func1_spec_reg_table = {0x28, 0x30, 0x34, 0x38, 0x3c},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0x60,
-	.base_1_reg = 0x61,
-	.poll_reg = 0x50,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x1,
-	.host_int_status_reg = 0x03,
-	.host_int_mask_reg = 0x02,
-	.status_reg_0 = 0xc0,
-	.status_reg_1 = 0xc1,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xD8,
-	.io_port_1_reg = 0xD9,
-	.io_port_2_reg = 0xDA,
-	.max_mp_regs = 184,
-	.rd_bitmap_l = 0x04,
-	.rd_bitmap_u = 0x05,
-	.rd_bitmap_1l = 0x06,
-	.rd_bitmap_1u = 0x07,
-	.wr_bitmap_l = 0x08,
-	.wr_bitmap_u = 0x09,
-	.wr_bitmap_1l = 0x0a,
-	.wr_bitmap_1u = 0x0b,
-	.rd_len_p0_l = 0x0c,
-	.rd_len_p0_u = 0x0d,
-	.card_misc_cfg_reg = 0xcc,
-	.card_cfg_2_1_reg = 0xcd,
-	.cmd_rd_len_0 = 0xb4,
-	.cmd_rd_len_1 = 0xb5,
-	.cmd_rd_len_2 = 0xb6,
-	.cmd_rd_len_3 = 0xb7,
-	.cmd_cfg_0 = 0xb8,
-	.cmd_cfg_1 = 0xb9,
-	.cmd_cfg_2 = 0xba,
-	.cmd_cfg_3 = 0xbb,
-	.fw_dump_host_ready = 0xee,
-	.fw_dump_ctrl = 0xe2,
-	.fw_dump_start = 0xe3,
-	.fw_dump_end = 0xea,
-	.func1_dump_reg_start = 0x0,
-	.func1_dump_reg_end = 0xb,
-	.func1_scratch_reg = 0xc0,
-	.func1_spec_reg_num = 8,
-	.func1_spec_reg_table = {0x4C, 0x50, 0x54, 0x55, 0x58,
-				 0x59, 0x5c, 0x5d},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8977 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0xF8,
-	.base_1_reg = 0xF9,
-	.poll_reg = 0x5C,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-		CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x4,
-	.host_int_status_reg = 0x0C,
-	.host_int_mask_reg = 0x08,
-	.status_reg_0 = 0xE8,
-	.status_reg_1 = 0xE9,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xE4,
-	.io_port_1_reg = 0xE5,
-	.io_port_2_reg = 0xE6,
-	.max_mp_regs = 196,
-	.rd_bitmap_l = 0x10,
-	.rd_bitmap_u = 0x11,
-	.rd_bitmap_1l = 0x12,
-	.rd_bitmap_1u = 0x13,
-	.wr_bitmap_l = 0x14,
-	.wr_bitmap_u = 0x15,
-	.wr_bitmap_1l = 0x16,
-	.wr_bitmap_1u = 0x17,
-	.rd_len_p0_l = 0x18,
-	.rd_len_p0_u = 0x19,
-	.card_misc_cfg_reg = 0xd8,
-	.card_cfg_2_1_reg = 0xd9,
-	.cmd_rd_len_0 = 0xc0,
-	.cmd_rd_len_1 = 0xc1,
-	.cmd_rd_len_2 = 0xc2,
-	.cmd_rd_len_3 = 0xc3,
-	.cmd_cfg_0 = 0xc4,
-	.cmd_cfg_1 = 0xc5,
-	.cmd_cfg_2 = 0xc6,
-	.cmd_cfg_3 = 0xc7,
-	.fw_dump_host_ready = 0xcc,
-	.fw_dump_ctrl = 0xf0,
-	.fw_dump_start = 0xf1,
-	.fw_dump_end = 0xf8,
-	.func1_dump_reg_start = 0x10,
-	.func1_dump_reg_end = 0x17,
-	.func1_scratch_reg = 0xe8,
-	.func1_spec_reg_num = 13,
-	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D,
-				 0x60, 0x61, 0x62, 0x64,
-				 0x65, 0x66, 0x68, 0x69,
-				 0x6a},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0xF8,
-	.base_1_reg = 0xF9,
-	.poll_reg = 0x5C,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x4,
-	.host_int_status_reg = 0x0C,
-	.host_int_mask_reg = 0x08,
-	.status_reg_0 = 0xE8,
-	.status_reg_1 = 0xE9,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xE4,
-	.io_port_1_reg = 0xE5,
-	.io_port_2_reg = 0xE6,
-	.max_mp_regs = 196,
-	.rd_bitmap_l = 0x10,
-	.rd_bitmap_u = 0x11,
-	.rd_bitmap_1l = 0x12,
-	.rd_bitmap_1u = 0x13,
-	.wr_bitmap_l = 0x14,
-	.wr_bitmap_u = 0x15,
-	.wr_bitmap_1l = 0x16,
-	.wr_bitmap_1u = 0x17,
-	.rd_len_p0_l = 0x18,
-	.rd_len_p0_u = 0x19,
-	.card_misc_cfg_reg = 0xd8,
-	.card_cfg_2_1_reg = 0xd9,
-	.cmd_rd_len_0 = 0xc0,
-	.cmd_rd_len_1 = 0xc1,
-	.cmd_rd_len_2 = 0xc2,
-	.cmd_rd_len_3 = 0xc3,
-	.cmd_cfg_0 = 0xc4,
-	.cmd_cfg_1 = 0xc5,
-	.cmd_cfg_2 = 0xc6,
-	.cmd_cfg_3 = 0xc7,
-	.fw_dump_host_ready = 0xcc,
-	.fw_dump_ctrl = 0xf0,
-	.fw_dump_start = 0xf1,
-	.fw_dump_end = 0xf8,
-	.func1_dump_reg_start = 0x10,
-	.func1_dump_reg_end = 0x17,
-	.func1_scratch_reg = 0xe8,
-	.func1_spec_reg_num = 13,
-	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D,
-				 0x60, 0x61, 0x62, 0x64,
-				 0x65, 0x66, 0x68, 0x69,
-				 0x6a},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0x6C,
-	.base_1_reg = 0x6D,
-	.poll_reg = 0x5C,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x4,
-	.host_int_status_reg = 0x0C,
-	.host_int_mask_reg = 0x08,
-	.status_reg_0 = 0x90,
-	.status_reg_1 = 0x91,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xE4,
-	.io_port_1_reg = 0xE5,
-	.io_port_2_reg = 0xE6,
-	.max_mp_regs = 196,
-	.rd_bitmap_l = 0x10,
-	.rd_bitmap_u = 0x11,
-	.rd_bitmap_1l = 0x12,
-	.rd_bitmap_1u = 0x13,
-	.wr_bitmap_l = 0x14,
-	.wr_bitmap_u = 0x15,
-	.wr_bitmap_1l = 0x16,
-	.wr_bitmap_1u = 0x17,
-	.rd_len_p0_l = 0x18,
-	.rd_len_p0_u = 0x19,
-	.card_misc_cfg_reg = 0xd8,
-	.card_cfg_2_1_reg = 0xd9,
-	.cmd_rd_len_0 = 0xc0,
-	.cmd_rd_len_1 = 0xc1,
-	.cmd_rd_len_2 = 0xc2,
-	.cmd_rd_len_3 = 0xc3,
-	.cmd_cfg_0 = 0xc4,
-	.cmd_cfg_1 = 0xc5,
-	.cmd_cfg_2 = 0xc6,
-	.cmd_cfg_3 = 0xc7,
-	.func1_dump_reg_start = 0x10,
-	.func1_dump_reg_end = 0x17,
-	.func1_scratch_reg = 0x90,
-	.func1_spec_reg_num = 13,
-	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
-				 0x61, 0x62, 0x64, 0x65, 0x66,
-				 0x68, 0x69, 0x6a},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8987 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0xF8,
-	.base_1_reg = 0xF9,
-	.poll_reg = 0x5C,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x4,
-	.host_int_status_reg = 0x0C,
-	.host_int_mask_reg = 0x08,
-	.status_reg_0 = 0xE8,
-	.status_reg_1 = 0xE9,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xE4,
-	.io_port_1_reg = 0xE5,
-	.io_port_2_reg = 0xE6,
-	.max_mp_regs = 196,
-	.rd_bitmap_l = 0x10,
-	.rd_bitmap_u = 0x11,
-	.rd_bitmap_1l = 0x12,
-	.rd_bitmap_1u = 0x13,
-	.wr_bitmap_l = 0x14,
-	.wr_bitmap_u = 0x15,
-	.wr_bitmap_1l = 0x16,
-	.wr_bitmap_1u = 0x17,
-	.rd_len_p0_l = 0x18,
-	.rd_len_p0_u = 0x19,
-	.card_misc_cfg_reg = 0xd8,
-	.card_cfg_2_1_reg = 0xd9,
-	.cmd_rd_len_0 = 0xc0,
-	.cmd_rd_len_1 = 0xc1,
-	.cmd_rd_len_2 = 0xc2,
-	.cmd_rd_len_3 = 0xc3,
-	.cmd_cfg_0 = 0xc4,
-	.cmd_cfg_1 = 0xc5,
-	.cmd_cfg_2 = 0xc6,
-	.cmd_cfg_3 = 0xc7,
-	.fw_dump_host_ready = 0xcc,
-	.fw_dump_ctrl = 0xf9,
-	.fw_dump_start = 0xf1,
-	.fw_dump_end = 0xf8,
-	.func1_dump_reg_start = 0x10,
-	.func1_dump_reg_end = 0x17,
-	.func1_scratch_reg = 0xE8,
-	.func1_spec_reg_num = 13,
-	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
-				 0x61, 0x62, 0x64, 0x65, 0x66,
-				 0x68, 0x69, 0x6a},
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
-	.firmware = SD8786_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd87xx,
-	.max_ports = 16,
-	.mp_agg_pkt_limit = 8,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
-	.can_dump_fw = false,
-	.can_auto_tdls = false,
-	.can_ext_scan = false,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
-	.firmware = SD8787_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd87xx,
-	.max_ports = 16,
-	.mp_agg_pkt_limit = 8,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
-	.can_dump_fw = false,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
-	.firmware = SD8797_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd87xx,
-	.max_ports = 16,
-	.mp_agg_pkt_limit = 8,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
-	.can_dump_fw = false,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
-	.firmware = SD8897_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8897,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = true,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
-	.firmware = SD8977_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8977,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = true,
-	.fw_dump_enh = true,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
-	.firmware = SD8997_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8997,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = true,
-	.fw_dump_enh = true,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
-	.firmware = SD8887_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8887,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = false,
-	.can_auto_tdls = true,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8987 = {
-	.firmware = SD8987_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8987,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = true,
-	.fw_dump_enh = true,
-	.can_auto_tdls = true,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
-	.firmware = SD8801_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd87xx,
-	.max_ports = 16,
-	.mp_agg_pkt_limit = 8,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.can_dump_fw = false,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
 /*
  * .cmdrsp_complete handler
  */
-- 
2.17.1


