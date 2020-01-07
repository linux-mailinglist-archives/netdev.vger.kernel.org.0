Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE231323DD
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 11:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgAGKjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 05:39:08 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:33936 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbgAGKjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 05:39:08 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C605340654;
        Tue,  7 Jan 2020 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578393548; bh=A+ywmO99yzrq2CMIo8Wi3yih5b1nyenwQVJiw0NnKdI=;
        h=From:To:Cc:Subject:Date:From;
        b=VTZpdd+yfmuEzd2EtgkFSoef26hNiUXD5Hn7RxAeBdvKLvkj2TDOk1q6kiFNLn50v
         k80aJHAVq7JLCx8HbrOqIu/NhU0xsHGrXC1fre/YysZ5RWHeyvPhnj/q2FBUAdFuGs
         5aWdajqRvOE1R3YYw8ExZZ3aZmQQbp9AN4R0/ZaLsAF0ug6AZIdFxowEg0y+35eFzt
         TXXcd9yVI29B2BlWklOU+XCfYuHNqs7+Wv5oXEa7MFQ7oxnvud06fzf7ySviEWhnzD
         J5q0oNWi5U9sCruaxLuhDXkE5Ke11ZC5nvXZRmjNAvpz5ek7YIEGW2c1QzhlavRjrM
         minxQRGhqcOcA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A6B26A005C;
        Tue,  7 Jan 2020 10:39:05 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-doc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] Documentation: stmmac documentation improvements
Date:   Tue,  7 Jan 2020 11:37:17 +0100
Message-Id: <cover.1578392890.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Not sure if this should go for net-next or Documentation tree. ]

Converts stmmac documentation to RST format.

1) Adds missing entry of stmmac documentation to MAINTAINERS.

2) Converts stmmac documentation to RST format and adds some new info.

3) Adds the new RST file to the list of files.

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (3):
  MAINTAINERS: Add stmmac Ethernet driver documentation entry
  Documentation: networking: Convert stmmac documentation to RST format
  Documentation: networking: Add stmmac to device drivers list

 Documentation/networking/device_drivers/index.rst  |   1 +
 .../networking/device_drivers/stmicro/stmmac.rst   | 697 +++++++++++++++++++++
 .../networking/device_drivers/stmicro/stmmac.txt   | 401 ------------
 MAINTAINERS                                        |   1 +
 4 files changed, 699 insertions(+), 401 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/stmicro/stmmac.rst
 delete mode 100644 Documentation/networking/device_drivers/stmicro/stmmac.txt

-- 
2.7.4

