Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04488214F62
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgGEUgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:36:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47740 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728038AbgGEUgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 16:36:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsBNP-003k2G-Q2; Sun, 05 Jul 2020 22:36:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/3] dsa: b53/sf2
Date:   Sun,  5 Jul 2020 22:36:22 +0200
Message-Id: <20200705203625.891900-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixup most of the C=1 W=1 warnings in these drivers.

Andrew Lunn (3):
  net: dsa: b53: Fixup endianness warnings
  dsa: bcm_sf2: Initialize __be16 with a __be16 value
  dsa: bmc_sf2: Pass GENMASK() signed bits

 drivers/net/dsa/b53/b53_spi.c | 26 ++++++++++++++++++--------
 drivers/net/dsa/bcm_sf2_cfp.c |  8 ++++----
 2 files changed, 22 insertions(+), 12 deletions(-)

-- 
2.27.0.rc2

