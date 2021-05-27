Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B612F39255F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 05:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhE0D0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 23:26:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61754 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233542AbhE0D0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 23:26:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14R3OvhS015435;
        Wed, 26 May 2021 20:24:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=V3AKUgEip2dGz1A7n15Ax1SlvshrVe4qk4Siw6WKtpA=;
 b=EuLh/3Qn6GXM5k0TJMHVjCVZjtD8p37saFI9w5SoOWtCg1p2q7CTCgXyWuGZ1fGk7sjA
 qJGuPJf19FJcL7waO0CeGGiYb2SfjuOhc9ZXPtPXZBf8a3mKlperEv6ldsKlapasJCnL
 aoi93II3JpdIL96SFA9K6W7TQ3llbfnf1aGKpqvDtUbA13PRRBaPHyAgF5oPPaDmPMJV
 W3tMS2pyAVDNY4q5I2U9y7OBNlqV61WtPTTX/1k7svlNO/iPy/6/6yDh45dK381WKTZ8
 763fLFFgbKyn2xcGTYhxz2hYWFNqiNZo5nUQ0L0WWzoE8pmHa+KwDdKGCubk/jhxm1BS Fg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38spf3b38w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 20:24:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 20:24:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 20:24:47 -0700
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 25AFF3F703F;
        Wed, 26 May 2021 20:24:44 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <gcherian@marvell.com>,
        <sgoutham@marvell.com>
Subject: [net-next PATCHv2 0/5] NPC KPU updates
Date:   Thu, 27 May 2021 08:54:39 +0530
Message-ID: <20210527032444.3204054-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: i3N1i53fDO7bHzS0-yDb9U6Yz-ioxDgL
X-Proofpoint-ORIG-GUID: i3N1i53fDO7bHzS0-yDb9U6Yz-ioxDgL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_01:2021-05-26,2021-05-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for
 - Loading Custom KPU profile entries
 - Add NPC profile Load from System Firmware DB
 - Add Support fo Coalescing KPU profiles
 - General Updates/Fixes to default KPU profile

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
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  294 +-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |    4 +-
 7 files changed, 5840 insertions(+), 3280 deletions(-)

-- 
2.25.1

