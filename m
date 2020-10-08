Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453292873BD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbgJHL7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729650AbgJHL6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 07:58:48 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA5CC061755;
        Thu,  8 Oct 2020 04:58:47 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d6so2635208plo.13;
        Thu, 08 Oct 2020 04:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C16XrUr3EIZoC6wKnJOdQjSS5HIA0XhjmNmgGMQUzM4=;
        b=M6GmYwfbt/kjjUW6kp5B076qsmpCA6NAxj2aoMFmCLiqC6VWEhmwIkeTxTLjaR/BCj
         3iR9bU/ra3dayF4z0WUFKWnNJ5peBgsjjppx5Uk9CZaKeMVGwGVpJGo9b8hx0tklIqdu
         prMZsWNqmRo/buzmThYSm4iKEsbYTH/EZtJ7WczGcl/Rbqdn7UPUo/dpNf4L6mLygsoI
         rGIeSL0ftAreMCxlS4OTBU8g9V1P958rcn5Bg8W3DD2z4CqsAZ43pbSi/vsdJU024AUt
         yxjl+fh02KHA9q0MpzJx5O73kisLHCxKK5bf2Mj5mnAJW70PhVt7Yi1612Y5722HdrAp
         hw6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C16XrUr3EIZoC6wKnJOdQjSS5HIA0XhjmNmgGMQUzM4=;
        b=gQtwiM+D4eQKpOKLSzFoPbflC37Txr444Zt+imcdenPUUDzcdblqEJpJtsmx8H8q0u
         r5uv5QgNDjiTsznvZC11XvxOQIF/G/A/MU3pvV7jB/zRNIdx/4PgVvALkFjJKQraAv3N
         0jwRq09IcOD6TMUU+Tf4PWuxkj/QN2lDCyj3HT7FuimafaurMaaBwMs32DIeaggIAB4T
         y6TFpVcNPmdglO2JOIIh5OommUK8geIGns8LfBPSSafz9XA7OHlurmPrfUcPtqM2XRqn
         dClJHlk22pGecKf3TD7gNMiRs/fE+JKyq9XCsp5sMgkh1NXW/OtLPKFk9HXzcLbG8N7A
         49Iw==
X-Gm-Message-State: AOAM530E9X+LPHNqncrUrYl4hAbW/Fq4TYkYFm+habqAXHvqskcQU/+O
        71HJuV9cvyyyYMcQf+GPCrw=
X-Google-Smtp-Source: ABdhPJxBYQscTqQs3Usj08yzGOuKS+2JWwobVnEXIACwojWNpwWI5RwwKY4148y1cdC1Hg6PHssNQg==
X-Received: by 2002:a17:902:aa04:b029:d3:8b4e:e5ef with SMTP id be4-20020a170902aa04b02900d38b4ee5efmr7380941plb.65.1602158327213;
        Thu, 08 Oct 2020 04:58:47 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id 31sm7027555pgs.59.2020.10.08.04.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 04:58:46 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 6/6] staging: qlge: add documentation for debugging qlge
Date:   Thu,  8 Oct 2020 19:58:08 +0800
Message-Id: <20201008115808.91850-7-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008115808.91850-1-coiby.xu@gmail.com>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instructions and examples on kernel data structures dumping and coredump.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 .../networking/device_drivers/index.rst       |   1 +
 .../device_drivers/qlogic/index.rst           |  18 +++
 .../networking/device_drivers/qlogic/qlge.rst | 118 ++++++++++++++++++
 MAINTAINERS                                   |   6 +
 4 files changed, 143 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/qlogic/index.rst
 create mode 100644 Documentation/networking/device_drivers/qlogic/qlge.rst

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index a3113ffd7a16..d8279de7bf25 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -15,6 +15,7 @@ Contents:
    ethernet/index
    fddi/index
    hamradio/index
+   qlogic/index
    wan/index
    wifi/index
 
diff --git a/Documentation/networking/device_drivers/qlogic/index.rst b/Documentation/networking/device_drivers/qlogic/index.rst
new file mode 100644
index 000000000000..ad05b04286e4
--- /dev/null
+++ b/Documentation/networking/device_drivers/qlogic/index.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+QLogic QLGE Device Drivers
+===============================================
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   qlge
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/networking/device_drivers/qlogic/qlge.rst b/Documentation/networking/device_drivers/qlogic/qlge.rst
new file mode 100644
index 000000000000..0b888253d152
--- /dev/null
+++ b/Documentation/networking/device_drivers/qlogic/qlge.rst
@@ -0,0 +1,118 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================================
+QLogic QLGE 10Gb Ethernet device driver
+=======================================
+
+This driver use drgn and devlink for debugging.
+
+Dump kernel data structures in drgn
+-----------------------------------
+
+To dump kernel data structures, the following Python script can be used
+in drgn:
+
+.. code-block:: python
+
+	def align(x, a):
+	    """the alignment a should be a power of 2
+	    """
+	    mask = a - 1
+	    return (x+ mask) & ~mask
+
+	def struct_size(struct_type):
+	    struct_str = "struct {}".format(struct_type)
+	    return sizeof(Object(prog, struct_str, address=0x0))
+
+	def netdev_priv(netdevice):
+	    NETDEV_ALIGN = 32
+	    return netdevice.value_() + align(struct_size("net_device"), NETDEV_ALIGN)
+
+	name = 'xxx'
+	qlge_device = None
+	netdevices = prog['init_net'].dev_base_head.address_of_()
+	for netdevice in list_for_each_entry("struct net_device", netdevices, "dev_list"):
+	    if netdevice.name.string_().decode('ascii') == name:
+	        print(netdevice.name)
+
+	ql_adapter = Object(prog, "struct ql_adapter", address=netdev_priv(qlge_device))
+
+The struct ql_adapter will be printed in drgn as follows,
+
+    >>> ql_adapter
+    (struct ql_adapter){
+            .ricb = (struct ricb){
+                    .base_cq = (u8)0,
+                    .flags = (u8)120,
+                    .mask = (__le16)26637,
+                    .hash_cq_id = (u8 [1024]){ 172, 142, 255, 255 },
+                    .ipv6_hash_key = (__le32 [10]){},
+                    .ipv4_hash_key = (__le32 [4]){},
+            },
+            .flags = (unsigned long)0,
+            .wol = (u32)0,
+            .nic_stats = (struct nic_stats){
+                    .tx_pkts = (u64)0,
+                    .tx_bytes = (u64)0,
+                    .tx_mcast_pkts = (u64)0,
+                    .tx_bcast_pkts = (u64)0,
+                    .tx_ucast_pkts = (u64)0,
+                    .tx_ctl_pkts = (u64)0,
+                    .tx_pause_pkts = (u64)0,
+                    ...
+            },
+            .active_vlans = (unsigned long [64]){
+                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52780853100545, 18446744073709551615,
+                    18446619461681283072, 0, 42949673024, 2147483647,
+            },
+            .rx_ring = (struct rx_ring [17]){
+                    {
+                            .cqicb = (struct cqicb){
+                                    .msix_vect = (u8)0,
+                                    .reserved1 = (u8)0,
+                                    .reserved2 = (u8)0,
+                                    .flags = (u8)0,
+                                    .len = (__le16)0,
+                                    .rid = (__le16)0,
+                                    ...
+                            },
+                            .cq_base = (void *)0x0,
+                            .cq_base_dma = (dma_addr_t)0,
+                    }
+                    ...
+            }
+    }
+
+coredump via devlink
+--------------------
+
+
+And the coredump obtained via devlink in json format looks like,
+
+.. code:: shell
+
+	$ devlink health dump show DEVICE reporter coredump -p -j
+	{
+	    "Core Registers": {
+	        "segment": 1,
+	        "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
+	    },
+	    "Test Logic Regs": {
+	        "segment": 2,
+	        "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
+	    },
+	    "RMII Registers": {
+	        "segment": 3,
+	        "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
+	    },
+	    ...
+	    "Sem Registers": {
+	        "segment": 50,
+	        "values": [ 0,0,0,0 ]
+	    }
+	}
+
+When the module parameter qlge_force_coredump is set to be true, the MPI
+RISC reset before coredumping. So coredumping will much longer since
+devlink tool has to wait for 5 secs for the resetting to be
+finished.
diff --git a/MAINTAINERS b/MAINTAINERS
index 9ecb727f0a8f..d482078e3e88 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14411,6 +14411,12 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/staging/qlge/
 
+QLOGIC QLGE 10Gb ETHERNET DRIVER
+M:	Coiby Xu <coiby.xu@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/device_drivers/qlogic/qlge.rst
+
 QM1D1B0004 MEDIA DRIVER
 M:	Akihiro Tsukada <tskd08@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
2.28.0

