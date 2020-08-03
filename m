Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BC223A3A8
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHCL5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:57:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:41730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgHCL5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:57:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0179AABF1
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:57:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A9CC360754; Mon,  3 Aug 2020 13:57:03 +0200 (CEST)
Message-Id: <cover.1596451857.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 0/7] compiler warnings cleanup, part 1
To:     netdev@vger.kernel.org
Date:   Mon,  3 Aug 2020 13:57:03 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Żenczykowski recently cleaned up many "unused parameter" compiler
warnings but some new occurences appeared since (mostly in netlink code).

This series gets rid of all currently found "unused parameter" warnings and
also one zero length array access warning (gcc10). There are still some
compiler warnings left (signed/unsigned comparison and missing struct field
initializers); these will be handled in next cycle as the fixes are more
intrusive.

This series should not affect resulting code; checked by comparing
resulting binary against unpatched source.

Michal Kubecek (7):
  rename maybe_unused macro to __maybe_unused
  cable_test: clean up unused parameters
  igc: mark unused callback parameter
  netlink: mark unused callback parameter
  netlink: mark unused parameters of bitset walker callbacks
  netlink: mark unused parameters of parser callbacks
  ioctl: avoid zero length array warning in get_stringset()

 amd8111e.c           |  2 +-
 at76c50x-usb.c       |  2 +-
 de2104x.c            |  4 ++--
 dsa.c                |  2 +-
 e100.c               |  2 +-
 e1000.c              |  2 +-
 et131x.c             |  2 +-
 ethtool.c            | 10 ++++++----
 fec.c                |  2 +-
 fec_8xx.c            |  2 +-
 fjes.c               |  2 +-
 ibm_emac.c           |  2 +-
 igb.c                |  2 +-
 igc.c                |  3 ++-
 internal.h           |  2 +-
 ixgb.c               |  2 +-
 ixgbe.c              |  2 +-
 ixgbevf.c            |  2 +-
 lan78xx.c            |  2 +-
 marvell.c            |  4 ++--
 natsemi.c            |  4 ++--
 netlink/cable_test.c | 21 ++++++++-------------
 netlink/netlink.c    |  2 +-
 netlink/parser.c     | 28 ++++++++++++++++------------
 netlink/pause.c      |  3 ++-
 netlink/privflags.c  |  2 +-
 netlink/settings.c   |  9 ++++++---
 netlink/tsinfo.c     |  2 +-
 realtek.c            |  2 +-
 sfc.c                |  3 ++-
 smsc911x.c           |  2 +-
 stmmac.c             |  4 ++--
 tg3.c                |  4 ++--
 tse.c                |  2 +-
 vioc.c               |  2 +-
 vmxnet3.c            |  2 +-
 36 files changed, 76 insertions(+), 69 deletions(-)

-- 
2.28.0

