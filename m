Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85181299D0
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLWSXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:23:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36412 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726766AbfLWSXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:23:21 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNIKrmn017918;
        Mon, 23 Dec 2019 10:23:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=5lhcps3lzSsb4JVLAe71yjQ+ZwnJLgmCrwxrtXaVhuY=;
 b=FWFpR0dAx8HI3K+PVXUd53cygeebVQUsPqehVALot4bd40Rwg90TgZ9S3/FlAlFwO7nA
 bwKLmseiSe2Hy/SYXV41dLJSmmJfIq1LkE7CIdy6scW/3XYRhpj7D4/TivMLKnkP4FHR
 z4HLxmyS7zoKDX1OrJ+q0YuZuMntflF2NZaSAREaIWs54rpEST93LYVArjb8y9P7115/
 aVa4cNA+wp5Gpr1CGEf9AaiT1R7UsRP5ppGriBdqTJwEROkB+vUxU2IRSCTCYaCT3fDA
 b7crpENdU94AyGlh0OULk+205tdFCB+gG0Uj+9AGeLuw17crWmfHewcBn3FwWjToYUlh cw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2x1kssdmr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Dec 2019 10:23:18 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Dec
 2019 10:23:16 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Dec 2019 10:23:16 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E81F83F7041;
        Mon, 23 Dec 2019 10:23:16 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBNINGSk003956;
        Mon, 23 Dec 2019 10:23:16 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBNINGPF003955;
        Mon, 23 Dec 2019 10:23:16 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 0/2] bnx2x: Bug fixes
Date:   Mon, 23 Dec 2019 10:23:07 -0800
Message-ID: <20191223182309.3919-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_07:2019-12-23,2019-12-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This series has changes in the area of vlan resources
management APIs to fix fw assert issue reported in max
vlan configuration testing over the PF.

Please consider applying it to "net"

Manish Chopra (2):
  bnx2x: Use appropriate define for vlan credit
  bnx2x: Fix accounting of vlan resources among the PFs

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.18.1

