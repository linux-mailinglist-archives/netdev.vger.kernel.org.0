Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C86284107
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgJEUeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:34:44 -0400
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:49326 "EHLO
        mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbgJEUeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:34:44 -0400
IronPort-SDR: 5UJJ2ztZuermn/HKPMlDXYbxr2onSa5jvZdSeaMTyvJObu/jdR6Qy1DVHAJYq3hsP1PhKZ8ip8
 CCrf7XC41edcjdtwRN4VmG8Ya4kj5jkNA5lBqO3XTPp7vlnTIEZsTuXtepoUY+w8oQ2moc1rG2
 0RA0R3FUUk9+kCrjTRs9PeAf7mra1mH4kr5U/qfM+FEkT/HOjarGe0L7uyId6ePBQGDqaH7o5Q
 /G8tQNIvZRQuPgpAplF1w221AkUaXmZx/IS3nuFENGWe8dbZDYGyETw23m0Wyx/jVOGpkctgKi
 LRc=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AOOADfBzJo/D3wsDXCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd0u4TKvad9pjvdHbS+e9qxAeQG9mCtLQY0aGP6PmocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmTiwbal9IRmoogndq8cbjZZ/Iast1x?=
 =?us-ascii?q?XFpWdFdf5Lzm1yP1KTmBj85sa0/JF99ilbpuws+c1dX6jkZqo0VbNXAigoPG?=
 =?us-ascii?q?Az/83rqALMTRCT6XsGU2UZiQRHDg7Y5xznRJjxsy/6tu1g2CmGOMD9UL45VS?=
 =?us-ascii?q?i+46ptVRTljjoMOTwk/2HNksF+jLxVrg+vqRJ8xIDbb46bOeFicq7eZ94WWX?=
 =?us-ascii?q?BMUtpNWyFHH4iyb5EPD+0EPetAr4fyvUABrRqkCgmqGejhyiVIiWHr0qIkye?=
 =?us-ascii?q?QhEB3J3A89FN8JvnTbts76NKkJXOCuz6nJzTPDYO1K2Tvn84fHbAksrPeRVr?=
 =?us-ascii?q?1/bcTf01MgFx/ZjlqOs4zlOSuY2OoOvmWf7+RtVOKih3Appg9xvzWj2toghp?=
 =?us-ascii?q?XIi4waxV7J6Ct0zZgoKNC4SkN2f9GqHIdeuS+VM4Z4QsMsT39stSs817YIuo?=
 =?us-ascii?q?a7cTAOxZg63RLTdv+Kf5aS7h7+VeucIS10iG9kdb+5mh2861KvyvfmWcmxyF?=
 =?us-ascii?q?tKqy1FncTSuX0VzBzT79SHSuN6/ke8xTaDzwDT5f9AIUAzjafbL5khzaIqmZ?=
 =?us-ascii?q?oXsUTDGTT2mFnsgK+ScUUr5vKn6+D6bbXho5+TLY50igfmPqQvnMywH/g4Px?=
 =?us-ascii?q?AKUmSG4+iwyb7u8VPjTLlXj/A7krPVvI3bKMgDo662GQ5V0oIt6xalCDem1c?=
 =?us-ascii?q?wVnXcdI11edhKKlJPpO1LOIfD+E/i/n06gnyx1yPzeJL3uHo3NLmTfkLfmZb?=
 =?us-ascii?q?ty9lRTyBQtwtBa/J9bF6sOIOztVU/0sNzYCRE5MxCuz+bhFtp9ypsUWXiTDa?=
 =?us-ascii?q?+BLKPSrViI6/osI+mRf4Aaoi3wK/s76P70i382h1sdcbOu3ZsNZ3CyBu5mLF?=
 =?us-ascii?q?mBYXrwntcBFn8HvgwgQ+z2lVKNTyBTam2sX6Iz+D47EpiqDYTdSYC3hryOwi?=
 =?us-ascii?q?O7EodRZmBcBVCGCW3oeJmcW/cQdCKSJddskiQeWre6T48h0gqjtAnkxLp7IO?=
 =?us-ascii?q?rU+ykYtY7929hv/eHTkgsy9TNsBcSHz26NV310nn8PRzIu2KBwu0J9ylCZ0a?=
 =?us-ascii?q?h3nfNVDtNT5/VUUgc/Mp7cye96C8voVgLGZNeJR06sQs+6DjEpUtIx39gObl?=
 =?us-ascii?q?5mG9W+kB/D0SSqDKETl7CRB5w09rjT32PqJ8lj0XbGyLIsj0I4TcRTKG2mgL?=
 =?us-ascii?q?Bw9xTJC4HVlEWZkr6gdb4A0y7V6GeD0W2OsVlYUAFuS6XKRm4QZlHKrdni6U?=
 =?us-ascii?q?PCSLmuBqkgMgtb08KNMLNKZcfvjVpcXvvjP87eY22rl2iqGBaC3qmMY5bye2?=
 =?us-ascii?q?UBwCXdD1AJkxgI/XaGKwc+Aj2uo3jFATxpC1LvZVng8e5kqHO0VkU01R2Fb1?=
 =?us-ascii?q?V917qp/R4YneGTRO0N3r8fvychsyt7HFCj39LNBduAphZhc7lcYd8n51dHz2?=
 =?us-ascii?q?3ZvRRnPpO8N6BimkIecwNvskLu0BV3EYVAkcY3rHMozQp/MqaY0FJHdzOF0p?=
 =?us-ascii?q?H8I7zXKnHs/B2ucaLW3Uve0NmO8KcV9Ps4s0njvB2uFkc68HVnzthU032C6Z?=
 =?us-ascii?q?XWFwcSVInxXlgt+xh7obHaeDMx6JnI2nF2K6m0ryfI28g1C+s91hagY9BfPb?=
 =?us-ascii?q?uKFADoCMIaCdOjKPcpm1mpaBILIvxS+LQvMMy4JLO63/unNfhtmRqqhHpK5Y?=
 =?us-ascii?q?R63F7K8SdgDqbLwpwM6/KVxA2KU3H7lljl+sb6hYxJexkMEWeljyvpHohcYu?=
 =?us-ascii?q?t1Z4lYJ32pJpiZz99/jpildWRV+FO5BlgFkJuncBCcR0f+zAtdyQIdrCr0ym?=
 =?us-ascii?q?OD0zVonmRx/eKk1yvUzrG6eQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFHgUiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjs?=
 =?us-ascii?q?mOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhc?=
 =?us-ascii?q?zhBCFC4FCgTiIMoUagUE/hF+KNAS3TYJxgxOEa5JUDyKDDp4RLZJngXmgMIF?=
 =?us-ascii?q?6TSAYgyRQGQ2OKAMXjiZCMDcCBgoBAQMJVwE9AY0yAQE?=
X-IPAS-Result: =?us-ascii?q?A2DgAgDggntf/xCltltgHAEBAQEBAQcBARIBAQQEAQFHg?=
 =?us-ascii?q?UiBHoJRX40/klaKWYctCwEBAQEBAQEBATUBAgQBAYRKgjsmOBMCAwEBAQMCB?=
 =?us-ascii?q?QEBBgEBAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpqhczhBCFC4FCgTiIM?=
 =?us-ascii?q?oUagUE/hF+KNAS3TYJxgxOEa5JUDyKDDp4RLZJngXmgMIF6TSAYgyRQGQ2OK?=
 =?us-ascii?q?AMXjiZCMDcCBgoBAQMJVwE9AY0yAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 05 Oct 2020 22:34:41 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        pshelar@ovn.org, dev@openvswitch.org, yoshfuji@linux-ipv6.org,
        kuznet@ms2.inr.ac.ru, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/9 net-next] net: netdevice.h: sw_netstats_rx_add helper
Date:   Mon,  5 Oct 2020 22:34:18 +0200
Message-Id: <20201005203418.55128-1-fabf@skynet.be>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

some drivers/network protocols update rx bytes/packets under
u64_stats_update_begin/end sequence.
Add a specific helper like dev_lstats_add()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 include/linux/netdevice.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0c79d9e56a5e5..42b18e034adde 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2530,6 +2530,17 @@ struct pcpu_lstats {
 
 void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes);
 
+static inline void dev_sw_netstats_rx_add(struct net_device *dev, unsigned int len)
+{
+	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
+
+	u64_stats_update_begin(&tstats->syncp);
+	tstats->rx_bytes += len;
+	tstats->rx_packets++;
+	u64_stats_update_end(&tstats->syncp);
+
+}
+
 static inline void dev_lstats_add(struct net_device *dev, unsigned int len)
 {
 	struct pcpu_lstats *lstats = this_cpu_ptr(dev->lstats);
-- 
2.28.0

