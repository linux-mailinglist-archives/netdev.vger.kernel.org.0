Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A6343CFC8
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239815AbhJ0Rfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:35:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21764 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229612AbhJ0Rfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:35:42 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RFH2wm032380;
        Wed, 27 Oct 2021 10:33:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=yPBv08k3uR/dsj97LBJ/WfGfp4/U/wI9KQBCFFLw5f8=;
 b=CG4FYtpJm10fI82p82c6Dtx5e2qhBrQXwjlBmU+z7HXYr6y7Qo40C4a9SDXD8D0lXr3W
 mgwemgyCgghjIwbSRqkD1nJkeRu5CnP1en2nVcDlvZRiM2cIukzvWRll0Ebmk+MDlzJG
 YguDIOlt40DvS14ixu/2jWyFN8sKR7o0E8q4amrLn6g+SZdIXWvUnAYwuGq3NFRadwaj
 PMGbYj3Z3kGkipKD6+7YH5wMaq48qcx05KwkmedEmFgfRz5WrTFaXyr3is3lvvb4F75z
 TNPi8nPA/7K9cRz81kwCsqEf5jHKswKHJNU5+6Nd+OoN+7WKJOdQYFH7mOWVVwFMb3We fg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1caapt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:33:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 10:33:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 10:33:11 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id BFFA53F709F;
        Wed, 27 Oct 2021 10:33:05 -0700 (PDT)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>
Subject: [net PATCH v3 0/3] RVU Debugfs fix updates.
Date:   Wed, 27 Oct 2021 23:02:31 +0530
Message-ID: <20211027173234.23559-1-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: hmYWo3kJk0-Cam54Sl21dCnOF5_KpV1n
X-Proofpoint-ORIG-GUID: hmYWo3kJk0-Cam54Sl21dCnOF5_KpV1n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_05,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch series consists of the patch fixes done over
rvu_debugfs.c and rvu_nix.c files.

Patch 1: Check and return if ipolicers do not exists.
Patch 2: Fix rsrc_alloc to print all enabled PF/VF entries with list of LFs
allocated for each functional block.
Patch 3: Fix possible null pointer dereference.

Changes made from v2 to v3:
Included a new patch in this series which fixes null pointer dereference.

Rakesh Babu (1):
  octeontx2-af: Display all enabled PF VF rsrc_alloc entries.

Rakesh Babu Saladi (1):
  octeontx2-af: Fix possible null pointer dereference.

Subbaraya Sundeep (1):
  octeontx2-af: Check whether ipolicers exists

 .../marvell/octeontx2/af/rvu_debugfs.c        | 148 ++++++++++++++----
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   3 +
 2 files changed, 118 insertions(+), 33 deletions(-)

--
2.17.1
