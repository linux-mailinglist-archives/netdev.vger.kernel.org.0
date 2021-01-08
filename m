Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBDA2EF964
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 21:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbhAHUjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 15:39:20 -0500
Received: from ficht.host.rs.currently.online ([178.63.44.182]:36584 "EHLO
        ficht.host.rs.currently.online" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729087AbhAHUjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 15:39:19 -0500
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jan 2021 15:39:18 EST
Received: from carbon.srv.schuermann.io (carbon.srv.schuermann.io [IPv6:2a01:4f8:120:614b:2::1])
        by ficht.host.rs.currently.online (Postfix) with ESMTPS id D2F0A1E6FA;
        Fri,  8 Jan 2021 20:28:00 +0000 (UTC)
From:   Leon Schuermann <leon@is.currently.online>
To:     oliver@neukum.org, davem@davemloft.net
Cc:     hayeswang@realtek.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Leon Schuermann <leon@is.currently.online>
Subject: [PATCH 0/1] r8152: Add Lenovo Powered USB-C Travel Hub
Date:   Fri,  8 Jan 2021 21:27:26 +0100
Message-Id: <20210108202727.11728-1-leon@is.currently.online>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch resolves an issue with my Lenovo USB-C Hub with an
integrated Realtek USB Ethernet controller.

When suspending my host system, along with an active Ethernet link
using the Realtek USB Ethernet adapter on a somewhat busy network,
after a few minutes the NIC would start to constantly send MAC pause
frames. Presumably this is because flow control in the NIC is not
disabled while the host system suspends, which triggers the pause
frame transmission as soon as the internal buffers fill up. With
multiple Ethernet switches from different manufactures this manages to
bring large parts of my network down as soon as the laptop is in
standby.

Because of Lenovo's somewhat confusing naming scheme around their
hubs, I've taken the liberty to add their product ID to the entry,
such that others can find the device I'm referring to.

I did not find any specific git tree to base this patch on, so it is
based on Linus' latest master. If you have a more appropriate tree I
will of course rebase accordingly. Also, if this is the wrong address
to direct this patch, I'd be happy if you could point me to the right
people.

Thanks!

Leon


Leon Schuermann (1):
  r8152: Add Lenovo Powered USB-C Travel Hub

 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/r8152.c     | 1 +
 2 files changed, 8 insertions(+)


base-commit: f5e6c330254ae691f6d7befe61c786eb5056007e
-- 
2.29.2

