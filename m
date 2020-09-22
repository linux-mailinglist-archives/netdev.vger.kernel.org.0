Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DEB2742A6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgIVNHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:07:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40734 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbgIVNHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:07:39 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08MD6RFQ021909;
        Tue, 22 Sep 2020 06:07:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=RkFgvU4FnBJacFhRae2BQpZC3S9+grhDJkyO5+PHOjs=;
 b=Aw/BuzaZC/cfPj5hY2bZct4kfetNkuEtZx+AH27/R0HLzSiaTQFfRpOPH1W/Kvm/T4vH
 /SBy86edgA62uOv1MQugbq3S1XH0Io9rZBbBniJmy2aPSQSligcMWlKSXoWlwsLl9r14
 uckkgHiaBRFqFxwUx1KsncKGLQ2RTU8msN1yEBevT+Aw3Kt/f7DxqFTfyVhS6TWzRJT1
 L7wLZvpWuOiYuXSD5JwNaJFNtGl7NE5f05/B2PrkE328LY6uNmAVUdRjpVbL/Q5iWAtK
 qTufmR1AyG4W0inuf72U7t20AM3MmsbxAJrYJA9PrhiqSZPKUqDDrLD2l98VL3RznMoU SQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgna5d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 06:07:38 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Sep
 2020 06:07:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Sep 2020 06:07:36 -0700
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 4BE503F703F;
        Tue, 22 Sep 2020 06:07:35 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     George Cherian <george.cherian@marvell.com>
Subject: [net-next PATCH 0/2] Add support for VLAN based flow distribution
Date:   Tue, 22 Sep 2020 18:37:25 +0530
Message-ID: <20200922130727.2350661-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_12:2020-09-21,2020-09-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add support for VLAN based flow distribution for octeontx2
netdev driver. This adds support for configuring the same via ethtool.

Following tests have been done.
	- Multi VLAN flow with same SD
	- Multi VLAN flow with same SDFN
	- Single VLAN flow with multi SD
	- Single VLAN flow with multi SDFN
All tests done for udp/tcp both v4 and v6


George Cherian (2):
  octeontx2-af: Add support for VLAN based RSS hashing
  octeontx2-pf: Support to change VLAN based RSS hash options via
    ethtool

 drivers/net/ethernet/marvell/octeontx2/af/mbox.h       |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 10 +++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c   |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  7 +++++++
 4 files changed, 18 insertions(+), 2 deletions(-)

-- 
2.25.1

