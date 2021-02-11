Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34A1318F4A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhBKP7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 10:59:40 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60972 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhBKP53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 10:57:29 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BFtDtw004399;
        Thu, 11 Feb 2021 07:56:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=S82q/aTj7WZR4BXZZ08CDyeqw2IQ51C0ttMTFxEHBAk=;
 b=gfGvWOiK8+3pp6TggOjLIpusf1xro7xHHPFArx/dDUPp8IAjMi+UEayF05pycg/C4Tnp
 OwXREuU6mZjlLana87gZoYLe8fM4NP8c0pr4U35b8gXqwYgCt44s3HPGgTxgXyhfh4Bk
 np9DMHiAIWzCZX3qm6BSk7VI0xFdzJE9SESHy3WfE8knjBnDgxMbOOjxcF1NuiCIUsUC
 I1pjgOFKsRUHrjvEuP11C2mDwPINN22ZEUV9kcLBRS+jpS9YNlMBZ/n8GAh/mCG15SKm
 ukdT+M7FI76Zb8qEuk6coQYSsZzPWzlK+XnMSMFkyl2FkSPB/zdpn2K7y6PhRtYJSl8v sQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqf953-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:56:37 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:56:36 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:56:35 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 07:56:35 -0800
Received: from EL-LT0043.marvell.com (unknown [10.193.38.106])
        by maili.marvell.com (Postfix) with ESMTP id 710E63F7041;
        Thu, 11 Feb 2021 07:56:34 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 0/2] pktgen: scripts improvements
Date:   Thu, 11 Feb 2021 16:56:24 +0100
Message-ID: <20210211155626.25213-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev community,

Please consider small improvements to pktgen scripts we use in our environment.

Adding delay parameter through command line,
Adding new -a (append) parameter to make flex runs

v2: Review comments from Jesper

CC: Jesper Dangaard Brouer <brouer@redhat.com>

Igor Russkikh (2):
  samples: pktgen: allow to specify delay parameter via new opt
  samples: pktgen: new append mode

 samples/pktgen/README.rst                     | 18 +++++++++++
 samples/pktgen/functions.sh                   |  7 ++++-
 samples/pktgen/parameters.sh                  | 15 ++++++++-
 .../pktgen_bench_xmit_mode_netif_receive.sh   |  3 --
 .../pktgen_bench_xmit_mode_queue_xmit.sh      |  3 --
 samples/pktgen/pktgen_sample01_simple.sh      | 25 ++++++++-------
 samples/pktgen/pktgen_sample02_multiqueue.sh  | 29 +++++++++--------
 .../pktgen_sample03_burst_single_flow.sh      | 15 ++++-----
 samples/pktgen/pktgen_sample04_many_flows.sh  | 17 +++++-----
 .../pktgen/pktgen_sample05_flow_per_thread.sh | 17 +++++-----
 ...sample06_numa_awared_queue_irq_affinity.sh | 31 ++++++++++---------
 11 files changed, 110 insertions(+), 70 deletions(-)

-- 
2.25.1

