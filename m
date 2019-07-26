Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20349773D5
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfGZWGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:06:03 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:35003 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726262AbfGZWGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 18:06:03 -0400
Received: from localhost.localdomain ([83.160.161.190])
        by smtp-cloud8.xs4all.net with ESMTPSA
        id r8LOhoWNGqTdhr8LPhb2VF; Sat, 27 Jul 2019 00:05:59 +0200
From:   Paul Bolle <pebolle@tiscali.nl>
To:     David Miller <davem@davemloft.net>
Cc:     Tilman Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@web.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Karsten Keil <kkeil@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gigaset: stop maintaining seperately
Date:   Sat, 27 Jul 2019 00:05:41 +0200
Message-Id: <20190726220541.28783-1-pebolle@tiscali.nl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfJIu4LM2ZHLWf052ThOOvDs9Gy94eAD8P2nwXSqePYSur+Uez733qlhn0gmnx85qdd1+Yg04a3c9XbcfKGlPDW6Bl8q8+KFkEsCA1drjRDTaonyq6qU8
 N0+kGK+Y4eBGfEb3wgIsGL487Iz+pNlH3Ew1sIfhUuEfYg02NxzscbSSU07H7oU8/N/Pd5dp+AeBA0VtuX8ny3zaUvPcWAhZ+jBihkq3K5B0uaBGclsbPiT3
 k6EcW9rhVNNUzI3L3iqSf4JeBaG2QREs+OXLsQCmZyv9cNJSFZacFru9q27+vH/llVS097MyL1MdBCF8m/JyiXn6aFWbfKNCNoDVRG0vlEJtQFbcAS7eVDuh
 oTWNcABMLjLeS/BcIlWLJ0gyJFoOJtR2gBSrirF/DezhTypvIvM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Dutch consumer grade ISDN network will be shut down on September 1,
2019. This means I'll be converted to some sort of VOIP shortly. At that
point it would be unwise to try to maintain the gigaset driver, even for
odd fixes as I do. So I'll stop maintaining it as a seperate driver and
bump support to CAPI in staging. De facto this means the driver will be
unmaintained, since no-one seems to be working on CAPI.

I've lighty tested the hardware specific modules of this driver (bas-gigaset,
ser-gigaset, and usb-gigaset) for v5.3-rc1. The basic functionality appears to
be working. It's unclear whether anyone still cares. I'm aware of only one
person sort of using the driver a few years ago.

Thanks to Karsten Keil for the ISDN subsystems gigaset was using (I4L and
CAPI). And many thanks to Hansjoerg Lipp and Tilman Schmidt for writing and
upstreaming this driver.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 MAINTAINERS | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 783569e3c4b4..e99afbd13355 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6822,13 +6822,6 @@ F:	Documentation/filesystems/gfs2*.txt
 F:	fs/gfs2/
 F:	include/uapi/linux/gfs2_ondisk.h
 
-GIGASET ISDN DRIVERS
-M:	Paul Bolle <pebolle@tiscali.nl>
-L:	gigaset307x-common@lists.sourceforge.net
-W:	http://gigaset307x.sourceforge.net/
-S:	Odd Fixes
-F:	drivers/staging/isdn/gigaset/
-
 GNSS SUBSYSTEM
 M:	Johan Hovold <johan@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/johan/gnss.git
-- 
2.21.0

