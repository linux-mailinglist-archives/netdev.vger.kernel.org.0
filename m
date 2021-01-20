Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E71E2FD0CC
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbhATMwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:52:35 -0500
Received: from esa6.hc1455-7.c3s2.iphmx.com ([68.232.139.139]:30661 "EHLO
        esa6.hc1455-7.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388115AbhATMdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:33:23 -0500
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2021 07:33:22 EST
IronPort-SDR: GPUE+7zVT4CQpKQ6fKK4SuPwruyWp8BLQKYhke0svxJS1yBjW8f/9SefY8nYkY9CuDjQgHOIBM
 WfYdHyuBwZkQ9/wKlyQaJQc0BdkV+vbOt5Y3Lh3tsetQe1bRTA6FyU8pyOMy9imtw8eD3JqLmp
 q6ij/xKX/DHwuA4IoBp0PJ7FC82uDub851sGxAm+YWToJ7KLACAc2ppsIgqEnXyJbFiIe/Zzti
 yx9PkMc9a6amFG0OS5nqoNGcez0SmoldxYissklbjzFqniWisbR9xZH+vbdIbINe9zHynFJJVi
 xVA=
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="15774913"
X-IronPort-AV: E=Sophos;i="5.79,361,1602514800"; 
   d="scan'208";a="15774913"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP; 20 Jan 2021 21:22:24 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
        by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 6278321EC02
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 21:22:23 +0900 (JST)
Received: from durio.utsfd.cs.fujitsu.co.jp (durio.utsfd.cs.fujitsu.co.jp [10.24.20.112])
        by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id B57BAE1652
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 21:22:22 +0900 (JST)
Received: by durio.utsfd.cs.fujitsu.co.jp (Postfix, from userid 1006)
        id 790711FF145; Wed, 20 Jan 2021 21:22:22 +0900 (JST)
From:   Yuusuke Ashizuka <ashiduka@fujitsu.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, ashiduka@fujitsu.com
Subject: [PATCH ethtool] Fix help message for master-slave option
Date:   Wed, 20 Jan 2021 21:21:22 +0900
Message-Id: <20210120122122.13641-1-ashiduka@fujitsu.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 558f7cc33daf ("netlink: add master/slave configuration support")
Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
---
 ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index 585aafa..84a61f4 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5630,7 +5630,7 @@ static const struct option args[] = {
 			  "		[ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]\n"
 			  "		[ sopass %x:%x:%x:%x:%x:%x ]\n"
 			  "		[ msglvl %d[/%d] | type on|off ... [--] ]\n"
-			  "		[ master-slave master-preferred|slave-preferred|master-force|slave-force ]\n"
+			  "		[ master-slave preferred-master|preferred-slave|forced-master|forced-slave ]\n"
 	},
 	{
 		.opts	= "-a|--show-pause",
-- 
2.29.2

