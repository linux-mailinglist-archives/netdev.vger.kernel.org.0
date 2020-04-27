Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930791BA735
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgD0PFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:05:50 -0400
Received: from simonwunderlich.de ([79.140.42.25]:37822 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgD0PFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:05:50 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2020 11:05:49 EDT
Received: from kero.packetmixer.de (p4FD5799A.dip0.t-ipconnect.de [79.213.121.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 5B08B62058;
        Mon, 27 Apr 2020 17:00:42 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/4] pull request for net: batman-adv 2020-04-27
Date:   Mon, 27 Apr 2020 17:00:35 +0200
Message-Id: <20200427150039.28730-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
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

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20200427

for you to fetch changes up to 6f91a3f7af4186099dd10fa530dd7e0d9c29747d:

  batman-adv: Fix refcnt leak in batadv_v_ogm_process (2020-04-21 10:08:05 +0200)

----------------------------------------------------------------
Here are some batman-adv bugfixes:

 - fix random number generation in network coding, by George Spelvin

 - fix reference counter leaks, by Xiyu Yang (3 patches)

----------------------------------------------------------------
George Spelvin (1):
      batman-adv: fix batadv_nc_random_weight_tq

Xiyu Yang (3):
      batman-adv: Fix refcnt leak in batadv_show_throughput_override
      batman-adv: Fix refcnt leak in batadv_store_throughput_override
      batman-adv: Fix refcnt leak in batadv_v_ogm_process

 net/batman-adv/bat_v_ogm.c      | 2 +-
 net/batman-adv/network-coding.c | 9 +--------
 net/batman-adv/sysfs.c          | 3 ++-
 3 files changed, 4 insertions(+), 10 deletions(-)
