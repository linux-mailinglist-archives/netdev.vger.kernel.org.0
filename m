Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C742A680F
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgKDPt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:49:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35322 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbgKDPtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:49:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaL2F-005EbW-Tn; Wed, 04 Nov 2020 16:49:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        David Laight <David.Laight@ACULAB.COM>,
        Lee Jones <lee.jones@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/7] smsc W=1 warning fixes
Date:   Wed,  4 Nov 2020 16:48:51 +0100
Message-Id: <20201104154858.1247725-1-andrew@lunn.ch>
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

v2:
Use while (0)
Rework buffer alignment to make it clearer

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
 drivers/net/ethernet/smsc/smc911x.c | 19 +++++++++++--------
 drivers/net/ethernet/smsc/smc91x.c  | 10 ++++++++--
 drivers/net/ethernet/smsc/smc91x.h  | 10 ++++++++++
 4 files changed, 32 insertions(+), 13 deletions(-)

-- 
2.28.0

