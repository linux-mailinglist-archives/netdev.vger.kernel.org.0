Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE1D43B29C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhJZMsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:48:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36016 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234908AbhJZMsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:48:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QAMYgO014652;
        Tue, 26 Oct 2021 05:45:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=F4OEXCVP0gdZ4FRVpkES0j7FmgoGou2hwIkEcHB6Z0M=;
 b=NXjCoaDV/TxRBE3pWgRj/xTJxoWXvir+7h82zVAlBudAV9rxuh09Dhm9IEIFONsF3gXb
 trKuYeuN22hugW3TIkecz4OFUlYukXIzpgLRAYclTrgCPQKmrfLhwK9G3MI4y5mY0hc/
 6tDd+Z6OqLg1PdruStigvlaZB1Fem4fN06XEDmOGwTvBdWuBJjT3Qs3rwncAlq/5+EAx
 dmuGUCFklz++/U8p4lrNs2NLfYWzMK+eQJcqDskg3PX+nz53VTXmWiPDZgc5pbMZ+v2u
 QQfUicEv9ZJX0VmflRb0r13UclJoD9n+eiZ1PTo7/lwPLkBCVnQg3yo480p70kTCm2SZ 6A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bxfv8gjw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 05:45:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 05:45:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 05:45:36 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 5EBEC3F7065;
        Tue, 26 Oct 2021 05:45:30 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC:     <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        "Rakesh Babu" <rsaladi2@marvell.com>
Subject: [net PATCH v2 0/2] RVU Debugfs fix updates.
Date:   Tue, 26 Oct 2021 18:15:23 +0530
Message-ID: <20211026124525.4396-1-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: VwCKrFt2SFLlG0mN1WcJ2ZxTdQoRf1OO
X-Proofpoint-ORIG-GUID: VwCKrFt2SFLlG0mN1WcJ2ZxTdQoRf1OO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_03,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch series consists of the patch fixes done over
rvu_debugfs.c file.

Patch 1: Check and return if ipolicers do not exists.
Patch 2: Fix rsrc_alloc to print all enabled PF/VF entries with list of LFs
allocated for each functional block.

Changes made from v1 to v2:
In patch 2 commit message "fixes" tag line is wrapped in v1. Unwrapped
such lines.

Rakesh Babu (1):
  octeontx2-af: Display all enabled PF VF rsrc_alloc entries.

Subbaraya Sundeep (1):
  octeontx2-af: Check whether ipolicers exists

 .../marvell/octeontx2/af/rvu_debugfs.c        | 146 ++++++++++++++----
 1 file changed, 114 insertions(+), 32 deletions(-)

--
2.17.1
