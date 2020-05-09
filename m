Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EF81CBE24
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgEIGrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:47:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41086 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725940AbgEIGrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:47:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0496kn5K028061;
        Fri, 8 May 2020 23:47:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=GLppoQbG/iVcW0QwSnNVMAOckA84tnhVQdqCcJAGDJo=;
 b=QT5MOw2vOITz6tGryiMg2zhaADgsZ8NKOWyNfuhsfh1aYI63cURxWxTqwGJHf67cqgDy
 l4rKFpOzAW4sKAYzrb9PSqgy2qvZ6d9nwRiTOAVMDyXM6XnDqA8vNcPMZJw+yuC54h1R
 5gWztD7ty8CHXa1wG2cAG0HWd59s26ZMNjiHgA4Jmvw4ZVPnMyFEMasnZ48yRlIjLEoo
 xkED7TpVQGd0DpG72NerNH/3jD9wJ4/F+HrLZhP+lbswQQmIFxDIWD7gYYhkYoLeKX+4
 OOhbq0qio3XDd103lIRgrSGADugtnnpH0V2OxdU6uAI3JL+pDFHDRxVxYkbE5rEF85XV Bw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30vtdkp38b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 23:47:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:47:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:47:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 23:47:19 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 0D1303F703F;
        Fri,  8 May 2020 23:47:08 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 net-next 0/7] net: atlantic: driver updates
Date:   Sat, 9 May 2020 09:46:53 +0300
Message-ID: <20200509064700.202-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_02:2020-05-08,2020-05-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch series contains several minor cleanups for the previously
submitted series.

We also add Marvell copyrights on newly touched files.

v2:
 * accommodated review comments related to the last patch in series
   (MAC generation)

v1: https://patchwork.ozlabs.org/cover/1285011/

Mark Starovoytov (7):
  net: atlantic: use __packed instead of the full expansion.
  net: atlantic: minor MACSec code cleanup
  net: atlantic: rename AQ_NIC_RATE_2GS to AQ_NIC_RATE_2G5
  net: atlantic: remove TPO2 check from A0 code
  net: atlantic: remove hw_atl_b0_hw_rss_set call from A2 code
  net: atlantic: remove check for boot code survivability before reset
    request
  net: atlantic: unify MAC generation

 .../ethernet/aquantia/atlantic/aq_common.h    | 11 +++---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 27 ++++++++++----
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      | 18 +++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 19 +++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |  9 +++--
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  9 ++---
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  9 ++---
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 35 ++++---------------
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  4 +--
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.c |  8 -----
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h |  4 +--
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 25 ++-----------
 .../aquantia/atlantic/macsec/macsec_api.c     |  6 ++--
 14 files changed, 77 insertions(+), 109 deletions(-)

-- 
2.20.1

