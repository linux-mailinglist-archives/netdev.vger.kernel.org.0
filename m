Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0160ECDF3F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfJGK0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:26:16 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:28440 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727252AbfJGK0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 06:26:15 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97AKd9X026094;
        Mon, 7 Oct 2019 12:25:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=H88ogHBdYtQHjzt8PI+xIbOfTqIYK6OWrNfyZ8b/qAQ=;
 b=XF8ipVvWR7wHVIQa/++Se+C0jwQK0IKDcwaKQVrQyX8bg6ccdzBfNMfpZOghZiHEDLST
 IdTLx7eNun+TCRkcAWdjKHoO9oMn6tSY/sv76KQGSVxVBnCR1JGxK029fsZvn7bfxRYE
 43u5jYwHnFR02DBkb8tc2oZTH8nqhpMZEcCr1a/S9xyUm2O9X32JWXL/0905WTUmuc84
 6B1HjmOQU1a8Ay+qrDvKOVhOTVxbxO8wEpaWgwxsL/yBsinOnVAfYz/pmWlh4xgREfwP
 4+n54iLjrQl8x+lA0c1I0Ia+60ZLBk6cBkY6qjozUK9vyIGow4i/gkdJTwotGmeY3LEd Jw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2vegxvhrn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 12:25:55 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 006FD100034;
        Mon,  7 Oct 2019 12:25:54 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id D8E782BFE0A;
        Mon,  7 Oct 2019 12:25:54 +0200 (CEST)
Received: from localhost (10.75.127.50) by SFHDAG3NODE2.st.com (10.75.127.8)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 7 Oct 2019 12:25:54
 +0200
From:   Alexandre Torgue <alexandre.torgue@st.com>
To:     Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC:     <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 0/3] Fixes for dt-bindings verification
Date:   Mon, 7 Oct 2019 12:25:49 +0200
Message-ID: <20191007102552.19808-1-alexandre.torgue@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG4NODE1.st.com (10.75.127.10) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_02:2019-10-07,2019-10-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using "make dt_binding_check" on top v5.4-rc1 some errors are 
reported in several schemas. Those 3 patches allow to execute
"make dt_binding_check" without issues. Most probably those patches
have alread been sent.

regards
Alexandre


Alexandre Torgue (3):
  dt-bindings: media: Fix id path for sun4i-a10-csi
  dt-bindings: net: adi: Fix yaml verification issue
  dt-bindings: regulator: Fix yaml verification for fixed-regulator
    schema

 .../bindings/media/allwinner,sun4i-a10-csi.yaml        |  2 +-
 Documentation/devicetree/bindings/net/adi,adin.yaml    |  6 ++++++
 .../devicetree/bindings/regulator/fixed-regulator.yaml | 10 +++++++---
 3 files changed, 14 insertions(+), 4 deletions(-)

-- 
2.17.1

