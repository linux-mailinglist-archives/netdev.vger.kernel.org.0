Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31EA2CE6B5
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgLDDwL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 22:52:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54296 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726038AbgLDDwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:52:11 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B43jVpg003363
        for <netdev@vger.kernel.org>; Thu, 3 Dec 2020 19:51:31 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3577a2ad3g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:51:31 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 19:51:29 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id B831F4D9AA85; Thu,  3 Dec 2020 19:51:28 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>
CC:     <kernel-team@fb.com>
Subject: [PATCH 0/1 v3 net-next] Add OpenCompute timecard driver
Date:   Thu, 3 Dec 2020 19:51:27 -0800
Message-ID: <20201204035128.2219252-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_01:2020-12-03,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 mlxlogscore=771 clxscore=1034 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012040020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

v2->v3:
 remove dev_info() informational lines
v1->v2:
 make the driver dependent on CONFIG_PCI, for the test robot.
 move the config option under PTP_1588_CLOCK hierarcy
v1:
 initial submission

Jonathan Lemon (1):
  ptp: Add clock driver for the OpenCompute TimeCard.

 drivers/ptp/Kconfig   |  14 ++
 drivers/ptp/Makefile  |   1 +
 drivers/ptp/ptp_ocp.c | 400 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 415 insertions(+)
 create mode 100644 drivers/ptp/ptp_ocp.c

-- 
2.24.1

