Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1FA278948
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgIYNRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:17:40 -0400
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:53128 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728148AbgIYNRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:17:40 -0400
IronPort-SDR: iSyu2GFpLieY1mj/lx1m2Sc+lTimUv4gFxSXnKLXQydqZA2k7O1NjPL26a9DF/h9gnYhuw0lEj
 BIf09xKVANJUrxD6DcOWqaI50DwTE/iwusuKSe2RhBExQlQO8zMOJ7NOrpS0U4yRrg3Vepzhv+
 BYltoYR7ToUvMnqFXjB3x93RyV2hGSkDzHU8e0qRewzxfa+kdfPRVYpCPGjHnki4UwmBCP3gJx
 NhbxdWPHubO9o23c7Lrlx3QEtgCUVZTN2uaqmI475TCd5mnV2S5zCfiSyYpJ+96W5AVxQk9pKH
 Lso=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AtYWiKh+zboh1E/9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B+0+0VIJqq85mqBkHD//Il1AaPAdyEragcwLeH+4nbGkU4qa6bt34DdJEeHz?=
 =?us-ascii?q?Qksu4x2zIaPcieFEfgJ+TrZSFpVO5LVVti4m3peRMNQJW2aFLduGC94iAPER?=
 =?us-ascii?q?vjKwV1Ov71GonPhMiryuy+4ZLebxhKiTanf79+MBq6oAXVu8ILnYZsN6E9xw?=
 =?us-ascii?q?fTrHBVYepW32RoJVySnxb4+Mi9+YNo/jpTtfw86cNOSL32cKskQ7NWCjQmKH?=
 =?us-ascii?q?0169bwtRbfVwuP52ATXXsQnxFVHgXK9hD6XpP2sivnqupw3TSRMMPqQbwoXz?=
 =?us-ascii?q?mp8qFmQwLqhigaLT406GHZhNJtgqxVoxyvoBNwzYHPbY2JN/dzZL/RcMkGSW?=
 =?us-ascii?q?ZdWMtaSixPApm7b4sKF+cPPfxXoJL8p1QUqxu1GAmiBPnxxTBVmHD2x6w63P?=
 =?us-ascii?q?giEQrb2wEgEcgBv2/arNjuL6cSUuC0zK/WwjXfdf9Zwiny5ZHOfxs8rv6CQa?=
 =?us-ascii?q?h+ftDNyUkzCQzFlFOQpJTrMT6W0ukDs2mW4up+We+hi2Aqth19riWzysothY?=
 =?us-ascii?q?fHiZ8Yx17a+ChkwIs4J8O1RkFnbdCqH5VdsyGUOYtoTs4mRWxjpSU0yqUetJ?=
 =?us-ascii?q?O/YSQG0okryh3BZ/CdboSF4xLuWPyMLTp5gn9uZaixiAyo8Ue6z+3xTsy00F?=
 =?us-ascii?q?FXoSVbitTMrXUN1wDL6siAV/t94l+t2TaR2ADX7eFJOUQ0la3HJJE7xr4wlp?=
 =?us-ascii?q?0TsV/fHiPsnEX2i7OZeV8g+ue17OTnZ6/ppp6aN4NsiwH+NLohmtCnDOk8Lw?=
 =?us-ascii?q?QCRXWX9Oei2LH54EH0QbVHgucrnqTYqJzaIN4Upq+9Aw9byIYj7BO/Ai+o0N?=
 =?us-ascii?q?sChnYHIklIeAmEj4npPVHBPuz4Ae2kjFuyiDtr3ezJPqX9ApXRKXjOiKrucq?=
 =?us-ascii?q?xj60FCzQo+1s1Q6IhKCr4fJfLzXkjxtNLEDhMjNQy73frnAs1n1owCQWKPHr?=
 =?us-ascii?q?OZMKTKvF+L++IgOPODaZQWuDnjMfgl4eDhjXsjlV8aZ6mp0oMdaGqkEfR+P0?=
 =?us-ascii?q?WZfX3sj88EEWcJowoxV/Llh0GcXj5QfHuyRL885iolB468EYjCR5ingKad0y?=
 =?us-ascii?q?ejAp1WemdGB0iKEXj2a4WLRukDaDyJL89/nTwLS6KhR5Ui1R6wrg/6zaRoLu?=
 =?us-ascii?q?7O9i0fr5Lj28B/5/fPmhEq6Tx0E8Od3nmJT2F1mGMIWjA30Ll8oUNj0FeD17?=
 =?us-ascii?q?Z3g/hDGNxN6PNGTB06OYTfz+NkEdDyXBzOftOTRFahWNWmDik7TsgtzN8Wf0?=
 =?us-ascii?q?Z9B9KigwjN3yWwGLAVmaeGBIc38qPc2Xj+Odp9x2zd26Y/3BEaRZ5DPHOrg4?=
 =?us-ascii?q?Zz/hbeAorOnVnfkau2MewfwSTE3GSO12yDuAdfSgEjf7/CWCUxb0HXpNKxyF?=
 =?us-ascii?q?nPQ7K0CL8kel9PwMSMArBJe9vkkRNMSaGwa5zlf2utljLoVl6zzbSWYd+ydg?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2ASEgDD7G1f/xCltltfHAEBATwBAQQ?=
 =?us-ascii?q?EAQECAQEHAQEcgUqBHCACAQGCLV+NPpJikgQLAQEBAQEBAQEBNQECBAEBhEu?=
 =?us-ascii?q?CMSU4EwIDAQEBAwIFAQEGAQEBAQEBBQQBhg9Fgjcig0cLASMjgT8SgyaCWCm?=
 =?us-ascii?q?4PzOEEIURgUKBNgIBAQEBiCuFGoFBP4RfihIiBLc9gnGDE4RpkkwPIqEQLZJ?=
 =?us-ascii?q?bm1SGRIF6TSAYO4JpUBkNnGhCMDcCBgoBAQMJVwE9AY4fAQE?=
X-IPAS-Result: =?us-ascii?q?A2ASEgDD7G1f/xCltltfHAEBATwBAQQEAQECAQEHAQEcg?=
 =?us-ascii?q?UqBHCACAQGCLV+NPpJikgQLAQEBAQEBAQEBNQECBAEBhEuCMSU4EwIDAQEBA?=
 =?us-ascii?q?wIFAQEGAQEBAQEBBQQBhg9Fgjcig0cLASMjgT8SgyaCWCm4PzOEEIURgUKBN?=
 =?us-ascii?q?gIBAQEBiCuFGoFBP4RfihIiBLc9gnGDE4RpkkwPIqEQLZJbm1SGRIF6TSAYO?=
 =?us-ascii?q?4JpUBkNnGhCMDcCBgoBAQMJVwE9AY4fAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 25 Sep 2020 15:17:37 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 5/5 net-next] vxlan: fix vxlan_find_sock() documentation for l3mdev
Date:   Fri, 25 Sep 2020 15:17:17 +0200
Message-Id: <20200925131717.56666-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 1e9ab1002281c..fa21d62aa79c9 100644
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

