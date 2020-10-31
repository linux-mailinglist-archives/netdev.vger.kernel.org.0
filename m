Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE712A1912
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 18:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgJaRrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 13:47:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgJaRrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 13:47:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYuyU-004XAM-H2; Sat, 31 Oct 2020 18:47:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/3] xilinx_emaclite W=1 fixes
Date:   Sat, 31 Oct 2020 18:47:18 +0100
Message-Id: <20201031174721.1080756-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kerneldoc, pointer issues, and add COMPILE_TEST support to easy
finding future issues via build testing.

Andrew Lunn (3):
  drivers: net: xilinx_emaclite: Add missing parameter kerneldoc
  drivers: net: xilinx_emaclite: Fix -Wpointer-to-int-cast warnings with
    W=1
  drivers: net: xilinx_emaclite: Add COMPILE_TEST support

 drivers/net/ethernet/xilinx/Kconfig           |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.28.0

