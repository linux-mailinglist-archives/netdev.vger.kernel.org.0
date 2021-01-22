Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EBD3006B4
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbhAVPH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:07:56 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728286AbhAVPGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:06:24 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10MF50Xe005182;
        Fri, 22 Jan 2021 07:05:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=5JbAvsL2syjN+jFpQDIhMXYI8XvCzUVGqKxD9QTDI/k=;
 b=TcGY/THh346qLNm2/5++fUTykhVDN7dP4NTGJSEhy/J82xrWoUNnZTh7U/t4KZqBW93Z
 iiL2pAF41hSMNVDdDOXn964uogaUAVR9DYDRDzTpUOZf/IsvCI2oPF+DgoA2lTKmSGbZ
 VQrRNQkxrsQq4mKgWK81yUIVa+KX96uCeF5k439VPpb/beDwpzQOV476U2xqzwcSMSH3
 uF+5SZej9zyNBv331CqNmaWnNA6qkStpKzut4agsootx8xQinv7Qx/V5zmuyZ1ZUjB6A
 HHp0XEVtb8MmPWICXZAKSRtygPdLQmNvMGIVA7N0r950ods5X9RZo48wUGOmqEiMq1hg 3Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3668p7t1jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 07:05:31 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 22 Jan
 2021 07:05:29 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 22 Jan
 2021 07:05:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 Jan 2021 07:05:29 -0800
Received: from NN-LT0019.marvell.com (unknown [10.193.38.12])
        by maili.marvell.com (Postfix) with ESMTP id B83C53F703F;
        Fri, 22 Jan 2021 07:05:27 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 0/2] pktgen: scripts improvements
Date:   Fri, 22 Jan 2021 16:05:15 +0100
Message-ID: <20210122150517.7650-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_11:2021-01-22,2021-01-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev community,

Please consider small improvements to pktgen scripts we use in our environment.

Adding delay parameter through command line,
Adding new -a (append) parameter to make flex runs

Igor Russkikh (2):
  samples: pktgen: allow to specify delay parameter via new opt
  samples: pktgen: new append mode

 samples/pktgen/README.rst                      | 18 ++++++++++++++++++
 samples/pktgen/functions.sh                    |  2 +-
 samples/pktgen/parameters.sh                   | 15 ++++++++++++++-
 .../pktgen_bench_xmit_mode_netif_receive.sh    |  3 ---
 .../pktgen_bench_xmit_mode_queue_xmit.sh       |  3 ---
 samples/pktgen/pktgen_sample01_simple.sh       | 13 ++++++++-----
 samples/pktgen/pktgen_sample02_multiqueue.sh   | 11 ++++++++---
 .../pktgen_sample03_burst_single_flow.sh       | 13 ++++++++-----
 samples/pktgen/pktgen_sample04_many_flows.sh   | 13 ++++++++-----
 .../pktgen/pktgen_sample05_flow_per_thread.sh  | 13 ++++++++-----
 ..._sample06_numa_awared_queue_irq_affinity.sh | 11 ++++++++---
 11 files changed, 81 insertions(+), 34 deletions(-)

-- 
2.17.1

