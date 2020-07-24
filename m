Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBD822C5C2
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGXNJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:09:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17398 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbgGXNI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:08:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06OD5Fpc016676;
        Fri, 24 Jul 2020 06:08:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=dnN26gY+5plrnF+T6HmJYyBHMf/NLNeeDWyYx0fnIKs=;
 b=qY+vxIgGQY9DajXwT1nXB0cMvGfueclIDv3floHiWycxjMplzBEMCqxr7ZQOaNPnY/6V
 3OyF3uWjmElY0UKOpH3xA4zSIbVgmVT9bQQ4nsJuX/G1gBbP2uchI08sTfEaGdLunhtr
 Qsr4wMcK8sYw6oyoDUDPV7lY2TFRA5OpF+roWLq/xgWeXcahDrLznPwtn8LOr5JaIzbX
 Soz3ZtfBgdBPZty2N7iXhuYLdS3cVJDAMD2XielRC3+QlFvzShxG14sQxmoZ6xfp6bt8
 BLIWwk17/QiceDTT9S87qE0NFznShDTDkV81BjS4tRq8IBuiYnXv6MwK0Y5cCdppR+bB aA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0km1t6h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 06:08:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul
 2020 06:08:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Jul 2020 06:08:54 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 2D8143F7041;
        Fri, 24 Jul 2020 06:08:51 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <sgoutham@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH 4/4] crypto: marvell: enable OcteonTX2 cpt options for build
Date:   Fri, 24 Jul 2020 18:38:04 +0530
Message-ID: <1595596084-29809-5-git-send-email-schalla@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1595596084-29809-1-git-send-email-schalla@marvell.com>
References: <1595596084-29809-1-git-send-email-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_04:2020-07-24,2020-07-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add OcteonTX2 cpt options in crypto Kconfig and Makefile

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/Kconfig            | 17 +++++++++++++++++
 drivers/crypto/marvell/Makefile           |  1 +
 drivers/crypto/marvell/octeontx2/Makefile | 14 ++++++++++++++
 3 files changed, 32 insertions(+)
 create mode 100644 drivers/crypto/marvell/octeontx2/Makefile

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 1306338..fe4f48c 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -35,3 +35,20 @@ config CRYPTO_DEV_OCTEONTX_CPT
 
 		To compile this driver as module, choose M here:
 		the modules will be called octeontx-cpt and octeontx-cptvf
+
+config CRYPTO_DEV_OCTEONTX2_CPT
+	tristate "Support for Marvell OcteonTX2 CPT driver"
+	depends on ARCH_THUNDER || COMPILE_TEST
+	depends on PCI_MSI && 64BIT
+	depends on CRYPTO_LIB_AES
+	select OCTEONTX2_MBOX
+	select CRYPTO_SKCIPHER
+	select CRYPTO_HASH
+	select CRYPTO_AEAD
+	select CRYPTO_DEV_MARVELL
+	help
+		This driver allows you to utilize the Marvell Cryptographic
+		Accelerator Unit(CPT) found in OcteonTX2 series of processors.
+
+		To compile this driver as module, choose M here:
+		the modules will be called octeontx2-cpt and octeontx2-cptvf
diff --git a/drivers/crypto/marvell/Makefile b/drivers/crypto/marvell/Makefile
index 6c6a151..39db6d9 100644
--- a/drivers/crypto/marvell/Makefile
+++ b/drivers/crypto/marvell/Makefile
@@ -2,3 +2,4 @@
 
 obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += cesa/
 obj-$(CONFIG_CRYPTO_DEV_OCTEONTX_CPT) += octeontx/
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2/
diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
new file mode 100644
index 0000000..49b988c
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o octeontx2-cptvf.o
+
+common-objs := otx2_cpt_mbox_common.o
+octeontx2-cpt-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o otx2_cptpf_ucode.o \
+		      ${common-objs}
+octeontx2-cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf_main.o \
+			otx2_cptvf_reqmgr.o otx2_cptvf_algs.o
+
+ifeq ($(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT), m)
+	octeontx2-cptvf-objs += ${common-objs}
+endif
+
+ccflags-y += -I$(src)/../../../net/ethernet/marvell/octeontx2/af/
-- 
1.9.1

