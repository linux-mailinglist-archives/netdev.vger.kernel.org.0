Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C161A862A5
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 15:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732865AbfHHNKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 09:10:23 -0400
Received: from packetmixer.de ([79.140.42.25]:58710 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732789AbfHHNKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 09:10:22 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2019 09:10:21 EDT
Received: from kero.packetmixer.de (p200300C5971AA600F539B63C8CCC72B7.dip0.t-ipconnect.de [IPv6:2003:c5:971a:a600:f539:b63c:8ccc:72b7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 0AC9762056;
        Thu,  8 Aug 2019 15:02:10 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/2] pull request for net: batman-adv 2019-08-08
Date:   Thu,  8 Aug 2019 15:02:06 +0200
Message-Id: <20190808130208.2124-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here are some bugfixes which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 5f9e832c137075045d15cd6899ab0505cfb2ca4b:

  Linus 5.3-rc1 (2019-07-21 14:05:38 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20190808

for you to fetch changes up to f7af86ccf1882084293b11077deec049fd01da63:

  batman-adv: Fix deletion of RTR(4|6) mcast list entries (2019-07-22 21:34:58 +0200)

----------------------------------------------------------------
Here are some batman-adv bugfixes:

 - Fix netlink dumping of all mcast_flags buckets, by Sven Eckelmann

 - Fix deletion of RTR(4|6) mcast list entries, by Sven Eckelmann

----------------------------------------------------------------
Sven Eckelmann (2):
      batman-adv: Fix netlink dumping of all mcast_flags buckets
      batman-adv: Fix deletion of RTR(4|6) mcast list entries

 net/batman-adv/multicast.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)
