Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717EF214EDE
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgGETaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:30:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgGETaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:30:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsALD-003jRU-N2; Sun, 05 Jul 2020 21:30:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/5] net: dsa: Fix C=1 W=1 warnings
Date:   Sun,  5 Jul 2020 21:30:03 +0200
Message-Id: <20200705193008.889623-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mostly not using __be16 when decoding packet contents.

Andrew Lunn (5):
  net: dsa: Add __precpu property to prevent warnings
  net: dsa: tag_ksz: Fix __be16 warnings
  net: dsa: tag_lan9303: Fix __be16 warnings
  net: dsa: tag_mtk: Fix warnings for __be16
  net: dsa: tag_qca.c: Fix warning for __be16 vs u16

 net/dsa/dsa_priv.h    |  2 +-
 net/dsa/tag_ksz.c     |  9 +++++----
 net/dsa/tag_lan9303.c | 17 +++++++++--------
 net/dsa/tag_mtk.c     |  3 ++-
 net/dsa/tag_qca.c     |  8 +++++---
 5 files changed, 22 insertions(+), 17 deletions(-)

-- 
2.27.0.rc2

