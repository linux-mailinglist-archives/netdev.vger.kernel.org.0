Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794E7F44A7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbfKHKgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:36:00 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:14516 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731521AbfKHKgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 05:36:00 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8ARGTX030051;
        Fri, 8 Nov 2019 11:35:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=nTJBG22LeaDRqpzOs70JNI51jts39fxEqE5wUF9RG80=;
 b=nkjRKBcU1JqSCAll+smbcvx5JNV2WLP8aoWiNjPGEhB9tGWvJZybxnxQxUZLc7zABPkQ
 47Y+fmBhvQAFazRyd/Szzi6a4+BtOmWZaWZ4Ir7o763cHqcuDfq7wdNsIzzH6xJRQkzI
 imtResp59inWv0TeVJTLh+yWnF4X4cZwgmc0wImN24P+JbpvflKfLHpI/h6ljNvlir/y
 RInuUVqYAPu/mutt5vApPMumPzyIoZOoriBmLAuabBQjrflL0mhIPISmpWwNsnZA+x5a
 UaMdlSJIVkd0r9cNQ1fLgXp8A3S9uKdjbxs/c2URexbX5lqrKS3zKjVP7O3r8sKDfqK4 Jg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w41vmu288-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 11:35:31 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id A38B810002A;
        Fri,  8 Nov 2019 11:35:30 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 81CE32B0FED;
        Fri,  8 Nov 2019 11:35:30 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 8 Nov 2019
 11:35:30 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 8 Nov 2019 11:35:29
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
Subject: [PATCH  0/2] Convert stm32 dwmac to DT schema
Date:   Fri, 8 Nov 2019 11:35:24 +0100
Message-ID: <20191108103526.22254-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_02:2019-11-07,2019-11-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert stm32 dwmac to DT schema

Christophe Roullier (2):
  dt-bindings: net: dwmac: increase 'maxItems' for 'clocks',
    'clock-names' properties
  dt-bindings: net: dwmac: Convert stm32 dwmac to DT schema

 .../devicetree/bindings/net/snps,dwmac.yaml   |   8 +-
 .../devicetree/bindings/net/stm32-dwmac.txt   |  44 -----
 .../devicetree/bindings/net/stm32-dwmac.yaml  | 161 ++++++++++++++++++
 3 files changed, 168 insertions(+), 45 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.yaml

-- 
2.17.1

