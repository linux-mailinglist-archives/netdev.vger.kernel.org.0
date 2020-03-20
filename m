Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DACD18CAE1
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgCTJxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:53:53 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42770 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726602AbgCTJxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:53:52 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id ACFF1C0F90;
        Fri, 20 Mar 2020 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584698031; bh=Iukq6WuoUVLoUcaK3eRq2H2/jc1iVUoBjvWnbKEYOt0=;
        h=From:To:Cc:Subject:Date:From;
        b=AxTAIJ8pEaPkEb+SNiR8hA9LUqZ/S+rlVVLQ5QpQSits94daVGK8oHaQJZA3t2fnv
         3wBKqdJgFslChM547SFmxEZwdsUj7KUSsKKEBztzpjCK/KEd984hOIXNY+DMzFgwHA
         nu94AnlnqdBHqETMpWOls+6XdUgSyvV70QIznBnLADEkUnE5NborqvQdLb8dM/pCFx
         PFGUrOoQdjmbIo6VJ+PUX9YMwQ9k+VO+aRqRfITfKGUPhPdwjNeFLmYM6Ocigr12P5
         OBDejrsPc/p7nC7fJ401FgCZO/+NKItSWLjXS+tM9qzVxxJ+IFxnSPEkJ53DomyYOG
         vyEUQwjVatkMQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 44DABA005F;
        Fri, 20 Mar 2020 09:53:47 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] net: phy: xpcs: Improvements for -next
Date:   Fri, 20 Mar 2020 10:53:33 +0100
Message-Id: <cover.1584697754.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Misc set of improvements for XPCS. All for net-next.

Patch 1/4, returns link error upon 10GKR faults are detected.

Patch 2/4, resets XPCS upon probe so that we start from well known state.

Patch 3/4, sets Link as down if AutoNeg is enabled but did not finish with
success.

Patch 4/4, restarts AutoNeg process if previous outcome was not valid.

---
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (4):
  net: phy: xpcs: Return error when 10GKR link errors are found
  net: phy: xpcs: Reset XPCS upon probe
  net: phy: xpcs: Set Link down if AutoNeg is enabled and did not finish
  net: phy: xpcs: Restart AutoNeg if outcome was invalid

 drivers/net/phy/mdio-xpcs.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

-- 
2.7.4

