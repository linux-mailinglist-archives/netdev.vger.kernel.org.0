Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84572A122C
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgJaAuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:50:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55804 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgJaAuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:50:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYf5z-004RiN-Aa; Sat, 31 Oct 2020 01:50:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/7] smsc W=1 warning fixes
Date:   Sat, 31 Oct 2020 01:49:51 +0100
Message-Id: <20201031004958.1059797-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixup various W=1 warnings, and then add COMPILE_TEST support, which
explains why these where missed on the previous pass.

One of these patches added as a new checkpatch warning, by
copy/pasting an existing macro and slightly modifying it. The code
already has lots of checkpatch warnings, so one more is not going to
make that much difference.

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
 drivers/net/ethernet/smsc/smc911x.c | 18 ++++++++++--------
 drivers/net/ethernet/smsc/smc91x.c  | 10 ++++++++--
 drivers/net/ethernet/smsc/smc91x.h  | 10 ++++++++++
 4 files changed, 31 insertions(+), 13 deletions(-)

-- 
2.28.0

