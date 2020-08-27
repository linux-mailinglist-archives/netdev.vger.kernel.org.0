Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F107253E2E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgH0GvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:51:07 -0400
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:45598 "EHLO
        mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgH0GvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:51:06 -0400
IronPort-SDR: 7oItj6Q/RRRJl9YHkqWN1IGbOxZ9arKM155BRwRCEg9pcXZdEK7NU/+1Lrh5PIy7IUKFqZF6mO
 aYb68JgGgV4ZXA25qbgWVX8QD5gxFG5meQkk8Ul4Ghu3Nw42fx5+NvAC1c6vhadet25HU6WYpc
 V/cjixsZFVANKBP1PCeQHNxhC3OzXwJVSS5cq+qLIeN5ek4FXwcWqxThVdv5pJzg2mGRmovx7z
 xlmk5rw+YfNZ6PK9On8upWiARih0g7y2Ul5/td+oamG3YvKEdSRgiI8phr8pOA6v3MXd4ayBZZ
 TGc=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AjkXQxxWjHsneVasusvsBzDUEbb7V8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZRSEvKdThVPEFb/W9+hDw7KP9fy5BypZu83K6SheOLV3FD?=
 =?us-ascii?q?Y9wf0MmAIhBMPXQWbaF9XNKxIAIcJZSVV+9Gu6O0UGUOz3ZlnVv2HgpWVKQk?=
 =?us-ascii?q?a3OgV6PPn6FZDPhMqrye+y54fTYwJVjzahfL9+Nhq7oRjQu8UMnIduNKg8xh?=
 =?us-ascii?q?TUrndUdOld2H9lK0+Ukxvg/Mm74YRt8z5Xu/Iv9s5AVbv1cqElRrFGDzooLn?=
 =?us-ascii?q?446tTzuRbMUQWA6H0cUn4LkhVTGAjK8Av6XpbqvSTksOd2xTSXMtf3TbAwXj?=
 =?us-ascii?q?Si8rtrRRr1gyoJKzI17GfagdF2galGohyuugZ/zpbUbo+LKfRwcKDTc9QVSm?=
 =?us-ascii?q?RORctdSy9MD5mgY4YVE+YNIeBVpJT9qVsUqhu+ABGhCuP1xTBTh3/5x6s62P?=
 =?us-ascii?q?khHwHcwgMvAswBsG7VrNrpN6cZTOe4zKfSwjrYYfNbwiz96IvIcxAnv/6MQa?=
 =?us-ascii?q?h8ftHPxkQ2EQ7Ok1qfp5D/MTyPyuQNr3aU7/BmVe+3hWAqqAV8rDiuy8oslI?=
 =?us-ascii?q?XEiIIbx03Y+Slk3Io4JNK2RkFmbNOqDpZdqiGXOoloT80tX21mtik0x7kGt5?=
 =?us-ascii?q?C7YiQHzJIqzAPcZfyfa4WF5g/vWPyMLTp7mn5pYq+zihey/ES61+HxV8+520?=
 =?us-ascii?q?tQoCVfiNnDrHUN2gTW6siAV/Ry4F+s2S2K1wDP8uFEJl00lbbDJ54h3LEwkp?=
 =?us-ascii?q?0TvFzHHi/xhEr5lquWdkUj+uiz9+TreLHmppiAOIBujgHxL6MumsmlDuQ5NA?=
 =?us-ascii?q?gCR2mb+eKi273/5UD0RKhGgucrnqTarpzWP9kXq6+5DgNPz4ou6g6zDzK839?=
 =?us-ascii?q?QZmXkHIkhFeBWCj4XxNVHBOuv3DfmkjlS3kzdqx/bGMaP9ApnXNXfMjq/tfa?=
 =?us-ascii?q?xh5E5E1Aoz0ddf6opJBb4bPvL8RErxucfFARAjLQy73ePnCNF61oMQRWKDGK?=
 =?us-ascii?q?mZP73OsVWQ/OIgP/GMZJMJuDb6M/Ul5OPugmQjllIGfqmmw4EXaHamEfRiOU?=
 =?us-ascii?q?mZZmDsgtgZG2cQogU+VPDqiEGFUTNLYXa9Qb486SwlB4K4ForDWI+tj6Kb3C?=
 =?us-ascii?q?uhHZ1ZeHpGClaSHnfsbYmEXO0MaC2KKM97jjMETaShS5Mm1Ry2sA/6yrxnLv?=
 =?us-ascii?q?fb+yEBtpLsysJ15+vNmhE27jF0Ecud3H+XT21unWMHWSU23KZhrkx50FuD1r?=
 =?us-ascii?q?J4g/NAH9xJ+/xJShs6NYLbz+FiBdD9QBnOftmSRVa9QdWnATcxQcwtw9MUeE?=
 =?us-ascii?q?lyBYbqsheW0yO0Dro9m7WVCZkw9azAmX78O4I1yGvM3YEigkMgT88JMnep1Y?=
 =?us-ascii?q?Bl8A2GKYfDkkyf34iweKgRxi/G9y/Xw2OEsmlDUx92XLmDV31JNRielsjw+k?=
 =?us-ascii?q?6XF+zmMr8gKAYUkcM=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AxAwD4Vkdf/xCltltfgRCBQ4EeglB?=
 =?us-ascii?q?fjTiSS5AFgX0LAQEBAQEBAQEBNAECBAEBhEyCOyU0CQ4CAwEBAQMCBQEBBgE?=
 =?us-ascii?q?BAQEBAQUEAYYPRYI3IoNHCwEjI4E/EoMmglgpsxozhBCBQ4NFgUKBOIgnhRm?=
 =?us-ascii?q?BQT+EX4oSIgS2UoJtgwyEXJI2DyGgRC2SHpsdhimCEU0gGDuCaVAZDZxoQjA?=
 =?us-ascii?q?3AgYKAQEDCVcBPQGQEwEB?=
X-IPAS-Result: =?us-ascii?q?A2AxAwD4Vkdf/xCltltfgRCBQ4EeglBfjTiSS5AFgX0LA?=
 =?us-ascii?q?QEBAQEBAQEBNAECBAEBhEyCOyU0CQ4CAwEBAQMCBQEBBgEBAQEBAQUEAYYPR?=
 =?us-ascii?q?YI3IoNHCwEjI4E/EoMmglgpsxozhBCBQ4NFgUKBOIgnhRmBQT+EX4oSIgS2U?=
 =?us-ascii?q?oJtgwyEXJI2DyGgRC2SHpsdhimCEU0gGDuCaVAZDZxoQjA3AgYKAQEDCVcBP?=
 =?us-ascii?q?QGQEwEB?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 27 Aug 2020 08:51:01 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 7/7 net-next] vxlan: fix vxlan_find_sock() documentation for l3mdev
Date:   Thu, 27 Aug 2020 08:50:46 +0200
Message-Id: <20200827065046.5888-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit aab8cc3630e32
("vxlan: add support for underlay in non-default VRF")

vxlan_find_sock() also checks if socket is assigned to the right
level 3 master device when lower device is not in the default VRF.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/vxlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 1501a5633a97e..2c6189e988ba3 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -190,8 +190,9 @@ static inline struct vxlan_rdst *first_remote_rtnl(struct vxlan_fdb *fdb)
 	return list_first_entry(&fdb->remotes, struct vxlan_rdst, list);
 }
 
-/* Find VXLAN socket based on network namespace, address family and UDP port
- * and enabled unshareable flags.
+/* Find VXLAN socket based on network namespace, address family, UDP port,
+ * enabled unshareable flags and socket device binding (see l3mdev with
+ * non-default VRF).
  */
 static struct vxlan_sock *vxlan_find_sock(struct net *net, sa_family_t family,
 					  __be16 port, u32 flags, int ifindex)
-- 
2.27.0

