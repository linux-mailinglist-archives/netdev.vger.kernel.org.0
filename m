Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5F597AC8
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfHUNaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:30:19 -0400
Received: from packetmixer.de ([79.140.42.25]:49024 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728765AbfHUNaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 09:30:19 -0400
Received: from kero.packetmixer.de (p200300C597103800A1B6E4CD9D830B1A.dip0.t-ipconnect.de [IPv6:2003:c5:9710:3800:a1b6:e4cd:9d83:b1a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 3B44762053;
        Wed, 21 Aug 2019 15:30:17 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net: batman-adv 2019-08-21
Date:   Wed, 21 Aug 2019 15:30:14 +0200
Message-Id: <20190821133015.12778-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here is a pull request with Erics bugfix from last week which we would
like to have integrated into net. We didn't get anything else, so it's
a short one this time. :)

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit f7af86ccf1882084293b11077deec049fd01da63:

  batman-adv: Fix deletion of RTR(4|6) mcast list entries (2019-07-22 21:34:58 +0200)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20190821

for you to fetch changes up to 3ee1bb7aae97324ec9078da1f00cb2176919563f:

  batman-adv: fix uninit-value in batadv_netlink_get_ifindex() (2019-08-14 19:27:07 +0200)

----------------------------------------------------------------
Here is a batman-adv bugfix:

 - fix uninit-value in batadv_netlink_get_ifindex(), by Eric Dumazet

----------------------------------------------------------------
Eric Dumazet (1):
      batman-adv: fix uninit-value in batadv_netlink_get_ifindex()

 net/batman-adv/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
