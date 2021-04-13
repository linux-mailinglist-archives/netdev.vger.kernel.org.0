Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAB035E430
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345262AbhDMQj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:39:57 -0400
Received: from mail-il1-f179.google.com ([209.85.166.179]:38736 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346959AbhDMQjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:39:52 -0400
Received: by mail-il1-f179.google.com with SMTP id c3so8503006ils.5
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ndtq1fkbKGfbaUkZP5HxUEnmKftbxraQzyuRGNQc1vk=;
        b=Jt5+/i3GM4Q0ZvLaPqyl/EQvDhc+rcJlNn16/XbImlrODkK2nye/KrIEjFcXDJI7nX
         Ijq5MXyzDA3p2n1w2MWZ8NCSGFX1LrmPHXwZghuI/XLUdL2MBQIt2ZGw/RgnHDd4T5Oa
         WF1xBr3CIN7rvNC8ez8s6nx4wSb8nDHkXp8CKSgBsk1iY6yAm9pkPajQGnjCK/FxedEa
         3lMeX1DCfCvzH6g5RhjcAf05+2uAJlShSk3wbdFDCh4WQyaW8nHgDO++JhsMD/9o5Cl3
         1OZg1hn3MJuDlyAq+bTKsftsxjRMjKcQiXZeM3Ja52k5ZJS5tOIOZTUiCJcn+vd4wD6J
         PdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ndtq1fkbKGfbaUkZP5HxUEnmKftbxraQzyuRGNQc1vk=;
        b=kHu8kAoi29i8n0ZexoSBOq2JqdaQHXFCFbUJCzegKDKYY5RkfcfS2lR9fLotf9LblG
         Qxz68vLWDGJDp3al712JdYCkGG/BbH92dsp0xIBG1unqha3Jf4+UODhZCoJdlIqCiBqA
         bfrLGCRMgG141eElNHd8lizHweX1vK5x3Pbo8zp8hon/JosEYnw5yt3hpZNSVT5oIwis
         Vfq63LsFnLbU+hPjictSEbEzk624fj6Ixb7mwD2uzH/wx+hsvbhPkl/jmF3dSt/6smc3
         mULKbz3KdFYlt4VQ1/dZeWqd0kj05K6RDVq6yH3gY7xUZYM0b2yE+gK5sjQcgcOjESkE
         iBHw==
X-Gm-Message-State: AOAM532qYNa1Gm++e+W/EbIMKosJLsVxeSA47chdOTOsDBfzo8FHNmAO
        Q8Vvk+b/GDVtaRKwInzrTNnfXw==
X-Google-Smtp-Source: ABdhPJwb7SlL0RqVKz76XLiP2XAqX1bdzcK3nw9Ddq3W9vh8Ie3MtC1tCA19xHJZnkZCBvvyemZ7yA==
X-Received: by 2002:a05:6e02:219c:: with SMTP id j28mr28030036ila.229.1618331912000;
        Tue, 13 Apr 2021 09:38:32 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 11sm7054469iln.74.2021.04.13.09.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 09:38:31 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: ipa: add IPA v4.9 configuration data
Date:   Tue, 13 Apr 2021 11:38:26 -0500
Message-Id: <20210413163826.1770386-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210413163826.1770386-1-elder@linaro.org>
References: <20210413163826.1770386-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the SM8350 SoC, which includes IPA version 4.9.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile        |   3 +-
 drivers/net/ipa/ipa_data-v4.9.c | 430 ++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_data.h      |   1 +
 drivers/net/ipa/ipa_main.c      |   4 +
 4 files changed, 437 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ipa/ipa_data-v4.9.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 8c0ac87903549..1efe1a88104b3 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -10,4 +10,5 @@ ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o
 
 ipa-y			+=	ipa_data-v3.5.1.o ipa_data-v4.2.o \
-				ipa_data-v4.5.o ipa_data-v4.11.o
+				ipa_data-v4.5.o ipa_data-v4.9.o \
+				ipa_data-v4.11.o
diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
new file mode 100644
index 0000000000000..e41be790f45e5
--- /dev/null
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -0,0 +1,430 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2021 Linaro Ltd. */
+
+#include <linux/log2.h>
+
+#include "gsi.h"
+#include "ipa_data.h"
+#include "ipa_endpoint.h"
+#include "ipa_mem.h"
+
+/** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.9 */
+enum ipa_resource_type {
+	/* Source resource types; first must have value 0 */
+	IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS		= 0,
+	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
+	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
+	IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
+	IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
+
+	/* Destination resource types; first must have value 0 */
+	IPA_RESOURCE_TYPE_DST_DATA_SECTORS		= 0,
+	IPA_RESOURCE_TYPE_DST_DPS_DMARS,
+};
+
+/* Resource groups used for an SoC having IPA v4.9 */
+enum ipa_rsrc_group_id {
+	/* Source resource group identifiers */
+	IPA_RSRC_GROUP_SRC_UL_DL			= 0,
+	IPA_RSRC_GROUP_SRC_DMA,
+	IPA_RSRC_GROUP_SRC_UC_RX_Q,
+	IPA_RSRC_GROUP_SRC_COUNT,	/* Last in set; not a source group */
+
+	/* Destination resource group identifiers */
+	IPA_RSRC_GROUP_DST_UL_DL_DPL			= 0,
+	IPA_RSRC_GROUP_DST_DMA,
+	IPA_RSRC_GROUP_DST_UC,
+	IPA_RSRC_GROUP_DST_DRB_IP,
+	IPA_RSRC_GROUP_DST_COUNT,	/* Last; not a destination group */
+};
+
+/* QSB configuration data for an SoC having IPA v4.9 */
+static const struct ipa_qsb_data ipa_qsb_data[] = {
+	[IPA_QSB_MASTER_DDR] = {
+		.max_writes		= 8,
+		.max_reads		= 0,	/* no limit (hardware max) */
+		.max_reads_beats	= 120,
+	},
+};
+
+/* Endpoint configuration data for an SoC having IPA v4.9 */
+static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
+	[IPA_ENDPOINT_AP_COMMAND_TX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 6,
+		.endpoint_id	= 7,
+		.toward_ipa	= true,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 20,
+		},
+		.endpoint = {
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.dma_mode	= true,
+				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
+				.tx = {
+					.seq_type = IPA_SEQ_DMA,
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_AP_LAN_RX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 7,
+		.endpoint_id	= 11,
+		.toward_ipa	= false,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 9,
+		},
+		.endpoint = {
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.aggregation	= true,
+				.status_enable	= true,
+				.rx = {
+					.pad_align	= ilog2(sizeof(u32)),
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_AP_MODEM_TX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 2,
+		.endpoint_id	= 2,
+		.toward_ipa	= true,
+		.channel = {
+			.tre_count	= 512,
+			.event_count	= 512,
+			.tlv_count	= 16,
+		},
+		.endpoint = {
+			.filter_support	= true,
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.qmap		= true,
+				.status_enable	= true,
+				.tx = {
+					.seq_type = IPA_SEQ_2_PASS_SKIP_LAST_UC,
+					.status_endpoint =
+						IPA_ENDPOINT_MODEM_AP_RX,
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_AP_MODEM_RX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 12,
+		.endpoint_id	= 20,
+		.toward_ipa	= false,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 9,
+		},
+		.endpoint = {
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.qmap		= true,
+				.aggregation	= true,
+				.rx = {
+					.aggr_close_eof	= true,
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_MODEM_AP_TX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 0,
+		.endpoint_id	= 5,
+		.toward_ipa	= true,
+		.endpoint = {
+			.filter_support	= true,
+		},
+	},
+	[IPA_ENDPOINT_MODEM_AP_RX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 7,
+		.endpoint_id	= 16,
+		.toward_ipa	= false,
+	},
+	[IPA_ENDPOINT_MODEM_DL_NLO_TX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 2,
+		.endpoint_id	= 8,
+		.toward_ipa	= true,
+		.endpoint = {
+			.filter_support	= true,
+		},
+	},
+};
+
+/* Source resource configuration data for an SoC having IPA v4.9 */
+static const struct ipa_resource ipa_resource_src[] = {
+	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 1,	.max = 12,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 1,	.max = 1,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 1,	.max = 12,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 20,	.max = 20,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 2,	.max = 2,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 3,	.max = 3,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 38,	.max = 38,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 4,	.max = 4,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 8,	.max = 8,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_HPS_DMARS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 0,	.max = 4,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 0,	.max = 4,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 0,	.max = 4,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 30,	.max = 30,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 8,	.max = 8,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 8,	.max = 8,
+		},
+	},
+};
+
+/* Destination resource configuration data for an SoC having IPA v4.9 */
+static const struct ipa_resource ipa_resource_dst[] = {
+	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
+			.min = 9,	.max = 9,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DMA] = {
+			.min = 1,	.max = 1,
+		},
+		.limits[IPA_RSRC_GROUP_DST_UC] = {
+			.min = 1,	.max = 1,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DRB_IP] = {
+			.min = 39,	.max = 39,
+		},
+	},
+	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
+			.min = 2,	.max = 3,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DMA] = {
+			.min = 1,	.max = 2,
+		},
+		.limits[IPA_RSRC_GROUP_DST_UC] = {
+			.min = 0,	.max = 2,
+		},
+	},
+};
+
+/* Resource configuration data for an SoC having IPA v4.9 */
+static const struct ipa_resource_data ipa_resource_data = {
+	.rsrc_group_dst_count	= IPA_RSRC_GROUP_DST_COUNT,
+	.rsrc_group_src_count	= IPA_RSRC_GROUP_SRC_COUNT,
+	.resource_src_count	= ARRAY_SIZE(ipa_resource_src),
+	.resource_src		= ipa_resource_src,
+	.resource_dst_count	= ARRAY_SIZE(ipa_resource_dst),
+	.resource_dst		= ipa_resource_dst,
+};
+
+/* IPA-resident memory region data for an SoC having IPA v4.9 */
+static const struct ipa_mem ipa_mem_local_data[] = {
+	[IPA_MEM_UC_SHARED] = {
+		.offset		= 0x0000,
+		.size		= 0x0080,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_UC_INFO] = {
+		.offset		= 0x0080,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_V4_FILTER_HASHED] = { .offset		= 0x0288,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V4_FILTER] = {
+		.offset		= 0x0308,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_FILTER_HASHED] = {
+		.offset		= 0x0388,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_FILTER] = {
+		.offset		= 0x0408,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V4_ROUTE_HASHED] = {
+		.offset		= 0x0488,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V4_ROUTE] = {
+		.offset		= 0x0508,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_ROUTE_HASHED] = {
+		.offset		= 0x0588,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_ROUTE] = {
+		.offset		= 0x0608,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_MODEM_HEADER] = {
+		.offset		= 0x0688,
+		.size		= 0x0240,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_AP_HEADER] = {
+		.offset		= 0x08c8,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_MODEM_PROC_CTX] = {
+		.offset		= 0x0ad0,
+		.size		= 0x0b20,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_AP_PROC_CTX] = {
+		.offset		= 0x15f0,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_NAT_TABLE] = {
+		.offset		= 0x1800,
+		.size		= 0x0d00,
+		.canary_count	= 4,
+	},
+	[IPA_MEM_STATS_QUOTA_MODEM] = {
+		.offset		= 0x2510,
+		.size		= 0x0030,
+		.canary_count	= 4,
+	},
+	[IPA_MEM_STATS_QUOTA_AP] = {
+		.offset		= 0x2540,
+		.size		= 0x0048,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_STATS_TETHERING] = {
+		.offset		= 0x2588,
+		.size		= 0x0238,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_STATS_FILTER_ROUTE] = {
+		.offset		= 0x27c0,
+		.size		= 0x0800,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_STATS_DROP] = {
+		.offset		= 0x2fc0,
+		.size		= 0x0020,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_MODEM] = {
+		.offset		= 0x2fe8,
+		.size		= 0x0800,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_UC_EVENT_RING] = {
+		.offset		= 0x3800,
+		.size		= 0x1000,
+		.canary_count	= 1,
+	},
+	[IPA_MEM_PDN_CONFIG] = {
+		.offset		= 0x4800,
+		.size		= 0x0050,
+		.canary_count	= 0,
+	},
+};
+
+/* Memory configuration data for an SoC having IPA v4.9 */
+static const struct ipa_mem_data ipa_mem_data = {
+	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
+	.local		= ipa_mem_local_data,
+	.imem_addr	= 0x146bd000,
+	.imem_size	= 0x00002000,
+	.smem_id	= 497,
+	.smem_size	= 0x00009000,
+};
+
+/* Interconnect rates are in 1000 byte/second units */
+static const struct ipa_interconnect_data ipa_interconnect_data[] = {
+	{
+		.name			= "ipa_to_llcc",
+		.peak_bandwidth		= 600000,	/* 600 MBps */
+		.average_bandwidth	= 150000,	/* 150 MBps */
+	},
+	{
+		.name			= "llcc_to_ebi1",
+		.peak_bandwidth		= 1804000,	/* 1.804 GBps */
+		.average_bandwidth	= 150000,	/* 150 MBps */
+	},
+	/* Average rate is unused for the next interconnect */
+	{
+		.name			= "appss_to_ipa",
+		.peak_bandwidth		= 74000,	/* 74 MBps */
+		.average_bandwidth	= 0,		/* unused */
+	},
+
+};
+
+/* Clock and interconnect configuration data for an SoC having IPA v4.9 */
+static const struct ipa_clock_data ipa_clock_data = {
+	.core_clock_rate	= 60 * 1000 * 1000,	/* Hz */
+	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
+	.interconnect_data	= ipa_interconnect_data,
+};
+
+/* Configuration data for an SoC having IPA v4.9. */
+const struct ipa_data ipa_data_v4_9 = {
+	.version	= IPA_VERSION_4_9,
+	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data	= ipa_qsb_data,
+	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data	= ipa_gsi_endpoint_data,
+	.resource_data	= &ipa_resource_data,
+	.mem_data	= &ipa_mem_data,
+	.clock_data	= &ipa_clock_data,
+};
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index e3212ea9e3bce..5c4c8d72d7d87 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -303,6 +303,7 @@ struct ipa_data {
 extern const struct ipa_data ipa_data_v3_5_1;
 extern const struct ipa_data ipa_data_v4_2;
 extern const struct ipa_data ipa_data_v4_5;
+extern const struct ipa_data ipa_data_v4_9;
 extern const struct ipa_data ipa_data_v4_11;
 
 #endif /* _IPA_DATA_H_ */
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 0d168afcdf041..aad915e2ce523 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -577,6 +577,10 @@ static const struct of_device_id ipa_match[] = {
 		.compatible	= "qcom,sdx55-ipa",
 		.data		= &ipa_data_v4_5,
 	},
+	{
+		.compatible	= "qcom,sm8350-ipa",
+		.data		= &ipa_data_v4_9,
+	},
 	{
 		.compatible	= "qcom,sc7280-ipa",
 		.data		= &ipa_data_v4_11,
-- 
2.27.0

