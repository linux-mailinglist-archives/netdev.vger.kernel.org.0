Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF0B26DDFC
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 16:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgIQOUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 10:20:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28248 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727393AbgIQOMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 10:12:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HDPZRw009045;
        Thu, 17 Sep 2020 06:28:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=CpUHwzjwahL9ePxdGDpF3pAZ54hXLm9ZaThD+WXfcK4=;
 b=dE3hN/ddHM5TZ/ZOyFz90RTGbHkJFxM3NG/XMK8RyEHJ+BBTK/s7PCclHxr3DbXiaecY
 SlukzhOUR/WRvbXiguGdzErZ7Kj9fpFjG+Dc8IzJHD++k+EVY8J+aPZ0V1h+yfN8qa0S
 U0Oe5fyKPkyJ9ymWKJY8Oyl+vnlK51HKRvQtwGno1cUbPgOLkYfOYw95v1uMAr7N0DDW
 kNApieXceBef9jLT5p/dIZMYxjRVMQYUCVlqL/psRt0yY/Pm3ntKxJ+xUkb2VMaZcL/g
 abDxEGnU3y/I5xM4/w+S9+VooIBP0aYkOShhifLom/PVgOKeHlp7goqYkRPIk46L1LhW yg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33m73p0ajk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 06:28:48 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 06:28:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 06:28:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Sep 2020 06:28:46 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 562333F7043;
        Thu, 17 Sep 2020 06:28:42 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v3,net-next,0/4] Add Support for Marvell OcteonTX2 Cryptographic
Date:   Thu, 17 Sep 2020 18:58:31 +0530
Message-ID: <20200917132835.28325-1-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_09:2020-09-16,2020-09-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series adds support for Marvell Cryptographic Acceleration
Unit(CPT) on OcteonTX2 CN96XX SoC.
This series is tested with CRYPTO_EXTRA_TESTS enabled and
CRYPTO_DISABLE_TESTS disabled.

Changes since v2:
 * Fixed C=1 warnings.
 * Added code to exit CPT VF driver gracefully.
 * Moved OcteonTx2 asm code to a header file under include/linux/soc/

Changes since v1:
 * Moved Makefile changes from patch4 to patch2 and patch3.

Srujana Challa (3):
  octeontx2-pf: move asm code to include/linux/soc
  octeontx2-af: add support to manage the CPT unit
  drivers: crypto: add support for OCTEONTX2 CPT engine
  drivers: crypto: add the Virtual Function driver for OcteonTX2 CPT

 MAINTAINERS                                   |    2 +
 drivers/crypto/marvell/Kconfig                |   17 +
 drivers/crypto/marvell/Makefile               |    1 +
 drivers/crypto/marvell/octeontx2/Makefile     |   10 +
 .../marvell/octeontx2/otx2_cpt_common.h       |   53 +
 .../marvell/octeontx2/otx2_cpt_hw_types.h     |  467 ++++
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  286 +++
 .../marvell/octeontx2/otx2_cpt_mbox_common.h  |  100 +
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  197 ++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  356 +++
 .../marvell/octeontx2/otx2_cptlf_main.c       |  967 ++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   79 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |  598 +++++
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  694 ++++++
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 2173 +++++++++++++++++
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |  180 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   29 +
 .../marvell/octeontx2/otx2_cptvf_algs.c       | 1698 +++++++++++++
 .../marvell/octeontx2/otx2_cptvf_algs.h       |  172 ++
 .../marvell/octeontx2/otx2_cptvf_main.c       |  229 ++
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  189 ++
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  540 ++++
 .../ethernet/marvell/octeontx2/af/Makefile    |    3 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   85 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |    2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |    7 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  343 +++
 .../marvell/octeontx2/af/rvu_debugfs.c        |  342 +++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   76 +
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   65 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   13 +-
 include/linux/soc/marvell/octeontx2/asm.h     |   29 +
 32 files changed, 9982 insertions(+), 20 deletions(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
 create mode 100644 include/linux/soc/marvell/octeontx2/asm.h

-- 
2.28.0

