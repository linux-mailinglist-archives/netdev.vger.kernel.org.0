Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4220745B7A5
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhKXJqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:46:39 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21498 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237376AbhKXJqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 04:46:37 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AO2UgiP007763;
        Wed, 24 Nov 2021 01:43:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=OvhsEci/ORiXjL4twm9UgoRc8fPoPPqp0Zle24eX/0Q=;
 b=PCT5aJM4l3ncWZXDMY39XAYxy7v3JK0v9qWOvtPhNNtCQbVu2nEyvEwPT2travfmj1x8
 NfXU2sqYhbi8LEBXRzsNfVAwzGt3/wySrqao/q537ct2+TjW6as0znvBAcEQ0Eh7DmvD
 TVe0XXoXhzF0AhXkTM3xnW9ndFgDp1OD6ryPmx9BOHEJzGAuctGai3sX+U5nQI7H3x9g
 iAIHtcNG5hqNOgqs64H0KPwrWJd+KW/V7/4fKXBMQaQgwNPOzzkB6xbz5zU7xmA5dj/Y
 U3ks/CYEsk25tXfLMSOjlkSPOYrGVKOl7kkTna+/xhatvAl2jF0GitEOTosMK4aeh6ff eg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ch9tt24pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 01:43:27 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 24 Nov
 2021 01:43:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 24 Nov 2021 01:43:25 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 00E0C3F70AB;
        Wed, 24 Nov 2021 01:43:24 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1AO9hJgd029436;
        Wed, 24 Nov 2021 01:43:19 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1AO9h4uQ029426;
        Wed, 24 Nov 2021 01:43:04 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: [PATCH net-next 0/2] qed*: enhancements
Date:   Wed, 24 Nov 2021 01:43:01 -0800
Message-ID: <20211124094303.29390-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: T5iqFR7p_WYMhyNvANi_YnulJ_j6cOx1
X-Proofpoint-GUID: T5iqFR7p_WYMhyNvANi_YnulJ_j6cOx1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_03,2021-11-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

This series adds below enhancements for qed/qede drivers

patch 1: Improves tx timeout debug data logs.
patch 2: Add ESL priv flag cap/status support via ethtool.

Please consider applying it to "net-next"

Manish Chopra (2):
  qed*: enhance tx timeout debug info
  qed*: esl priv flag support through ethtool

 drivers/net/ethernet/qlogic/qed/qed_int.c     | 23 +++++
 drivers/net/ethernet/qlogic/qed/qed_int.h     | 13 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 72 +++++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     | 22 +++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     | 22 +++++
 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h |  1 +
 .../net/ethernet/qlogic/qed/qed_reg_addr.h    |  2 +
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 13 +++
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 94 ++++++++++++++++---
 include/linux/qed/qed_if.h                    | 14 +++
 10 files changed, 260 insertions(+), 16 deletions(-)

-- 
2.27.0

