Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D834B214EE9
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgGETiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:38:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47660 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbgGETiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:38:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsASw-003jXv-G3; Sun, 05 Jul 2020 21:38:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/4] net: dsa: mv88e6xxx: Fixup C=1 W=1 warnings
Date:   Sun,  5 Jul 2020 21:38:06 +0200
Message-Id: <20200705193810.890020-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the mv88e6xxx driver build cleanly with C=1 W=1.

Andrew Lunn (4):
  net: dsa: mv88e6xxx: Fix sparse warnings from GENMASK
  net: dsa: mv88e6xxx: vlan_tci is __be16
  net: dsa: mv88e6xxx: Remove set but unused variable
  net: dsa: mv88e6xxx: scratch: Fixup kerneldoc

 drivers/net/dsa/mv88e6xxx/chip.c            | 2 +-
 drivers/net/dsa/mv88e6xxx/chip.h            | 4 ++--
 drivers/net/dsa/mv88e6xxx/global2.c         | 5 ++---
 drivers/net/dsa/mv88e6xxx/global2_scratch.c | 9 ++++++---
 4 files changed, 11 insertions(+), 9 deletions(-)

-- 
2.27.0.rc2

