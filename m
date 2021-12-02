Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA03466B56
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhLBVFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:05:49 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10210 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229683AbhLBVFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:05:49 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B2E1mI8022148;
        Thu, 2 Dec 2021 13:02:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=recJJvWfP/eYifLDVR7B6lWTU3vKD0yFANzLAdiWpB0=;
 b=FFTSw1BlcgkJu4KA/EdlFfHPtNinh6Hp34dVlxf0bly8GcsAR7jdg2EmnomPQGc/2E0L
 PDStbqiYr2mCQw78JBIcfKsHYBa0Y3gcnpjXR5puKKJtgqybmNvIT5vqq+XFj3wRSazH
 YzGd5IPOB3sYlV7QeowcY5oKDXX/x3NscyGnC2ux7PMgCMVWlt9HlM1mWqxGhCyCPN9o
 uGRhBIKageLWror6V8jgwnODMNBtu2ACC49fC33COMRw3WxgQP8g8TtDbIq/+K3Wpwda
 KQEtnVVjrKFmlFRzwZmB5uLrnkaljsVeTRzpNRT0Bhk+N4Msgp8Giq0Ryq4dULKmJtfQ yA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cpr523njd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 13:02:23 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 13:02:21 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 2 Dec 2021 13:02:21 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8ECAD3F7090;
        Thu,  2 Dec 2021 13:02:21 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1B2L2DnO025567;
        Thu, 2 Dec 2021 13:02:13 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1B2L1wAt025566;
        Thu, 2 Dec 2021 13:01:58 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: [PATCH v2 net-next 0/2] qed*: enhancements
Date:   Thu, 2 Dec 2021 13:01:55 -0800
Message-ID: <20211202210157.25530-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 5i0yh_Ipx4vi_-cMyayogtakzc4l9N9V
X-Proofpoint-ORIG-GUID: 5i0yh_Ipx4vi_-cMyayogtakzc4l9N9V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_14,2021-12-02_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

This series adds below enhancements for qed/qede drivers

patch 1: Improves tx timeout debug data logs.
patch 2: Add ESL(Enhanced system lockdown) priv flag cap/status support.

V1->V2: (addressed comments from Jakub)
----------------------------------------

* Fixed cosmetic issues in both patches
* Added ESL feature description in patch #2

Please consider applying it to "net-next"

Manish Chopra (2):
  qed*: enhance tx timeout debug info
  qed*: esl priv flag support through ethtool

 drivers/net/ethernet/qlogic/qed/qed_int.c     | 22 +++++
 drivers/net/ethernet/qlogic/qed/qed_int.h     | 13 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 72 ++++++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     | 22 +++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     | 22 +++++
 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h |  1 +
 .../net/ethernet/qlogic/qed/qed_reg_addr.h    |  2 +
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 13 +++
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 91 ++++++++++++++++---
 include/linux/qed/qed_if.h                    | 14 +++
 10 files changed, 256 insertions(+), 16 deletions(-)

-- 
2.27.0

