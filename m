Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB514B1795
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 22:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbiBJVdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 16:33:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiBJVdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 16:33:50 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5902C26C2;
        Thu, 10 Feb 2022 13:33:51 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21AJ34VY008090;
        Thu, 10 Feb 2022 13:33:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=nlrm+1Zpefi1YPk7p5tG6Y1/k5xHybXGj/udOzkg1NA=;
 b=jPuSD4cqPFZM8QgEe9zl8mLgzuoU2TsVOTV1syNJHjh6F7YncINzPOK4/O7fKxm4lqx3
 porVGjEKa6XMcR0vqZYADLjT3ilhrJi2DRfgNwV3fFbe1t06TuSP6Z4ic2emzefMfZgu
 QvpjXkGv4tOd0yruAmPIrath2LocLLaBWX0pXcYKWmC4EZdBC1Rge6X+I7gAdlB8RkQP
 /m8Dm5kynUAyFmV2mwR+ALBP1ReKkriHOXjZdEzOHZTbjc4agdocqlouAENauA09NC5M
 Gs4JCDTyOLPJ0xNofnUTVsbqSUrq80jh1LDmjPCXRuDV4HgyCXq/ZdckARNwvjVaHbtq qA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3e50ucaurn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 13:33:48 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Feb
 2022 13:33:46 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Feb 2022 13:33:46 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id C47223F706B;
        Thu, 10 Feb 2022 13:33:46 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <vburru@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Add octeon_ep driver
Date:   Thu, 10 Feb 2022 13:33:02 -0800
Message-ID: <20220210213306.3599-1-vburru@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: u1sjyav6SsBR6FGNliIVsYub7mdfl_Ik
X-Proofpoint-ORIG-GUID: u1sjyav6SsBR6FGNliIVsYub7mdfl_Ik
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_10,2022-02-09_01,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver implements networking functionality of Marvell's Octeon
PCI Endpoint NIC.

This driver support following devices:
 * Network controller: Cavium, Inc. Device b200

Veerasenareddy Burru (4):
  octeon_ep: Add driver framework and device initiazliation.
  octeon_ep: add support for ndo ops.
  octeon_ep: add Tx/Rx and interrupt support.
  octeon_ep: add ethtool support for Octeon PCI Endpoint NIC.

 .../device_drivers/ethernet/index.rst         |    1 +
 .../ethernet/marvell/octeon_ep.rst            |   35 +
 MAINTAINERS                                   |    7 +
 drivers/net/ethernet/marvell/Kconfig          |    1 +
 drivers/net/ethernet/marvell/Makefile         |    1 +
 .../net/ethernet/marvell/octeon_ep/Kconfig    |   20 +
 .../net/ethernet/marvell/octeon_ep/Makefile   |    9 +
 .../marvell/octeon_ep/octep_cn9k_pf.c         |  737 +++++++++++
 .../ethernet/marvell/octeon_ep/octep_config.h |  204 +++
 .../marvell/octeon_ep/octep_ctrl_mbox.c       |  254 ++++
 .../marvell/octeon_ep/octep_ctrl_mbox.h       |  170 +++
 .../marvell/octeon_ep/octep_ctrl_net.c        |  194 +++
 .../marvell/octeon_ep/octep_ctrl_net.h        |  299 +++++
 .../marvell/octeon_ep/octep_ethtool.c         |  509 +++++++
 .../ethernet/marvell/octeon_ep/octep_main.c   | 1177 +++++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.h   |  379 ++++++
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  367 +++++
 .../net/ethernet/marvell/octeon_ep/octep_rx.c |  512 +++++++
 .../net/ethernet/marvell/octeon_ep/octep_rx.h |  199 +++
 .../net/ethernet/marvell/octeon_ep/octep_tx.c |  334 +++++
 .../net/ethernet/marvell/octeon_ep/octep_tx.h |  284 ++++
 21 files changed, 5693 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Makefile
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_config.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.h

-- 
2.17.1

