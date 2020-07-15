Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55789220D5E
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbgGOMsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:48:45 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:60138 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728861AbgGOMsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:48:45 -0400
Received: from Q.local (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 80E1A564;
        Wed, 15 Jul 2020 14:48:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1594817323;
        bh=ymuoWEsdbUlRYdGRMk/tboXnTJb8BaO8toTY5V7aRxQ=;
        h=From:To:Cc:Subject:Date:From;
        b=AEuBZRjnvuPz8LxH97+ubyzGhBWRm59auYKmPT7gIsDbBuH51n63LTcwmXGcVRXdE
         0U4O3VpTWs52HfRNy7JUD+ERwUwTMLaiOzatgXen2TVLE7ZrKjuYP/yNhw577sJOJ3
         +S7VQe5cZRnY2yRUe74ZRksgY3MbUoCTr5ilMKHM=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     trivial@kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org
Subject: [PATCH v2 0/8] spelling.txt: /decriptors/descriptors/
Date:   Wed, 15 Jul 2020 13:48:31 +0100
Message-Id: <20200715124839.252822-1-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I wouldn't normally go through spelling fixes, but I caught sight of
this typo twice, and then foolishly grepped the tree for it, and saw how
pervasive it was.

so here I am ... fixing a typo globally... but with an addition in
scripts/spelling.txt so it shouldn't re-appear ;-)

V2: Posting before the merge windows close to pick up the last few
non-merged patches, and ideally - to get the actaul spelling.txt entry
picked up, and this time including trivial@kernel.org to let these get
head through that tree if required.

Cc: trivial@kernel.org
Cc: linux-arm-kernel@lists.infradead.org (moderated list:ARM SUB-ARCHITECTURES)
Cc: linux-kernel@vger.kernel.org (open list)
Cc: linux-input@vger.kernel.org (open list:INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN)...)
Cc: netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Cc: ath10k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH10K WIRELESS DRIVER)
Cc: linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS))
Cc: virtualization@lists.linux-foundation.org (open list:VIRTIO BALLOON)
Cc: linux-mm@kvack.org (open list:MEMORY MANAGEMENT)

Kieran Bingham (17):
  arch: arm: mach-davinci: Fix trivial spelling
  drivers: input: joystick: Fix trivial spelling
  drivers: net: wan: Fix trivial spelling
  drivers: net: wireless: Fix trivial spelling
  include: dynamic_debug.h: Fix trivial spelling
  kernel: trace: Fix trivial spelling
  mm/balloon_compaction: Fix trivial spelling
  scripts/spelling.txt: Add descriptors correction

 arch/arm/mach-davinci/board-da830-evm.c | 2 +-
 drivers/input/joystick/spaceball.c      | 2 +-
 drivers/net/wan/lmc/lmc_main.c          | 2 +-
 drivers/net/wireless/ath/ath10k/usb.c   | 2 +-
 drivers/net/wireless/ath/ath6kl/usb.c   | 2 +-
 drivers/net/wireless/cisco/airo.c       | 2 +-
 include/linux/dynamic_debug.h           | 2 +-
 kernel/trace/trace_events.c             | 2 +-
 mm/balloon_compaction.c                 | 4 ++--
 scripts/spelling.txt                    | 2 ++
 10 files changed, 12 insertions(+), 10 deletions(-)

-- 
2.25.1

