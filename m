Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0A5485606
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbiAEPjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiAEPjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:39:22 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657E1C061245;
        Wed,  5 Jan 2022 07:39:21 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d722f5b8f05b18fffe3e6112.dip0.t-ipconnect.de [IPv6:2003:e9:d722:f5b8:f05b:18ff:fe3e:6112])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DD196C0611;
        Wed,  5 Jan 2022 16:39:18 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2022-01-05
Date:   Wed,  5 Jan 2022 16:39:14 +0100
Message-Id: <20220105153914.512305-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

Below I have a last minute fix for the atusb driver.

Pavel fixes a KASAN uninit report for the driver. This version is the
minimal impact fix to ease backporting. A bigger rework of the driver to
avoid potential similar problems is ongoing and will come through net-next
when ready.

regards
Stefan Schmidt


The following changes since commit 7d18a07897d07495ee140dd319b0e9265c0f68ba:

  sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc (2022-01-04 12:36:51 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-net-2022-01-05

for you to fetch changes up to 754e4382354f7908923a1949d8dc8d05f82f09cb:

  ieee802154: atusb: fix uninit value in atusb_set_extended_addr (2022-01-04 20:10:04 +0100)

----------------------------------------------------------------
Pavel Skripkin (1):
      ieee802154: atusb: fix uninit value in atusb_set_extended_addr

 drivers/net/ieee802154/atusb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)
