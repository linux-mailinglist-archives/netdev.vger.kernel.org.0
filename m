Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087817C342
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbfGaNWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:22:19 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:50994 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbfGaNWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:22:19 -0400
Received: from ramsan ([84.194.98.4])
        by andre.telenet-ops.be with bizsmtp
        id jRNH2000F05gfCL01RNHfj; Wed, 31 Jul 2019 15:22:17 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYb-00017n-Hm; Wed, 31 Jul 2019 15:22:17 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYb-0004UB-Fk; Wed, 31 Jul 2019 15:22:17 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/8] net: Manufacturer names and spelling fixes
Date:   Wed, 31 Jul 2019 15:22:08 +0200
Message-Id: <20190731132216.17194-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi David,

This is a set of fixes for (some blatantly) wrong manufacturer names and
various spelling issues, mostly in Kconfig help texts.

Thanks!

Geert Uytterhoeven (8):
  net: 8390: Fix manufacturer name in Kconfig help text
  net: amd: Spelling s/case/cause/
  net: apple: Fix manufacturer name in Kconfig help text
  net: broadcom: Fix manufacturer name in Kconfig help text
  net: ixp4xx: Spelling s/XSacle/XScale/
  net: nixge: Spelling s/Instrument/Instruments/
  net: packetengines: Fix manufacturer spelling and capitalization
  net: samsung: Spelling s/case/cause/

 drivers/net/ethernet/8390/Kconfig           | 4 ++--
 drivers/net/ethernet/amd/Kconfig            | 2 +-
 drivers/net/ethernet/apple/Kconfig          | 4 ++--
 drivers/net/ethernet/broadcom/Kconfig       | 6 +++---
 drivers/net/ethernet/ni/Kconfig             | 2 +-
 drivers/net/ethernet/packetengines/Kconfig  | 6 +++---
 drivers/net/ethernet/packetengines/Makefile | 2 +-
 drivers/net/ethernet/samsung/Kconfig        | 2 +-
 drivers/net/ethernet/xscale/Kconfig         | 2 +-
 9 files changed, 15 insertions(+), 15 deletions(-)

-- 
2.17.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
