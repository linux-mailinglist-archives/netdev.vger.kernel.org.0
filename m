Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB65439ED9
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhJYTDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:03:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35986 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233804AbhJYTDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:03:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PIVBbq001248;
        Mon, 25 Oct 2021 12:01:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=skPOw8PuxIdPlr/lKMaOSrEMyf2mnE5f/7xA+QVju1U=;
 b=kwZUNTULXaUcJBdqhC+3xY0khXSMA0eK2MQmwtDKVuOcLNXovD4ATeYAO/TOPiOIyaEd
 O/uOX0aBkXZJn1rUZRtmXMIv1NLw9PbYgbCb2vYK6wd3Bf1a8Rb9GO9RscOv4RxYnU69
 REJ09YzzVr0F1d9wFgZr4165UNen8LjLFf2xysCPIHAoCq+jeCMLnSby+KEx5CGWp2Qw
 BnuJYaMjp9uDEneuYu1xk2nDptQmWijG3SUNBmP+M9vRKahyf9gUMGR+ynuMgkQh89ah
 4VEvElfzczF4nIrP39vb6yyDzk+bVxsA3Cpl8tXtnqoTIy6IEpBvasLw03XBHOvHgT4X /A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bwtjrj6wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 12:01:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 25 Oct
 2021 12:01:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 25 Oct 2021 12:01:08 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 135633F70AF;
        Mon, 25 Oct 2021 12:01:05 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
CC:     Rakesh Babu <rsaladi2@marvell.com>
Subject: [net PATCH 0/2] RVU Debugfs fix updates.
Date:   Tue, 26 Oct 2021 00:30:43 +0530
Message-ID: <20211025190045.7462-1-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: i4JhMmAjwA1JaID_Dt-zCWMLPnKd5kf4
X-Proofpoint-GUID: i4JhMmAjwA1JaID_Dt-zCWMLPnKd5kf4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch series consists of the patch fixes done over
rvu_debugfs.c file.

Patch 1: Check and return if ipolicers do not exists.
Patch 2: Fix rsrc_alloc to print all enabled PF/VF entries with list of LFs
allocated for each functional block.

Rakesh Babu (1):
  octeontx2-af: Display all enabled PF VF rsrc_alloc entries.

Subbaraya Sundeep (1):
  octeontx2-af: Check whether ipolicers exists

 .../marvell/octeontx2/af/rvu_debugfs.c        | 146 ++++++++++++++----
 1 file changed, 114 insertions(+), 32 deletions(-)

--
2.17.1
