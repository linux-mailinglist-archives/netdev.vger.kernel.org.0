Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E15F1BA0AE
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgD0KBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:01:07 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57970 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726243AbgD0KBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:01:07 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03R9w61t018343;
        Mon, 27 Apr 2020 12:00:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=vRrhq9Wy/QYvVJWvXZIasd5JyX/yiLS74yAccMkmaf0=;
 b=UQg6by3AJhirVkC+Z222kbrTa95g0DgcJkkMATJNElRc+Hmh+cRaqq8AMKrpnOxkBC++
 sS1eEmku4dxKXc3AnSXR6iViTqOX23WNtTKfWmJ4NM1BA7n4FIrFE1RD/tmtWdgTeNgz
 m7izw5ADzdpvxyX0R+F2xuS7XWACBF8F6gXhKOkVs+uzhh+jYb87DGG83IkY3CTkjIFX
 DdZQwr0yV31Z9UcQyjafufqRWpK2g6IX0oh8D11KWAyich5XoDJKTNSE5cTV0M7nSfFx
 E538B1GN5v98+BmBMo4wrZo9Q0o6ZYMunxh28hm+Fzcnm3L+EsIWGp6CMZTWdVdTiiA4 9Q== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30mhjwh4u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 12:00:46 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 55CC9100038;
        Mon, 27 Apr 2020 12:00:44 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 354902B8A30;
        Mon, 27 Apr 2020 12:00:44 +0200 (CEST)
Received: from localhost (10.75.127.45) by SFHDAG5NODE3.st.com (10.75.127.15)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 27 Apr 2020 12:00:43
 +0200
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH v3 0/1] net: ethernet: stmmac: simplify phy modes management for stm32
Date:   Mon, 27 Apr 2020 12:00:37 +0200
Message-ID: <20200427100038.19252-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.45]
X-ClientProxiedBy: SFHDAG3NODE1.st.com (10.75.127.7) To SFHDAG5NODE3.st.com
 (10.75.127.15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_05:2020-04-24,2020-04-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No new feature, just to simplify stm32 part to be easier to use.
Add by default all Ethernet clocks in DT, and activate or not in function
of phy mode, clock frequency, if property "st,ext-phyclk" is set or not.
Keep backward compatibility

version 3:
Add acked from Alexandre Torgue
Rebased on top of v5.7-rc2

Christophe Roullier (1):
  net: ethernet: stmmac: simplify phy modes management for stm32

 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 74 +++++++++++--------
 1 file changed, 44 insertions(+), 30 deletions(-)

-- 
2.17.1

