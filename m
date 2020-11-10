Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3F82ACB30
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 03:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgKJCki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 21:40:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgKJCki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 21:40:38 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcJaG-006Cxi-GS; Tue, 10 Nov 2020 03:40:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/3] xilinx_emaclite W=1 fixes
Date:   Tue, 10 Nov 2020 03:40:21 +0100
Message-Id: <20201110024024.1479741-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kerneldoc, pointer issues, and add COMPILE_TEST support to easy
finding future issues via build testing.

v2:
Use uintptr_t instead of long
Added Acked-by's.

Andrew Lunn (3):
  drivers: net: xilinx_emaclite: Add missing parameter kerneldoc
  drivers: net: xilinx_emaclite: Fix -Wpointer-to-int-cast warnings with
    W=1
  drivers: net: xilinx_emaclite: Add COMPILE_TEST support

 drivers/net/ethernet/xilinx/Kconfig           |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

-- 
2.29.2

