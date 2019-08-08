Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B32862C2
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 15:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732987AbfHHNPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 09:15:23 -0400
Received: from packetmixer.de ([79.140.42.25]:58740 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732856AbfHHNPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 09:15:23 -0400
Received: from kero.packetmixer.de (p200300C5971AA600E0A7EA13A3520353.dip0.t-ipconnect.de [IPv6:2003:c5:971a:a600:e0a7:ea13:a352:353])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 7EE3E62074;
        Thu,  8 Aug 2019 15:06:21 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/4] pull request for net-next: batman-adv 2019-08-08
Date:   Thu,  8 Aug 2019 15:06:15 +0200
Message-Id: <20190808130619.4481-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here is a small feature/cleanup pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 5f9e832c137075045d15cd6899ab0505cfb2ca4b:

  Linus 5.3-rc1 (2019-07-21 14:05:38 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-for-davem-20190808

for you to fetch changes up to 9cb9a17813bf0de1f8ad6deb9538296d5148b5a8:

  batman-adv: BATMAN_V: aggregate OGMv2 packets (2019-08-04 22:22:00 +0200)

----------------------------------------------------------------
This feature/cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - Replace usage of strlcpy with strscpy, by Sven Eckelmann

 - Add OGMv2 per-interface queue and aggregations, by Linus Luessing
   (2 patches)

----------------------------------------------------------------
Linus Lüssing (2):
      batman-adv: BATMAN_V: introduce per hard-iface OGMv2 queues
      batman-adv: BATMAN_V: aggregate OGMv2 packets

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sven Eckelmann (1):
      batman-adv: Replace usage of strlcpy with strscpy

 net/batman-adv/bat_v.c          |   7 ++
 net/batman-adv/bat_v_ogm.c      | 179 +++++++++++++++++++++++++++++++++++++++-
 net/batman-adv/bat_v_ogm.h      |   3 +
 net/batman-adv/main.h           |   2 +-
 net/batman-adv/soft-interface.c |   8 +-
 net/batman-adv/sysfs.c          |   2 +-
 net/batman-adv/types.h          |  12 +++
 7 files changed, 205 insertions(+), 8 deletions(-)
