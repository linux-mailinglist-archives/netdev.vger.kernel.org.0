Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0C81584BE
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 22:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgBJV0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 16:26:49 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:59710 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgBJV0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 16:26:49 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id E437F29B4B; Mon, 10 Feb 2020 16:26:47 -0500 (EST)
Message-Id: <cover.1581369530.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net-next 0/7] Improvements for SONIC ethernet drivers
Date:   Tue, 11 Feb 2020 08:18:50 +1100
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Now that the necessary sonic driver fixes have been merged, and the merge
window has closed again, I'm sending the remainder of my sonic driver
patch queue.

A couple of these patches will have to be applied in sequence to avoid
'git am' rejects. The others are independent and could have been submitted
individually. Please let me know if I should do that.

The complete sonic driver patch queue was tested on National Semiconductor
hardware (macsonic), qemu-system-m68k (macsonic) and qemu-system-mips64el
(jazzsonic).


Finn Thain (7):
  net/sonic: Remove obsolete comment
  net/sonic: Refactor duplicated code
  net/sonic: Remove redundant next_tx variable
  net/sonic: Remove redundant netif_start_queue() call
  net/sonic: Remove explicit memory barriers
  net/sonic: Start packet transmission immediately
  net/macsonic: Remove interrupt handler wrapper

 drivers/net/ethernet/natsemi/jazzsonic.c | 31 +----------
 drivers/net/ethernet/natsemi/macsonic.c  | 48 +++--------------
 drivers/net/ethernet/natsemi/sonic.c     | 66 +++++++++++++++++-------
 drivers/net/ethernet/natsemi/sonic.h     |  2 +-
 drivers/net/ethernet/natsemi/xtsonic.c   | 40 +-------------
 5 files changed, 60 insertions(+), 127 deletions(-)

-- 
2.24.1

