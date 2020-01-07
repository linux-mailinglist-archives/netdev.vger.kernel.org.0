Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC521323D2
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 11:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgAGKjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 05:39:09 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:33952 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727861AbgAGKjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 05:39:08 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B3FCC4064E;
        Tue,  7 Jan 2020 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578393548; bh=8ebY43sEqsPi9vuO9uvvE6clQNPWn1m8uaijybDWhlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=BlKiC61+/3wHd6sDHKzRECoAPKXBbmk4ns40/KjZh5c+ghgv2mKqNWdIYoclPyejA
         S2/Tcv+GOCRr9x7g7ebT4qGYgnXFEguQ690OS0to9m3Eg8LWEO635hGFjkzBFDvqGv
         Tr7UfqkMPXBHn/EJfkcfjwGYMsxCN5y0odrbxH8J5ylQmzpUzjnEn2EvQTjDPCSFHm
         8e/6UUMeY//NBDAqUwzbn/FqnaDwa6bNKbY3bCI1WEFd8MClMI1KCye6TZeTSpIZUU
         zAg/8SgRdDhf2+EkGJCMXrrt9uMw7O28Moq6y89GY5H3XPZmG6L4hMofpRaUrN8PNh
         xmAADlUm/EU+Q==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 50DB8A0062;
        Tue,  7 Jan 2020 10:39:06 +0000 (UTC)
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
Subject: [PATCH net-next 1/3] MAINTAINERS: Add stmmac Ethernet driver documentation entry
Date:   Tue,  7 Jan 2020 11:37:18 +0100
Message-Id: <68dea4828bf6326be6ca4ecae07c32f9ba682faa.1578392890.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578392890.git.Jose.Abreu@synopsys.com>
References: <cover.1578392890.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578392890.git.Jose.Abreu@synopsys.com>
References: <cover.1578392890.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing entry for the file that documents the stmicro Ethernet
driver stmmac.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

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
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 34de47832883..66a2e5e07117 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15777,6 +15777,7 @@ M:	Jose Abreu <joabreu@synopsys.com>
 L:	netdev@vger.kernel.org
 W:	http://www.stlinux.com
 S:	Supported
+F:	Documentation/networking/device_drivers/stmicro/
 F:	drivers/net/ethernet/stmicro/stmmac/
 
 SUN3/3X
-- 
2.7.4

