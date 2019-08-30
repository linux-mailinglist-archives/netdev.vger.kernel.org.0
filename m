Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3ADA30E7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfH3HZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:25:06 -0400
Received: from packetmixer.de ([79.140.42.25]:52086 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfH3HZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:25:05 -0400
Received: from kero.packetmixer.de (p200300C5970B8500250C6283C70837BA.dip0.t-ipconnect.de [IPv6:2003:c5:970b:8500:250c:6283:c708:37ba])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 761446206F;
        Fri, 30 Aug 2019 09:25:03 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/2] pull request for net: batman-adv 2019-08-30
Date:   Fri, 30 Aug 2019 09:25:00 +0200
Message-Id: <20190830072502.16929-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here is another small batman-adv pull request for net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 3ee1bb7aae97324ec9078da1f00cb2176919563f:

  batman-adv: fix uninit-value in batadv_netlink_get_ifindex() (2019-08-14 19:27:07 +0200)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20190830

for you to fetch changes up to 0ff0f15a32c093381ad1abc06abe85afb561ab28:

  batman-adv: Only read OGM2 tvlv_len after buffer len check (2019-08-23 18:20:31 +0200)

----------------------------------------------------------------
Here are two batman-adv bugfixes:

 - Fix OGM and OGMv2 header read boundary check,
   by Sven Eckelmann (2 patches)

----------------------------------------------------------------
Sven Eckelmann (2):
      batman-adv: Only read OGM tvlv_len after buffer len check
      batman-adv: Only read OGM2 tvlv_len after buffer len check

 net/batman-adv/bat_iv_ogm.c | 20 +++++++++++++-------
 net/batman-adv/bat_v_ogm.c  | 18 ++++++++++++------
 2 files changed, 25 insertions(+), 13 deletions(-)
