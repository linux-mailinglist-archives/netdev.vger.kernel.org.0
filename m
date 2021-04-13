Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61D535E7BC
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348301AbhDMUsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:48:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:41244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230281AbhDMUsw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:48:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 75F04ADEF;
        Tue, 13 Apr 2021 20:48:31 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/7] net: Korina improvements
Date:   Tue, 13 Apr 2021 22:48:11 +0200
Message-Id: <20210413204818.23350-1-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While converting Mikrotik RB532 support to use device tree I stumbled
over the korina ethernet driver, which used way too many MIPS specific
hacks. This series cleans this all up.

Thomas Bogendoerfer (7):
  net: korina: Fix MDIO functions
  net: korina: Use devres functions
  net: korina: Remove not needed cache flushes
  net: korina: Remove nested helpers
  net: korina: Use DMA API
  net: korina: Only pass mac address via platform data
  net: korina: Make driver COMPILE_TESTable

 arch/mips/rb532/devices.c     |   5 +-
 drivers/net/ethernet/Kconfig  |   2 +-
 drivers/net/ethernet/korina.c | 542 ++++++++++++++++++++++++----------
 3 files changed, 386 insertions(+), 163 deletions(-)

-- 
2.29.2

