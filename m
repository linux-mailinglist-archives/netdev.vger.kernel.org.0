Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46056131160
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 12:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgAFLXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 06:23:01 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44588 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgAFLXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 06:23:00 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 006BEacg018350;
        Mon, 6 Jan 2020 03:22:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=KVP3ffEv7I39vx3d6GvWTmsdRjszfXF5rVBz0R/EvPU=;
 b=IuSEnw1JuA60mDuyAmBKw4bHhGCI2e/hqBPVy8CHgH1G3viJZa7j986KWyCCmqJQmqeR
 QcjE+Euh/qlOxOG3ujYjSTs5nEHKLG9eP9HsMIMtjEXbfibTQeLa0EG+6ubFRwEba+tx
 KcBDCFkNCwowvFGKN7t16EUii5bjNioKKOGF86ix8TKzuXFp1nZO49SNhpCM0Az1yiHf
 bEl8b+gEqWchemDr786nOyN8q1B/ZMvyHwZvWbgRwIXMf64eU7l+7/PM6ewR7BVYs5dl
 CDSpq/viZt3CmT5rFgGvs7yCU95fN5JvKl1qgQSAXJ6IEWy8ddM102e1lpyXTPmE8oHU Ag== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xau3sn4a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jan 2020 03:22:58 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jan
 2020 03:22:56 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jan 2020 03:22:56 -0800
Received: from NN-LT0019.marvell.com (unknown [10.9.16.57])
        by maili.marvell.com (Postfix) with ESMTP id A60D93F704A;
        Mon,  6 Jan 2020 03:22:55 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net 0/3] Aquantia/Marvell atlantic bugfixes 2020/01
Date:   Mon, 6 Jan 2020 14:22:27 +0300
Message-ID: <cover.1578059294.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.24.1.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-06_04:2020-01-06,2020-01-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Here is a set of recently discovered bugfixes,

Please integrate, thanks!

Igor Russkikh (3):
  net: atlantic: broken link status on old fw
  net: atlantic: loopback configuration in improper place
  net: atlantic: remove duplicate entries

 drivers/net/ethernet/aquantia/atlantic/aq_nic.c              | 4 ++--
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c    | 3 ---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c | 4 +---
 3 files changed, 3 insertions(+), 8 deletions(-)

-- 
2.20.1

