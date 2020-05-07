Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD0B1C8486
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgEGIPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:15:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8324 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726235AbgEGIP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 04:15:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0478AhMH019767;
        Thu, 7 May 2020 01:15:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=Uo/ljGH8JpHJFaPOKvwIqlvkqYoRW2qcK1mk0/eSXIM=;
 b=ih8fhFI9XCH52bzMyCBiX5Ba4on4N/V5f580653E242D2IFAaHbE/qTh6x8qFBcI0hc4
 msbjr/lkvtun1e6pLFIX1KDU9cEpYPWZCNlalFBxwB5BUKQW6AKuak148sqawqi/mq1g
 MKZg/x/kmpS/Bv/fno2JkjErInliOGR1cW0wwladc7TWTGst41VWPPRVpEFkm7KiGtfp
 LwfeJs9VoVxkImnWb4dbiYBQ+9WNbN0TfRazOsKhlC62tDT2OZcwjl46pQr1K9DrOYXy
 dbgiS2ynqjeuN7o71js3EwHtYT3Ykhy1XkQzZ2vHYVdLBbDxHtTRHeBQ4nnnBtV3+2xJ BQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaum1aqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 01:15:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 May 2020 01:15:25 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id C62963F7041;
        Thu,  7 May 2020 01:15:23 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: [PATCH net-next 0/7] net: atlantic: driver updates
Date:   Thu, 7 May 2020 11:15:03 +0300
Message-ID: <20200507081510.2120-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_04:2020-05-05,2020-05-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch series contains several minor cleanups for the previously
submitted series.

We also add Marvell copyrights on newly touched files.

Mark Starovoytov (7):
  net: atlantic: use __packed instead of the full expansion.
  net: atlantic: minor MACSec code cleanup
  net: atlantic: rename AQ_NIC_RATE_2GS to AQ_NIC_RATE_2G5
  net: atlantic: remove TPO2 check from A0 code
  net: atlantic: remove hw_atl_b0_hw_rss_set call from A2 code
  net: atlantic: remove check for boot code survivability before reset
    request
  net: atlantic: unify get_mac_permanent

 .../ethernet/aquantia/atlantic/aq_common.h    | 11 ++---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  2 +-
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  | 41 +++++++++++++++++--
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |  9 ++--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 13 +++---
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      | 18 ++++----
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 19 +++++----
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |  9 ++--
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  9 ++--
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  9 ++--
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 36 ++++------------
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  4 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.c |  8 ----
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h |  4 +-
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 26 ++----------
 .../aquantia/atlantic/macsec/macsec_api.c     |  6 +--
 16 files changed, 111 insertions(+), 113 deletions(-)

-- 
2.20.1

