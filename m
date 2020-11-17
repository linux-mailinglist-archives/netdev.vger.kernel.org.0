Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40112B6A23
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgKQQae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:30:34 -0500
Received: from pbmsgap01.intersil.com ([192.157.179.201]:43602 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgKQQae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:30:34 -0500
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFxQPu031483;
        Tue, 17 Nov 2020 11:06:40 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap01.intersil.com with ESMTP id 34tbn59bca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:06:40 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Tue, 17 Nov 2020 11:06:38 -0500
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 17 Nov 2020 11:06:38 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v2 net-next 0/5] ptp_clockmatrix bug fix and improvement
Date:   Tue, 17 Nov 2020 11:05:57 -0500
Message-ID: <1605629162-31876-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 adultscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=612 suspectscore=4 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170115
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

This patch series is aiming at submitting the latest bug fixes and code
improvements of PHC driver for Renesas CLOCKMATRIX timing card. The code
has been thouroughly tested in both customer labs and Renesas internal
lab using the latest linuxptp program on Xilinx ZCU102 platform.

Changes since v1:
-Only strcpy 15 characters to leave 1 space for '\0'

Min Li (5):
  ptp: clockmatrix: bug fix for idtcm_strverscmp
  ptp: clockmatrix: reset device and check BOOT_STATUS
  ptp: clockmatrix: remove 5 second delay before entering write phase
    mode
  ptp: clockmatrix: Fix non-zero phase_adj is lost after snap
  ptp: clockmatrix: deprecate firmware older than 4.8.7

 drivers/ptp/idt8a340_reg.h    |   1 +
 drivers/ptp/ptp_clockmatrix.c | 477 ++++++++++++++++++++++++++++++++----------
 drivers/ptp/ptp_clockmatrix.h |  24 ++-
 3 files changed, 384 insertions(+), 118 deletions(-)

-- 
2.7.4

