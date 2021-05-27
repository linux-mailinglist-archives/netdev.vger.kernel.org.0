Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A185392B02
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 11:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbhE0JqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 05:46:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42360 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235891AbhE0JqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 05:46:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14R9f0pw001512;
        Thu, 27 May 2021 02:44:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=9PXqhRKYZ4uZ3n+M1Dk5X6DIHyKjvPjStZOLPOOvYR0=;
 b=UdLwM0rWIIlyIFkqSfi/1cVZKibl/nO5eBlZdoSmxQGIzMlwpiWt1sP6FLzeQFbNLe4D
 TKTmYn/9aFNaWt2trf7ucgwTrNkBs8CpSXA4WVnyC2zzN3j3WLDhKFKmqyOhwqoQe+X7
 1GYw9SveS8SKANk3wi77OHZjO+WWIAdKBlOJ9U+Ofbx0fZm/IwNaF0BroWs2CbvKcpWw
 fcWISOTMXe9+sCg9deLHlhrFINAWGx475Qmigs/yfhwjGgHqJnY5W7M+DU2kAV2z7tKF
 mkP9b1WNjgl1WarJIg9zuOxpb/b2dZZfUXTDrIXyW4iLBPtBE0viCd2dAPevp5Tlay71 Dg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38spf3c9fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 02:44:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 02:44:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 May 2021 02:44:42 -0700
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id B04623F7040;
        Thu, 27 May 2021 02:44:40 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <gcherian@marvell.com>,
        <sgoutham@marvell.com>
Subject: [net-next PATCHv3 0/5] NPC KPU updates
Date:   Thu, 27 May 2021 15:14:34 +0530
Message-ID: <20210527094439.1910013-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: uRkld3esgkR--QoaUt87VfuKXcMBDktb
X-Proofpoint-ORIG-GUID: uRkld3esgkR--QoaUt87VfuKXcMBDktb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_04:2021-05-26,2021-05-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for
 - Loading Custom KPU profile entries
 - Add NPC profile Load from System Firmware DB
 - Add Support fo Coalescing KPU profiles
 - General Updates/Fixes to default KPU profile

Changelog:
 v2->v3
 	Fix compilation warnings.

George Cherian (1):
  octeontx2-af: Update the default KPU profile and fixes

Harman Kalra (3):
  octeontx2-af: load NPC profile via firmware database
  octeontx2-af: adding new lt def registers support
  octeontx2-af: support for coalescing KPU profiles

Stanislaw Kardach (1):
  octeontx2-af: add support for custom KPU entries

 .../net/ethernet/marvell/octeontx2/af/npc.h   |  104 +-
 .../marvell/octeontx2/af/npc_profile.h        | 8673 ++++++++++-------
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |    6 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   34 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  298 +-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |    4 +-
 7 files changed, 5842 insertions(+), 3282 deletions(-)

-- 
2.25.1

