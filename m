Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503CA2ACB74
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbgKJDDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:03:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44910 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgKJDDL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 22:03:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcJw3-006D8V-Tp; Tue, 10 Nov 2020 04:03:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 0/7] smsc W=1 warning fixes
Date:   Tue, 10 Nov 2020 04:02:41 +0100
Message-Id: <20201110030248.1480413-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixup various W=1 warnings, and then add COMPILE_TEST support, which
explains why these where missed on the previous pass.

v2:
Use while (0)
Rework buffer alignment to make it clearer

v3:
Access the length from the hardware and Use __always_unused to tell the
compiler we want to discard the value.

Andrew Lunn (7):
  drivers: net: smc91x: Fix set but unused W=1 warning
  drivers: net: smc91x: Fix missing kerneldoc reported by W=1
  drivers: net: smc911x: Work around set but unused status
  drivers: net: smc911x: Fix set but unused status because of DBG macro
  drivers: net: smc911x: Fix passing wrong number of parameters to DBG()
    macro
  drivers: net: smc911x: Fix cast from pointer to integer of different
    size
  drivers: net: smsc: Add COMPILE_TEST support

 drivers/net/ethernet/smsc/Kconfig   |  6 +++---
 drivers/net/ethernet/smsc/smc911x.c | 17 +++++++++--------
 drivers/net/ethernet/smsc/smc91x.c  |  9 ++++++++-
 3 files changed, 20 insertions(+), 12 deletions(-)

-- 
2.29.2

