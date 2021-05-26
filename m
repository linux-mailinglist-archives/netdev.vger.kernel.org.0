Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193F8391C84
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbhEZP6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:58:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3228 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232769AbhEZP6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:58:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QFtBft003202;
        Wed, 26 May 2021 08:57:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=xvMoATson/9/jL9/umbFzvjnn+hxMohCdguAo0Q4hiU=;
 b=KW1jMgoN3tXk2FjyqwtopoyJ3Hdzgl5oonJH+hoMbXXJNe9POIDXn7hTo3eO0dgfQ2GY
 q1Kmq1vmpvYPJihiO2DG53jQSy5e6dzL4n+I7IgA/5C2/R+aIhu8uL7KEzR73qM+96Z4
 webzgcX1+moVJ3oXSLb8FAuLvAdr3JFB2L6VlWeQbBmLspGub+sPSOkLOUTTqKCjpwqC
 laOWrHmWw1Kvu0dUhSNDxmk7gV+OZ5saRVAYp/5rqP/E94Z0BOlJUQCZlFAjVn4F05KE
 P/93b/RD8i/QcmBHoFZlfcpQrwwujnU850uSAThLu8kWHVNj50HJ3t5+PO79bVjIjlVi iA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38spf38tn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 08:57:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 08:57:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 08:57:00 -0700
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 181F83F703F;
        Wed, 26 May 2021 08:56:57 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <gcherian@marvell.com>,
        <sgoutham@marvell.com>
Subject: [net-next PATCH 0/5] NPC KPU updates
Date:   Wed, 26 May 2021 21:26:51 +0530
Message-ID: <20210526155656.2689892-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 0wr2iZMWhx8iCeoNS6lPOahr_75k2snA
X-Proofpoint-ORIG-GUID: 0wr2iZMWhx8iCeoNS6lPOahr_75k2snA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_10:2021-05-26,2021-05-26 signatures=0
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
 .../marvell/octeontx2/af/npc_profile.h        | 8513 +++++++++++------
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |    6 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   34 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  294 +-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |    4 +-
 7 files changed, 5760 insertions(+), 3200 deletions(-)

-- 
2.25.1

