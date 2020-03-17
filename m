Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA501888EE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgCQPRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:17:52 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:32520 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726388AbgCQPRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:17:51 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02HFDLIT001980;
        Tue, 17 Mar 2020 16:17:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=k0ZMfP7aKLkzfzu3eH2J4VQnqrCYW3x7HRTJSMhhAes=;
 b=yAtDccBGIxfisii37vFQGuMhAub3J1lz8e6Z/NwU5mFZAyoUv8F5N3xBvi8zo6U+87pI
 35w8/n5f0njv83PGrDCY1bI5X4Y1G38LhievMBHKob+WoVmQFsgAFNWuTYRY7O2AcCCS
 NZliLMW5NC8b23P6dWlTEzB7hnWhy6B11sE/eP9y5OJjHCzZgw8PAMVEKpZ/jucMs1qv
 2nROyZOWPL9EbqNGq+XjbiMjGxkh1Fj5YMouTZ0vy/rEsxM3iUFsOVPnnsxVGlGJ58pY
 78I7chAfQKIECLj3AmUITdvonMVbXSQSGE626qa5vDtygo5MLPJ/wNhnWnQCRkAHU9n/ RQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2yrqa9s1vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Mar 2020 16:17:24 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B0151100038;
        Tue, 17 Mar 2020 16:17:14 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 8A84D2BC7AF;
        Tue, 17 Mar 2020 16:17:14 +0100 (CET)
Received: from localhost (10.75.127.46) by SFHDAG5NODE3.st.com (10.75.127.15)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Mar 2020 16:17:13
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <mripard@kernel.org>,
        <martin.blumenstingl@googlemail.com>,
        <alexandru.ardelean@analog.com>, <narmstrong@baylibre.com>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv2 0/2] Convert stm32 dwmac to DT schema
Date:   Tue, 17 Mar 2020 16:17:04 +0100
Message-ID: <20200317151706.25810-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG7NODE3.st.com (10.75.127.21) To SFHDAG5NODE3.st.com
 (10.75.127.15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_06:2020-03-17,2020-03-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert stm32 dwmac to DT schema

Christophe Roullier (2):
  dt-bindings: net: dwmac: increase 'maxItems' for 'clocks',
    'clock-names' properties
  dt-bindings: net: dwmac: Convert stm32 dwmac to DT schema

v1->v2:
update from Rob (solve checkpatch errors with trailing WS,
rename "Example", Wrap lines)

 .../devicetree/bindings/net/snps,dwmac.yaml   |   8 +-
 .../devicetree/bindings/net/stm32-dwmac.txt   |  44 -----
 .../devicetree/bindings/net/stm32-dwmac.yaml  | 160 ++++++++++++++++++
 3 files changed, 167 insertions(+), 45 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.yaml

-- 
2.17.1

