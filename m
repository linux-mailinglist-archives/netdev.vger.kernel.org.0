Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BF824A7B4
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgHSU3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:29:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56526 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgHSU3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:29:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JKTYnL008837;
        Wed, 19 Aug 2020 13:29:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=YJD3hORnMbs368p6fCb9sSw4d8OPm8PR2WySdVeYM7k=;
 b=XMflCpTZRHua1qXNzgBRyuSlp75jZ6vNxhaaOixmmQUAZO7m9S+q2QyYw4HauHGs5GDR
 4RfXjDGuwFWcGXZnyur55pz5vtTDMyud3NBc1UktsLJlLKcaDPBGg/sbQvKpm+EZ049t
 +qJBfwH6N3RoceG+zIohPgcabMq45eHqjqr1+KvxSVtvnqZBgZh+WnQjXcCEdsvUELt5
 XYhQIxc7zzoB8nVs2X2UnxaXpubIURhTjYyhjsjXwJRCGangL9A8FXfNuQ1EYN7FRuMo
 lzfUiOQzc3Bue8t196ioezGyduI26HiWn9yQdq0rFS/SGbNJjuV3op0ZVlS+CE9xHXGl jA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhsvay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 13:29:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 Aug
 2020 13:29:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Aug 2020 13:29:33 -0700
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.54.69])
        by maili.marvell.com (Postfix) with ESMTP id 8FDF93F703F;
        Wed, 19 Aug 2020 13:29:32 -0700 (PDT)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>
CC:     Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH net 0/3] net: qed disable aRFS in NPAR and 100G
Date:   Wed, 19 Aug 2020 23:29:26 +0300
Message-ID: <cover.1597833340.git.dbogdanov@marvell.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes some recent issues found by customers.

Dmitry Bogdanov (3):
  net: qed: Disable aRFS for NPAR and 100G
  net: qede: Disable aRFS for NPAR and 100G
  qed: RDMA personality shouldn't fail VF load

 drivers/net/ethernet/qlogic/qed/qed_dev.c      | 11 ++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_l2.c       |  3 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c     |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_sriov.c    |  1 +
 drivers/net/ethernet/qlogic/qede/qede_filter.c |  3 +++
 drivers/net/ethernet/qlogic/qede/qede_main.c   | 11 +++++------
 include/linux/qed/qed_if.h                     |  1 +
 7 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.17.1

