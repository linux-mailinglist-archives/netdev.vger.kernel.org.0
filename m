Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0997C443AA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392556AbfFMQbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:31:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36944 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730897AbfFMIbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:31:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D8U9Vm014483;
        Thu, 13 Jun 2019 01:31:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=z5y/xsVq0zEOaQ5uY2Da80TAkeePt4OnGH08z2DjssQ=;
 b=DGxdcwo6Q77TwPZmBZjUEohZ/iEvbMXgjj4rupD6ohwXfHt4c6SKF+jVIYl3XRayvhuD
 sTpsqDQzZlfYpcBofI7y8i6mVEtYdizMgHeWH+ZFEiQN5nsS2I9VwFik1XZjUR+UXXKC
 TA9yLKjEVbbz7LAmz67NeV0oy/DId2dLQjCtnpa5fcq90kg/IciRJEgmfUxyEpbXtyTf
 jTdzMUQHdzyGB0AYCDCMTBrkiQStgHC4HgV91M3d+POLIsow2/eD7BafcVpMrFg9V8Ic
 i1K5pA+SFh1Ilgm8LRlQ10o++OL9suUFFkZIcb/+x+UUr9sSf/yxgYmNobI/J79ekU77 4Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2t3j8205q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 01:31:04 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 13 Jun
 2019 01:31:03 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 13 Jun 2019 01:31:03 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 3D39B3F7044;
        Thu, 13 Jun 2019 01:31:02 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/4] qed: iWARP fixes
Date:   Thu, 13 Jun 2019 11:29:39 +0300
Message-ID: <20190613082943.5859-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a few small fixes related to iWARP.


Michal Kalderon (4):
  qed: iWARP - Use READ_ONCE and smp_store_release to access ep->state
  qed: iWARP - fix uninitialized callback
  qed: iWARP - Fix tc for MPA ll2 connection
  qed: iWARP - Fix default window size to be based on chip

 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 49 +++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 10 deletions(-)

-- 
2.14.5

