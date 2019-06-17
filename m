Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E9847D93
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfFQIuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:50:55 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:49244 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727549AbfFQIuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 04:50:55 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5H8kHSM013185;
        Mon, 17 Jun 2019 10:50:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=bC3LMa6griAbLsTsO7rZBdQI82fOLOouwCRCKGb6yWo=;
 b=0P2hgw7OSO+g2l9FRr/NH2Yp8meYJ17F6ZcwlInHSTOoAfRvYU1Xck2l3/C2A96grbgj
 Z9GWXQ4v3zQoRh6lXSi158kURnAI2RkJs7+q4wpbU3OnLw3NZTCzcqgAeuxPmGwK8Cqd
 R3zw9q0Vx2H+EO4RqTdfgBe67ysv//oub115SADAv9rhORW336Z+vl4f6W8Yxwi3p7wg
 b/VdNAj+FQ8XNTCI6yGcv+Gibx6lwJj9c23v9e/PSzPHY3AyyoPnERbkX2r9wEnJ5oS2
 qD18jiheP6fhEbvuMoQ4cISZubvejd0kCJ7VNCL9u0ZQnhpQZiRoKxTmK1aMIGvDjyDl 3A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2t4qjhsexj-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 17 Jun 2019 10:50:33 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 39F8B31;
        Mon, 17 Jun 2019 08:50:31 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 12DF7244F;
        Mon, 17 Jun 2019 08:50:31 +0000 (GMT)
Received: from SAFEX1HUBCAS24.st.com (10.75.90.95) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 17 Jun
 2019 10:50:30 +0200
Received: from localhost (10.201.22.222) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 17 Jun 2019 10:50:30
 +0200
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH  0/1] ARM: dts: stm32: replace rgmii mode with rgmii-id on stm32mp15 boards
Date:   Mon, 17 Jun 2019 10:50:17 +0200
Message-ID: <20190617085018.20352-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On disco and eval board, Tx and Rx delay are applied (pull-up of 4.7k
put on VDD) so which correspond to RGMII-ID mode with internal RX and TX
delays provided by the PHY, the MAC should not add the RX or TX delays
in this case

Christophe Roullier (1):
  ARM: dts: stm32: replace rgmii mode with rgmii-id on stm32mp15 boards

 arch/arm/boot/dts/stm32mp157a-dk1.dts | 2 +-
 arch/arm/boot/dts/stm32mp157c-ev1.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.17.1

