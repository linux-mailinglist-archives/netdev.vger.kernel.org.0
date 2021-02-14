Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C177D31B090
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 14:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBNNk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 08:40:29 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47444 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229576AbhBNNk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 08:40:28 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11EDaQEd025796;
        Sun, 14 Feb 2021 05:39:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=9rygOEDwUinFscxohl3+DEuEu378ZRSpxJPmQrEmgPU=;
 b=NjcStdS91MKDfepPkLDNxQBsINAmmzDaom76br7CSsdUT9Rbb+aa61F8wYIvk/6KDvpd
 3DmLKUPq7411dgPyUbUAMcgnPKMa+sd0myCs+rBZJstILQRjExMyJFgoCRqdkeNojXMO
 Gg4+83kJPcYDzc9lOmplKPnEQDMfyNQZJGIRFmJqQ70vLlKCelIHvW/jSs1UniofbsF7
 SudiGeFRzUqrF6NFUuWpMhiHR9yt3NfqfUgbp9t+MFH7RS68hnc+pC8zAaDpE6xT60co
 qexwia4es47op7H2Ai3VJTnG7iF2dbLff5OB5yfwWtobn9KB09qsBL4l8LHFowqfR6Sp oQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vhyx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 14 Feb 2021 05:39:35 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 05:39:34 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 14 Feb 2021 05:39:34 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 8ABF83F703F;
        Sun, 14 Feb 2021 05:39:31 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [net-next 0/4] net: mvpp2: Minor non functional driver code improvements
Date:   Sun, 14 Feb 2021 15:38:33 +0200
Message-ID: <1613309917-17569-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-14_03:2021-02-12,2021-02-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

The patch series contains minor code improvements and did not change any functionality.

Stefan Chulski (4):
  net: mvpp2: simplify PPv2 version ID read
  net: mvpp2: improve Packet Processor version check
  net: mvpp2: improve mvpp2_get_sram return
  net: mvpp2: improve Networking Complex Control register naming

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  6 +--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 52 +++++++++-----------
 2 files changed, 27 insertions(+), 31 deletions(-)

-- 
1.9.1

