Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9F9B119A75
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLJV4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:56:30 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17062 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726417AbfLJV4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:56:30 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBALtoMb007947;
        Tue, 10 Dec 2019 13:56:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=JsNH/Vk5GBrtsl650dNTIOusVAnzS/EvlfU2rBGN5NM=;
 b=EHJcEGOehakLlUdIJhcFUFRDBJhFTH0IS1/ZYCKPiHuotAFMhXFLovuTQasbO9ML3+qA
 fGO/Qc7TrALKsLgcFAF+QiAZcQiGmjivVshsBsMdI+/0C7VtsKG6MqhX+Fe/RE/ndzBH
 esAzmRkSKrgglkwGclQwpo+thQuzJaOO412SYrH+aqEZQmZ5pFj31bOMY7PHhiVrmLjd
 2brgZL0HjXUxRMATyh1AM6koX1yzmV0y9xdqwF7Dkog3u3tvtod+UyUf2T0zBPVJ4AKT
 iZtNP5mZ9dDjmjfTc1EojVYW7KsMAG6bc6IpAvi/2aAnufsqCthykmMy9cvXXadCS7jR zw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wst5swys9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 13:56:27 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 10 Dec
 2019 13:56:26 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 10 Dec 2019 13:56:26 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D28B13F7043;
        Tue, 10 Dec 2019 13:56:25 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBALuPi3023987;
        Tue, 10 Dec 2019 13:56:25 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBALuPXP023986;
        Tue, 10 Dec 2019 13:56:25 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 0/2] bnx2x: bug fixes
Date:   Tue, 10 Dec 2019 13:56:21 -0800
Message-ID: <20191210215623.23950-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_07:2019-12-10,2019-12-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This series has two driver changes, one to fix some unexpected
hardware behaviour casued during the parity error recovery in
presence of SR-IOV VFs and another one related for fixing resource
management in the driver among the PFs configured on an engine.

Please consider applying it to "net".

Thanks,
Manish

Manish Chopra (2):
  bnx2x: Do not handle requests from VFs after parity
  bnx2x: Fix logic to get total no. of PFs per engine

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 11 +++++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  | 12 ++++++++++++
 4 files changed, 23 insertions(+), 3 deletions(-)

-- 
2.18.1

